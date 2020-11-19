package com.fromis._9.dto;

import lombok.Data;

@Data
public class MemberDTO {	
	private String id;
	private String password;
	private String mpassword;
	private String name;
	private String email;
	private String imgname;
	private String imgoriname;
	private String kind;
	private String nopic;
	private boolean checkAutoLogin;
	private int mileage;
	
}
