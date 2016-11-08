From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: connmark: ignore skbs with magic untracked
 conntrack objects
Date: Tue, 8 Nov 2016 23:56:59 +0100
Message-ID: <20161108225659.GA31249@salvia>
References: <1477702910-12957-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57210 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752971AbcKHW5c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Nov 2016 17:57:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 33C1E392E1A
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:57:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23EE7DA807
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:57:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB0FCDA803
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Nov 2016 23:57:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477702910-12957-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 29, 2016 at 03:01:50AM +0200, Florian Westphal wrote:
> The (percpu) untracked conntrack entries can end up with nonzero connmarks.
> 
> The 'untracked' conntrack objects are merely a way to distinguish INVALID
> (i.e. protocol connection tracker says payload doesn't meet some
> requirements or packet was never seen by the connection tracking code)
> from packets that are intentionally not tracked (some icmpv6 types such as
> neigh solicitation, or by using 'iptables -j CT --notrack' option).
> 
> Untracked conntrack objects are implementation detail, we might as well use
> invalid magic address instead to tell INVALID and UNTRACKED apart.

We may consider recovering this old idea: https://lwn.net/Articles/141489/

> Check skb->nfct for untracked dummy and behave as if skb->nfct is NULL.
> 
> Reported-by: XU Tianwen <evan.xu.tianwen@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Here is the formal submit of earlier RFC patch, I also fixed
> connmark match; conceptually UNTRACKED is not a conntrack object
> so such skb should always fail the match.

Applied, thanks.
