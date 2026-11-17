Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794958167;
	b=D7/NXXjS3B1O9uLdkQQVacJ1TBBHsbCxl13dj+xC1jsY7DbwQc+5votjvySqotq3dJJ4
	 Z0E+YLdhxaRqBo+wpzqWGqcIuPSjNZ4HmW+FlG4iEKAuUemZLUVSlSvrz8FjoQc7Xn37E
	 FPJOpGJ5TPQUJBRWHwH7X+paCoFJdiy/tTYAyGpzdkuJ4+jUg2bDpN81St/LtH4kTscVV
	 8MPxqbPQ3DVzzGIvzXtkBaBLVUXHadH0xdcLobt1aI5LDJoIs+1f5qGkrmHmQAh5kG1Cp
	 hgZpPZHu2ILA5F6uYxpD/p3mjYysJ0zLGL19bLMnw5a9Ei/SyrEjiOjYsmMFRydqTdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794958167;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=/yJ9dNx5yVh93vwEf5CM2Fn23ZVD9CZY/sPC1mwnSA0=;
	b=rC9dzUE8gzpDv3q6jAlMXsWrlGFqN7TMpd502jXnhIrpX47m8cm3rCrwZTJHqBaPMBKi
	 H+Z1LvRUdDkkwJKGpDfJSuKrrwtvB5R0pTqrwWyM6RGJA0TsQa2Gn1MhzT+VuBV6F8Z2h
	 4qKJw4U7+SJQvrg1gPHX0jyzLhbrXYlAeN67NfdYMBgdkktHzI8jSC9UAF6BOlq86Avbz
	 Q44TqiFTiO8WeJApLhdN1TrTkFF3NQdDJdRfT0iItpt3t8xszbBlP6voq56yLYgDbtMTj
	 IoNnZ55sYJQySwOiKS49QMSERqrqDe2kNoUCdwUdis+tn7MgoDVG/p0uteM7x9P10MA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SAtkIx7T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8D9606A882;
	Tue, 17 Nov 2026 23:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SAtkIx7T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13471F000CB;
	Tue, 17 Nov 2026 23:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794958167;
	bh=/yJ9dNx5yVh93vwEf5CM2Fn23ZVD9CZY/sPC1mwnSA0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=SAtkIx7T4E8me6FOfZazv3JK2G12fgSwGk2LwE1LFItVVrS02NaNQGZvRfMCY8GAn
	 kb5QGPQav0pTnvqAOihh/IJwKeaz0Z009Kp0E9bzWxhzijlczxOIJGW+TOnIXdc+mc
	 3aMzBMPp/857AdiPq7VQQW14FmAgFr6vgal/pGQwqj7WKtgmU1ZXADqoeHDQFVSV1t
	 gOT52Wfgp0dmVllV52XOsmjXCZ61LwBF7Wg98tgiJCPmCAAoA50I+DqJyNR9hd7pPS
	 ijOo4YMMKnKI0+5jFi+GEHOK/3Pmm55FtheFb11Zdt19aUT5QXQe+qGf4k5NqAO0Js
	 EJO8mU6CB71lQ==
Subject: Re: [PATCH net-next 6/9] net: flow_offload: allow drivers to validate
 and invalidate cached paths
From: netdev-bot+sashiko@kernel.org
To: florian.fainelli@broadcom.com
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, horms@kernel.org,
 corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Date: Tue, 17 Nov 2026 23:29:25 +0000
Message-ID: <179495816543.3136.12103952304400202953@kernel.org>
In-Reply-To: <20261116222519.1416501-7-florian.fainelli@broadcom.com>
References: <20261116222519.1416501-7-florian.fainelli@broadcom.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] nf_flow_offload_validate()
  (net/netfilter/nf_flow_table_offload.c:931-939) checks the neighbour…
- [Low] nf_flow_offload_validate()
  (net/netfilter/nf_flow_table_offload.c:929 and 934) is documented as…

--

net: flow_offload: allow drivers to validate and invalidate cached paths

This adds optional invalidate and validate callbacks to struct
flow_cls_offload. Offload drivers can use them to ask the flowtable owner
whether a cached path is still valid, and to tear the owning flow down.
Netfilter now keeps direct-path dst references for hardware flowtables and
implements both callbacks, checking dst cookies and direct Ethernet
neighbours in each direction.

> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 4365859220e6a..1f3adf70f5987 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -885,6 +885,62 @@ static int nf_flow_offload_alloc(const struct flow_offload_work *offload,

[ ... ]

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

[ ... ]

> +		if (dst->dev->ifindex != tuple->out.ifidx)
> +			return -EOPNOTSUPP;
> +		neigh = dst_neigh_lookup(dst, &other->src_v4);
> +		if (!neigh)
> +			return -ESTALE;

[Severity: Medium]
Can this lookup change the neighbour table? For IPv4, dst_neigh_lookup()
goes through ipv4_dst_neigh_lookup()->ip_neigh_gw4(), which creates an
entry when the noref lookup misses:

include/net/route.h:ip_neigh_gw4() {
    ...
	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
	if (unlikely(!neigh)) {
		struct neigh_table *tbl = arp_table(dev_net(dev));

		neigh = __neigh_create(tbl, &daddr, dev, false);
	}
    ...
}

So validation can allocate a neighbour with GFP_ATOMIC, run forced GC
under tbl->lock, and insert a new NUD_NONE entry into the ARP table.

It also looks like two cases that are not provably stale end up returning
-ESTALE. The header documents the contract as:

    Return 0 for a valid path, -ESTALE for a demonstrably stale path,
    or -EOPNOTSUPP when validation is unavailable.

The first case is neighbour creation failing (-ENOBUFS at gc_thresh3, or
-ENOMEM). dst_neigh_lookup() turns the ERR_PTR into NULL, and the
!neigh branch above returns -ESTALE.

The second case is an entry that was garbage collected while the flow kept
forwarding. The software DIRECT path uses the cached out.h_dest and never
confirms the neighbour, so the entry can age out. Periodic GC can remove it
above gc_thresh1, and forced GC can remove it above gc_thresh2. The next
validate then creates a NUD_NONE entry, fails the NUD_VALID test below, and
returns -ESTALE, even though the next hop and MAC have not changed.

The consumer, fa_replace() in drivers/net/ethernet/broadcom/bcm-ns-fa.c
(added later in this series by "net: bgmac: add Northstar IPv4 TCP/UDP NAT
flowtable offload"), calls cls->invalidate() on -ESTALE. That runs
flow_offload_teardown() on a healthy flow.

A flow that the driver declined keeps being offered through
flow_offload_refresh(), roughly once per HZ. Under neighbour table pressure
this could keep tearing such flows down.

That driver's own fa_route_check() uses the lookup-only ipv4_neigh_lookup()
and returns -EOPNOTSUPP on a miss. Would a noref lookup under RCU, such as
__ipv4_neigh_lookup_noref() or __ipv6_neigh_lookup_noref(), returning
-EOPNOTSUPP on a miss, fit the documented contract better?

> +		neigh_ha_snapshot(mac, neigh, dst->dev);

[Severity: Low]
Should these dst->dev accesses use dst_dev_rcu()? This callback runs under
RCU while dst_dev_put() can concurrently republish the device:

net/core/dst.c:dst_dev_put() {
    ...
	rcu_assign_pointer(dst->dev_rcu, blackhole_netdev);
    ...
}

The ifindex check and neigh_ha_snapshot() each do a plain load of
dst->dev, and ipv4_dst_neigh_lookup() does a third load through
dst_dev_rcu(). KCSAN will report the plain loads, and the three loads can
see different net_devices within one validation pass.

There's no memory safety problem here. blackhole_netdev has addr_len set
to ETH_ALEN, so mac[] is fully written, and -ESTALE is the right answer for
a route that has moved to blackhole.

Would taking a single dev = dst_dev_rcu(dst) snapshot, or passing
neigh->dev to neigh_ha_snapshot(), avoid the race?

> +		valid = (READ_ONCE(neigh->nud_state) & NUD_VALID) &&
> +			ether_addr_equal(mac, tuple->out.h_dest);
> +		neigh_release(neigh);
> +		if (!valid)
> +			return -ESTALE;
> +	}
> +	return 0;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261116222519.1416501-1-florian.fainelli%40broadcom.com
