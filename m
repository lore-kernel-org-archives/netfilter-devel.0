Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E446A27B4EE
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Nov 2025 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762255100; cv=none; b=JMtb3ov2XG0E5MhHSuVAwBQNZJk3rred2rjv2Ysf8DqMCwLTgAjvHWhJD3Bwy4TnMRjjiPNfw08ad2gkDuuBb/Uuo9RRR2lSeyZFE2U3G6Ghm25P1n6DfRhWDo3HdNT8eyFK6Haq4O4GG566UswVLlOUwSlOCqjMBQr1NgXhaHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762255100; c=relaxed/simple;
	bh=lK0diGY0/MLE7HK7RU3OqIPCaCnQHm34XeXTkDmkVvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JqeUCuBp2tZpA4lly4X5ef95CHCW9qlrD1FQs6IY8Q3k5Woz5PpOeh0TbI+K9OLD6XHIbGMF6Uq+ymae31VWC+0EvxKPpKJZkACwkIk7AloBOn5nEPJQeNzig8njJdf5CBe7yIpn7f5IIASFAauSP27FUgRtCR3jQTfa9wA/reY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 63111603B8; Tue,  4 Nov 2025 12:18:09 +0100 (CET)
Date: Tue, 4 Nov 2025 12:18:09 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org
Subject: Re: [PATCH nf v3] netfilter: nft_connlimit: fix duplicated tracking
 of a connection
Message-ID: <aQng8WtxoVMaABLs@strlen.de>
References: <20251031130837.8806-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031130837.8806-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Connlimit expression can be used for all kind of packets and not only
> for packets with connection state new. See this ruleset as example:
> 
> table ip filter {
>         chain input {
>                 type filter hook input priority filter; policy accept;
>                 tcp dport 22 ct count over 4 counter
>         }
> }
> 
> Currently, if the connection count goes over the limit the counter will
> count the packets. When a connection is closed, the connection count
> won't decrement as it should because it is only updated for new
> connections due to an optimization on __nf_conncount_add() that prevents
> updating the list if the connection is duplicated.
> 
> In addition, since commit d265929930e2 ("netfilter: nf_conncount: reduce
> unnecessary GC") there can be situations where a duplicated connection
> is added to the list. This is caused by two packets from the same
> connection being processed during the same jiffy.
> +	if (!ct || !nf_ct_is_confirmed(ct)) {
> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}

This means the bug fix won't work when this is hooked before
conntrack.

> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> index 0189f8b6b0bd..5c90e1929d86 100644
> --- a/net/netfilter/xt_connlimit.c
> +++ b/net/netfilter/xt_connlimit.c
> @@ -69,8 +69,18 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		key[1] = zone->id;
>  	}
>  
> -	connections = nf_conncount_count(net, info->data, key, tuple_ptr,
> -					 zone);
> +	if (!ct || !nf_ct_is_confirmed(ct)) {
> +		connections = nf_conncount_count(net, info->data, key, tuple_ptr,
> +						 zone);

Same here, but usage in -t raw is legal/allowed.

I would suggest to rework this api so that this always passes in
struct nf_conn *ct, either derived from sk_buff or obtained via
nf_conntrack_find_get().

The net, tuple_ptr, and zone argument would be obsoleted and
replaced with nf_conn *ct arg.

This allows the nf_conncount internals to always skip the
insertion for !confirmed case, and the existing suppression
for same-jiffy collect could remain in place as well.

Its more work but since this has been broken forever I don't
think we need a urgent/small fix for this.
