From: Rick Jones <rick.jones2@hp.com>
Subject: Re: libiptc, arptables, ebtables plans or so - and header files
Date: Mon, 10 Nov 2008 10:01:10 -0800
Message-ID: <491876E6.5000109@hp.com>
References: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33030 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYKJSBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 13:01:16 -0500
In-Reply-To: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Hi Patrick and list,
> 
> 
> when Adam sent his xt_LED, I noticed that he avoided to create an 
> xt_LED.h and instead had the definition of the blob structs directly in 
> xt_LED.c and libxt_LED.c. It occurred to me that this has some 
> implications.
> 
> Theoretically, we could kill all {ipt,ip6t,xt}_*.h files in 
> <kernel>/include/linux/netfilter*/ -- since userspace, usually only 
> iptables, does not make use of them anyway, but has its own copies.
> 
> Yes, for simplicity, we let unifdef run over these headers before 
> copying them, but then again, when was the last time you had __KERNEL__ 
> in xt_*.h?
> 
> I really doubt there are any other userspace programs of these 
> files at this time. As I see it, these header files make only sense 
> when you are crafting blobs when interacting with libiptc. I am not 
> aware of any program making such extensive use of libiptc, probably due 
> to libiptc having been very closely kept in the iptables garden.

Well, there are a few of us trying to scale the walls :)  Some may have 
even managed to sneak into the garden, but perhaps the bugspray will 
drive them back out again :)

More seriously though I thought your goal was a libiptc that could 
wander-out from behind the garden walls?  If that were to happen, 
wouldn't that want some form of .h files, and perhaps even taking the 
copies out of iptables itself?

rick jones
