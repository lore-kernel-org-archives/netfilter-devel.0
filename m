From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Unable to use the ebtables limits module
Date: Sun, 6 Nov 2011 15:42:49 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1111061533110.6000@frira.zrqbmnf.qr>
References: <CAPed3OEtVFqe6O+MhUy41H5Z_oRe=Mefsucj9pac9nb8bSR10w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ruben Kerkhof <ruben@rubenkerkhof.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35139 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab1KFOmw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Nov 2011 09:42:52 -0500
In-Reply-To: <CAPed3OEtVFqe6O+MhUy41H5Z_oRe=Mefsucj9pac9nb8bSR10w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-11-06 15:23, Ruben Kerkhof wrote:

>Hi all,
>
>I've been trying to use the ebtables limits module as follows:
>
>ebtables -A INPUT -p IPv4 --ip-proto udp --ip-dport 80 --limit 10/second -j DROP
>This triggers the following kernel message: eb_tables: limit.0 match:
>invalid size 40 (kernel) != (user) 32
>and ebtables responds with:
>
>This only happens when the ebt_limit.ko is not loaded, and the
>iptables xt_limit module is loaded
>If I either modprobe the ebt_limit module, or unload the xt_limit,
>inserting the rule succeeds.

ebtables searching for limit r0 NFPROTO_BRIDGE match is satifiable by 
xt_limit.c's r0 NFPROTO_UNSPEC (and by ebt_limit.c's r0 NFPROTO_BRIDGE).

The nearest solution here is to move ebt_limit's NFPROTO_BRIDGE 
specialization into xt_limit.c.

This is a good reason why the names should carry a unified prefix (as I 
had already proposed in 
http://www.spinics.net/lists/netfilter-devel/msg16637.html ) -- having 
two xt_limits would have immediately made it obvious there is a clash.
