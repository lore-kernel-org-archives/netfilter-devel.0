Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E282853FA;
	Sat,  6 Sep 2025 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757193275; cv=none; b=gG8BZ93Xo/KH7g/TQizwkKnnCr+Ws9J0cfr/3o1M85tfRZE92gJdVULU5nXUiJFEEmisOLcCnZ+/ksCeD6p9WLpNnhtmBVFSOLIxfQsZ8ULqAEJtly0kMdoiF5MmT6QZJjeKbSl9vGEIIWatSyAakmDIpyi10rU6fkVJq61q4yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757193275; c=relaxed/simple;
	bh=bfsAAJAEdsT21ydSW2YaaVQq5rhdrjEq0IUPXx6bT0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1Dut4QKB6RnYb3nGNyfqlCe+vamrymJYq8OqYoTOcWLoE6qYywD5N01tp7Zq6uYOskAFLd8ikokLhN3/UZcVCpJmibTR3/x5MqtkhrhCjlA2l/o5y5vYlZBpWxLh8iJEQhFcylEaTRsTBS4+3ghW45qs0btVMESiXU2iB5d7u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 711DC604EE; Sat,  6 Sep 2025 23:14:32 +0200 (CEST)
Date: Sat, 6 Sep 2025 23:14:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v14 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aLykN7EjcAzImNiT@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708151209.2006140-4-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> +	__be16 outer_proto, proto = 0;
>  	struct nft_pktinfo pkt;
> +	int ret, offset = 0;
>  
>  	nft_set_pktinfo(&pkt, skb, state);
>  
>  	switch (eth_hdr(skb)->h_proto) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph;

Maybe add nft_set_bridge_pktinfo() and place this
entire switch/case there?

> +		skb_set_network_header(skb, offset);

I assume thats because the network header still points to
the ethernet header at this stage?
