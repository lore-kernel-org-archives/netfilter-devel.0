From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: nft_fib: store loopback interface to
 dreg when rt is local
Date: Thu, 24 Nov 2016 14:50:14 +0100
Message-ID: <20161124135014.GD24598@breakpoint.cc>
References: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52076 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965316AbcKXNxE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:53:04 -0500
Content-Disposition: inline
In-Reply-To: <1479994128-16654-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> In general, we haven't do routing lookup in PREROUTING hook, so it's
> very likely that fib4/6_is_local will not be met.

loopback packets retain skb->dst (and thats what this test is about).

> Then the *dest will
> be set to 0 because we do nothing when the fib result is RTN_LOCAL.

Yes.

> So if the user want to drop all packets which cannot be routed,
> and input the following nft rule:
>   # nft add rule filter prerouting fib daddr oif eq 0 drop
> 
> Then all the packets which destinate to local will be dropped
> incorrectly.

but in "saddr oif eq 0 drop" case they really should have no oif, the
address should not be considered routeable.

Pablo, please don't apply this; I would like to look at this next week.

Msybe this needs a check if we're testing daddr or saddr.
