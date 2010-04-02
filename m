From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: br_netfilter post routing hook question...
Date: Fri, 02 Apr 2010 21:55:03 +0200
Message-ID: <4BB64B97.9000203@pandora.be>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com> <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com> <CB2DD11991B27C4F99935E6229450D320566ACAE@STORK.scenix.com> <4BB63BC9.1050000@pandora.be> <CB2DD11991B27C4F99935E6229450D320566ACC5@STORK.scenix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: agashi shipora <gashipo@gmail.com>, netfilter-devel@vger.kernel.org
To: Gareth Williams <gwilliams@ubicom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:38712 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab0DBTzG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:55:06 -0400
In-Reply-To: <CB2DD11991B27C4F99935E6229450D320566ACC5@STORK.scenix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gareth Williams schreef:
> Ahh but I already tried physdev - and it throws warnings that it will
> not work on forward or post routing paths when it's not on a bridge
> interface.
>
> But I was specifying the rule with "-o br0" which is a bridge so the
> physdev rule should have been sane?
>
> Even though it threw this warning it did add into iptables but still
> didn't work for me.
>
> I might revisit it and see if I can figure out what was wrong.
>
>   
I'd do that if I were you :-)
First figure out what's going on e.g. by adding rules, sending traffic
and looking at the rule counters. The iptables LOG target should produce
a string containing the physindev and physoutdev device name (the bridge
input and output port for the packet).

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

