From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_ftp messages
Date: Mon, 24 Nov 2008 18:34:14 +0100
Message-ID: <492AE596.6040909@trash.net>
References: <31563483.01227485595724.JavaMail.shane@shane-laptop> <200811241445.56544.rusty@rustcorp.com.au> <492A9DD9.1090307@trash.net> <200811250344.46392.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Shane Goulden <shane@matrixau.net>, netfilter-devel@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbYKXReY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2008 12:34:24 -0500
In-Reply-To: <200811250344.46392.rusty@rustcorp.com.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rusty Russell wrote:
> On Monday 24 November 2008 22:58:09 Patrick McHardy wrote:
>> Rusty Russell wrote:
>>> 		if (net_ratelimit())
>>> 			printk("conntrack_ftp: partial %s %u+%u\n",
>>> 			       search[dir][i].pattern,
>>> 			       ntohl(th->seq), datalen);
>> Its strange that FTP is apparently working since we drop those packets.
>> I'm not sure about downgrading that message, its there to inform the
>> user of an exceptional action (dropping of packets within conntrack).
> 
> Actually, we drop the packets *so* it will work.  The idea is that they'll 
> coalesce and send the whole packet next time.

I see. The only case in which I triggered it so far was when sending
incomplete PORT commands using telnet, so I missed this important
fact :)

> If not, well, they don't get any more packes through, but without connection 
> tracking the other connections wouldn't work anyway (if the conntrack is being 
> used for NAT or filtering).
> 
> IIRC wu-ftpd used to trigger this (multiple write syscalls for the ip address 
> and nagle sometimes hit in the middle; go figure).

Thanks for the explanation. I'll queue up a patch for 2.6.29 to change
it to pr_debug().
