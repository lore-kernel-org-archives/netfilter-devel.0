Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725B3B101C;
	Tue, 26 May 2026 16:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779812416; cv=none; b=kTD0T5ILaqBKr2qUX5Hc4Um9ovL+nT6LzhVe/q/1K/yhpoXQWuUNR+nJWH9hOuUuCQ3M7E9jPl+hE9CptBWB+Iz3QRm4WWU57ZMiR2d6XXOL/F0p508q2NC365m/BPXTBjrvBCgo+tQ5FaxEsSCf+Zf9a8p5AnZjBEFqBNdOM6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779812416; c=relaxed/simple;
	bh=JkD5AwHMLC1iidJJVq3rOlPlh8zSVwFJFU03S6XseLI=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=nNBwLsDMAeDkDrs1O4lHY/5hEG07lMgEvAwH1NGXVTMh5LHsyAiq7UV/bVDRkEEb0yEu8ZQHz3hG0Q7k5JIq2KBq/KCwoq63qcwHeu6VOVdSCfhhGNS92C+b0UojbZfgK/aD64k9pvFzOtVdJ+SEMDa9D/qtgzKaFovppbXjAJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A6fJQtPf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A6fJQtPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBF51F000E9;
	Tue, 26 May 2026 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779812414;
	bh=rWDj5+wy3Ji9M21VFoY4wJ9b0BwAe0WhZBdSUvIxYlk=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=A6fJQtPfzj4yftbH1zNPem37iEAJyGoVjAuaPMwL/toXwswJ74ANg6FPSp5s3/8FR
	 EMA9RiyjkSFUdOQUAmIl1jze8seiwyDKaxk9qIWwJXB+giD6leh7E35pf3V6LPo/n5
	 WDOMPgeKgWwQyretZQ7q2hXPm5YWojWls2EG5Dghby+oVTGjIQwjPAf7TOH1ufQV8b
	 UWnfHCFMjDQ2cKtE33iXCtON1FbTLrOTrh6UtNH+SNavJo7OQ55/YNHyzIViEHxnSJ
	 LF3dzIJT1veyaOFLI/HGBjV7+kgnUUnMNLu94ts9IXNa5NFYgCcf4Bs3vjhIpGAU8r
	 3ShAWtcRQLeRg==
Content-Type: multipart/mixed; boundary="===============5726614534128345162=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <44848566ea55c9974065bd2aad211662a7b319452ecbc6e2f6cc942cb5b4e8d6@mail.kernel.org>
In-Reply-To: <20260526153708.279717-3-mahe.tardy@gmail.com>
References: <20260526153708.279717-3-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v7 2/7] net: move netfilter nf_reject6_fill_skb_dst to core ipv6
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,daniel@iogearbox.net,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,yonghong.song@linux.dev,jordan@jrife.io,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 26 May 2026 16:20:14 +0000 (UTC)

--===============5726614534128345162==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 09ffe0f13ce7..eb5a60d3babe 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -100,6 +100,8 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
>  	return ip6_route_output_flags(net, sk, fl6, 0);
>  }
>
> +int ip6_route_reply_fill_dst(struct sk_buff *skb);
> +
>  /* Only conditionally release dst if flags indicates
>   * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
>   */

[ ... ]

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index b106e5fef9cb..e72065aa5f5a 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -2725,6 +2725,24 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
>  }
>  EXPORT_SYMBOL_GPL(ip6_route_output_flags);
>
> +int ip6_route_reply_fill_dst(struct sk_buff *skb)
> +{
> +	struct dst_entry *result;
> +	struct flowi6 fl = {
> +		.daddr = ipv6_hdr(skb)->saddr
> +	};

Could ipv6_hdr(skb)->saddr read out-of-bounds memory if the IPv6 header
spans paged fragments?

Since this function is exported as EXPORT_SYMBOL_GPL for use by BPF kfuncs,
it might be called on packets where the header isn't guaranteed to be in
the linear data area. If there are no linearization checks like
pskb_may_pull() before accessing ipv6_hdr(), this could read out-of-bounds
memory or cause a page fault when processing undersized or fragmented
packets supplied by BPF programs.

The v6 cover letter mentions "call pskb_network_may_pull on the cloned
pkt", but this linearization check is not present in this function.

While the netfilter caller (nf_send_unreach6) may ensure the header is
linearized, the exported function itself doesn't validate this condition.

Reference: https://lore.kernel.org/bpf/1637d7e04ac3c65239ef77709175697bff287250913d1da68e8d4072e0ff34e1@mail.kernel.org/

> +	int err;
> +
> +	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);

Can skb->dev be NULL in contexts where this function will be used?

Since this function is exported as EXPORT_SYMBOL_GPL for use by BPF
kfuncs, it might be called from program types where the device reference
is not retained, such as socket filters or tc ingress before device
assignment. If skb->dev is NULL in these contexts, dev_net(skb->dev)
would cause a NULL pointer dereference.

While the netfilter caller (nf_send_unreach6) checks and sets skb->dev
to loopback_dev if NULL, the exported function itself does not have this
protection.

Reference: https://lore.kernel.org/bpf/20260421111321.94393C2BCB0@smtp.kernel.org/

> +	err = result->error;
> +	if (err)
> +		dst_release(result);
> +	else
> +		skb_dst_set(skb, result);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
> +
>  struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_orig)
>  {
>  	struct rt6_info *rt, *ort = dst_rt6_info(dst_orig);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26459248718
--===============5726614534128345162==--
