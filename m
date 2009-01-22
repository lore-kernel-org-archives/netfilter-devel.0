From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCP-packet with PUSH flag with wrong payload data in LOCAL_OUT
Date: Thu, 22 Jan 2009 18:22:02 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901221820010.1370@fbirervta.pbzchgretzou.qr>
References: <7031232632416@webmail11.yandex.ru> <alpine.LSU.2.00.0901221521450.24791@fbirervta.pbzchgretzou.qr> <68611232638800@webmail51.yandex.ru> <alpine.LSU.2.00.0901221705140.30491@fbirervta.pbzchgretzou.qr> <12961232643245@webmail56.yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Vladimir Kobylyanskiy <kentlinux@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45434 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZAVRWE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:22:04 -0500
In-Reply-To: <12961232643245@webmail56.yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-01-22 17:54, Vladimir Kobylyanskiy wrote:
>
>> Very well. But there still is another case I can think of -
>> non-linear skb.
>> 	struct tcphdr tcpbuf;
>> 	const struct tcphdr *th;
>> 	
>> 	th = skb_header_pointer(skb, ip_hdrlen(skb), sizeof(tcpbuf), &tcpbuf);
>> 	if (th->psh && ntohs(tcp->dest) == 80) {
>> 		char n[4];
>> 		if (skb_copy_bits(skb, ip_hdrlen(skb) + 4*tcp->doff,
>> 		    n, sizeof(n)) >= 0)
>> 			printk("data: %02x %02x %02x %02x\n", n[0], n[1],
>> 			       n[2], n[3]);
>> 	}
>
>Yes! It is non-linear skb! All works! THANK YOU VERY MUCH!
>I try to fix this bug for about 2 weeks. And You fix it for 15 minutes!
>Non of my books tell me about non-linear skb.

I suggest my very own 
http://jengelh.medozas.de/Netfilter_Modules.pdf

supplemental to that one might want to read "Linux Networking Internals" 
as published by O'Reilly, though, it is based on 2.6.14 and one needs 
to think a fair bit to make it applicable to 14 releases later that we 
had.
