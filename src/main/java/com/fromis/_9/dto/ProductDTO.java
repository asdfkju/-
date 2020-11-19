package com.fromis._9.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ProductDTO {

	private int pnum;
	private String price;
	private String name;
	private String contents;
	private Date writedate;
	private String orifilename;
	private String filename;
	private int amount;
	private int sum;
}
