Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC977345743;
	Tue,  9 Sep 2025 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757427971; cv=none; b=jlbUjIkHGjnuHMKP803ldgFsJCz9yWrg9kZtLLYwSF2CMNtlxEveyZ6M6oSNNVCHbBOlj2w/oiE9Ny6WZXceNKL+K8sZf/kLNfURl12NOtWJg4f3cLTKBRBo6whBQ1M0z3ingsM9GDR49gynkOdFeTr2V5fRzQ7rGsAKQHtFNsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757427971; c=relaxed/simple;
	bh=qo7Tm4ouH4rHO4+pEEdvznnS6Z0WRZ/Yr5401paIlgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrbOc+hS0crQiTqmiC3nOHzRRoJ99AQ3ghmht5S4QRDoTrosXvJ+t3sCDDbvOqSeQx7JRfusYTM6Pw5mRx6paEuO2/wh3Ovvv0nfXm/DEHIROFlM2nAbJbPZK2VwikT2vcDboCOPr3lYBTJSmMKsdszWKvgtFBgAGNIsaGYqiJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E730260329; Tue,  9 Sep 2025 16:26:07 +0200 (CEST)
Date: Tue, 9 Sep 2025 16:26:07 +0200
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
Message-ID: <aMA4_2-dhnXzUt_j@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-4-ericwouds@gmail.com>
 <aLykN7EjcAzImNiT@strlen.de>
 <5334812c-37cb-42fa-9d53-402cf3d63786@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5334812c-37cb-42fa-9d53-402cf3d63786@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> Ok. At the end of nft_do_chain_bridge() I've added (after removing
> skb->protocol munging):
> 
> 	if (offset && ret == NF_ACCEPT)
> 		skb_reset_network_header(skb);
> 
> To reset the network header, only when it had been changed.
> 
> Do you want this helper to return the offset, so it can be used here?

Makes sense, yes.

> >> +		skb_set_network_header(skb, offset);
> > 
> > I assume thats because the network header still points to
> > the ethernet header at this stage?
> 
> That is correct.

Can you add a comment to that effect?  (I assume it points not
to ethernet header but to the header that follows, e.g. pppoe).

