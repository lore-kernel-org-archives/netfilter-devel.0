From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 13:28:09 +0100
Message-ID: <492A9DD9.1090307@trash.net>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Shane Goulden <shane@matrixau.net>, netfilter-devel@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62198 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbYKXM2T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:28:19 -0500
In-Reply-To: <200811241445.56544.rusty@rustcorp.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rusty Russell wrote:
> On Monday 24 November 2008 10:43:19 Shane Goulden wrote:
>> 2.6.18-92.1.10.el5xen
>>
>> FTP is working. Is there a way to easily silence the messages?
> 
> Not that I am aware of.  Perhaps that printk (still there in latest kernels) 
> should be downgraded to a DEBUG?
> 
> 		if (net_ratelimit())
> 			printk("conntrack_ftp: partial %s %u+%u\n",
> 			       search[dir][i].pattern,
> 			       ntohl(th->seq), datalen);

Its strange that FTP is apparently working since we drop those packets.
I'm not sure about downgrading that message, its there to inform the
user of an exceptional action (dropping of packets within conntrack).

Shane, how do you trigger those messages?
