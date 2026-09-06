Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598B9217704;
	Sun,  6 Sep 2026 04:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788668324; cv=none; b=dtrZkX4SMYZs+pi49g4h2eF7Sb0KPQ7aGv4rcUdTCbUp/GtfJDhEZnkHSfy69GT8HklUIpZHeFs801YrC8omJRLHqPpyeVbckm2WVjgk1jUqbawhr9EDqDnQWMq2BCcXb8aA5DBT499LrOjz+iHb0e5UnlhaB4kmkzpaPzKUQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788668324; c=relaxed/simple;
	bh=C2APnU0KFZkND5kSczDYEavOxInW2UclGHzMtXaxKvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tZbvVHykqqXC6ZFPYiuHjaGQ7q/q6lpmJ/ZiKYVk58bC5A7NCE4h6M8AgmsKaRr/mVTYfy0zbcZiXRTchoe2cCz1pzv+UdCWDXONxVrilQPMefccHmixTzEjKbAfzUob2owcT9DTMivyN9UWbve0W6fcHHumZYzuRk7UcTBjR8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3F89C60544; Sun, 06 Sep 2026 06:18:34 +0200 (CEST)
Date: Sun, 6 Sep 2026 06:18:33 +0200
From: Florian Westphal <fw@strlen.de>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, co+459f67f4d8af8ce6@bugs.sh,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: ip6t_rpfilter: handle routes without
 inet6_dev
Message-ID: <apzpbMAdqSa_SkEx@strlen.de>
References: <20260906034939.3746540-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260906034939.3746540-1-bestswngs@gmail.com>

Weiming Shi <bestswngs@gmail.com> wrote:
> ip6_route_lookup() can return an error-free route whose rt6i_idev is
> NULL.  For example, lowering an external nexthop device's MTU below
> IPV6_MIN_MTU tears down its inet6_dev while fib6_ifdown() leaves routes
> using nexthop objects in the FIB.
> 
> rpfilter_lookup_reverse6() dereferences rt6i_idev before evaluating its
> loose-mode condition.  This lets an unprivileged user with a private user
> and network namespace trigger a NULL pointer dereference:
> 
>   Oops: general protection fault, probably for non-canonical address
>   0xdffffc0000000000
>   KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
>   RIP: rpfilter_mt
>   ip6t_do_table
>   nf_hook_slow
>   ipv6_rcv
>   process_backlog
>   net_rx_action
>   handle_softirqs
> 
> Evaluate loose mode first because route existence is sufficient there.
> In strict mode, compare devices only when the route has an inet6_dev.

I don't think we should treat rt->rt6i_idev == NULL as an eligible
result, even in loose mode. Maybe this instead?

diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -61,7 +61,7 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
                fl6.flowi6_oif = dev->ifindex;
 
        rt = (void *)ip6_route_lookup(net, &fl6, skb, lookup_flags);
-       if (rt->dst.error)
+       if (rt->dst.error || !rt->rt6i_idev)
                goto out;
 
        if (rt->rt6i_flags & (RTF_REJECT|RTF_ANYCAST))


