From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: SNAT before IPSEC - why?
Date: Sun, 9 Oct 2011 03:35:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110090332060.8451@frira.zrqbmnf.qr>
References: <4E8FB084.6030807@earthlink.net> <alpine.LNX.2.01.1110081124330.2367@frira.zrqbmnf.qr> <4E90BC0E.8030004@earthlink.net> <alpine.LNX.2.01.1110090025040.3981@frira.zrqbmnf.qr> <4E90F26A.3030800@earthlink.net> <4E90F4EA.7050606@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50102 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1JIBft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 21:35:49 -0400
In-Reply-To: <4E90F4EA.7050606@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-10-09 03:12, Stephen Clark wrote:

>>> http://jengelh.medozas.de/images/nf-packet-flow.png or .svg
>> Beautiful! Thanks,
>
>In looking at the graph - do in ipsec packets and out ipsec packet
>hit the INPUT and OUTPUT chains even if the packet is being
>forwarded and is not really destined for the machine running
>iptables?

It always depends on the routing table.
