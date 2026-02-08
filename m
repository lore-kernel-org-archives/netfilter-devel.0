Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 331184086A
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Feb 2026 23:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770594928; cv=none; b=ugPC+/Y8n4WTaVGczyJDI8rvfkfmRDdD54VxGzlEjLf4OogDrnDixrQfiDHN8CNBkzZW6IBlyahx0V4EiBhxhrDdBVeOWDi2zAxwkSc453st2ZkBLGNiwbmwClpwh7gFQAzCl9/zyYpcwuWURjU61+/YxWd+19IDomaEMlFiHhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770594928; c=relaxed/simple;
	bh=2PkKx70iITF+oaTIKKeXXDh3A+0RH8Nw9H4QMVuD2fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L78tbEHtfxuKM31BG2QXtQ8P+6J+g8Xma52SUHjulTj/gRezk6bEIP6ATfMsBRp8Dpg/UAgjb1ntv/KKg64lw+a9zVC5DH+y79myHoWtRa+cl2xKmKOvwhrst+kqbh0Op8yMLINeFBs6cM53nuI5/zkrW11fwxpGAce7aDxOOpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7AFF460AEF; Mon, 09 Feb 2026 00:55:26 +0100 (CET)
Date: Mon, 9 Feb 2026 00:55:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v17 nf-next 4/4] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aYkiburYQtxMUSTj@strlen.de>
References: <20251109192427.617142-1-ericwouds@gmail.com>
 <20251109192427.617142-5-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109192427.617142-5-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
>  #if IS_ENABLED(CONFIG_NF_TABLES_BRIDGE)
> +static int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt, struct sk_buff *skb,
> +				  const struct nf_hook_state *state,
> +				  __be16 *proto)
> +{
> +	nft_set_pktinfo(pkt, skb, state);
> +
> +	switch (*proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;
> +
> +		if (!pskb_may_pull(skb, PPPOE_SES_HLEN)) {
> +			*proto = 0;
> +			return -1;
> +		}

Do you think this could be switched over to skb_header_pointer()?

> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr;
> +
> +		if (!pskb_may_pull(skb, VLAN_HLEN)) {

Same here.

If we need to linearize here, please add a comment explaining why.

Thanks!
