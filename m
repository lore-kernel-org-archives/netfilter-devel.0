From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: store loopback interface to
 dreg when rt is local
Date: Thu, 24 Nov 2016 15:48:59 +0100
Message-ID: <20161124144859.GE24598@breakpoint.cc>
References: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
 <20161124135014.GD24598@breakpoint.cc>
 <50e29b0e.fa76.15896bf2fb2.Coremail.zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52416 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964989AbcKXOvz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 09:51:55 -0500
Content-Disposition: inline
In-Reply-To: <50e29b0e.fa76.15896bf2fb2.Coremail.zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> At 2016-11-24 21:50:14, "Florian Westphal" <fw@strlen.de> wrote:
> >Liping Zhang <zlpnobody@163.com> wrote:
> >> In general, we haven't do routing lookup in PREROUTING hook, so it's
> >> very likely that fib4/6_is_local will not be met.

[..]

> Yes, so I use the words "very likely" :)
> [...]
> >but in "saddr oif eq 0 drop" case they really should have no oif, the
> >address should not be considered routeable.
>
> Yes, I read the ipt_rpfilter.c's source codes, and I find that there's a test flag
> XT_RPFILTER_ACCEPT_LOCAL, so I guess your initial intention is (just my
> guess, maybe I'm wrong):
>    0 - no route
>    1 - local route
>    others - routing oif

Yes, thats right.

"1" should only appear if lookup-up address is configured on this machine.
For saddr, I don't think its good idea, because it will pass

oif ne 0 accept

For ACCEPT_LOCAL i think its easier to combine this with the addrtype
check of just add explicit accept rules that make it bypass nft_fib
rule.

What do you think?

I agree that for your prerouting daddr example 0 makes no sense and 1
would indeed be a better option.

