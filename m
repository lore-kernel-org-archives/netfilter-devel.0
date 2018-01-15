From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC nft] src: ct: add connection counting support
Date: Mon, 15 Jan 2018 11:46:39 +0100
Message-ID: <20180115104639.6x55lm4tjrnz5nk6@salvia>
References: <20180112134111.19132-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55000 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751990AbeAOKqo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 05:46:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E35F3303D04
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 11:46:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF1B9DA847
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 11:46:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180112134111.19132-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Jan 12, 2018 at 02:41:11PM +0100, Florian Westphal wrote:
> This adds support for a native connlimit replacement.
> 
> It re-uses nftables concatenation support and thus allows
> using any key combinations supported by nftables.
> 
> Because counting is expensive, it is useful to limit this
> to new connections only.  Example:
> 
>   ct state new ct count { ip saddr . tcp dport } gt 10 drop
> 
> TODO: man page entry.
> 
> NB: This uses {} to separate ct count statement from grouping to
> avoid shift/reduce conflicts in the parser, unlike fib we do not
> have distinct 'end marker' available.

If your concern is this {} curly braces, I think that should be fine
from a semantic point of view.

>From the kernel perspective, I wonder if it would be good to place
this rbtree that allows us to count in a nftables set, so we can
create maps that people can flush and that can also populate from
userspace via API (me thinking of this usecase: userspace software,
updating reputation ranks for IP addresses based on more heuristics,
using this new set type, if that makes sense to you, of course).

I understand this might be more work - I haven't seen your patch to
add nf_conncount to nftables, but I suspect you already made a bit of
progress - so this turn may trigger some rework.

Let me know, thanks!
