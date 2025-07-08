Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C47C219A97;
	Tue,  8 Jul 2025 22:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012162; cv=none; b=u5mxaxGLbeeJcB8qniA85pYVqlqV5bM7PIIDpDhNndveStpbjIqqVvyI/M+v9UgrvE/1AjL87H0tfFPUwXHcct+Dms6eUYHGPP6SbolY3ghNY73UZ+y+jOnWguSWWulhCJFTEEjXqpzxBAhGdBQa2LvmDyKxu4G7mg16WxgDSl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012162; c=relaxed/simple;
	bh=z0tUCMMPDbF3xWgFul1BEHRkbE3mK2LburHI2nQPO1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euZ7g0GsdQ3w9Bja2sSmJRUBsNnK9a1e5074yUvDzo86qdHSq65DXIsPCiERs/IUkgsccEd8oqlse0zRmRSXYZl2641jbZQ0gqOzsPwcn2zyIl6P7frI5xj05cQjRyHrsyCOM0vUtH/asq01K110elVUZYicl9soBBG+Vk7F9Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1ACA76122E; Wed,  9 Jul 2025 00:02:38 +0200 (CEST)
Date: Wed, 9 Jul 2025 00:02:38 +0200
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
Message-ID: <aG2Vfqd779sIK1eL@strlen.de>
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
> +		if (!pskb_may_pull(skb, VLAN_HLEN))
> +			break;
> +		vhdr = (struct vlan_hdr *)(skb->data);
> +		offset = VLAN_HLEN;
> +		outer_proto = skb->protocol;
> +		proto = vhdr->h_vlan_encapsulated_proto;
> +		skb_set_network_header(skb, offset);
> +		skb->protocol = proto;

Why is skb->protocol munged?  Also applies to the previous patch,
I forgot to ask.
