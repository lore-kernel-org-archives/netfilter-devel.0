From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: (nfnl_talk: recvmsg over-run) and (nf_queue: full at 1024 	entries,
 dropping packets(s). Dropped: 582) - bug or just some defaults 	increase
 required?
Date: Wed, 18 Feb 2009 15:48:19 +1300
Message-ID: <499B76F3.1090901@treenet.co.nz>
References: <c4b050a10902061014w3df3b2c3xe9e6465be79b4e07@mail.gmail.com>	 <4996FBBE.20009@netfilter.org>	 <200902161819.27630.anton.vazir@gmail.com>	 <49996D49.9050606@netfilter.org>	 <c4b050a10902160638s231bd34by7e90f320dde3e27e@mail.gmail.com>	 <49998504.9020004@netfilter.org>	 <c4b050a10902160733y605a5cc1l710596b0aa658f5d@mail.gmail.com>	 <c4b050a10902160741i6d7a42deqaa41f9e22bdc4484@mail.gmail.com>	 <c4b050a10902170858j698c32c3ye6c58682911c59eb@mail.gmail.com>	 <499AF0B8.5060202@netfilter.org> <c4b050a10902170931n1307ea87if2f39d9160a34bff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton VG <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:40698
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZBRCsI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:48:08 -0500
In-Reply-To: <c4b050a10902170931n1307ea87if2f39d9160a34bff@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton VG wrote:
> Pablo,
> 
> Thanks so much for patch, will test it shortly,
> 
> Do you have any suggestion what method to use if not select() ?
> 
> Since we have to handle potentially thousands of queues on the single PC?
> 
> Sincerely,
> Anton.

epoll and in where available kqueue seems to be faster and non-blocking 
than select().

AYJ

