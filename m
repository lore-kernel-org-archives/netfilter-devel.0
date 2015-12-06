From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter target/matches
Date: Sun, 6 Dec 2015 23:45:22 +0100
Message-ID: <20151206224522.GA27161@breakpoint.cc>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
 <5664B698.8040904@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36040 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbbLFWp0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Dec 2015 17:45:26 -0500
Content-Disposition: inline
In-Reply-To: <5664B698.8040904@alliedtelesis.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
> Hi All,
> 
> I'm still hoping for some feedback on this.  I have some userspace 
> patches around this as well, (to set/show the tc_index in the 
> connection, and to add the marking/matching rules in iptables), but I am 
> holding off on sending them until I know what people think of this 
> idea/implementation first.

I can't say for sure since I don't know enough about tc.

However, AFAICS tc_index seems to be something that should be internal
to tc and not exposed/changeable via iptables.

> Basically it allows 16 bits of marking in skb and connmark for traffic
> control purposes using an existing field in the skb.

Why not extend cls_flow to allow matching ctmark directly via tc
filters instead of requiring conntrack->foo copy to skb->foo?

We also have -j CLASSIFY to set skb->priority and at least cls_flow
seems to be able to match on that (did not test it).
