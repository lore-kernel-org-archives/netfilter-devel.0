Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AE2379C46;
	Wed,  9 Sep 2026 18:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788979937; cv=none; b=UnC5dn567z9LpdCc0dT99kOAixs66f2ziRvkvcH+5iaFdbyAfVgrh/0xjUBsJl7+uObik+SsWhyabR7nZt4DqK84hG2krhN3VO42SqiHxWnMJ13e/iu0alnkCb6UnfnIbhaMnGgxIl6URcfKFPIZYsszPB8IId5pkHqPtpeMI8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788979937; c=relaxed/simple;
	bh=lqj4FvGFlEJ5FuacsuDuZx4Ha1Iy7mqTj5ytXSOg6PY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hnD7T9QqYUeM/kNnb4J5BQPT9MGH5jAxmUu4WyVe/6Ifd1noQV7W1Fpwy4bdbHKYW+bqCbLhmN3uCL8t0pQmKC8J7ukXBVyYWAmZCVRr5700RBvIoo6RS9Lz8wQRy0UBgggHKAK5IT2WqqwD9YnJmLVdTiYJ9fQMo+69YuZfA4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FHidKaRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FHidKaRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D201F000FF;
	Wed,  9 Sep 2026 18:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788979936;
	bh=JhBrkPGbWgGAvtAaMe0LAPoWBvMekSbbVmJYCuZJDIA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=FHidKaRVG0lBtroCYLJx4dBPD8Jm/R7V6jy35zSv8VH2mDi/7OxFa1rthVqCT9v4S
	 mnjj7dlhckRZSvvbHhI+24akZn41hc+cTVIWCZ6geLY9A2eJqlcaSicmjuMtzPEtWu
	 n2c47jh5EoTh07kngeuPi6F9KJUhjMKeRlkQKGFmluPsTr0BugVdQh+4euSEg7sER+
	 /8XigF7tJ7Lu3/QugFjcMtJQNwcWYhUz7PBt+AdU1QeFty4DfgOlGC3DMjd8f9cvpL
	 Ju6sGhfzRMh+6v8pzqL30k/daKuHlSLTgAk1h8zorJL5/93fVg1d72TujuSVwDH6OK
	 2yVrp9ib0nuYQ==
Subject:
 Re: [PATCH nf] netfilter: ip6t_rpfilter: handle routes without inet6_dev
From: netdev-bot+sashiko@kernel.org
To: bestswngs@gmail.com
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 co+459f67f4d8af8ce6@bugs.sh, xmei5@asu.edu
Date: Wed, 09 Sep 2026 18:52:14 +0000
Message-ID: <178897993484.219967.3278656276914447043@kernel.org>
In-Reply-To: <20260906034939.3746540-1-bestswngs@gmail.com>
References: <20260906034939.3746540-1-bestswngs@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 0

- [Medium] net/ipv6/netfilter/ip6t_rpfilter.c:rpfilter_lookup_reverse6()
  now makes strict-mode matching depend on the presence of an optional…

--

netfilter: ip6t_rpfilter: handle routes without inet6_dev

This reorders rpfilter_lookup_reverse6() so loose mode is evaluated before
touching rt->rt6i_idev, and adds a NULL check on rt6i_idev before the strict
mode device comparison.  The stated trigger is a route using an external
nexthop object whose device lost its inet6_dev.

Closes: https://lore.kernel.org/all/VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh/

> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index 67c87a88cde4f..2bcc96f9385cb 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -72,9 +72,11 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  		goto out;
>  	}
>  
> -	if (rt->rt6i_idev->dev == dev ||
> -	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
> -	    (flags & XT_RPFILTER_LOOSE))
> +	if (flags & XT_RPFILTER_LOOSE)
> +		ret = true;
> +	else if (rt->rt6i_idev &&
> +		 (rt->rt6i_idev->dev == dev ||
> +		  l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex))
>  		ret = true;

[Severity: Medium]
Should the strict-mode comparison use the route's nexthop device instead of
rt6i_idev?  With this form, strict mode returns no-match for exactly the
routes the commit message describes, i.e. those whose device has no
inet6_dev, even when the packet did arrive on that device.

rt6i_idev is filled in best-effort in ip6_rt_copy_init():

net/ipv6/route.c:ip6_rt_copy_init() {
	...
	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
	...
}

while the device itself is always present on the returned route, since
ip6_create_rt_rcu() allocates it from res->nh->fib_nh_dev:

net/ipv6/route.c:ip6_create_rt_rcu() {
	struct net_device *dev = res->nh->fib_nh_dev;
	...
	nrt = ip6_dst_alloc(dev_net(dev), dev, flags);
	...
}

Would comparing rt->dst.dev keep the strict-mode contract and make the NULL
guard unnecessary?

Does this also make the two in-tree implementations of the same reverse path
semantics disagree?  nft_fib_ipv6.c derives the device from the fib6
nexthops and never looks at rt6i_idev:

net/ipv6/netfilter/nft_fib_ipv6.c:nft_fib6_info_nh_dev_match() {
	return nh_dev == dev ||
	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
}

and the IPv4 half of the same match does the same thing:

net/ipv4/netfilter/ipt_rpfilter.c:rpfilter_lookup_reverse() {
	...
	return fib_info_nh_uses_dev(res.fi, dev) || flags & XT_RPFILTER_LOOSE;
}

So for one topology, nft fib saddr . iif oif would still match while
iptables -m rpfilter in strict mode would not, and the common
-m rpfilter --invert -j DROP rule would then drop the packet.

Two paths where the verdict looks like it changes rather than staying
incidentally the same:

1) The VRF second pass.  vrf_ip6_rcv() re-runs PRE_ROUTING with dev set to
the VRF master:

drivers/net/vrf.c:vrf_ip6_rcv() {
	...
	skb = vrf_rcv_nfhook(NFPROTO_IPV6, NF_INET_PRE_ROUTING, skb, vrf_dev);
	...
}

If the reverse route's nexthop is an enslaved device whose inet6_dev was
torn down, and the fib6_info uses an external nexthop object so the route
survives:

net/ipv6/route.c:fib6_ifdown() {
	...
	if (rt == net->ipv6.fib6_null_entry || rt->nh)
		return 0;
	...
}

then the l3mdev_master_ifindex_rcu() clause that used to accept this is now
skipped entirely.

2) A cached exception route (RTF_CACHE, e.g. a PMTU exception) created while
the nexthop device had no inet6_dev keeps rt6i_idev NULL even after the
device's inet6_dev is recreated, so a packet arriving on that very device is
reported as not matching.

Is the NULL rt6i_idev case meant to be treated as "route exists but device
unknown", or is the intent that the check simply never needed rt6i_idev in
the first place?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260906034939.3746540-1-bestswngs%40gmail.com
