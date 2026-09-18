Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793453B47C3;
	Fri, 18 Sep 2026 02:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789697056; cv=none; b=Ux9HTopE/n2bTi4oNp6HoaNeJl54dcyFNTN55/q3YcSK1KXMaxHQH/nvrihj9/Q4HIFmjXzllJN+pS+yFRf5flVnQeZcscvH9b5QrKPuOns+/yLh2SZFS0Qkm19t/vAIM93K6LQH8SGm+oQas15lF9FLIG/Vscj8R45h1BjyRtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789697056; c=relaxed/simple;
	bh=Bp6mkDc0mD4rxyW1Gr3Sv25qwAm8a8kl+kZGApgaB3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vkc0srBulbPSe8pXEgwBZ+Relmx3MbCTtyR7ZDjMSH684qw/Y2DLR0a9zJ6I2xW14m/rFVBmfF5VkntI1ID7hSxR/QG/8Kt7yeEB0aYakZR6yGQ0tGh1wjkRVjBvU9B/atJSgjbJo56jOmx88RoiM8N5gvOdmSOPWmUNH2fGEt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WV5oiI6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WV5oiI6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182EF1F00898;
	Fri, 18 Sep 2026 02:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789697051;
	bh=JaboV52UYUJtbPOiiBs4a/Eliiv9mnd+EHX5MYq3Eb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WV5oiI6w0dkqMMA7zzieLibEbRvObGjrrhSmuu40InfHrY9vAfs4BHlMbM5aUYtfd
	 smNZnru9ZaMo+mKqJfGY4a4Pa09g0kGeUq3ZQBJGKDdV6c7nyyee/PqEkSv+QYQwY4
	 kEbc+WDPTIlhbgg5YiWlaBUabIMZzUWy/7UW8XNGiJCxQ1QwVo8+zHw0cdx+xuLH7O
	 UpiPCae0BXfaHqtZePydASlTUXOb0e9wRdBjSzv5PsQX3AGaQ2jdpydbTZxfFY3VIB
	 v/anRwihBOmCAN8dtu6pL5aUAJT2JQJgn4DiWu/PVDvZVb+4/VllXnHW9d9meOcJg4
	 H/lRjk/7HT+Pw==
From: Jakub Kicinski <kuba@kernel.org>
To: pablo@netfilter.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: Re: [PATCH net 03/10] netfilter: ip6t_rpfilter: reject routes without inet6_dev
Date: Thu, 17 Sep 2026 19:04:10 -0700
Message-ID: <20260918020410.3513378-1-kuba@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916231652.127456-4-pablo@netfilter.org>
References: <20260916231652.127456-4-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
---
netfilter: ip6t_rpfilter: reject routes without inet6_dev

This adds a NULL check on rt6i_idev right after the ip6_route_lookup()
call in rpfilter_lookup_reverse6(), so routes that survived in the FIB
after their nexthop device lost its inet6_dev are skipped. It protects
the later rt6i_idev->dev dereferences in the same function.

Closes: https://lore.kernel.org/all/VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh/

> diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
> index 67c87a88cde4f..b5def30c3127e 100644
> --- a/net/ipv6/netfilter/ip6t_rpfilter.c
> +++ b/net/ipv6/netfilter/ip6t_rpfilter.c
> @@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
>  		fl6.flowi6_oif = dev->ifindex;
>  
>  	rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
> -	if (rt->dst.error)
> +	if (rt->dst.error || !rt->rt6i_idev)
>  		goto out;

[Severity: High]
This isn't a bug introduced by this patch, but if rt6i_idev can be NULL on
an error-free route, does the same dereference remain unguarded in
validate_ipv6_net_dev() in drivers/infiniband/core/cma.c?

drivers/infiniband/core/cma.c:validate_ipv6_net_dev() {
	struct rt6_info *rt = rt6_lookup(dev_net(net_dev), &dst_addr->sin6_addr,
					 &src_addr->sin6_addr, net_dev->ifindex,
					 NULL, strict);
	bool ret;

	if (!rt)
		return false;

	ret = rt->rt6i_idev->dev == net_dev;
	...
}

The !rt test there looks equivalent to the rt->dst.error test this patch
just found insufficient, since rt6_lookup() only returns NULL for the
error case:

net/ipv6/route.c:rt6_lookup() {
	dst = fib6_rule_lookup(net, &fl6, skb, flags, ip6_pol_route_lookup);
	if (dst->error == 0)
		return dst_rt6_info(dst);

	dst_release(dst);

	return NULL;
}

So the route class described in this commit message, an error-free cache
route whose rt6i_idev was left NULL by ip6_rt_copy_init():

net/ipv6/route.c:ip6_rt_copy_init() {
	...
	rt->rt6i_idev = dev ? in6_dev_get(dev) : NULL;
	...
}

would pass the !rt check and then be dereferenced when validating an
incoming RoCE CM request via validate_net_dev() -> validate_ipv6_net_dev().

The other in-tree readers of the field already treat NULL as legal:

net/ipv6/fib6_rules.c:fib6_rule_suppress() {
	...
	if (rt->rt6i_idev)
		dev = rt->rt6i_idev->dev;
	...
}

net/ipv6/icmp.c:icmp6_send() {
	...
		if (rt6 && rt6->rt6i_idev)
			dev = rt6->rt6i_idev->dev;
	...
}

Would a follow-up patch adding the same guard to cma.c make sense? Note
that reaching the cma.c site is not unprivileged end-to-end the way the
rpfilter path is: it needs the NULL-idev route to exist in the namespace
of the RoCE netdev, which normally means CAP_NET_ADMIN in init_net plus an
RDMA-capable device. Nothing later in this series touches
drivers/infiniband/core/cma.c or net/ipv6/route.c, so the call site is
still unguarded at the end of the series.
