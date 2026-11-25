Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795566650;
	b=h1G2hWQ7NSedpp/tS/pjVRMysBFTP0Sknfo0BL/gYTr8d/RE7ENpVuru5iFK2VnxHpjS
	 yKwtGqer9Ue55rNBw1IOEb+GsicXUlMaYtIVMpMi3HodEc7N4znem9MYgnq9yuUhcKrK6
	 jRdkv+XOb/7Qr4g1YI29Nzsx5RU6oAVwi8rqoqNcIlHZFD6N9vOs2iGtw71zt62RnvK9N
	 Jsa/73Bq/xsgDoDeKaIYic0yCqatmYlnAvIAwgl8F1a0NgDV0fXFEtGB+eIkmYT4cmgoW
	 FgHqmfBHuuWgG5N5TA0rIG902f0si/3TajG/RN6JGw3LXGYcIZRHr42VyGUonCj94RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795566650;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=opO6KqrLeZU2YFUSJAKWKg1/ArS9FwTmKWO3coNyByA=;
	b=jTIzJkSwr2IpFth10akiLuiGuTvxjPrZy60WOvTnqbxZgx7rxFqcGbmnI3s3gD8iL+87
	 uHfdLg3taa9WqoCt6K+iJCSTl22pzxCynGOB9s7hnIgh0bA6L2QT1qat+NKsuzuP1B+/z
	 MWijQmR1BWiIQ6LlSlF3Xwf1yd5g38K80EOOL95Ae+iZ5sTE+QAQ5/5wCkny7Rs00nAUA
	 ysD/9CEkQlnQuAHsI1nyhKvXVcZHcDR9L3k1LtTPPtFSMgdDGHCFa6/uPLqxXBLdN0LMq
	 Rv9uPpnXnjd7FptpQDZiz30kcKyI784YOusUh0yEuoxUOQ3a2egT1rImEC4tmepMPhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rLL1wP2W;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EAE1C606A31E;
	Wed, 25 Nov 2026 00:30:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAE1C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=rLL1wP2W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795566647;
	bh=opO6KqrLeZU2YFUSJAKWKg1/ArS9FwTmKWO3coNyByA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rLL1wP2WAiEAH+1CzJfQMLdmOeZ3TwhZfbvAbLLd2Ki9tOUStpQdz6SyBW6BN3nap
	 sq8dLhfJoCTe9aq5TFnkDw0mFXYul9OsjPwvTm3tgkcLc0Gnu2fKLmtw+UDWSSvBwy
	 1H+O/GjncKALc449Sz3B/omNJrQBz+gi4eczr1nWVoC59kU8fnEpojCAY8QEwMT7xu
	 c748JkTW+s1xwjcIIgMEi2/3o9GsqovIFM3tUayLdO+AB4xgS4ICwhg5dAFYHV4psh
	 LNFshBpcvPhnnwwJD6ytopeGZggf3kp2siaE6Ai3YOA1kidDBMpONjWYkgxAFbVz16
	 g6uVosNgxT2cQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4C65E6007A;
	Wed, 25 Nov 2026 01:30:47 +0100 (CET)
Date: Wed, 25 Nov 2026 01:30:44 +0100
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
Message-ID: <awYsNPjUfgpDAgMr@chamomile>
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
 <20261116222519.1416501-7-florian.fainelli@broadcom.com>
 <awI-mtwn3ohPw-fF@chamomile>
 <b5a899c1-c1b8-409e-8b50-ca722c229f5b@broadcom.com>
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
In-Reply-To: <b5a899c1-c1b8-409e-8b50-ca722c229f5b@broadcom.com>

Hi Florian,

On Mon, Nov 23, 2026 at 08:10:16AM -0800, Florian Fainelli wrote:
> 
> 
> On 11/21/2026 5:00 PM, Pablo Neira Ayuso wrote:
> > On Mon, Nov 16, 2026 at 02:25:16PM -0800, Florian Fainelli wrote:
> > [...]
> > > +static int nf_flow_offload_validate(unsigned long cookie)
> > > +{
> > > +	struct flow_offload *flow = nf_flow_offload_cookie_flow(cookie);
> > > +	unsigned int dir;
> > > +
> > > +	for (dir = 0; dir < FLOW_OFFLOAD_DIR_MAX; dir++) {
> > > +		struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
> > > +		struct flow_offload_tuple *other = &flow->tuplehash[!dir].tuple;
> > > +		struct dst_entry *dst = tuple->dst_cache;
> > > +		struct neighbour *neigh;
> > > +		u8 mac[ETH_ALEN];
> > > +		bool valid;
> > > +
> > > +		if (!dst)
> > > +			return -EOPNOTSUPP;
> > > +		/* This is the actual route selected with the packet's policy
> > > +		 * context, including mark, DSCP and the reverse lookup's oif.
> > > +		 */
> > > +		if (!dst_check(dst, tuple->dst_cookie))
> > > +			return -ESTALE;
> > > +		if (tuple->xmit_type != FLOW_OFFLOAD_XMIT_DIRECT)
> > > +			continue;
> > > +		/* A stacked path may have a different final Ethernet neighbour.
> > > +		 * Do not mistake that unsupported context for a stale owner.
> > > +		 */
> > > +		if (dst->dev->ifindex != tuple->out.ifidx)
> > > +			return -EOPNOTSUPP;
> > > +		neigh = dst_neigh_lookup(dst, &other->src_v4);
> > > +		if (!neigh)
> > > +			return -ESTALE;
> > > +		neigh_ha_snapshot(mac, neigh, dst->dev);
> > > +		valid = (READ_ONCE(neigh->nud_state) & NUD_VALID) &&
> > > +			ether_addr_equal(mac, tuple->out.h_dest);
> > > +		neigh_release(neigh);
> > > +		if (!valid)
> > > +			return -ESTALE;
> > > +	}
> > > +	return 0;
> > 
> > This validation to catch for stale entries looks very similar to what
> > I'm working on. I guess there is a chance to consolidate all this in
> > common infrastructure for both software and hardware modes.
> 
> Excellent, happy to point you to an off the shelf device where you could be
> testing this on, if you would like to?

I have a setup with Banana pi r64 and openwrt, I have this large
series of backports to synchronize with with current upstream trees:

patches/generic-backport/951-netfilter-flowtable-inline-vlan-encapsulation-in-xmi.patch
patches/generic-backport/952-netfilter-flowtable-inline-pppoe-encapsulation-in-xm.patch
patches/generic-backport/953-netfilter-flowtable-remove-hw_ifidx.patch
patches/generic-backport/953-netfilter-flowtable-use-tuple-address-to-calculate-n.patch
patches/generic-backport/954-netfilter-flowtable-Add-IPIP-rx-sw-acceleration.patch
patches/generic-backport/955-netfilter-flowtable-Add-IPIP-tx-sw-acceleration.patch
patches/generic-backport/956-netfilter-always-set-route-tuple-out-ifindex.patch
patches/generic-backport/957-netfilter-Add-ctx-pointer-in-nf_flow_skb_encap_proto.patch
patches/generic-backport/958-netfilter-Introduce-tunnel-metadata-info-in-nf_flowt.patch
patches/generic-backport/959-netfilter-flowtable-Add-IP6IP6-rx-sw-acceleration.patch
patches/generic-backport/960-netfilter-flowtable-Add-IP6IP6-tx-sw-acceleration.patch
patches/generic-backport/961-netfilter-flowtable-dedicated-slab-for-flow-entry.patch
patches/generic-backport/962-netfilter-nf_flow_table_ip-reset-mac-header-before-v.patch
patches/generic-backport/963-netfilter-replace-skb_try_make_writable-by-skb_ensur.patch
patches/generic-backport/964-netfilter-flowtable-fix-inline-vlan-encapsulation-in.patch
patches/generic-backport/965-netfilter-fix-inline-pppoe-encapsulation-i.patch
patches/generic-backport/966-flowtable-use-skb_pull_rcsum-to-pop-vlan-p.patch
patches/generic-backport/967-netfilter-flowtable-avoid-num_encaps-underflow-on-br.patch
patches/generic-backport/967-netfilter-flowtable-bail-out-if-forward-path-cannot-.patch
patches/generic-backport/968-netfilter-flowtable-fix-and-simplify-IP6IP6-tunnel-h.patch
patches/generic-backport/969-netfilter-flowtable-use-dst-in-this-direction-when-p.patch
patches/generic-backport/970-netfilter-flowtable-Validate-iph-ihl-in-nf_flow_ip4_.patch
patches/generic-backport/971-netfilter-flowtable-IPIP-tunnel-hardware-offload-is-.patch
patches/generic-backport/972-netfilter-flowtable-support-IPIP-tunnel-with-direct-.patch
patches/generic-backport/973-netfilter-flowtable-use-correct-direction-to-set-up-.patch
patches/generic-backport/974-netfilter-flowtable-tear-down-flow-entries-with-stal.patch
patches/generic-backport/975-netfilter-flowtable-consolidate-net_device-field-in-.patch
patches/generic-backport/976-netfilter-flowtable-consolidate-flowtable-device-che.patch
patches/generic-backport/977-net-dsa-stop-at-the-user-device-in-.fill_forward_pat.patch
patches/generic-backport/978-net-do-not-advance-stack-index-from-dev_fwd_path.patch
patches/generic-backport/979-net-pass-dst-via-net_device_path-in-dev_fill_forward.patch
patches/generic-backport/980-netfilter-flowtable-release-tunnel-route-on-error-wh.patch
patches/generic-backport/981-net-pass-net_device_path_ctx-to-dev_fill_forward_pat.patch
patches/generic-backport/982-net-remove-WARN_ON_ONCE-from-the-dev_fill_forward_pa.patch
patches/generic-backport/982-0001-netfilter-flowtable-generalize-pending-status-bit.patch
patches/generic-backport/983-netfilter-nft_meta-add-double-tagged-vlan-and-pppoe-.patch
patches/generic-backport/984-net-netfilter-add-ether_type-to-net_device_path_ctx-.patch
patches/generic-backport/985-netfilter-flowtable-rename-tun.l3_proto-to-tun.inner.patch
patches/generic-backport/986-netfilter-flowtable-rename-ctx.tun.proto-to-ctx.tun..patch
patches/generic-backport/987--netfilter-flowtable-store-ethertype-in-flowtable-con.patch
patches/generic-backport/987-netfilter-flowtable-move-ipv4-and-ipv6-xmit-path-to-.patch
patches/generic-backport/988-netfilter-flowtable-detach-layer-2-encapsulation-par.patch

I guess this should be fine for testing this patch, maybe there is a
better way.

I still have to automate testing more classic scenarios in the real
hardware, such as PPPoE (I have configuration to make this local),
vlan, ipip tunnels, wireguard, etc.

If there's anything else I'm missing, please, let me know.

Thanks.
