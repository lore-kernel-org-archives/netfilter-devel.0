Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826094;
	b=WRNFOqyHTG5ly3TaR0UUjcKx8uRW1xWAM26AL1zj1gwaQXYYjRmNDsmMLjJh+Ky33ESy
	 htAa/HIYe//cTKQPgtlenTxXDMPBrzUDDcPGFlMRtsMFI0kyzP0A4oFH9JF0KkwlJT4CX
	 SSupBQwbUVuF+eGLzI5YyEMPF54XgGj7rU8/mAtUTG39zdkR9HtL0qMiuOCSwciG9sELD
	 iabNnFAoGPXbRaWXFtmDzBZlXYxMZUuEIlTZN3hTQOJyqFFr4NgPr3GkEAp58+dyLHpbG
	 LTjfsyfTe4ESKVAlZSfD5moOYu/FvgqZ8iWhHreYuBTzV3vCwxNuODm6gfs4crfIEYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826094;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=bpAqt3vkpgdi9prEru8xJMcJCmuHua0RnlTvNxptGDE=;
	b=DCv1neZTv4xQw5+tpw86NH7lSP9t0ebChPSvzgZrdpdOXkQLDFX16e7AQ6vKIedyn+LM
	 xdGb0SCORwRVuDw5h13JXgKw46C3MiKiYQz6aGQCPSKPSlfru4/hew+dH+1Nlj+YOJ9Du
	 42RaNibE2jFazs5FITco/NzQEuGiRy+asQ1XxH71o6ixiT5+XVLtiAIj271fyLhuKEJoD
	 J/9bS1WCRAC0Dp1WZNb15CRoI2BXwiJLfMvtyDkA6eDlcZ4Uh577xOvF0L3u3JQ29XhSw
	 2Z8Z8/cWkBfVcjSpJYrpb8BDcV+B4QdGR0jtnA6KaKbk+0Lf+9STbs+DafmJeDqPqOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYZGuI9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C4E606A323;
	Mon, 16 Nov 2026 10:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nYZGuI9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF71F000C4;
	Mon, 16 Nov 2026 10:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826094;
	bh=bpAqt3vkpgdi9prEru8xJMcJCmuHua0RnlTvNxptGDE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nYZGuI9HsutNv7MNlehITYeIvk9DkMW7zVq7//uSS8bGVGe9ULAarbQSc6IlWw28X
	 NSWpo2ZnDhLUJTHXFtYF3w/ZYtLWJUGliz3ABwd0yK8wGjzTX9tp0eqjst6nKngig4
	 45YRBXH4S0B/kfPN7f8CV3tR/DM4CJT090kqC4ndX2NqVj2VYHoJC2kVG2w/c/76av
	 UGWn8ToSWlxH/rlc/KTRHN1BN+OGB3kWdIygcGPBNprSYNMCdfHcFQ4BQf1wzkNjov
	 kzrVwhxQVn0+4wPNE8wxsEr4ZfcPM7XOk+IdKBEtNoU8uTtPrJp2vzyDgKm2BFW2zV
	 2KjvsT3njCaAQ==
Subject: Re: [PATCH net-next v3 1/4] net: xfrm: interface: restore dst_orig on
 every xfrm interface
From: netdev-bot+sashiko@kernel.org
To: jhs@mojatatu.com
Cc: netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 jiri@resnulli.us, victor@mojatatu.com, sashiko-bot@kernel.org
Date: Mon, 16 Nov 2026 10:48:13 +0000
Message-ID: <179482609307.3136.802369385137912510@kernel.org>
In-Reply-To: <CORE-9NOG.v3.r0.20261115050625-1@mojatatu.com>
References: <CORE-9NOG.v3.r0.20261115050625-1@mojatatu.com>
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

- [Low] The commit fixes bugs that users can hit, but it has no Fixes:
  tag and no Cc: stable.
- [Low] The commit message contradicts itself about where this patch sits
  in the series, and the second reproducer it gives does nothing at this…
- [Low] In bpf_skb_set_xfrm_info() (net/xfrm/xfrm_interface_bpf.c:82-84),
  the new comment "The allocated dst owns one reference, handed to the…

--

net: xfrm: interface: restore dst_orig on every xfrm interface

xfrmi_xmit2() now restores md_info->dst_orig on both collect_md and
configured if_id interfaces. It takes its own reference with dst_clone()
and drops the metadata dst from the skb before installing the route.
bpf_skb_set_xfrm_info() now allocates a metadata dst per skb, and the
shared per-cpu xfrm_bpf_md_dst is removed.

> Found while testing the dst release for the two producers that steer a
> packet to another device, fixed later in this series. One of the consumers

[ ... ]

> the shortest way to hit the overwrite. A netdev egress fwd rule that steers
> a packet routed with an xfrm encapsulation into an interface reaches the
> same place once the dst release earlier in this series keeps the route:
>
>     ip link add xf0 type xfrm if_id 42
>     ip link set xf0 up
>     ip neigh replace 10.20.0.1 lladdr 02:aa:00:00:00:ab \
>             dev va nud permanent
>     ip route add 10.20.0.1/32 dev va encap xfrm if_id 42
>     nft add rule netdev t c fwd ip to 10.1.0.2 device xf0
>
> Send one packet to 10.20.0.1. With CONFIG_DEBUG_NET=y and panic_on_warn=1
> the kernel panics in xfrmi_xmit() with the metadata dst still installed
> while the route is put back.

[Severity: Low]
The first paragraph says the dst release is "fixed later in this series".
This paragraph says it comes "earlier in this series". Which one is meant?

This commit appears to be the first in the series. The dst release changes
(skb_dst_drop_keep_metadata() and its use in nft_fwd_netdev) come after
it.

At this commit, can the nft reproducer reach the new restore block in
xfrmi_xmit2() at all? The only writer of xfrm_md_info.dst_orig is
bpf_skb_set_xfrm_info(). For an encap xfrm route, skb_xfrm_md_info()
falls back to the lwtunnel state:

include/net/dst_metadata.h:skb_xfrm_md_info() {
    ...
	if (dst && dst->lwtstate &&
	    dst->lwtstate->type == LWTUNNEL_ENCAP_XFRM)
		return lwt_xfrm_info(dst->lwtstate);
    ...
}

dst_orig is never set in that state, so md_info->dst_orig stays NULL.

Also, on the tc-bpf path, wouldn't the first DEBUG_NET warning fire in
bpf_skb_set_xfrm_info() rather than in xfrmi_xmit()? Before this patch,
skb_dst_force() leaves a counted reference in the slot. Then
skb_dst_set(skb, md_dst) trips skb_dst_check_unset() before the packet
reaches the xfrm interface.

> diff --git a/net/xfrm/xfrm_interface_bpf.c b/net/xfrm/xfrm_interface_bpf.c
> index 5ea15037ebd10..8e83c624b774a 100644
> --- a/net/xfrm/xfrm_interface_bpf.c
> +++ b/net/xfrm/xfrm_interface_bpf.c

[ ... ]

> @@ -86,7 +79,8 @@ __bpf_kfunc int bpf_skb_set_xfrm_info(struct __sk_buff *skb_ctx, const struct bp
>  	skb_dst_force(skb);
>  	info->dst_orig = skb_dst(skb);
>  
> -	dst_hold((struct dst_entry *)md_dst);
> +	/* The allocated dst owns one reference, handed to the skb here. */
> +	skb_dstref_steal(skb);
>  	skb_dst_set(skb, (struct dst_entry *)md_dst);
>  	return 0;
>  }

[Severity: Low]
This isn't a bug, but does this comment describe the line it sits on? It
reads as describing the md_dst reference, which the following
skb_dst_set() hands to the skb.

Here, skb_dstref_steal() clears skb->_skb_refdst without dropping the
reference that skb_dst_force() took on the original route. That
reference now belongs to info->dst_orig, and metadata_dst_free() releases
it later:

net/core/dst.c:metadata_dst_free() {
    ...
	dst_release(md_dst->u.xfrm_info.dst_orig);
    ...
}

The kernel-doc for skb_dstref_steal() says:

 * When in doubt, prefer skb_dst_drop() over skb_dstref_steal() to correctly
 * handle dst_entry reference counting.

Using skb_dst_drop() here would free dst_orig while it is still in use.
Could the comment say that the route's reference moves to
info->dst_orig? The other one-way users in net/ipv4/netfilter.c,
net/ipv6/netfilter.c and net/xfrm/xfrm_policy.c have comments like that.

> diff --git a/net/xfrm/xfrm_interface_core.c b/net/xfrm/xfrm_interface_core.c
> index 9835fbe63ccb8..896180f8d1719 100644
> --- a/net/xfrm/xfrm_interface_core.c
> +++ b/net/xfrm/xfrm_interface_core.c

[ ... ]

> @@ -433,25 +434,26 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
>  	int mtu;
>  
>  	if (xi->p.collect_md) {
> -		struct xfrm_md_info *md_info = skb_xfrm_md_info(skb);
> -
>  		if (unlikely(!md_info))
>  			return -EINVAL;
>  
>  		if_id = md_info->if_id;
>  		fl->flowi_oif = md_info->link;
> -		if (md_info->dst_orig) {
> -			struct dst_entry *tmp_dst = dst;
> -
> -			dst = md_info->dst_orig;
> -			skb_dst_set(skb, dst);
> -			md_info->dst_orig = NULL;
> -			dst_release(tmp_dst);
> -		}

[Severity: Low]
Should this patch have a Fixes: tag and Cc: stable? The restore block
removed here and the per-cpu xfrm_bpf_md_dst used by
bpf_skb_set_xfrm_info() both come from:

Fixes: 94151f5aa966 ("xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF")

The patch fixes problems that users can hit:

- the skb_dst_set() warning over a counted dst slot
- the route lost when a clone reaches the interface first
- the link-failure drops on a non-collect_md interface

The DEBUG_NET_WARN_ON_ONCE() in skb_dst_check_unset(), which turns the
overwrite into a splat or a panic, was added later by commit
a890348adcc9.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/CORE-9NOG.v3.r0.20261115050625%40mojatatu.com
