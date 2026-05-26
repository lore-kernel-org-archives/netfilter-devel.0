Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7443B47FD;
	Tue, 26 May 2026 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779812418; cv=none; b=OAyNR8TXrRGtczEKtN3qsRvFHZ5N77JVngLkJLFVECks5AhkUNWK29Q5okDcEFfU+iEJLwsAh6wUpYic/KMYU8b2ZRtTmY5UTzwPKlAe9ThV4jCeh9pJAvYmJWRrT6h3WWQ/vdKNlD97dE5jbNwI2EU1bp66Y9puOw4lvO7P0os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779812418; c=relaxed/simple;
	bh=LNzcUEFKM3rHewgRlY/HtPpw16korDka0RAidYMf+KY=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=c+/Hk+m4dK+3G8+R3l6ztWzrTvzfXQL6xj8pB3tZ5nhYdpIni3+t2LVRFWkqGXYfP3CwHRrIXg9+Jk2beskmj9xWwLnfSeeb3cHdo13jLZAo9EaVEwMCk/Bzy0JdEl8V135NEG2L730rC3taunMp/Mpp4NLJdW7JYGan+qKKWjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmJPN2Vw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmJPN2Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB851F000E9;
	Tue, 26 May 2026 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779812416;
	bh=uzRt0vOXQxsGI9u7t/+Q2pQZCKwVypSMRt8xxBQ14B0=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=WmJPN2VwKYI+6G+7eNsmqi8FZIcd850lFrIfva6YVIsIlTU0WRta2mqHfEazY8Xh1
	 btSV45rTDvJ1zQUMAUVX1SeOnA+pt47+eEyy59+j5MP3YLNfnhcXVDLAXVYuz2A3WB
	 kZZaclVYtnwmXJWDIrYU9nPlHLjJgzReA/yykqRFxMwmSXJtY6jqSamHNky5qjMZBt
	 XYFpcldu1CzfpM/rEGEHnftNQXDSTSjCQk+bWGWg14I3nR+IXUdMHp575aEcRK3C0+
	 o9WSE1greKw2UPZy9zr3gpe7PIxVqEU9x5BS9wVEOFQkXXxy5NilnlMKFdnO3IW8sq
	 gxZQ40m3tV6Eg==
Content-Type: multipart/mixed; boundary="===============6950901046391295818=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <e05eecf46884c32961a01faff14a72c8382f2a3083999cb88158a1958ffd83d1@mail.kernel.org>
In-Reply-To: <20260526153708.279717-2-mahe.tardy@gmail.com>
References: <20260526153708.279717-2-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v7 1/7] net: move netfilter nf_reject_fill_skb_dst to core ipv4
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,daniel@iogearbox.net,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,yonghong.song@linux.dev,jordan@jrife.io,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 16:20:16 +0000 (UTC)

--===============6950901046391295818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/net/route.h b/include/net/route.h
> index f90106f383c5..300d292cd9a1 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, struct flowi4 *flp,
>  				    const struct sock *sk);
>  struct dst_entry *ipv4_blackhole_route(struct net *net,
>  				       struct dst_entry *dst_orig);
> +int ip_route_reply_fill_dst(struct sk_buff *skb);
>
>  static inline struct rtable *ip_route_output_key(struct net *net, struct flowi4 *flp)
>  {

[ ... ]

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 3d62d45d84bd..ff79992ce098 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2945,6 +2945,21 @@ struct rtable *ip_route_output_flow(struct net *net, struct flowi4 *flp4,
>  }
>  EXPORT_SYMBOL_GPL(ip_route_output_flow);
>
> +int ip_route_reply_fill_dst(struct sk_buff *skb)
> +{
> +	struct rtable *rt;
> +	struct flowi4 fl4 = {
> +		.daddr = ip_hdr(skb)->saddr
> +	};
                   ^^^^

Can ip_hdr(skb)->saddr be accessed safely here?

Now that this is exported for BPF kfuncs, it can be reached from early
hooks like TC ingress where the IPv4 header might not be linearized yet.

If a malformed packet contains less than sizeof(struct iphdr) bytes of
linear data, accessing the saddr field could read beyond the available
linear buffer.

Does this function need validation via pskb_may_pull() or similar to
ensure the header is accessible?

Note: This concern was raised by sashiko-bot@kernel.org in v4 review
(https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/)
and repeated in v6. The author responded that 'it should be fine since
it's the caller responsability to make sure the header has been
linearized, and we are calling pskb_network_may_pull' but the function
itself does not validate this, leaving it vulnerable if called
incorrectly.

> +
> +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);
                                               ^^^^^^^^

Can skb->dev be NULL here?

While safe in its original netfilter context, a BPF_PROG_TYPE_NETFILTER
program attached to the NF_INET_LOCAL_OUT hook will receive locally
generated SKBs before skb->dev is assigned (in __ip_local_out before
ip_output).

If called from such contexts, dev_net(skb->dev) would trigger a kernel
panic.

Does this function need a NULL check on skb->dev?

Note: This concern was raised by sashiko-bot@kernel.org in v4 review
(https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/)
and repeated in v6. The author responded that 'We can't attach such
program as now it's only cgroup_skb and tc, outdated' but the function
is exported via EXPORT_SYMBOL_GPL without any enforcement, making it
callable from contexts where skb->dev might be NULL.

> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +	skb_dst_set(skb, &rt->dst);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);
> +
>  /* called with rcu_read_lock held */
>  static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  			struct rtable *rt, u32 table_id, dscp_t dscp,


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26459248718
--===============6950901046391295818==--
