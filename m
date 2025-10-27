Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64284283FEE
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 13:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761572884; cv=none; b=cUCeT+fZTKMe6SS9hc/pYRu9VyqQXy8yjLCLa9ykSJWh+gWWFk8ksLpVIzi5fvo0z3YJDFWpz+22nnTQIgGacJ9k/Anvt1XsusjcqcoIMUp3P1EI8F622Ic2ytB/Z8+HF1fOBORIlQu3ihwoWHnBZeZUoIhKHsZMVKTXLh8t9Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761572884; c=relaxed/simple;
	bh=tXYu9PpgNviFE8jhWeEDF4hS30GPLSas+xXIg791Maw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwfx73EiHIdRDSwk5E/8bzGYXMDtQrfI+3Jh94/00AIFGuwb4POa30lhmQqimyRgSfVQdBCJjEWWXSdnPB/phJywtxaL+nAx1DB43ORZ4ZD+d5nYW326gvVH45n1D5rQ4nYSReVJMvj5NxilXiMsPseGhOuaE8tb9m3ROELuA6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 61DCD6031F; Mon, 27 Oct 2025 14:47:52 +0100 (CET)
Date: Mon, 27 Oct 2025 14:47:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aP94A1HduHkJudgg@strlen.de>
References: <20251027125730.3864-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027125730.3864-1-fmancera@suse.de>

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

Right.  Would you mind sending a patch for nftables documentation to
recommend combining this with ct state new or similar?

> +	if (ctinfo == IP_CT_NEW) {
> +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> +			regs->verdict.code = NF_DROP;
> +			return;
> +		}
> +	} else {
> +		local_bh_disable();
> +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> +		local_bh_enable();

LGTM, we could make a __nf_conncount_gc_list and make
nf_conncount_gc_list not need BH disable (and do the jiffies
check first w.o. BH disable) but I think in the interest of
a small patch and given that we should not be dealing with
!new packets anyway I think this change is fine.

Thanks Fernando for fixing this up.
