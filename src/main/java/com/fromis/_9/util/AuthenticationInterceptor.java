package com.fromis._9.util;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import com.fromis._9.controller.MemberController;
import com.fromis._9.dto.MemberDTO;
import com.fromis._9.service.MemberService;

public class AuthenticationInterceptor extends HandlerInterceptorAdapter {

    @Autowired
    private MemberService memberService;
    
    @Autowired
    private HttpSession session;
     
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception { 
        HttpSession session = request.getSession();
        Object obj = session.getAttribute("id");
        if ( obj ==null ){
            Cookie loginCookie = WebUtils.getCookie(request,"loginCookie");
            if ( loginCookie !=null ){
                String sessionId = loginCookie.getValue();
                MemberDTO member = memberService.checkUserWithSessionKey(sessionId);                 
                if ( member !=null ){
                	boolean result=memberService.checkperiod(member);
                	if(result) {
                		System.out.println("로그인 금지기간");
                        return true;	
                	}
                	else {
                		System.out.println("로그인 가능");
                        session.setAttribute("id", member.getId());
                        session.setAttribute("kind", member.getKind());
                        session.setAttribute("password", member.getPassword());
                        return true;
                	}
                }
            }
            return true;
        }
         
        return true;
    }
       
    @Override
    public void postHandle(HttpServletRequest request,HttpServletResponse response, Object handler,
            ModelAndView modelAndView)throws Exception {
    	  String requestURI = request.getRequestURI();
    	  String kind = (String) session.getAttribute("kind");
    	  if(requestURI.equals("/_9/goMyPage")) {
    		  try {
        		  if(kind.equals("관리자") || kind.equals("회원")) {
        			  modelAndView.setViewName("member/MyPage");
        		  } else { System.out.println("로그인 안한 사람이 침입");
        		  }
    		  } catch(Exception e){
    			  System.out.println("알수 없는 오류 발생");
    			  e.getMessage();
    			  modelAndView.setViewName("Home");
    		  }

    	  }
    }
}
