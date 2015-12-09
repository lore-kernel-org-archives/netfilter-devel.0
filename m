From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 nf-next 1/2] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 9 Dec 2015 13:22:08 +0100
Message-ID: <20151209122208.GA2185@salvia>
References: <1448743985-21685-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39767 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbbLIMWN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 07:22:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F16FFFB450
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E1702DA7FF
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 80B2ADA80C
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 13:22:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448743985-21685-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Nov 28, 2015 at 09:53:04PM +0100, Florian Westphal wrote:
> nft monitor mode can then decode and display this trace data.
> 
> Parts of LL/Network/Transport headers are provided as separate
> attributes.
> 
> Otherwise, printing IP address data becomes virtually impossible
> for userspace since in the case of the netdev family we really don't
> want userspace to have to know all the possible link layer types
> and/or sizes just to display/print an ip address.
> 
> We also don't want userspace to have to follow ipv6 header chains
> to get the s/dport info, the kernel already did this work for us.
> 
> To avoid bloating nft_do_chain all data required for tracing is
> encapsulated in nft_traceinfo.
> 
> The structure is initialized unconditionally(!) for each nft_do_chain
> invocation.
> 
> This unconditionall call will be moved under a static key in a
> followup patch.
> 
> With lots of help from Patrick McHardy and Pablo Neira.

Nice work Florian, applied.

> Acked-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Florian Westphal <fw@strlen.de>

BTW, I have inverted these two tags. IIRC they should show the
timeline, ie. An ack comes after your original work (thus the
signed-off-by). For patches I get acked myself that get through my
tree, I keep the ack after by Signed-off-by tag.
