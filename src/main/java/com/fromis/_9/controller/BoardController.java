package com.fromis._9.controller;

import java.io.BufferedWriter;
import java.io.File;




import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.fromis._9.dto.BasketDTO;
import com.fromis._9.dto.BoardDTO;
import com.fromis._9.dto.CommentsDTO;
import com.fromis._9.dto.CommentsLikeDTO;
import com.fromis._9.dto.CommentsReplyDTO;
import com.fromis._9.dto.ProductDTO;
import com.fromis._9.dto.ReportDTO;
import com.fromis._9.page.Paging;
import com.fromis._9.service.BoardService;

@Controller
public class BoardController {

	@Autowired
	private HttpSession session;


	@Autowired
	private BoardService boardService;

	private ModelAndView mav;

	
	@RequestMapping(value = "/goBoardWrite", method = RequestMethod.GET)
	public String boardWrite() {
		return "board/BoardWrite";
	}		
	
	@RequestMapping(value = "/goShop", method = RequestMethod.GET)
	public String goShop() {
		return "board/Shop";
	}		
	
	@RequestMapping(value = "/registerProductForm", method = RequestMethod.GET)
	public String registerProduct() {
		return "board/RegisterProduct";
	}			
	@ResponseBody
	@RequestMapping(value = "/selectBoard", method = RequestMethod.GET)
	public Map<String,Object> selectBoard(@RequestParam("page") int page,HttpServletRequest request) {
		Map<String,Object> map = new HashMap<String,Object>();
		HttpSession session = request.getSession();
		//특정게시물에서 새로고침 시 조회수 증가를 막기 위한 세션 저장
		session.setAttribute("session", "mandu");
		map = boardService.selectBoard(page);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/clickByIconBoard", method = RequestMethod.GET)
	public Map<String,Object> clickByIconBoard(@RequestParam("page") int page,HttpServletRequest request) {
		Map<String,Object> map = new HashMap<String,Object>();
		HttpSession session = request.getSession();
		//첫 페이지에서 include 되는게 아닌 아이콘을 눌렀을 때를 위한 세션 저장
		session.setAttribute("noInclude", "clickByIcon");
		map = boardService.selectBoard(page);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/boardWrite", method = RequestMethod.POST)
	public String boardWrite(@ModelAttribute BoardDTO board, MultipartHttpServletRequest mtfRequest,HttpServletRequest request) throws IOException {
	    board.setId((String) session.getAttribute("id"));
		boolean result = boardService.boardWrite(board, mtfRequest,request);
		String returns = "no";
		if (result) {
			returns = "yes";
		}
		return returns;
	}

	@ResponseBody
	@RequestMapping(value = "/reportCheck", method = RequestMethod.GET)
	public boolean reportCheck(@RequestParam("bnum") int bnum) throws IOException {	    
		boolean result = boardService.reportCheck(bnum);
		return result;
	}
	
	@RequestMapping(value = "/viewPost", method = RequestMethod.GET)
	public ModelAndView viewPost(@RequestParam("bnum") int bnum,HttpServletRequest request) throws IOException {
		mav = new ModelAndView();
		Map<String,Object> map = new HashMap<String,Object>();
		HttpSession session = request.getSession();
        BoardDTO post = boardService.viewPost(bnum);   
		List<BoardDTO> postPic = boardService.viewPostPic(bnum);
		if("mandu".equals(session.getAttribute("session")) || "mandu2".equals(session.getAttribute("session2"))) {
			int updateHits = boardService.updateHits(bnum);
			session.removeAttribute("session");
			session.removeAttribute("session2");
		}
		map.put("post", post);
		map.put("postPic", postPic);
		mav.addObject("post",post);
		mav.addObject("postPic",postPic);
		mav.setViewName("board/ViewPost");			
		return mav;		
	}	
	
	@ResponseBody
	@RequestMapping(value = "/selectComments", method = RequestMethod.GET)
	public Map<String,Object> selectComments(@RequestParam("page") int page,@RequestParam("bnum") int bnum) {
		Map<String,Object> commentsMap = new HashMap<String,Object>();
		commentsMap = boardService.selectComments(page,bnum);
		return commentsMap;
	}
	
	@ResponseBody
	@RequestMapping(value = "/writeComments", method = RequestMethod.POST)
	public int writeComments(@ModelAttribute CommentsDTO comments,HttpServletRequest request,MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
		int result = boardService.writeComments(comments,request,mtfRequest);
		return result; 
	}
	
	
	@RequestMapping(value = "/fileDownload", method = RequestMethod.GET)
	public void filedownload(@RequestParam("filename") String filename,HttpServletRequest request,HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(); 
		String root_path = session.getServletContext().getRealPath("/");
		String attach_path = "resources/fileUpload/";
		String savePath=root_path+""+attach_path+filename;
	    File downloadFile = new File(savePath); //그 경로 맞는 파일 객체 생성
	    FileInputStream inStream = new FileInputStream(downloadFile);  // 객체를 읽어들임
	    try {
			setDisposition(filename,request,response);// 파일 다운로드시 한글 처리
		} catch (Exception e) {
			e.printStackTrace();
		}
	    OutputStream outStream = response.getOutputStream(); //객체를 쓰기함
	     
	    byte[] buffer = new byte[4096]; 
	    int bytesRead = -1;
	     
	    while ((bytesRead = inStream.read(buffer)) != -1) {
	        outStream.write(buffer, 0, bytesRead);
	    }
	    inStream.close();
	    outStream.close();
	}
	
    private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
        String browser = getBrowser(request); //현재 브라우저 리턴 받기
        String dispositionPrefix = "attachment; filename="; // 값 초기화
        String encodedFilename = null; //인코딩된 파일 이름
        if (browser.equals("MSIE")) {
               encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Trident")) {       // IE11 문자열 깨짐 방지
               encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
        } else if (browser.equals("Firefox")) {
               encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
               encodedFilename = URLDecoder.decode(encodedFilename);
        } else if (browser.equals("Opera")) {
               encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
        } else if (browser.equals("Chrome")) {
               StringBuffer sb = new StringBuffer();
               for (int i = 0; i < filename.length(); i++) {
                      char c = filename.charAt(i);
                      if (c > '~') {
                            sb.append(URLEncoder.encode("" + c, "UTF-8"));
                      } else {
                            sb.append(c);
                      }
               }
               encodedFilename = sb.toString();
        } else if (browser.equals("Safari")){
               encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1")+ "\"";
               encodedFilename = URLDecoder.decode(encodedFilename);
        }
        else {
               encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1")+ "\"";

        }
        response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);
        if ("Opera".equals(browser)){
               response.setContentType("application/octet-stream;charset=UTF-8");
        }
}
    
	public String getBrowser(HttpServletRequest request) {
        String header = request.getHeader("User-Agent");
   if (header.indexOf("MSIE") > -1) {
       return "MSIE";
   } else if (header.indexOf("Trident") > -1) {   // IE11 문자열 깨짐 방지
       return "Trident";
   } else if (header.indexOf("Chrome") > -1) {
       return "Chrome";
   } else if (header.indexOf("Opera") > -1) {
       return "Opera";
   } else if (header.indexOf("Safari") > -1) {
       return "Safari";
   }
   return "Firefox";
  }
	
	@ResponseBody
	@RequestMapping(value = "/modifyComments", method = RequestMethod.POST)
	public int modifyComments(@ModelAttribute CommentsDTO comments,HttpServletRequest request,MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
	    int result = boardService.modifyComments(comments,request,mtfRequest);
		return result; 
	}
	
	@ResponseBody
	@RequestMapping(value ="/deleteComments", method=RequestMethod.POST)
	public int deleteComments(@RequestParam("cnum") int cnum) {
		int result = boardService.deleteComments(cnum);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/bestPost",method=RequestMethod.GET)
	public List<BoardDTO> bestPost(){
		List<BoardDTO> boardList = boardService.bestPost();
		return boardList; 
	}
    
	@RequestMapping(value="/RandomStr", method=RequestMethod.GET)
	public ModelAndView RandomStr(int bnum) {
		mav = new ModelAndView();
		Random rnd = new Random();
		StringBuffer temp = new StringBuffer();
		for (int i = 0; i < 5; i++) {
		        temp.append( (char) ( (int) (rnd.nextInt(26) ) + 65));
		    }
		mav.addObject("bnum",bnum);
		mav.addObject("temp",temp);
		mav.setViewName("board/RandomStr");
		return mav;
	}
	
	@RequestMapping(value="/callPostForm", method=RequestMethod.GET)
	public ModelAndView callPostForm(int bnum) {
		mav = new ModelAndView();
		BoardDTO board = boardService.callPostForm(bnum);
		mav.addObject("post",board);
		mav.setViewName("board/ModifyPostForm");	
		return mav;
	}
	
	@ResponseBody
	@RequestMapping(value="/deletePost", method=RequestMethod.POST)
	public boolean deletePost(int bnum) {
		boolean result = boardService.deletePost(bnum);
		if(result == true) {
			return true;
		} else {
			return false;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/search",method=RequestMethod.POST)
	public Map<String,Object> search(@RequestParam("kind") String kind,@RequestParam("contents") String contents,@RequestParam("page") int page,HttpServletRequest request) {
		Map<String,Object> map = new HashMap<String,Object>();
		HttpSession session = request.getSession();
		session.setAttribute("session2", "mandu2");
		map = boardService.search(kind,contents,page);
		return map;
	}
	
	@RequestMapping(value="/reportForm",method=RequestMethod.GET)
	public ModelAndView reportForm(@RequestParam("bnum") int bnum,@RequestParam("postId") String postId) {
		mav = new ModelAndView();
		mav.addObject("bnum",bnum);
		mav.addObject("postId",postId);
		mav.setViewName("board/ReportForm");
		return mav;	
	}
	
	@ResponseBody
	@RequestMapping(value="/reportPost",method=RequestMethod.POST)
	public boolean reportPost(@ModelAttribute ReportDTO report) {
		System.out.println(report);
		int result = boardService.reportPost(report);
		if(result > 0) {
			return true;
		} else {
			return false;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/boardWrittenByMe", method=RequestMethod.POST)
	public Map<String,Object> boardWrittenByMe(@RequestParam("id") String id,@RequestParam("page") int page,@RequestParam("kind") String kind) {
		Map<String,Object> map = new HashMap<String,Object>();
			map = boardService.writtenByMe(id,page,kind);			
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/commentsWrittenByMe", method=RequestMethod.POST)
	public Map<String,Object> commentsWrittenByMe(@RequestParam("id") String id,@RequestParam("page") int page,@RequestParam("kind") String kind) {
		Map<String,Object> map = new HashMap<String,Object>();
			map = boardService.writtenByMe(id,page,kind);	
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/selectReport", method=RequestMethod.POST)
	public Map<String,Object> selectReport(@RequestParam("page") int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		map = boardService.selectReport(page);
		return map;
	}
	
	@RequestMapping(value="/selectReportPost",method=RequestMethod.GET)
	public ModelAndView selectReportPost(@RequestParam("repnum") int repnum) {
		mav = new ModelAndView();
		ReportDTO report = boardService.selectReportPost(repnum);
		mav.addObject("report",report);
		mav.setViewName("board/SelectReportPost");
		return mav;
	}
	
	@ResponseBody
	@RequestMapping(value="/acceptReport", method=RequestMethod.POST)
	public boolean acceptReport(@RequestParam("repnum") int repnum) {
		boolean result = boardService.acceptReport(repnum);
		return result;
		}	
	
	@ResponseBody
	@RequestMapping(value="/popularPost", method=RequestMethod.GET)
	public List<BoardDTO> popularPost() {
		List<BoardDTO> list = boardService.popularPost();
		return list;
		}	
	
	@RequestMapping(value="/goSelectBoardPhoto",method=RequestMethod.GET)
	public ModelAndView goSelectBoardPhoto() {
		mav = new ModelAndView();
		mav.setViewName("board/SelectBoardPhoto");
		return mav;
	}

	@ResponseBody
	@RequestMapping(value="/selectBoardPhoto", method=RequestMethod.POST)
	public Map<String,Object> selectBoardPhoto(@RequestParam("page") int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		map = boardService.selectBoardPhoto(page);
		return map;
		}	
	
	@ResponseBody
	@RequestMapping(value="/writeCommentsReply", method=RequestMethod.POST)
	public boolean writeCommentsReply(@ModelAttribute CommentsReplyDTO commentsReply,HttpServletRequest request,MultipartHttpServletRequest mtfRequest) throws IOException {
		boolean result = boardService.writeCommentsReply(commentsReply,request,mtfRequest);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/commentsLike", method=RequestMethod.POST)
	public boolean commentsLike(@ModelAttribute CommentsLikeDTO commentsLike) {
		int result = boardService.commentsLike(commentsLike);
		if(result > 0)
			return true;
			else {
				return false;
			}
	}
	
	
	@ResponseBody
	@RequestMapping(value="/weather", method=RequestMethod.GET)
	public String weather() throws IOException {
		//현재 날씨 크롤링
		String WeatherURL = "https://weather.naver.com/today";
		Document doc = Jsoup.connect(WeatherURL).get();
		Elements elem = doc.select(".today_weather .weather_area");
		String[] str = elem.text().split(" ");//정보 파싱	
		session.setAttribute("elem", elem);
		return "yes";
	}
	
	
	private String upload(String imgoriname, byte[] bytes, HttpServletRequest request) throws IOException {
		HttpSession session = request.getSession(); 
		String root_path = session.getServletContext().getRealPath("/");
		String attach_path = "resources/fileUpload/";
		String savePath=root_path+""+attach_path;
		UUID uuid=UUID.randomUUID();
		String savefilename=uuid+"_"+imgoriname;
		File target=new File(savePath,savefilename);
		FileCopyUtils.copy(bytes,target);
		return savefilename;	
	}
	
	
	@ResponseBody
	@RequestMapping(value="/registerProduct", method=RequestMethod.POST)
	public String registerProduct(ProductDTO product, MultipartHttpServletRequest mtfRequest, HttpServletRequest request) throws IOException {
    	String imgoriname=mtfRequest.getFile("pic").getOriginalFilename();
    	String imgname=upload(imgoriname,mtfRequest.getFile("pic").getBytes(),request);
    	product.setFilename(imgname);
    	product.setOrifilename(imgoriname);
    	boolean result = boardService.registerProduct(product, mtfRequest, request);
	if(result) 
			return "yes";
		else
			return "no";
	}
	
	@ResponseBody
	@RequestMapping(value = "/selectProduct", method = RequestMethod.POST)
	public Map<String,Object> selectProduct(@RequestParam("page") int page) {
		Map<String,Object> map = new HashMap<String,Object>();
		map = boardService.selectProduct(page);
		return map;
	}
	
	@RequestMapping(value= "/selectBasket",method=RequestMethod.GET)
	public ModelAndView selectBasket(@RequestParam("id") String id) {
		mav = new ModelAndView();
		List<BasketDTO> list = boardService.selectBasket(id);
		mav.addObject("list",list);
		mav.setViewName("board/SelectBasket");
		return mav;
	}

	@ResponseBody
	@RequestMapping(value = "/containBasket", method = RequestMethod.POST)
	public String containBasket(@ModelAttribute ProductDTO product,@RequestParam("id") String id) {
		int price = Integer.parseInt(product.getPrice());
		product.setSum(price*product.getAmount());
		int result = boardService.containBasket(product,id);
		if(result>0)
			return "yes";
			else
				return "no";
	}
	
	@ResponseBody
	@RequestMapping(value = "/changeAmount", method = RequestMethod.POST)
	public List<BasketDTO> changeAmount(@ModelAttribute BasketDTO basket) {		
		int price = basket.getSum()/basket.getAmount();
		basket.setAmount(basket.getChangeAmount());
		basket.setSum(basket.getChangeAmount()*price);
		int result = boardService.changeAmount(basket);
		if (result > 0) { 
			List<BasketDTO> list = boardService.selectBasket(basket.getId());
			int resultSum = boardService.selectBasketSum(basket);
		return list;
		}
		else 
			return null;
	}
	
	@ResponseBody
	@RequestMapping(value = "/selectBasketSum", method = RequestMethod.POST)
	public int selectBasketSum(@ModelAttribute BasketDTO basket) {	
		Integer result = boardService.selectBasketSum(basket);
		if(result == null ) 
			return 0;
		else
			return result;
	}
	
	@ResponseBody
	@RequestMapping(value = "/removeThatProduct", method = RequestMethod.POST)
	public boolean removeThatProduct(@ModelAttribute BasketDTO basket) {
		int result = boardService.removeThatProduct(basket);
		if(result>0)
			return true;
		else
			return false;
	}
	
	@ResponseBody
	@RequestMapping(value = "/payment", method = RequestMethod.POST)
	public Map<String,Object> payment(@ModelAttribute BasketDTO basket) {	
		Map<String,Object> map = new HashMap<String,Object>();
		map = boardService.payment(basket);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteBasket", method = RequestMethod.POST)
	public String deleteBasket(@ModelAttribute BasketDTO basket) {
		int result = boardService.deleteBasket(basket);
		if(result>0)
			return "yes";
		else
			return "no";
	}
	
	@RequestMapping(value = "/managementProduct", method = RequestMethod.GET)
	public ModelAndView managementProduct(@RequestParam("page") int page) {
		mav = new ModelAndView();
		Map<String,Object> map = new HashMap<String,Object>();
		map = boardService.managementProduct(page);
		mav.addObject("map",map);
		mav.setViewName("board/ManagementProduct");
		return mav;
	}	
	
	@RequestMapping(value="/deleteProduct", method = RequestMethod.GET)
	public ModelAndView deleteProduct(@RequestParam("pnum")int pnum) {
		mav = new ModelAndView();
		int result = boardService.deleteProduct(pnum);
		if(result>0) {
			return managementProduct(1);
		}else {
            PrintWriter out=null;
            out.print("Fail");
			mav.setViewName("board/ManagementProduct");
			return mav;
		}
	}
}
