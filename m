From: Justin Yaple <yaplej@gmail.com>
Subject: Set pointer to TCP header in callback function
Date: Tue, 13 Apr 2010 20:40:23 -0700
Message-ID: <i2p8363055a1004132040je747ad0avda68218c6cd6110e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38347 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab0DNDkZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 23:40:25 -0400
Received: by gyg13 with SMTP id 13so3892823gyg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 20:40:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am stuck trying to access the TCP header from the callback function
of my nfq_q_handle.  I have packets coming in, and can access the IP
header without any problem, but I am not getting the correct TCP
destination port.  Here is the section of code I am having problems
with.  I am guessing I am setting the pointer tchp wrong.  I have done
this before in the kernel with sk_buffs, but the method for accessing
the TCP header was a little different.

struct iphdr *iph = NULL;
struct tcphdr *tcph = NULL;
int ret;
char *payload;

ret = nfq_get_payload(nfa, &payload);
if (ret >= 0)
	printf("payload_len=%d ", ret);

iph = (struct iphdr *) payload;
if ((iph->protocol == IPPROTO_TCP) ){
	printf("packet is a TCP packet\n ");
}

tcph = (struct tcphdr *) (((u_int32_t *)payload) + (iph->ihl * 4));
//this must initialize to the wrong byte
printf("iph length is %u\n",iph->ihl);  //this works
printf("dest port is %u\n",tcph->dest); //this displays the wrong ports
