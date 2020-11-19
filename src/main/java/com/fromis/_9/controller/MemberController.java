package com.fromis._9.controller;

import java.io.File;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.util.WebUtils;

import com.fromis._9.service.MemberService;
import com.fromis._9.util.MailSend;
import com.fromis._9.dto.BoardLikeDTO;
import com.fromis._9.dto.MemberDTO;

@Controller
public class MemberController {
	
	@Autowired
	private HttpSession session;
	
	@Autowired
	private MemberService memberService;
	
	private ModelAndView mav;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home() {
		return "Home";
	}

	@RequestMapping(value = "/goHome", method = RequestMethod.GET)
	public String goHome() {
		return "Home";
	}
	
	@RequestMapping(value = "/goMyPage", method = RequestMethod.GET)
	public String goMyPage() {
		return "member/MyPage";
	}
	
	
	@RequestMapping(value = "/signUp", method = RequestMethod.GET)
	public String signUp() {
		return "SignUp";
	}
	
	@ResponseBody
	@RequestMapping(value="/checkId", method=RequestMethod.GET)
	public boolean checkId(@RequestParam("id") String id) {
		boolean boo = memberService.checkId(id);
		System.out.println(boo);
		return memberService.checkId(id);
        }
	
	@RequestMapping(value="/sendCode", method=RequestMethod.GET)
	public ModelAndView sendCode(@RequestParam("email") String email) {
		mav=new ModelAndView();
		String code=codeGen();
		String subject="프로미스나인 카페 이메일 인증 코드 발송";
		String content="인증코드 : " + code;
		MailSend mailSend = new MailSend();
		mailSend.mailSend(email,subject,content);
		session.setAttribute("code", code);
		mav.addObject("email", email);
		mav.setViewName("member/EmailCertify");
		return mav;
	}
	
	@ResponseBody
	@RequestMapping(value="/reSendCode", method=RequestMethod.GET)
	public String reSendCode(@RequestParam("email") String email) {
		String code=codeGen();
		String subject="프로미스나인 카페 이메일 인증 코드 발송";
		String content="인증코드 : " + code;
		MailSend mailSend = new MailSend();
		mailSend.mailSend(email,subject,content);
		session.invalidate();
		session.setAttribute("code", code);
		return "Success";
	}
	
    public String codeGen() {
        Random random = new Random();
        String code = "";
        for(int i=0;i<4;i++) {
            String randomCode = Integer.toString(random.nextInt(10));
                if(!code.contains(randomCode)) {
                    code += randomCode;
                }
                else {
                    i-=1;
                }
            }
        return code;
    }
    
	@ResponseBody
	@RequestMapping(value="/emailCertify", method=RequestMethod.GET)
	public String emailCertify(@RequestParam("code") String code) {
		String sendCode=(String) session.getAttribute("code");
		if(sendCode.equals(code)) {
			return "Success";
		}
		return "Fail";
	}
	
	@ResponseBody
	@RequestMapping(value="/checkEmail", method=RequestMethod.POST)
	public boolean checkEmail(@RequestParam("email") String email) {
		return memberService.checkEmail(email);
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
    @RequestMapping(value="/createMember", method=RequestMethod.POST)
    public String createMember(@ModelAttribute MemberDTO member,MultipartHttpServletRequest mtfRequest,HttpServletRequest request) throws IOException {
    	
    	//form 안에 있었던 name="pic"
    	String imgoriname=mtfRequest.getFile("pic").getOriginalFilename();
    	String imgname=upload(imgoriname,mtfRequest.getFile("pic").getBytes(),request);
    	member.setImgname(imgname);
    	member.setImgoriname(imgoriname);
    	boolean result=memberService.createMember(member);
    	if(result) {
    		return "Success";
    	}
		return "Fail";
    }
    
	@ResponseBody
	@RequestMapping(value="/login", method=RequestMethod.POST)
	public String login(@ModelAttribute MemberDTO member,HttpServletResponse response) {
		member = memberService.login(member);
		if(member != null) {
		boolean period=memberService.checkperiod(member);
			if(period) {
				return "report";
			} else {
				session.setAttribute("kind", member.getKind());
				session.setAttribute("id", member.getId());
				session.setAttribute("password", member.getPassword());
				if(member.isCheckAutoLogin()) {
				Cookie cookie =new Cookie("loginCookie", session.getId());
				cookie.setPath("/");
				int amount=60*60*24*1;
				cookie.setMaxAge(amount);
				//매개변수에 response를 넣어준 이유. 자동로그인 체크시 쿠키생성을 위함
				response.addCookie(cookie);
				Date sessionLimit =new Date(System.currentTimeMillis() + (1000*amount));
				memberService.keepLogin(member.getId(), session.getId(), sessionLimit);   				
				return "Success";	
			} else {
				return "Success";
			}
	}
} else {
	return "Fail";
	}
}
	
	@RequestMapping(value="/logout", method=RequestMethod.GET)
	public String logout(HttpServletResponse response,HttpServletRequest request) {
        Object obj = session.getAttribute("id");
        if ( obj !=null ){
            String member = (String) obj;
            // null이 아닐 경우 제거
            session.invalidate();// 세션 전체를 날려버림
            //쿠키를 가져와보고
            Cookie loginCookie = WebUtils.getCookie(request,"loginCookie");
            if ( loginCookie !=null ){
                // null이 아니면 존재하면!
                loginCookie.setPath("/");
                // 쿠키는 없앨 때 유효시간을 0으로 설정하는 것 !!! invalidate같은거 없음.
                loginCookie.setMaxAge(0);
                // 쿠키 설정을 적용한다.
                response.addCookie(loginCookie);
                // 사용자 테이블에서도 유효기간을 현재시간으로 다시 세팅해줘야함.
                Date date =new Date(System.currentTimeMillis());
                memberService.keepLogin(member, session.getId(), date);
                return "redirect:/goHome";
            }
        }
		return "redirect:/goHome";
	}
	
	@RequestMapping(value="/miForm",method=RequestMethod.GET)
	public ModelAndView miForm() {
		mav = new ModelAndView();	
		String id = (String) session.getAttribute("id");
		mav = memberService.miForm(id);
	    return mav;		
	}
	
	@ResponseBody
	@RequestMapping(value = "/modifyMI", method = RequestMethod.POST)
	public String modifyComments(@ModelAttribute MemberDTO member,HttpServletRequest request,MultipartHttpServletRequest mtfRequest) throws IllegalStateException, IOException {
	  System.out.println(member);
		int result = memberService.modifyMI(member,request,mtfRequest);
	    if(result>0) {
	    	return "yes";
	    } else {
	    	return "no";
	    }
	}
	
	@RequestMapping(value="/searchForm", method=RequestMethod.GET)
	public String searchForm() {
		return "member/SearchForm";
	}
	
	@ResponseBody
	@RequestMapping(value="/searchID", method=RequestMethod.POST)
	public String searchID(@ModelAttribute MemberDTO member) {
		boolean result=memberService.searchID(member);
		if(result) {
			String id =member.getId();
			return id;
		}
		else {
			return "no";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/searchPW", method=RequestMethod.POST)
	public String searchPW(@ModelAttribute MemberDTO member) {
		boolean result=memberService.searchPW(member);
		if(result) {
			String subject="fromis_9 카페 비밀번호 발송";
			String content="비밀번호 : " + member.getPassword();
			MailSend mailSend = new MailSend();
			mailSend.mailSend(member.getEmail(),subject,content);
			return "yes";
		}
		else {
			return "no";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/memberWithdrawal", method=RequestMethod.POST)
	public boolean memberWithdrawal(@ModelAttribute MemberDTO member) {
		int result = memberService.memberWithdrawal(member);
		if(result>0) {
			return true;
		} else {
			return false;
		}
	}
	
	@RequestMapping(value="/deleteMember", method=RequestMethod.GET)
	public ModelAndView deleteMember() {
		mav = new ModelAndView();
		session.invalidate();
		mav.setViewName("Home");
		return mav;		
	}
	
	@RequestMapping(value="/modifyEmail", method=RequestMethod.GET)
	public ModelAndView modifyEmail(String id) {
		mav = new ModelAndView();
		mav.addObject("id",id);
		mav.setViewName("member/ModifyEmail");
		return mav;		
	}
	
	@ResponseBody
	@RequestMapping(value="/sendCodeToModify", method=RequestMethod.POST)
	public Map<String,Object> sendCodeToModify(@RequestParam("email") String email) {
        Map<String,Object> map = new HashMap<String,Object>();	
		String code=codeGen();
		String subject="메일 수정을 위한 코드 발송";
		String content="인증코드 : " + code;
		MailSend mailSend = new MailSend();
		mailSend.mailSend(email,subject,content);
		map.put("code",code);
		map.put("email", email);
		return map;
	}
	
	@ResponseBody
	@RequestMapping(value="/emailUpdate", method=RequestMethod.POST)
	public String emailUpdate(@ModelAttribute MemberDTO member) {
		boolean result = memberService.emailUpdate(member);
		if(result) {
			return "yes";
		} else {
			return "no";
		}
	}

	@ResponseBody
	@RequestMapping(value="/selectBoardLike", method=RequestMethod.POST)
	public BoardLikeDTO selectBoardLike(@ModelAttribute BoardLikeDTO boardLike) {
		boardLike = memberService.selectBoardLike(boardLike);
		return boardLike;
	}
	
	@ResponseBody
	@RequestMapping(value="/like", method=RequestMethod.POST)
	public boolean like(@ModelAttribute BoardLikeDTO boardLike) {
		boolean result = memberService.like(boardLike);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/dislike", method=RequestMethod.POST)
	public boolean dislike(@ModelAttribute BoardLikeDTO boardLike) {
		boolean result = memberService.dislike(boardLike);
		return result;
	}
	
	@ResponseBody
	@RequestMapping(value="/selectMember",method=RequestMethod.GET)
	public Map<String,Object> selectMember(@RequestParam("page") int page){
		Map<String,Object> map = new HashMap<String,Object>();
		map = memberService.selectMember(page);
		return map;
	}
		


}
