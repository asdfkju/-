package com.fromis._9.service;

import java.io.File;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import com.fromis._9.dao.MemberDAO;
import com.fromis._9.dto.BoardLikeDTO;
import com.fromis._9.dto.MemberDTO;
import com.fromis._9.page.Paging;

@Service
public class MemberService {

	private ModelAndView mav;
	
	@Autowired
	private MemberDAO mdao;
	
	@Autowired
	private HttpSession session;

	public boolean checkId(String id) {
		return mdao.checkId(id);
	}

	public boolean checkEmail(String email) {
		return mdao.checkEmail(email);
	}

	public boolean createMember(MemberDTO member) {
		boolean result=mdao.createMember(member);
		if(result) {
			return true;
		}
		return false;
	}
	
	public MemberDTO login(MemberDTO member) {
		return mdao.login(member);
	}
	
    public void keepLogin(String uid, String sessionId, Date next) {
        mdao.keepLogin(uid, sessionId, next);
    }
 
    public MemberDTO checkUserWithSessionKey(String sessionId) {
        return mdao.checkUserWithSessionKey(sessionId);
    }

	public boolean checkperiod(MemberDTO member) {
		return mdao.checkperiod(member);
	}
	
	public void searchKind(MemberDTO member) {
		mdao.searchKind(member);
	}

	public String usersEmail(String id) {
		return mdao.usersEmail(id);
	}

	public ModelAndView miForm(String id) {
		mav = new ModelAndView();
		MemberDTO member = mdao.miForm(id);
		mav.addObject("member",member);
		mav.setViewName("member/MIForm");
		return mav;
	}

	public int modifyMI(MemberDTO member, HttpServletRequest request, MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
            int result;
            System.out.println(member.getNopic());
		if(member.getNopic().equals("yes")) {
			result = mdao.modifyMI(member);	
			session.setAttribute("password", member.getPassword());
		} else {
		String orifilename=mtfRequest.getFile("mfile").getOriginalFilename();
        	String filename=uploadFile(orifilename,mtfRequest.getFile("mfile").getBytes(),request);
    		member.setImgoriname(orifilename);
    		member.setImgname(filename);
		result = mdao.modifyMI(member);	
		session.setAttribute("password", member.getPassword());
		}
		return result;
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

	public boolean searchID(MemberDTO member) {
		return mdao.searchID(member);
	}

	public boolean searchPW(MemberDTO member) {
		return mdao.searchPW(member);
	}

	public int memberWithdrawal(MemberDTO member) {
		return mdao.memberWithdrawal(member);
	}

	public boolean emailUpdate(MemberDTO member) {
		return mdao.emailUpdate(member);
	}

	public BoardLikeDTO selectBoardLike(BoardLikeDTO boardLike) {
		return mdao.selectBoardLike(boardLike);
	}

	@SuppressWarnings("unused")
	public boolean like(BoardLikeDTO boardLike) {
		String me = boardLike.getId();
		BoardLikeDTO bl = mdao.searchLikeUser(boardLike);
		if(bl != null) {
			if(bl.getDislikes()>0) {
				mdao.like2(boardLike);
			} else {
				mdao.returnLike(me);
				mdao.deleteLike(me);				
			}
			return true;
		} else if(bl == null){
			mdao.like(boardLike);
			return true;			
		} else {
			return false;
		}
	}
	
	@SuppressWarnings("unused")
	public boolean dislike(BoardLikeDTO boardLike) {
		String me = boardLike.getId();
		BoardLikeDTO bl = mdao.searchLikeUser(boardLike);
		System.out.println(bl);
		if(bl != null) {
			if(bl.getLikes()>0) {
				mdao.dislike2(boardLike);
			} else {
				mdao.returnDislike(me);
				mdao.deleteDislike(me);				
			}
			return true;
		} else if(bl == null){
			mdao.dislike(boardLike);
			return true;
		}
		return false;
	}

	public Map<String, Object> selectMember(int page) {
		Paging paging = new Paging();
		Map<String,Object> map = new HashMap<String,Object>();
		int count = mdao.memberCount();
		paging.setPage(page);
		paging.setTotalCount(count);
		List<MemberDTO> list = mdao.selectMember(paging);
		map.put("list", list);
		map.put("paging", paging);
		return map;
	}
}
