Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E17448096B;
	Mon, 18 May 2026 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779109675; cv=none; b=IGpKn9TEujq4Hq9wxWtS31kLqxQLZ2fbrJs9tbB707+sMWU+30Q2VpEq+nuKwLweDNVl9udXghziWRC9LVIuQc3IZHX7zXAJN5xcbM2V2Rtc6itIDbNWjOJiU4TsDWQbl1dghmqc0JwJZAWG6mYhpcbT7F+c7XHgUEVo5T9U0rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779109675; c=relaxed/simple;
	bh=Pz/3MiL/qO/aB9Br1454DMJoiOo112lvA2sXMF0Z3X8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=GdZeGV8IqTN5+cEdnaCUvtvpV/NIIouZA5RtBGaMadTVCe8vGi+5nX95flss460YCVmYsoaZ5s0fWUqp9gHdDjEtEJwhrPHFMXiZ3+gTJD36wVSWPme/i3o4BcKQi1gZY4Bh1DtSeXFF4vU4Kr211HsFBWMHZ8OFqgnlPHOsRlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOw1kc0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOw1kc0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CB5C4AF09;
	Mon, 18 May 2026 13:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779109675;
	bh=Pz/3MiL/qO/aB9Br1454DMJoiOo112lvA2sXMF0Z3X8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=dOw1kc0e2EmLpGOVWLDrK59fB8SJO5ZMn8/TOVcDJvAIn9whKW7eZFum8dMKCYh4B
	 Z4ooEfebp5W42+PPROsE8IV+PDADHB6Xbj1dALNDFHne5Tc8XmOmlbTja51PikmpAv
	 0jdOTMVV25ZMBpSb3Ph/RQ5b4bEGJl87aBrT139GV+j8Aqfu5C75YFU/ZJG6c1mZ+H
	 XYgZMjN2pscieaumV5TQsFS79I+0Cf/+dmNjmAuZATTR7+PuMPMkWkKqdhvRNdqJ4V
	 OBDjwz8u4aD6xtUM2KrqpUa1M961tvSVYpx0Poj1bUyr9AGMsiGJL0rOoWnAMSv1Dz
	 09VEbFsENFtVg==
Content-Type: multipart/mixed; boundary="===============8738191017777707641=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <af01ada15e1b76da2dfb6cfa749727e0337787f117ddf5724a3cb702513e81dc@mail.kernel.org>
In-Reply-To: <20260518122842.218522-2-mahe.tardy@gmail.com>
References: <20260518122842.218522-2-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v6 1/6] net: move netfilter nf_reject_fill_skb_dst to core ipv4
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,daniel@iogearbox.net,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,yonghong.song@linux.dev,jordan@jrife.io,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 18 May 2026 13:07:54 +0000 (UTC)

--===============8738191017777707641==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index bc1296f0ea69..1f031c5ef554 100644
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

Can this lead to an out-of-bounds read?

Now that this is exported for BPF kfuncs, it can be reached from early
hooks like TC ingress where the IPv4 header might not be linearized yet.

If a malformed packet contains less than sizeof(struct iphdr) bytes of
linear data, does accessing ->saddr require validation via pskb_may_pull()
or similar?

This concern was raised by sashiko-bot@kernel.org in v4 review:
https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/

> +
> +	rt = ip_route_output_key(dev_net(skb->dev), &fl4);

Can skb->dev be NULL here?

While safe in its original netfilter context, a BPF_PROG_TYPE_NETFILTER
program attached to the NF_INET_LOCAL_OUT hook will receive locally
generated SKBs before skb->dev is assigned (e.g., in __ip_local_out before
ip_output).

Does dev_net(skb->dev) need a check to prevent a kernel panic when called
from such contexts?

This concern was raised by sashiko-bot@kernel.org in v4 review:
https://lore.kernel.org/bpf/20260421111320.D97D9C2BCB0@smtp.kernel.org/

> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +	skb_dst_set(skb, &rt->dst);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312
--===============8738191017777707641==--
