Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB214318BB3
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2026 07:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790233523; cv=none; b=KKff/J1V4w0uyuKx2kPZOCgb3f8Lzurv+IBw4I2vYHUm/SkENpKXxfJCqvBcUyNTFn66+mrrJoXxQn/twZVmQm1hFsvTRBtPPCfcSHXUOQo/LipV3frv1IbUxaD9paVkB1al1rx5no5l2fO75m9XhMAxWedFA5XA0A34KNNXEus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790233523; c=relaxed/simple;
	bh=EjxcQdQWBDAnXNevqRYTV1oi8BkdZS2ImPd+dxbeudw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkKsF2NkZxcrD3slzguR5rna8zxQHq5JXPhkjLjSJn4WrjgF5XDCFmwnsxUwPLevdB0rRRV/F2fPASwIKPLWfYF8usBSyLkk+xAQyjT1hEDqVJxPKEHcAWJkSx0Mear3A+ZpIn5dic7EiEOKe0gnWvhO3NMzmJrZyrG1x1y6MWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8384760344; Thu, 24 Sep 2026 09:05:13 +0200 (CEST)
Date: Thu, 24 Sep 2026 09:05:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Yu Junzhe <junzheyu1@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [BUG] netfilter: nf_tables_netdev_event UAF of JUMP binding chain
Message-ID: <arTLqWyoMpwfMC7O@strlen.de>
References: <20260924063821.573-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924063821.573-1-junzheyu1@gmail.com>

Yu Junzhe <junzheyu1@gmail.com> wrote:
> I am reporting a slab use-after-free in nf_tables_netdev_event(): deleting
> a netdev hooked by an nftables ingress base chain can free a binding-chain
> successor while the notifier is still walking table->chains. Triggering it
> requires CAP_NET_ADMIN (including in a network namespace). I do not claim
> privilege escalation; the result we see is local DoS (KASAN slab UAF read).
> 
> Summary
> =======
> 
> nf_tables_netdev_event() walks table->chains with list_for_each_entry_safe.
> On NETDEV_UNREGISTER it releases the netdev ingress base chain. A JUMP to an
> NFT_CHAIN_BINDING successor is deactivated (nft_chain_del + bound = false)
> and then nft_immediate_destroy() kfree's that successor. The walker's saved
> nr still points at the freed nft_chain, so the loop increment reads
> chain->list.next.
> 
> The deactivate/destroy path:
> 
>   __nft_release_basechain_now()
>     -> nft_rule_expr_deactivate(..., NFT_TRANS_RELEASE)
>     -> nft_immediate_deactivate(): nft_chain_del(chain); chain->bound = false;
>     -> nft_immediate_destroy(): nf_tables_chain_destroy() when !chain->bound
> 
> list_for_each_entry_safe only protects deleting the current entry, not a
> sibling freed inside the loop body.
> 
> Affected
> ========
> 
> - Confirmed on Linux 6.6.144, KASAN guest.
> - Files: net/netfilter/nft_chain_filter.c, net/netfilter/nft_immediate.c,
>   net/netfilter/nf_tables_api.c
> - Config: CONFIG_NF_TABLES=y, CONFIG_NF_TABLES_NETDEV=y, CONFIG_BRIDGE=y
>   (KASAN used for the report)
> - Source review of torvalds/linux master as of 2026-09-18:
>   nft_immediate_deactivate() still unlinks binding chains on NFT_TRANS_RELEASE
>   and nft_immediate_destroy() still destroys them when !chain->bound.
>   __nft_release_basechain() is gone from nf_tables_api.c and the notifier
>   only unregisters hooks on tip, so this PoC's live RTM_DELLINK trigger was
>   not re-run on tip.
> 
> Ruleset that triggers it
> ========================
> 
>   table netdev t {
>           chain in {
>                   type filter hook ingress device "br0" priority 0;
>                   jump j
>           }
>           chain j {
>                   flags binding;
>           }
>   }

nft fails to parse "binding" here.

> Create br0 in a network namespace, load the ruleset, then RTM_DELLINK br0
> while the namespace is still alive (NETDEV_UNREGISTER). Netns teardown alone
> is too late: nft pernet exit wins that race.
> 
> Crash excerpt (minimized PoC, Linux 6.6.144 KASAN)
> ==================================================

We don't  handle 6.6.144 or other -stable kernels.
Please check current kernels, either linux.git , net.git or nf.git.

If the problem exists there, then please report back with
a working reproducer.
