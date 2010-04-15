From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Netfilter for Windows
Date: Thu, 15 Apr 2010 12:35:40 +0200
Message-ID: <4BC6EBFC.3020204@trash.net>
References: <E1065721E84E443C803CD31BFE864396@kerio.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ondrej Slanina <oslanina@kerio.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60706 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab0DOKfn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:35:43 -0400
In-Reply-To: <E1065721E84E443C803CD31BFE864396@kerio.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ondrej Slanina wrote:
> I just created a basic 'port' of Linux netfilter core modules on MS
> Windows. Now, it's implemented as a single kernel module (IM driver) and
> userspace library which has the same API as libnetfilter_queue. Network
> filtering is now performed only on pre_input and post_output sides.
> Kernel module now includes packet queueing, processing, not as on Linux,
> where this tasks is processed by separate modules. It will be
> distributed under GPL. I have some questions:

Cool. Finally those poor souls can use a proper firewall :)

> 1, Can I use 'netfilter' and 'libnetfilter_queue' names for this? For
> example kernel module named netfilter.sys, userspace library named
> libnetfilter_queue.lib, project name netfilter, netfilter for windows or
> something like it?

I think using the same names is fine.

> 2, Should I put some notice about origin into source code files ?
> Something like: "Based on Linux netfilter/libnetfilter_queue"  ?
Just keeping the original copyright and GPL headers is fine.

> My implementation is now very primitive, but I want to extend it in the future. 

Please keep us posted. I guess we could also host the source on
one of the netfilter servers in case you're interested.

