From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,v4] netfilter: conntrack: introduce clash
 resolution on insertion race
Date: Tue, 3 May 2016 16:36:12 +0200
Message-ID: <20160503143612.GF2395@breakpoint.cc>
References: <1462280210-13007-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:49708 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755748AbcECOgP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 10:36:15 -0400
Content-Disposition: inline
In-Reply-To: <1462280210-13007-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch introduces nf_ct_resolve_clash() to resolve race condition on
> conntrack insertions.
> 
> This is particularly a problem for connection-less protocols such as
> UDP, with no initial handshake. Two or more packets may race to insert
> the entry resulting in packet drops.
> 
> Another problematic scenario are packets enqueued to userspace via
> NFQUEUE after the raw table, that make it easier to trigger this
> race.
> 
> To resolve this, the idea is to reset the conntrack entry to the one
> that won race. Packet and bytes counters are also merged.
> 
> The 'insert_failed' stats still accounts for this situation, after
> this patch, the drop counter is bumped whenever we drop packets, so we
> can watch for unresolved clashes.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: Explicit initialization of ret = NF_DROP for dying conntracks.

Looks good, thanks for working on this.
