From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nf-next 2/2] netfilter: nf_tables: wrap tracing with a
 static key
Date: Wed, 9 Dec 2015 13:22:20 +0100
Message-ID: <20151209122220.GB2185@salvia>
References: <1448743985-21685-1-git-send-email-fw@strlen.de>
 <1448743985-21685-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbbLIMW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 07:22:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 268F1FB441
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1787EDA801
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7EBA3DA807
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448743985-21685-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 28, 2015 at 09:53:05PM +0100, Florian Westphal wrote:
> Only needed when meta nftrace rule(s) were added.
> The assumption is that no such rules are active, so the call to
> nft_trace_init is "never" needed.
> 
> When nftrace rules are active, we always call the nft_trace_* functions,
> but will only send netlink messages when all of the following are true:
> 
>  - traceinfo structure was initialised
>  - skb->nf_trace == 1
>  - at least one subscriber to trace group.
> 
> Adding an extra conditional
> (static_branch ... && skb->nf_trace)
> 	nft_trace_init( ..)
> 
> Is possible but results in a larger nft_do_chain footprint.

Also applied, thanks.
