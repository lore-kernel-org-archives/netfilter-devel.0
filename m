Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795309215;
	b=Sa16TlAGq3qz689TdMkJlMtQzv8B6sKJkpB5bH/R9APPF7Lqd1duJGCgjNL9XknO1vmS
	 xbFiAx/6sYBlpd+sSl16q6RyjMEzshuGTylbYyvnSGL0v6wkSECALABkESVLIzAqZSuhQ
	 6TDXxzCQco+mowK40RQkFT1BysFEqkoUpZkTcHo2MHPHt0Bhbw1m8gfGCqkhOpWZZqfvx
	 YXEVCbswJJovwIth+2j4cv98po23sjTZgF2RJ3I0TRAuue9An74kjgeu1cRjhAFX6SvIJ
	 VsqIDkY7p3qkuwkglX0jQbZ3+AUklS4wc7X2a2DQbtZ+c9qaYOJia2h8VDMDu3QyNgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795309215;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=yiOSm1bkyAMQFGBb+Y0A4VMMiKXTGYYH6qcBe1qvEcQ=;
	b=3JyVqxXhvD7cbJo/NndODm/98ICvQs+K5oEtSKuqlsOYM0hAtEzoHTbjX2wBcMight7b
	 y3d1tuzU+6Opc3FXkvc03P/rkEoBR8Q0NU0Uvw6pc1slm5woneWNgvCPhE5zRlkvhTE49
	 MNXc5OvCTVpTTOfsz9kwD298btYQyaUxSOBpIdfuDs3F+3p/HmAsPynmTGveeJink0UOW
	 8w6y+ciOuQZ282fYXkviOmpsiAbSnw3ndsJrWKgStjUL2GuUpVDmwV3161SwTeDa0ZQ7x
	 PCYLNjiB+hv4nCB27EiMLoogBm4XaospFSJRfPN8PnHPHIvZV794YEHa6pNDHUq8QdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=idLo7FDd;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id F053F606A32A;
	Sun, 22 Nov 2026 01:00:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F053F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=idLo7FDd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795309212;
	bh=yiOSm1bkyAMQFGBb+Y0A4VMMiKXTGYYH6qcBe1qvEcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=idLo7FDdCW2WIP2s6cJFayiTrWkOe0sP+zL5IHZnpWk1cVN7hsAEhxuxXuB7b3TGC
	 F6+4HON7HbgtUFSuFl4xIzAmTfaDdMR1SEyzTQHES28vx8mUkCnKHUGqNGYvkKpoeK
	 eT9/B6DGS1mApyF7xppRNJFbCXD/RhGkRzbjQ+6zAIlAnmRGcp09ez6cHlCfN+iyxR
	 SwHd6v3NW9oqPDmiZNPJQdXAXrOxI4wm3dgAbzam9FIzJ4p9x3ZHlv9Z74mx+OhLJU
	 e+5fbAtCqI7WRLfbr+P/pKOxdktk2BSrxh5lyqfpMU0jbppHw+pfZdGC7DTilQMzgT
	 WuTn/oRkQ6+0Q==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7883A6005B;
	Sun, 22 Nov 2026 02:00:12 +0100 (CET)
Date: Sun, 22 Nov 2026 02:00:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Simon Horman <horms@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
	"open list:NETFILTER" <coreteam@netfilter.org>
Subject: Re: [PATCH net-next 6/9] net: flow_offload: allow drivers to
 validate and invalidate cached paths
Message-ID: <awI-mtwn3ohPw-fF@chamomile>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
 <20261116222519.1416501-7-florian.fainelli@broadcom.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261116222519.1416501-7-florian.fainelli@broadcom.com>

On Mon, Nov 16, 2026 at 02:25:16PM -0800, Florian Fainelli wrote:
[...]
> +static int nf_flow_offload_validate(unsigned long cookie)
> +{
> +	struct flow_offload *flow = nf_flow_offload_cookie_flow(cookie);
> +	unsigned int dir;
> +
> +	for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
> +		struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
> +		struct flow_offload_tuple *other = &flow->tuplehash[!dir].tuple;
> +		struct dst_entry *dst = tuple->dst_cache;
> +		struct neighbour *neigh;
> +		u8 mac[ETH_ALEN];
> +		bool valid;
> +
> +		if (!dst)
> +			return -EOPNOTSUPP;
> +		/* This is the actual route selected with the packet's policy
> +		 * context, including mark, DSCP and the reverse lookup's oif.
> +		 */
> +		if (!dst_check(dst, tuple->dst_cookie))
> +			return -ESTALE;
> +		if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_DIRECT)
> +			continue;
> +		/* A stacked path may have a different final Ethernet neighbour.
> +		 * Do not mistake that unsupported context for a stale owner.
> +		 */
> +		if (dst->dev->ifindex != tuple->out.ifidx)
> +			return -EOPNOTSUPP;
> +		neigh = dst_neigh_lookup(dst, &other->src_v4);
> +		if (!neigh)
> +			return -ESTALE;
> +		neigh_ha_snapshot(mac, neigh, dst->dev);
> +		valid = (READ_ONCE(neigh->nud_state) & NUD_VALID) &&
> +			ether_addr_equal(mac, tuple->out.h_dest);
> +		neigh_release(neigh);
> +		if (!valid)
> +			return -ESTALE;
> +	}
> +	return 0;

This validation to catch for stale entries looks very similar to what
I'm working on. I guess there is a chance to consolidate all this in
common infrastructure for both software and hardware modes.
