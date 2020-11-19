package com.fromis._9.dto;

import lombok.Data;
import java.util.Date;
@Data
public class BasketDTO {
	private int bknum;
	private int pnum;
	private String id;
	private Date writedate;
	private int amount;
	private String name;
	private int sum;
	private int price;
	private int changeAmount;
	private int resultSum;
}
