Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21CC3F9F46;
	Mon, 18 May 2026 13:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779109677; cv=none; b=XbPGsuwki9yTxHUq7eagUdVmOtk+a3PP8UDQP19pDpyqVBysH+ibrUS+Tous7vzRT9XjO5BeRSNCfLUREbwV5wahHid2nFPvhNVcFWLBuFgZLqyMk4y2JbZJq/RfsBSMKFHc2rDYGWO2mZ0RsKTBX5Q9ZCzNdvzaA/Okyndk4GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779109677; c=relaxed/simple;
	bh=wDhHE+7nMuwQa6zHiOQXTxkw0qm8N32xPT15HPP0geM=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=o7Kwjj+R9/NgWXX4+rIUW2KDVIggT8aQLdVwg0xMJkLB6PEXPHKMVjKFbWrl9h5nxbgNmqzXWvCpXl5oz5erpB5LY+VclxBKwR+pSCiAdYPUr8yHuY4FN/DD0+3ZTgEowGlklM5mQb/iYNKMTYx1dIlJ0Pftut2iroKTH+QBxJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyAiEqbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyAiEqbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20317C2BCB7;
	Mon, 18 May 2026 13:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779109677;
	bh=wDhHE+7nMuwQa6zHiOQXTxkw0qm8N32xPT15HPP0geM=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=UyAiEqbgziyzf5U8Z2aLj4SxeSZvR36p3UkI4rIJcUKE8hHYpfnDrDXT7oYV1fTC7
	 MdY9A0mtxkB7KfKhSnhwrt83lv9OIcwTYlhDy4ruvx07xEvP1GJEzhKvUXEHETO2/N
	 veUHTZM4N0FP6oWLlKbqYxvcDyPNDofi9YrbwD/tLg9oRzvtrJx+0z+aOX6k6GmV+M
	 ZaTM9C3zuOVszv8hpPlD0OD+AlCceqHYiiHLgeOEceIz+M+qN7ZXkarJjpsKxYsuAJ
	 LOecAAhCf4jYOfbe9cvx+ID4WQHYB7WDcBfbVr9SjLwJQOnw99eKmNgSDoSghCe68J
	 e6jj9/SE2lz0g==
Content-Type: multipart/mixed; boundary="===============4254253264928789480=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <1637d7e04ac3c65239ef77709175697bff287250913d1da68e8d4072e0ff34e1@mail.kernel.org>
In-Reply-To: <20260518122842.218522-3-mahe.tardy@gmail.com>
References: <20260518122842.218522-3-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v6 2/6] net: move netfilter nf_reject6_fill_skb_dst to core ipv6
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,daniel@iogearbox.net,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,yonghong.song@linux.dev,jordan@jrife.io,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,edumazet@google.com,kuba@kernel.org,pabeni@redhat.com,mahe.tardy@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 18 May 2026 13:07:57 +0000 (UTC)

--===============4254253264928789480==
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

[ ... ]

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index e3d355d1fbd6..37a7627a94de 100644
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
                         ^^^^^^^^^^^^^^^^^^^^

Is it possible for the IPv6 header to span paged fragments here?

If the packet header isn't guaranteed to be in the linear data area, and
there are no linearization checks like pskb_may_pull() before accessing
ipv6_hdr(), could this read out-of-bounds memory or cause a page fault
when processing undersized or fragmented packets supplied by BPF programs?

While v6 cover letter mentions "call pskb_network_may_pull on the cloned
pkt", this linearization check is not present in this function.

> +	};
> +	int err;
> +
> +	result = ip6_route_output(dev_net(skb->dev), NULL, &fl);
                                  ^^^^^^^^^^^^

Could skb->dev be NULL in contexts where this function will be used?

Since this is being exported for use by BPF kfuncs, it might be called
from program types where the device reference is not retained, such as
socket filters.

If skb->dev is NULL in these contexts, won't dev_net(skb->dev) cause a
NULL pointer dereference?

While the netfilter caller (nf_send_unreach6) checks and sets skb->dev to
loopback_dev if NULL, the exported function itself does not have this
protection. When called from BPF kfuncs, especially in contexts like socket
filters or tc ingress before device assignment, skb->dev could be NULL.

> +	err = result->error;
> +	if (err)
> +		dst_release(result);
> +	else
> +		skb_dst_set(skb, result);
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(ip6_route_reply_fill_dst);
> +

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26034287312
--===============4254253264928789480==--
