From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] netfilter: nf_tables: extend tracing infrastructure
Date: Mon, 16 Nov 2015 22:56:35 +0100
Message-ID: <20151116215635.GA6601@salvia>
References: <20151109133608.GD8098@macbook.localdomain>
 <1447343209-28029-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51988 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbbKPV4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Nov 2015 16:56:44 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0EACE1714E9
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 22:56:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F0A731788E9
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 22:56:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04BD4D192A
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2015 22:56:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1447343209-28029-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

Cc'ing Patrick to shake him for ideas :)

On Thu, Nov 12, 2015 at 04:46:49PM +0100, Florian Westphal wrote:
> RFC for the kernel-side of the tracing changes.
> 
> Caveats+Questions are:
>  - should kernel dump entire rule instead of just the handle?
>  PRO of dumping entire rule matched:
>   * Userspace doesn't need to dump rules first to display
>   the rule that matched
>   * nft trace doesn't need to also monitor ruleset for changes
>   * would make it possible to use a new nfnetlink group as Pablo
>   suggested
> 
>  CON:
>   * needs more memory in kernel space (can't use NLMSG_GOODSIZE -
>     allocation uses GFP_ATOMIC)
> 
>  This patch only dumps the rule handle.

Agreed, only rule handle should be fine. We have limited bandwidth
delivering netlink event notifications from the packet path, so
keeping the message small there looks like a good idea to me.

>  As you can see, I reimplemented parts of nfqueue/nfnetlink_log attributes.
>  Problem is that I don't want to add dependencies on nfetlink_log for this,
>  but things like iif and oif are rather imporant, esp. when debugging
>  packets being forwarded.
> 
>  The first 128 bytes of the packet data is also dumped to userspace, currently
>  limited to when we do the initial 'skb->nf_trace=1' assignment in nft_meta.c
>
>  Patrick, I saw your idea wrt. dumping register contents instead, but it
>  seems both complex and 'backwards' to me -- isn't the 'meta set nftrace'
>  rule already a selector, i.e. user would say something like
> 
>  'tcp port 22 limit rate 1/second meta nftrace set 1'
> 
>  So I'm not sure its right to extend nftrace with additional selectors (its
>  also possible that I failed to understand what you were suggesting  8-} )

I can see room to extend this infrastructure later on if we need to
make it more flexible (eg. allow the user to specify what part of the
packets need to be dumped to userspace). We can probably even add a
specific 'trace' expression from the kernel to allow more specific
selection on what packet fields you want to dump to userspace.

BTW, any reason to remove the existing infrastructure? It's been there
since almost the beginning (this would break users that are expecting
the existing behaviour). Moreover, we'll have people using the
iptables-compat infrastructure also expecting a similar output to
native iptables.

You can probably generalize the trace infrastructure through static
key plus indirections to keep both tracing approaches around (allowing
only one at the same time should be enough).

>From userspace, we would need to have a way to indicate that we want
to use the new infrastructure, not the classic tracing. That syntax
would need some thinking. Probably we can introduce a 'trace'
statement, so the syntax looks compact like this:

'tcp port 22 limit rate 1/second trace'

Meaning in this case that the userspace is specifically requesting for
the new kind of tracing.
