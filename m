Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E939DBC0;
	Mon, 20 Apr 2026 11:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776684976; cv=none; b=I9e6s48jtrS6nosKmQpl+ovklJTLfBZut+xd0bj5+yZQAvUzrM5pr6Nps+q9ix50908FLmOue5loLuVHZ5XDSj2OqdDsO14CpgKF1sGMuuUxWmLxI9dX9KaZkPS7VonqIRO+ShQ4ruMcbfbdYjGcmZoUmdiXm+h2epdzBA5JS+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776684976; c=relaxed/simple;
	bh=CzC1f2IdcUuuIRupN0t9FEAu5CFDldqNWyqEI6A/ZuU=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=K2YKs9MX3lkVSbMY/NFiDTZfFGwBJuKF1/iZRvR2tQiJnnrqf3tfE/Q8YW9qwY1cBe6Kb6ql66YXDoC1WlX/n9Au0tQeStS1nm0Q8gD8Mt9+E3VmsqstkS1pgJK8wLqfkmqTv1saTgHvUMnM+mfKEmHd5BYPRibJVEc2BeMmKmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVAiU11r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVAiU11r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC08C19425;
	Mon, 20 Apr 2026 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776684976;
	bh=CzC1f2IdcUuuIRupN0t9FEAu5CFDldqNWyqEI6A/ZuU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=YVAiU11rMyQq0Omv4kN/avyNS7ihuTSIhEqP94Ip9HSTQ8NBTtrKA5B+HCeiQLWaf
	 iJJhWOApYot7gcu/UCUluSce1Grvu0fkLRZoUswHhJdT5zzto8HfTgX0SaauH6fzYM
	 lPcCeWzaHYfnZE3D1GYiRg06bbllSIxvYtXNjDDLaeT2mfaIS3eEhwzKtaDayddGyY
	 vDgeLx6gaJqnrdQqbhTeunfFtsjvGmXkaOwzQmi/eIdd9DdunRmzJMRvS4uAV/RzWr
	 jGiS+ao55shSq8vH5+8PNktGm0yl/k/f8zk1i+2y4MJAVKaR7zQzLMY+KN1BZe+SsO
	 18bsManvcxLvA==
Content-Type: multipart/mixed; boundary="===============7598404052493046523=="
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c706a726c2e82dfc6162f96d7c04313301c24d1a4e36af5c421fda7a1c01b1a1@mail.kernel.org>
In-Reply-To: <20260420105816.72168-4-mahe.tardy@gmail.com>
References: <20260420105816.72168-4-mahe.tardy@gmail.com>
Subject: Re: [PATCH bpf-next v4 3/6] bpf: add bpf_icmp_send_unreach kfunc
From: bot+bpf-ci@kernel.org
To: mahe.tardy@gmail.com,mahe.tardy@gmail.com
Cc: alexei.starovoitov@gmail.com,andrii@kernel.org,ast@kernel.org,bpf@vger.kernel.org,coreteam@netfilter.org,daniel@iogearbox.net,fw@strlen.de,john.fastabend@gmail.com,lkp@intel.com,martin.lau@linux.dev,netdev@vger.kernel.org,netfilter-devel@vger.kernel.org,oe-kbuild-all@lists.linux.dev,pablo@netfilter.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Mon, 20 Apr 2026 11:36:15 +0000 (UTC)

--===============7598404052493046523==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/net/core/filter.c b/net/core/filter.c
> --- a/net/core/filter.c
> +++ b/net/core/filter.c

[ ... ]

> @@ -12423,6 +12427,86 @@
>  	return 0;
>  }
>
> +static DEFINE_PER_CPU(bool, bpf_icmp_send_in_progress);
> +
> +/**
> + * bpf_icmp_send_unreach - Send ICMP destination unreachable error
> + * @skb: Packet that triggered the error
> + * @code: ICMP unreachable code (0-15 for IPv4, 0-6 for IPv6)
> + *
> + * Sends an ICMP destination unreachable message in response to the
> + * packet. The original packet is cloned before sending the ICMP error,
> + * so the BPF program can still let the packet pass if desired.
> + *
> + * Recursion protection: If called from a context that would trigger
> + * recursion (e.g., root cgroup processing its own ICMP packets),
> + * returns -EBUSY on re-entry.
> + *
> + * Return: 0 on success, negative error code on failure:
> + *         -EINVAL: Invalid code parameter
> + *         -ENOMEM: Memory allocation failed
> + *         -EHOSTUNREACH: Routing lookup failed
> + *         -EBUSY: Recursion detected
> + *         -EPROTONOSUPPORT: Non-IP protocol
> + */
> +__bpf_kfunc int bpf_icmp_send_unreach(struct __sk_buff *__skb, int code)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)__skb;
> +	struct sk_buff *nskb;
> +	bool *in_progress;
> +
> +	in_progress = this_cpu_ptr(&bpf_icmp_send_in_progress);
> +	if (*in_progress)
> +		return -EBUSY;
> +
> +	switch (skb->protocol) {
> +#if IS_ENABLED(CONFIG_INET)
> +	case htons(ETH_P_IP):
> +		if (code < 0 || code > NR_ICMP_UNREACH)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!skb_dst(nskb) && ip_route_reply_fetch_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		*in_progress = true;
> +		icmp_send(nskb, ICMP_DEST_UNREACH, code, 0);
> +		*in_progress = false;
> +		kfree_skb(nskb);
> +		break;
> +#endif
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case htons(ETH_P_IPV6):
> +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!skb_dst(nskb) && ip6_route_reply_fetch_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}

Is the route lookup needed here? Looking at icmpv6_send() in
net/ipv6/icmp.c, it fills fl6.{daddr,saddr} and passes them to
icmpv6_route_lookup() which performs its own route lookup. The function
doesn't appear to use skb_dst() from the original skb:

icmpv6_send() {
    ...
    fl6.daddr = hdr->saddr;
    fl6.saddr = saddr;
    ...
    dst = icmpv6_route_lookup(net, skb, sk, &fl6);
    ...
}

The same applies to the IPv4 path with icmp_send(). Additionally, at
cgroup/egress the skb->_skb_refdst should already be set, and the same
should be true for cgroup/ingress for inet proto.

Does the kfunc work without ip_route_reply_fetch_dst() and
ip6_route_reply_fetch_dst()? If so, can these calls be removed?

Reference: Martin KaFai Lau's comment in v3 review
https://lore.kernel.org/bpf/df4b0996-3e88-4ea4-983b-82866455a6fc@linux.dev/

> +
> +		*in_progress = true;
> +		icmpv6_send(nskb, ICMPV6_DEST_UNREACH, code, 0);
> +		*in_progress = false;
> +		kfree_skb(nskb);
> +		break;
> +#endif
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	return 0;
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/24663313503
--===============7598404052493046523==--
