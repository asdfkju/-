package com.fromis._9.service;

import java.io.File;


import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fromis._9.dao.BoardDAO;
import com.fromis._9.dto.BasketDTO;
import com.fromis._9.dto.BoardDTO;
import com.fromis._9.dto.BoardPicDTO;
import com.fromis._9.dto.CommentsDTO;
import com.fromis._9.dto.CommentsLikeDTO;
import com.fromis._9.dto.CommentsReplyDTO;
import com.fromis._9.dto.ProductDTO;
import com.fromis._9.dto.ReportDTO;
import com.fromis._9.page.CommentsPaging;
import com.fromis._9.page.Paging;

@Service
public class BoardService {
		
	@Autowired
	private BoardDAO bdao;
	
	@Autowired
	private HttpSession session;
	
	private ModelAndView mav;


	public Map<String, Object> selectBoard(int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		int count = bdao.countBoard();
		Paging paging = new Paging();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<BoardDTO> list = bdao.selectBoard(paging);
		map.put("list", list);
		map.put("paging", paging);
		return map;
	}
	
	public boolean boardWrite(BoardDTO board, MultipartHttpServletRequest mtfRequest, HttpServletRequest request) throws IOException {
		List<MultipartFile> filelist = mtfRequest.getFiles("pic");
		int result=0;
		String distinct = "";
		if(board.getDistinct() != null) {
			//수정 할 때
			distinct="yes";
			result = bdao.updatePost(board);
		} else {
			//수정 안할 때
			distinct="no";
		    result = bdao.boardWrite(board);
		}
		// MultipartHttpServletRequest타입변수를 가져와 업로드할 파일의 정보를가져옴
		// 정보가담긴mtfRequest변수에담긴 파일이아닌 파일들의 정보를 가져와야하므로 getFiles("여러파일의 정보가담긴 파일태그
		// name")을 사용
		bdao.deletePic(board);
		if (filelist.get(0).getSize() != 0) {// 파일리스트에 저장된값이 있으면 반응하게함
			for (int i = 0; i < filelist.size(); i++) {// filelist에 담긴 파일들의 갯수(size)만큼for문을 돌림
				board.setOrifilename(filelist.get(i).getOriginalFilename());// filelist에담긴파일중.i번째인 파일의정보를get해서 파일의
																			// 오리지널
																			// 이름만.getOriginalFilename()으로 가져와서
				// 업로드할 파일이 중복되면 덮어쓰기되므로 중복안되게 파일명을 랜덤하게 하기위한 메소드에 세팅하여 저장할값을 리턴받는다
				String uploadFileName = uploadFile(filelist.get(i).getOriginalFilename(),
						filelist.get(i).getBytes(),request);
				board.setFilename(uploadFileName);// 나중에 jsp에서 띄울때 필요한 저장된 파일의 이름 저장

		if (result > 0 && distinct.contains("no")) {
					bdao.boardPic(board);
				} else if (result > 0 && distinct.contains("yes")) {
					bdao.updatePic(board);
				}
			}
			return true;
		} else if (result>0) {
			return true;
		}
		else {
			return false;
		}
	}

	private String uploadFile(String originalName, byte[] bytes, HttpServletRequest request) throws IOException {
		// 랜덤한 파일명을 만들기위한 랜덤값을 주는 uuid객체생성
		HttpSession session = request.getSession(); 
		String root_path = session.getServletContext().getRealPath("/");
		String attach_path = "resources/fileUpload/";
		UUID uuid = UUID.randomUUID();
		// 랜덤생성이름+파일이름 합치기
		String saveFileName = uuid + "_" + originalName;
		String savePath = root_path+""+attach_path;// 저장경로
		File target = new File(savePath, saveFileName);// 파일경로+랜덤이름과합쳐진 파일이름이담긴 파일로 새로 만들어 변수에대입
		FileCopyUtils.copy(bytes, target);// target와 가져온 바이트를 세팅하여 새로운 파일로 만들어(copy) 디렉토리로복사
		return saveFileName; // 파일경로+랜덤이름과합쳐진 파일이름이담긴변수 리턴
	}

	public boolean reportCheck(int bnum) {
		String result = bdao.reportCheck(bnum);
		if(result.equals("N")) {
			return true;
		} else if(result.equals("Y")) {
			return false;
		} 
		return false;
	}

	public BoardDTO viewPost(int bnum) {
		BoardDTO post = bdao.viewPost(bnum);

		return post;
	}
	
	public int updateHits(int bnum) {
		int updateHits = bdao.updateHits(bnum);
		return updateHits;
	}
	
	public List<BoardDTO> viewPostPic(int bnum) {
		List<BoardDTO> postPic = bdao.viewPostPic(bnum);
		return postPic;
	}
	
	public Map<String,Object> selectComments(int page,int bnum) {
		Map<String,Object> commentsMap = new HashMap<String,Object>();
		int count = bdao.countComments(bnum);
		CommentsPaging commentPaging = new CommentsPaging();
		commentPaging.setPage(page);
		commentPaging.setTotalCount(count);

		
		//베스트댓글 로직
		List<CommentsDTO> list = bdao.selectCommentsNotPaging(bnum);
		int verify = bdao.verifyBestComments(bnum);
		int division=0;
		for(int i=0; i<list.size(); i++) {
			if(list.get(i).getLikes() == verify) {
				division++;
				if(division==1) {
				    bdao.resetPreviousBestComments(bnum);
					bdao.bestComments(list.get(i).getCnum());
				} else {
					bdao.resetPreviousBestComments(bnum);
				}
				
			}
		}
		CommentsDTO first=null;
		CommentsDTO second=null;
		List<CommentsDTO> commentsList = bdao.selectComments(commentPaging,bnum);
		for(int i=0; i<commentsList.size(); i++) {
			if(commentsList.get(i).getBest().equals("o")) {
				for(int j=i; j>0; j--) {
					first = commentsList.get(j-1);
					second = commentsList.get(j);
				    commentsList.remove(j);
				    commentsList.remove(j-1);
				    commentsList.add(j-1,second);
				    commentsList.add(j,first);
				}
			}			
		}
		
		List<CommentsReplyDTO> commentsReplyList = bdao.selectCommentsReplyList(bnum);
		for(int i=0; i<commentsList.size(); i++) {
			if(commentsList.get(i).getDel().equals("yes")) {
				commentsList.get(i).setContents("삭제된 댓글입니다.");
			}
		}
		commentsMap.put("commentsReplyList", commentsReplyList);
		commentsMap.put("commentsList", commentsList);
		commentsMap.put("commentsPaging", commentPaging);
		return commentsMap;
	}

		
	public int writeComments(CommentsDTO comments, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
    	String orifilename=mtfRequest.getFile("cfile").getOriginalFilename();
    	if(orifilename != "") {
        	String filename=uploadFile(orifilename,mtfRequest.getFile("cfile").getBytes(),request);
        	comments.setExpic("yes");
    		comments.setOrifilename(orifilename);
    		comments.setFilename(filename);

    	} else {
    		comments.setExpic("no");
    	}
		int result = bdao.writeComments(comments);	
		return result;
	}

	public int modifyComments(CommentsDTO comments, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
    	String orifilename=mtfRequest.getFile("cfile").getOriginalFilename();
   	if(orifilename != "") {
        	String filename=uploadFile(orifilename,mtfRequest.getFile("cfile").getBytes(),request);
        	comments.setExpic("yes");
    		comments.setOrifilename(orifilename);
    		comments.setFilename(filename);
    	} else {
    		comments.setExpic("no");
    	}
		int result = bdao.modifyComments(comments);	
		return result;
	}

	public int deleteComments(int cnum) {
		int result = bdao.deleteComments(cnum);		
		return result;
	}

	public List<BoardDTO> bestPost() {
		List<BoardDTO> boardList = bdao.bestPost();
		return boardList;
	}
	

	public BoardDTO callPostForm(int bnum) {
		BoardDTO board = bdao.callPostForm(bnum);
		return board;
	}	

	public boolean deletePost(int bnum) {		
		int result = bdao.deletePost(bnum);
		if(result>0) {
			return true;
		} else {
			return false;
		}
	}

	public Map<String,Object> search(String kind, String contents,int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		int count = bdao.searchCountBoard(kind, contents);
		Paging paging = new Paging();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<BoardDTO> list = bdao.search(kind,contents,paging);
		map.put("list", list);
		map.put("paging", paging);
		return map;		
	}

	public int reportPost(ReportDTO report) {
		int result = bdao.reportPost(report);
		if(result>0) {
			return result;
		} else {
			return 0;
		}
	}

	public Map<String, Object> writtenByMe(String id,int page,String kind) {
		Paging paging = new Paging();
		Map<String,Object> map = new HashMap<String,Object>();
		paging.setPage(page);
		if("게시물".equals(kind)) {
			int count = bdao.bwCount(id);
			paging.setTotalCount(count);
			List<BoardDTO> board = bdao.boardWrittenByMe(paging,id);
			map.put("list",board);
		} else if("댓글".equals(kind)) {
			int count = bdao.cwCount(id);
			paging.setTotalCount(count);
			List<CommentsDTO> comments = bdao.commentsWrittenByMe(paging,id);
			map.put("list", comments);
		}
		map.put("paging",paging);
		return map;
	}

	public Map<String,Object> selectReport(int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		Paging paging = new Paging();
		int count = bdao.reportCount();
		paging.setTotalCount(count);
		paging.setPage(page);
		List<ReportDTO> list = bdao.selectReport(paging);
		map.put("list",list);
		map.put("paging", paging);
		return map;
	}

	public ReportDTO selectReportPost(int repnum) {
		ReportDTO report = bdao.selectReportPost(repnum);
		return report;
	}

	public boolean acceptReport(int repnum) {
		int result = bdao.acceptReport(repnum);
		if(result>0) {
			return true;
		}
		return false;
	}

	public List<BoardDTO> popularPost() {
		return bdao.popularPost();
	}

	public Map<String, Object> selectBoardPhoto(int page) {
		int count = bdao.countBoardByPhoto();
		Paging paging = new Paging();
		Map<String,Object> map = new HashMap<String,Object>();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<BoardDTO> pagingList = bdao.boardListPagingByPhoto(paging);
		List<BoardDTO> list = new ArrayList<BoardDTO>();
		BoardDTO board = new BoardDTO();
		for(int i=0; i<pagingList.size(); i++) {
			int bnum = pagingList.get(i).getBnum();
			int bpnum = bdao.getBpnum(bnum);
			board = bdao.boardListByPhoto(bpnum);
			list.add(board);							
		}
		map.put("list",list);
		map.put("paging",paging);
		return map;
	}

	public boolean writeCommentsReply(CommentsReplyDTO commentsReply, HttpServletRequest request,
			MultipartHttpServletRequest mtfRequest) throws IOException {
    	String orifilename=mtfRequest.getFile("rfile").getOriginalFilename();
    	if(orifilename != "") {
        	String filename=uploadFile(orifilename,mtfRequest.getFile("rfile").getBytes(),request);
        	commentsReply.setExpic("yes");
        	commentsReply.setOrifilename(orifilename);
        	commentsReply.setFilename(filename);

    	} else {
    		commentsReply.setExpic("no");
    	}
		int result = bdao.writeCommentsReply(commentsReply);
		if(result>0) {
			return true;
		} else {
			return false;
		}
	}

	public int commentsLike(CommentsLikeDTO commentsLike) {
		int count = bdao.selectCommentsLike(commentsLike);
		if(count > 0) {
			bdao.deleteCommentsLike(commentsLike);
			bdao.resetCommentsLike(commentsLike);
		} else {
			bdao.insertCommentsLike(commentsLike);
			bdao.commentsLike(commentsLike);
		}
		return 1;
	}

	public boolean registerProduct(ProductDTO product, MultipartHttpServletRequest mtfRequest, HttpServletRequest request) {
		int result =bdao.registerProduct(product);
		if(result>0)
			return true;
		else
			return false;
	}

	public Map<String, Object> selectProduct(int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		Paging paging = new Paging();
		int count = bdao.countProduct();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<ProductDTO> list = bdao.selectProduct(paging);
		map.put("paging", paging);
		map.put("list", list);
		return map;
	}

	public List<BasketDTO> selectBasket(String id) {
		return bdao.selectBasket(id);
	}

	public int containBasket(ProductDTO product,String id) {
		int verify = bdao.isContainThatProduct(product,id);
		if(verify > 0) {
			return bdao.updateBasket(product,id);
		} else {
			return bdao.containBasket(product,id);
		}
	}

	public int changeAmount(BasketDTO basket) {
		bdao.changeAmount(basket);
		List<BasketDTO> list = bdao.selectBasket(basket.getId());
		if(list != null) {
			return 1;
		} else {
			return 0;
		}
	}

	public Integer selectBasketSum(BasketDTO basket) {
		return bdao.selectBasketSum(basket);
	}

	public int removeThatProduct(BasketDTO basket) {
		return bdao.removeThatProduct(basket);
	}

	public Map<String, Object> payment(BasketDTO basket) {
		Map<String,Object> map = new HashMap<String,Object>();
		BasketDTO info = bdao.paymentUserInfo(basket);
		List<BasketDTO> list = bdao.selectBasket(basket.getId());
		map.put("info", info);
		map.put("list", list);
		return map;
	}

	public int deleteBasket(BasketDTO basket) {
		//결제 완료 후
		List<BasketDTO> blist = bdao.selectBasket(basket.getId());
		List<ProductDTO> plist = bdao.subProduct();
		for(int i=0; i<blist.size(); i++) {
			for(int j=0; j<plist.size(); j++) {
				if(blist.get(i).getPnum() == plist.get(j).getPnum()) {
					plist.get(j).setAmount(plist.get(j).getAmount() - blist.get(i).getAmount());
				}
			}
		}
		
		for(int k=0; k<plist.size(); k++) {
		//수량 변경
			bdao.insertProduct(plist.get(k));
		}
		
		return bdao.deleteBasket(basket);
	}

	public Map<String,Object> managementProduct(int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		Paging paging = new Paging();
		int count = bdao.countProduct();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<ProductDTO> list = bdao.selectProduct(paging);
		map.put("paging", paging);
		map.put("list", list);
		return map;
	}

	public int deleteProduct(int pnum) {
		int result = bdao.deleteProduct(pnum);
		return result;
	}


}
