From: Vladimir Kobylyanskiy <kentlinux@yandex.ru>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 19:54:05 +0300
Message-ID: <12961232643245@webmail56.yandex.ru>
References: <7031232632416@webmail11.yandex.ru> <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr> <68611232638800@webmail51.yandex.ru> <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards4.yandex.ru ([77.88.32.20]:45356 "EHLO
	forwards4.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZAVQ7X (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 11:59:23 -0500
In-Reply-To: <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

22.01.09, 19:11, "Jan Engelhardt" <jengelh@medozas.de>:

> Very well. But there still is another case I can think of -
> non-linear skb.
> 	struct tcphdr tcpbuf;
> 	const struct tcphdr *th;
> 	
> 	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcpbuf), &tcpbuf);
> 	if (th->psh && ntohs(tcp->dest) == 80) {
> 		char n[4];
> 		if (skb_copy_bits(skb, ip_hdrlen(skb) + 4*tcp->doff,
> 		    n, sizeof(n)) >= 0)
> 			printk("data: %02x %02x %02x %02x\n", n[0], n[1],
> 			       n[2], n[3]);
> 	}

Yes! It is non-linear skb! All works! THANK YOU VERY MUCH!
I try to fix this bug for about 2 weeks. And You fix it for 15 minutes!
Non of my books tell me about non-linear skb. Google was useless!
Man, You are the best! :)

I want to give You a little present - bottle of Russian vodka (old Russian tradition :) ). 
How can I pass it to You? Give me your address please!
