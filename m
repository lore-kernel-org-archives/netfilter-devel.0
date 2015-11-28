From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Sat, 28 Nov 2015 12:36:47 +0000
Message-ID: <20151128123647.GB17106@macbook.localdomain>
References: <1448649800-26153-1-git-send-email-fw@strlen.de>
 <1448649800-26153-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58142 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbK1Mgw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 07:36:52 -0500
Content-Disposition: inline
In-Reply-To: <1448649800-26153-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.11, Florian Westphal wrote:
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
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Looks very good to me, nice work!

Acked-by: Patrick McHardy <kaber@trash.net>

for both kernel patches.
