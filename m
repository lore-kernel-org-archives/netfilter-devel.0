Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753774;
	b=n0YdbZanrPDtoUUB5bSxQ8nqIrx83hytp00c4DdjSbz5IWQZxA0JqSrhoDwhkWYTLMTx
	 wBvn3egaCu7TGBHOrzwrOQpRZm7QCvTQdiuxHzRV0Hb7aCtj1wY9kW8bKj8upIsCWJ0AP
	 pqOIGCZyGPT94iDp0K1YKyakF0TooZ+wxJcrCvLUqHc6TUArKFwa8NX7bUQbSzNGn22sy
	 ychCk6T501bf0z8mHTYD2hYPCIRtR2WOihhbQVhkby90LjWdofmyH1vqm0cbV/cWqeEkb
	 c1XaplpzvNtvcEYa6+GOCl7bDrQhyRA0s6o2llUhWbYeBLMTIBQgunEPK507duYYOAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753774;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Dl9/HggcS4fydY7rUkoqQ91fLGnVu7gHe7o/RWfBPTw=;
	b=T2X3N+FPM/2VsRM5eNetL6jblonCxMHtzJEXLkXe/xedenCntLbrySf9rgPhViGgUAoi
	 7Wd1EMxW1YAUhdQZg/9oT9zomJmSh/mu1OkWKOQ+grXvQuTWCLzQhcOrsPtFCHKKTHiOR
	 WP+ZxwZc/ohp+IJlEyGtEt512WO2eoCZq4Ylswbs2JFCn2O1Fprmd2fk+wrh0vO00xVvl
	 hwAr8bXxLmPYQgCgLDHQlWgM9LXYIcoxF1egSGlERzteTKPXmhnVyqX5dE+xn7NkqYr4V
	 NbPKe8NsYVPaX9/lJ9s74ZqiuyssYWwN0E77PAuYf8FBt9R+pSVt2T0Fz1LVfGsbSCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngW8qcHJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B09606A323;
	Sun, 15 Nov 2026 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngW8qcHJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A961F000C4;
	Sun, 15 Nov 2026 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753773;
	bh=Dl9/HggcS4fydY7rUkoqQ91fLGnVu7gHe7o/RWfBPTw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ngW8qcHJg1cVNvohnVIydcn8FsmI4aJqDtKuzhWyG87Sm2K5abN53oIg0B/W6F6JN
	 DGqJ8wTwwA1qJKMUn/HJC0UuswV3os2cI86nf16I1wu7RSSZ7t+J0jR+Y59EKeUUkD
	 OlrvawLkuvGGKzkerCnhwz8bWmVrOuHZQqtRMOF/XbzC+bAg5rR6Bnf9MJc0C+BQc2
	 LSehEmb2mOWR4mCQJhP3nqwAvJLwrT0Uk4FeRYYQHwkEaBoN1VX8CUfGrKgh2h/0QR
	 USR1vcVh8muW9GSWH+E93P/YYoWPWJJ0noJIPuVXRy4q2DzGAcHyOlH+Zqs7hYS86u
	 UxU/dAW6yi6Qw==
Subject: Re: [PATCH net-next 1/2] netfilter: nft_fwd_netdev: drop the stale
 dst when steering to a device
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 victor@mojatatu.com, jiri@resnulli.us, sashiko-bot@kernel.org
Date: Sun, 15 Nov 2026 14:42:52 +0000
Message-ID: <179475377256.2199510.7063513352863534262@kernel.org>
In-Reply-To: <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>
References: <CORE-9NOG.v1.r0.20261111073528-1@mojatatu.com>
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit fixes a real wire-level bug in nft_fwd_neigh_eval()
  (net/netfilter/nft_fwd_netdev.c) but has no Fixes: tag and no Cc:…
- [Low] The commit message says the rule supplies both the device and the
  nexthop "so the route dst is never consulted", which implies dropping…

--

netfilter: nft_fwd_netdev: drop the stale dst when steering to a device

This patch makes nft_fwd_neigh_eval() drop the skb's dst before it
switches skb->dev to the configured output device and calls neigh_xmit().
Without the drop, a packet parked on an incomplete neighbour's arp_queue
can be re-resolved through the stale dst when the queue drains. It then
leaves the configured device carrying another device's link-layer
addresses.

Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/

> Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com
> Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

[Severity: Low]
Should this have a Fixes: tag and Cc: stable?

The skb->dev = dev; followed by neigh_xmit() in nft_fwd_neigh_eval(),
with the skb's dst still attached, came in with:

d32de98ea70f ("netfilter: nft_fwd_netdev: allow to forward packets via neighbour layer")

The bug became much easier to hit once nft_fwd_validate() allowed
NF_NETDEV_EGRESS, because egress skbs always carry the output route's
dst:

f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")

The reproducer in the commit message uses an egress chain. Without a
Fixes: tag, stable backporters can't tell which trees need this fix.

> diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> index a48c2f765bbaa..ad4d61d64cdde 100644
> --- a/net/netfilter/nft_fwd_netdev.c
> +++ b/net/netfilter/nft_fwd_netdev.c
> @@ -175,6 +175,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
>  		}
>  	}
>  
> +	skb_dst_drop(skb);

[Severity: Low]
The commit message says:

    Both lookup inputs the neighbour transmission needs, the device and
    the nexthop, are supplied by the rule, so the route dst is never
    consulted.

Is that accurate? The arp_queue drain is not the only place that reads
the dst. If the target neighbour never resolves, the neighbour's
error_report hook also reads it:

neigh_xmit()
  neigh->output()
    ... resolution fails ...
    arp_error_report() / ndisc_error_report()
      dst_link_failure(skb)

include/net/dst.h:dst_link_failure() {
    ...
	if (dst && dst->ops && dst->ops->link_failure)
		dst->ops->link_failure(skb);
    ...
}

Before this patch, an egress skb handled by "fwd ip to <nh> device <dev>"
whose nexthop never resolved still had its route dst. So
ipv4_link_failure() or ip6_link_failure() sent ICMP host unreachable or
ICMPv6 address unreachable back to the sender, and expired or
invalidated the original route.

Once the dst is dropped, dst_link_failure() returns without doing
anything. __icmp_send() also needs skb_rtable(skb_in), so the packet is
now dropped silently. Local senders no longer get EHOSTUNREACH feedback,
and the route is not expired.

The new behaviour is arguably more correct. The old ICMP and route
expiry applied to a route and device the packet was no longer using,
and the new behaviour matches the ingress hook, where skbs normally have
no dst.

Could the commit message mention this change in user-visible behaviour?

The follow-up patch "bpf: drop the stale dst when redirecting to an
explicit nexthop" makes the same claim for bpf_redirect_neigh(), so the
same question may apply there.

>  	skb->dev = dev;
>  	skb_clear_tstamp(skb);
>

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v1.r0.20261111073528%40mojatatu.com
