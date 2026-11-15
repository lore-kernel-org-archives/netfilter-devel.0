Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794753775;
	b=v90e0pMMxvidpEY7fsO9DBXmuSv6Fc3fujRe/pkaqI2XoBB0G4WRGqEaIABZWcw9DAsW
	 Sd4OLNw0OWZC5kVS3HN7JBc24l7BS5vxO26faKXxcHMtH/D9WnrKkawBz+zBs3WPiLzA0
	 8Zfv9jjuX0jW6giK9ngxzrh4cbtW213DL5i4eANPApKXkDtUe7Uw6/GG/XbV667t41lpp
	 gqbMGHYe9Oc5PpD5P9AaAigZ4B/78iePPoN0QGHiX8q7SiWVNCAAhfJmMfivv0rUzDR4d
	 ZlWnXSUM9BxNP+3HOn2tbNvy1FDgZ34PeYTNGZFoUx4J1Ra5RyUVEfgCdYbQKKztiGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753775;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=5RLrZt8FReUBCz2ezWXwB2Rd3XaHQYT5OlInj55xgUc=;
	b=Y+MG75S+XkvJsgZj8+EcfTwC0DJxCxPNBNUnd6PQthcvfAsmam4XAJFdPv6dnJ5wo+UW
	 KvHIMsQgiP70xcC0bDSwq60k3OUfnJx5yOwz0S3giodoMW8ibuGEBoLU13iRiMVT697aI
	 acihpDdYz8mHbx6GEAd6g5A/ZmVRDZ9KGsjr4i2N2356Na1CHZ58r4yUCYTbjJbXx212n
	 VG3F7GH8Ls65KccEbVCOT8IhpVQ9o7Uyea3YszTqG8EVjrbdhwM/a6rhbuMCQAy8mAZuT
	 nY44Cmy6Z/7PDngnh9uZSM4neDUSepO3lPrCgP8grR/ZFnA7Hg8MHjsliHYMZWc0LQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VPr0o8yj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE98606A331;
	Sun, 15 Nov 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VPr0o8yj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1FF1F000C4;
	Sun, 15 Nov 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794753775;
	bh=5RLrZt8FReUBCz2ezWXwB2Rd3XaHQYT5OlInj55xgUc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=VPr0o8yjky0ZwmSord9IiHgcoJFWBmJvNk79LBlJeUiI5245JKSE/iUwvJjV7kBlN
	 ybx0gcMT+82/LNr2jcp3NMm16U2jcbJ+FkrV1NnRwJzv3oI3VUr5FhXRHA7Qb18Q9u
	 U2FvCRlGCI8JBMcO/MChuEcCrwNRR0IzEky7Ats4S0gUW23tCFRGg8Q0keSpLtBPkD
	 QtjZJyFRPEvjB3MoaEJZSDU8UC3HGYEBDtH0gs4M4mTRZ3sbtV8FFTlr64NFfFch2B
	 Y6jXzqW0ft0tDYjzr0pP59YPdi1y/phpvR6iCIrbeaipnZMBIUeD6rX78abnlLaQ+1
	 aV/WdFYsvSdag==
Subject: Re: [PATCH net-next 2/2] bpf: drop the stale dst when redirecting to
 an explicit nexthop
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 victor@mojatatu.com, jiri@resnulli.us, sashiko-bot@kernel.org
Date: Sun, 15 Nov 2026 14:42:54 +0000
Message-ID: <179475377405.2199510.12212399228969931993@kernel.org>
In-Reply-To: <CORE-9NOG.v1.r0.20261111073528-2@mojatatu.com>
References: <CORE-9NOG.v1.r0.20261111073528-2@mojatatu.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] The new `else { skb_dst_drop(skb); }` branches in
  __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6()…
- [Low] The commit fixes a user-visible bug but has no Fixes: tag (and no
  stable Cc).

--

bpf: drop the stale dst when redirecting to an explicit nexthop

With BPF_F_NEXTHOP, __bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6()
skip the FIB lookup. They leave the packet's original dst attached while
skb->dev is switched to the target device. If the packet is parked on the
target's arp_queue, the drain looks the neighbour up again from that stale
dst and builds the frame with the wrong link-layer header, so the patch
drops the dst on the explicit-nexthop branch.

Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/

> Reported-by: Sashiko (nipa) <sashiko-bot@kernel.org>
> Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com
> Link: https://lore.kernel.org/netdev/QDISC-6HS9.v3.r0.20261103062649-2@mojatatu.com/
> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>

[Severity: Low]
Should this patch carry a Fixes: tag? The explicit-nexthop branches in
__bpf_redirect_neigh_v4() and __bpf_redirect_neigh_v6() that keep the
original route dst came from:

Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop")

The related fix for the non-nexthop branch, commit 23f3770e1a53 ("bpf: Fix
metadata_dst leak __bpf_redirect_neigh_v{4,6}"), had a Fixes: tag.
Without one here, stable kernels that contain ba452c9e996d may not get
this fix.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index aca8160b26a1a..2af24f371648a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -2318,6 +2318,8 @@ static int __bpf_redirect_neigh_v6(struct sk_buff *skb, struct net_device *dev,
>  		skb_dst_set(skb, dst);
>  	} else if (nh->nh_family != AF_INET6) {
>  		goto out_drop;
> +	} else {
> +		skb_dst_drop(skb);
>  	}

[Severity: High]
Can this drop a metadata dst that was attached by
bpf_skb_set_tunnel_key()?

The new else branch drops any dst on the skb and does not check whether
it is a route dst. bpf_skb_set_tunnel_key() stores the TX tunnel info in
a DST_METADATA dst:

net/core/filter.c:bpf_skb_set_tunnel_key() {
    ...
	skb_dst_drop(skb);
	dst_hold((struct dst_entry *) md);
	skb_dst_set(skb, (struct dst_entry *) md);
    ...
}

Take a tc program that calls bpf_skb_set_tunnel_key() and then
bpf_redirect_neigh() to a collect_md vxlan or geneve device, using an nh
from bpf_fib_lookup().

Before this patch the metadata dst stayed on the skb. vxlan and geneve
call netif_keep_dst(), so __dev_queue_xmit() keeps it. vxlan_xmit() then
finds skb_tunnel_info() with IP_TUNNEL_INFO_TX and encapsulates.

After this patch skb_tunnel_info() returns NULL. In collect_md mode,
vxlan_xmit() then drops the packet:

drivers/net/vxlan/vxlan_core.c:vxlan_xmit() {
    ...
			if (info && info->mode & IP_TUNNEL_INFO_TX)
				vxlan_xmit_one(skb, dev, cfg, vni, NULL, false);
			else
				kfree_skb_reason(skb, SKB_DROP_REASON_TUNNEL_TXINFO);
    ...
}

Geneve behaves the same way.

If the overlay neighbour is not yet resolved, arp_solicit() also reads
the tunnel metadata for the ARP request from the parked skb's dst:

net/ipv4/arp.c:arp_solicit() {
    ...
	if (skb && !(dev->priv_flags & IFF_XMIT_DST_RELEASE))
		dst = skb_dst(skb);
    ...
}

With that dst now NULL, would the solicitation be dropped too, so the
neighbour never resolves?

The commit message says:

  That branch never consults the route dst, so nothing is lost

That is true for a routing dst. The target device's xmit path does read
a metadata dst, though.

Metadata dsts use dst_blackhole_ops, and dst_blackhole_neigh_lookup()
returns NULL. For those dsts, the arp_queue drain already falls back to
the parking neighbour.

Would skipping the drop when skb_metadata_dst(skb) is set fix the
reported bug without this regression?

The same question applies to the new else branch in
__bpf_redirect_neigh_v4().

No selftest covers this case. test_tc_neigh_fib.c only redirects with a
FIB-derived nexthop and no tunnel key.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v1.r0.20261111073528%40mojatatu.com
