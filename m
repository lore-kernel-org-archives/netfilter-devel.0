From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: ebt_ip6: allow matching on ipv6-icmp
 types/codes
Date: Fri, 17 Dec 2010 18:03:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012171753180.16252@obet.zrqbmnf.qr>
References: <20101217152702.GB15737@Chamillionaire.breakpoint.cc> <alpine.LNX.2.01.1012171654410.29660@obet.zrqbmnf.qr> <20101217162110.GA9421@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34180 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055Ab0LQREB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 12:04:01 -0500
In-Reply-To: <20101217162110.GA9421@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-12-17 17:21, Florian Westphal wrote:
>
>You are right,
>    If (foo & bar && baz)
>
>is used in other places as well.

In that case, it is obvious.

The odd thing is the precedence of == in C before & and |.

In that regard you would not need any parentheses in the
quoted part besides those required by the if keyword:

>>+            if ((info->invflags & EBT_IP6_PROTO ||
>>+                 info->protocol != IPPROTO_ICMPV6))
>>+                    return -EINVAL;
>
>if ((info->invflags & EBT_IP6_PROTO) || info->protocol != 
>IPPROTO_ICMPV6)

[I guess that tells me I am already autoparenthizing subconsciously
when I would not need to.]
