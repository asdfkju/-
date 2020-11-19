package com.fromis._9.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReportDTO {

	private int repnum;
	private String contents;
	private String title;
	private String id;
	private int bnum;
	private String postid;
	private Date writedate;
	private String read;
	private String acceptreport;
	
}
