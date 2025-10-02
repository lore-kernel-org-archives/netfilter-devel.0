Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45B82F90CD;
	Thu,  2 Oct 2025 08:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759393514; cv=none; b=Pqg4GKTHRqJ2XVVIcUcRsHzNm96FVRJRsTF5YSctvnyvsvEeXHv42IELqCTUOyzJu3HlloyldUrtUw/xdXnNEsE67nNpw5h+wUc3UHn+RwyrgJ22Zf1ivtzMYwLZceB9vPFF8wgVrCAewvH1zax/LyFfpILIbdx83GNp/shT2u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759393514; c=relaxed/simple;
	bh=nWxfZQR7Ozg/B1MyeK9GV94SrsxFI8TSyB/bZm6voY4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cRt5fRdSvEmgOzZZ3OF88WvKZnhj4SY5HmbjcJwJPxaNx2WUX6Zx9ZPSGGZO5zm7AGjM+hL32g1eQM4o9NManuvRUSqT5ncCvA4CZ3c47fySbf/N49zSbjDskDvPwEjLfOPtpbCN+x8bAy7s3jhd7prf+zllg/6LNlJVXoIa2EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2A3E460532; Thu,  2 Oct 2025 10:25:11 +0200 (CEST)
Date: Thu, 2 Oct 2025 10:25:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, bridge@lists.linux.dev
Subject: Re: [PATCH v15 nf-next 3/3] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aN425i3sBuYiC5D5@strlen.de>
References: <20250925183043.114660-1-ericwouds@gmail.com>
 <20250925183043.114660-4-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925183043.114660-4-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> This adds the capability to evaluate 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets in the bridge filter chain.

Same comment as previous patch, this needs to explain the why, not the what.

nft_do_chain_bridge() passes all packets to the interpreter, so the
above statement is not correct either, you can already filter on all of
these packet types.  This exposes NFT_PKTINFO_L4PROTO etc, which is
different than what this commit message says.

I also vaguely remember I commented that this changes (breaks?) existing
behaviour for a rule like "tcp dport 22 accept" which may now match e.g.
a PPPoE packet.

Pablo, whats your take on this?  Do we need a new NFPROTO_BRIDGE
expression that can munge (populate) nft_pktinfo with the l4 data?

That would move this off to user policy (config) land.

(or extend nft_meta_bridge, doesn't absolutely require a brand new expression).

> +static inline int nft_set_bridge_pktinfo(struct nft_pktinfo *pkt,
> +					 struct sk_buff *skb,
> +					 const struct nf_hook_state *state,
> +					 __be16 *proto)

This is only called from one .c file and unless this gets changed later
this should reside in that .c file (without inline keyword).
