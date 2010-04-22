From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Recalculate checksums in netfilter queue
Date: Thu, 22 Apr 2010 13:19:56 -0700
Message-ID: <l2z8363055a1004221319q17cb25f8k8734736374747f99@mail.gmail.com>
References: <l2z8363055a1004201802x47a250f3ya43e4bec4e79061c@mail.gmail.com>
	 <x2t3fdd6ce01004201902x33440642rd1189d2852aa57a@mail.gmail.com>
	 <z2o8363055a1004212015w2216df48s3074cdb2328c66db@mail.gmail.com>
	 <20100422084313.jk0ntlfyss444g0o@webmail.dartmouth.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Morgon.J.Kanter@dartmouth.edu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61278 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324Ab0DVUT5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:19:57 -0400
Received: by gyg13 with SMTP id 13so4660520gyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Apr 2010 13:19:56 -0700 (PDT)
In-Reply-To: <20100422084313.jk0ntlfyss444g0o@webmail.dartmouth.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> The RFC for IP contains C code that you can literally copy and paste for
> this task.
>
> -- Morgon

Thanks.  I finally have both my tcp checksum, and ip checksum
functions working.  I found where I was doing some calculations in
reverse order than the example given in the RFC.  Would there be any
reason not to add checksum functions to libnetfilter_queue?

unsigned short tcp_sum_calc(unsigned short len_tcp, unsigned short
*src_addr, unsigned short *dest_addr, unsigned short *buff)
{
	unsigned short prot_tcp = 6;
	long sum = 0;
	int i = 0;
	
	/* Check if the tcp length is even or odd.  Add padding if odd. */
	if((len_tcp % 2) == 1){
		buff[len_tcp] = 0;  // Empty space in the ip buffer should be 0 anyway.
      	len_tcp += 1; // increase length to make even.
	}
	
	/* add the pseudo header */	
	sum += ntohs(src_addr[0]);
	sum += ntohs(src_addr[1]);
	sum += ntohs(dest_addr[0]);
	sum += ntohs(dest_addr[1]);
	sum += len_tcp; // already in host format.
	sum += prot_tcp; // already in host format.

	/*
	 * calculate the checksum for the tcp header and payload
	 * len_tcp represents number of 8-bit bytes,
	 * we are working with 16-bit words so divide len_tcp by 2.
	 */
	for(i=0;i<(len_tcp/2);i++){
		sum += ntohs(buff[i]);
	}

	// keep only the last 16 bits of the 32 bit calculated sum and add the carries
	while (sum >> 16){
		sum = (sum & 0xFFFF) + (sum >> 16);
	}
	
	// Take the bitwise complement of sum
	sum = ~sum;

	return htons(((unsigned short) sum));
}

unsigned short ip_sum_calc(unsigned short len_ip_header, unsigned short *buff){
	long sum = 0;
	int i = 0;
	
	for (i=0;i<len_ip_header/2;i++){
		sum += ntohs(buff[i]);
	}
	
	while (sum >> 16){
		sum = (sum & 0xFFFF) + (sum >> 16);
	}
	
	sum = ~sum;
	
	return htons(((unsigned short) sum));
}
