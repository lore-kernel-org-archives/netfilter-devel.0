Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27AC2882CC;
	Sat,  6 Sep 2025 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757193094; cv=none; b=Md9owS+U8ZedlmFCIvmwz46Oqq66gG3BS9hbzv6reTZz20OqQRrLuSh9QNtZkXH+cuGJOzDtARm02u1QkijeVNKVz1dBtFWzSPYwRJjc5yJQF4GBXF6wYgL4R4IrWREgvdjoE0a8drotAyKcZs/ZJ1toS85qLrjdYTLJFAtGNT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757193094; c=relaxed/simple;
	bh=t0a81YL+YyAbNhA4M7BdPfKDM6E50+IcCqUkH8qrTrA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fo2yy/rbAhv277zV5ZGAC0n61Jd6JdNpw701pFpkf7nXFtT6ClvxtEewls2SuSizcytoReJGqA0HnqVKOni6fSTHDFaUQ0I64AoEdyiU8Z3XLqW/xVCNQ5LpbTgEtyh+yV+2n/zEH2LokInF8CeS1f/4I0jzGCM6Fy63miykfss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4DE90604EE; Sat,  6 Sep 2025 23:11:31 +0200 (CEST)
Date: Sat, 6 Sep 2025 23:11:30 +0200
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
Subject: Re: [PATCH v14 nf-next 2/3] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aLyjgj5CP5KIvUdl@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708151209.2006140-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
>  	enum ip_conntrack_info ctinfo;
> +	u32 len, data_len = U32_MAX;
> +	int ret, offset = 0;
>  	struct nf_conn *ct;
> -	u32 len;
> -	int ret;
> +	__be16 outer_proto;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if ((ct && !nf_ct_is_template(ct)) ||
>  	    ctinfo == IP_CT_UNTRACKED)
>  		return NF_ACCEPT;
>  
> +	if (ct && nf_ct_zone_id(nf_ct_zone(ct), CTINFO2DIR(ctinfo)) !=
> +			NF_CT_DEFAULT_ZONE_ID) {
> +		switch (skb->protocol) {
> +		case htons(ETH_P_PPP_SES): {
> +			struct ppp_hdr {
> +				struct pppoe_hdr hdr;
> +				__be16 proto;
> +			} *ph;
> +

This function is getting too long, please move this to a helper
function.
