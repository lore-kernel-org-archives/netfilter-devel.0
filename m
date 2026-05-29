Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F903EA96F
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 16:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780072720; cv=none; b=G8yIw5ytJHn2SpKsgWPlnltol7sxnM8mvVb1dEaiMwBAeCxgovVj4yqmP6R3QxlSz2sLvgUyuagdyNtxyjJVk+i8lL/Eod4Ahq6WgVIyW0Vblv7jHTEmXPkwYN1lXSyXjuRp1/QPnuU7oHpvICRD0kmtaN45mWncNcV/c+W8LTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780072720; c=relaxed/simple;
	bh=/Y8ar8CMumogSsOXnB/Gdqt4/NcRSXVMEOItI1c/JR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GD6uzefkDjd39Y/DJpdge5HFvs+ZLETBeQIpglCwxx+kG9zx5VdcsL8MX0xBgqxI6+hKCG9BV8cM1tDhXR+j1l9tA3BT+CNF2Ns+htYanAvrwU/ulNG0ILskMuBg8lASYNd5NZKMvCC2EA95s1JYYQsrAKdOiDALpLpV7oP5Bxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=soTi04W2; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="soTi04W2"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-134a84f0aa7so518630c88.1
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 09:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780072717; x=1780677517; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lssr/C0cbaJdj27EF+3IvENguNS1iAdnsK2hRzMZQ00=;
        b=soTi04W2pdF9qQtvvsTrmF0Ea6Z7CRMqKiiybhx0GebTYyl3xfi8o8ULMFnh2AqbWp
         X5OFvXNR5s3/9qj0XCjjeGEWJGreK4/skebgbZzb6QVDUFB6f7bdAfB9mHXx3gUyTmrX
         aaIomw7FbR71wQOg2+/Mnwq9BSUlJHfU5g8fg4GFL3rG/mzlExm082jJW/aQPZOhCE+B
         t/I+dla0JFb8v+hlnffM1QcogZcrx6kdP3NWmPwt56jce3he5SVAnI46t5CfXFttVzQK
         wpvDmXJrDl3GAqShfikevPwgfLSpLmi/W0dzOdaPDfw4bSCQPlqKRbraYTOu3SFyx9Ck
         r/Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780072717; x=1780677517;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lssr/C0cbaJdj27EF+3IvENguNS1iAdnsK2hRzMZQ00=;
        b=fONQPCBTed6/2MddvyTxAPpLdFa7MJUlvQueH5huCBccLJDcNUsvXdPBdCfhTGMUZX
         /bRpCkf+UV004ukMWE3nK8k9nGblXSCDuX1l9YpTBwWnMN5TK3tfY8gX2zN2LVzsLQkW
         6PPeFJ7htL0dD8I1TODni3AkmziZrEZiUaqAOHXwqdIP6AgPinxb2SKL7PlaV44XltJ1
         5Poj4sCiYpjOjTrbczkP8JR7w/1PY7VQlBmvt91fLamE/ng5K12HH1DmEgQdn3tqVXS2
         X52bBmTjVFGPk+hzK/bLa5WNDMz1L04tF+eMb9u484AiVyAefC4t/BfpuW+vg9SzwViN
         ut8Q==
X-Forwarded-Encrypted: i=1; AFNElJ9X9+eQCKAlluqhcaK5w/x5euOOUcY7Z+9WSjp+mdPruZGXh30G4uBlaA8pXy5ZRyPJfoTqVY4aTVoIah7NSUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMhtRL+80PeqTP1BlNDLRpMqEv2JpSnZF3xgRWL99UtsVKWj/x
	c6iPQsjGuDbliujwF6lVmVyzSgHU5+V1npemWSEZSLBy8AP+fJFgJiLmCIIxM2CoVX8=
X-Gm-Gg: Acq92OHd/AVyKKUNgFPWGlrMveX+7AT72VP/7SQKNfEhZtvsvmAH7Cr0BtvYBn+L3oj
	A3uMpzgXQze1/rGCGR2gQ2tX1aNkk/wprRX0DXZE1WFhJ6ELwcwqZm379z/pZ4JpA+A0bWuX+qG
	DEogJs9ikU/FNwO48YOFj5mT1cbnlSgfi9zkP1IQXZ1emYRXG6oHeAlKiDaX4yaMr/jybPkuShS
	KQjmBgg+fH459HPE604TZe5NB9THSg2hG3v/EfC00pewcAygzwoIssqRVw/9lE6H2N4ZOOvbpCS
	AYmxdIhkB6QyM5ebBdZimvOaJI5bW42Nhe85AvDS/4yFDZKLNvEmlkOnOMc+FMsF/vqv9nhmbEq
	CKvGxlN3tm9ga8NWSVE58zOJHA7DwouYq5XA295c4cn4LPqLsA9PhtSnUOzJgG3rypU+JlOJriK
	wtu9XbFngC8NxaLpUdsBgt+sAh
X-Received: by 2002:a05:7301:100a:b0:304:e865:f7da with SMTP id 5a478bee46e88-304fa6e6dc3mr112982eec.7.1780072716838;
        Fri, 29 May 2026 09:38:36 -0700 (PDT)
Received: from m2 ([83.171.251.19])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ed2c120csm1801594eec.4.2026.05.29.09.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 09:38:36 -0700 (PDT)
Date: Fri, 29 May 2026 09:38:34 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 3/7] bpf: add bpf_icmp_send kfunc
Message-ID: <nbbkmh744qaq6qkt5jfleu7ukd5ogl55iu2n22w4f6su7wqjvb@zrhwvhqqrj7m>
References: <20260526153708.279717-1-mahe.tardy@gmail.com>
 <20260526153708.279717-4-mahe.tardy@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526153708.279717-4-mahe.tardy@gmail.com>

On Tue, May 26, 2026 at 03:37:04PM +0000, Mahe Tardy wrote:
> This is needed in the context of Tetragon to provide improved feedback
> (in contrast to just dropping packets) to east-west traffic when blocked
> by policies using cgroup_skb programs. We also extend this kfunc to tc
> program as a convenience.
> 
> This reuses concepts from netfilter reject target codepath with the
> differences that:
> * Packets are cloned since the BPF user can still let the packet pass
>   (SK_PASS from the cgroup_skb progs for example) and the current skb
>   need to stay untouched (cgroup_skb hooks only allow read-only skb
>   payload).
> * We protect against recursion since the kfunc, by generating an ICMP
>   error message, could retrigger the BPF prog that invoked it.
> 
> For now, we support cgroup_skb and tc program types. For cgroup_skb and
> tc egress, almost everything should be good. However for tc ingress:
> - packet will not be routed yet: need to set the net device for
>   icmp_send, thus the call to ip[6]_route_reply_fill_dst.
> - fragments could trigger hook: icmp_send will only reply to fragment 0.
> - ensure the ip headers is linearized before processing, and zero out
>   the SKB control block after cloning to prevent icmp_send()/icmpv6_send()
>   from misinterpreting garbage data as IP options.
> 
> Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH are currently supported.
> The interface accepts a type parameter to facilitate future extension to
> other ICMP control message types.
> 
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  net/core/filter.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 9590877b0714..6db0bdd71c6f 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -84,6 +84,8 @@
>  #include <linux/un.h>
>  #include <net/xdp_sock_drv.h>
>  #include <net/inet_dscp.h>
> +#include <linux/icmpv6.h>
> +#include <net/icmp.h>
> 
>  #include "dev.h"
> 
> @@ -12464,6 +12466,101 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md *x, u32 len)
>  	return 0;
>  }
> 
> +/**
> + * bpf_icmp_send - Send an ICMP control message
> + * @skb_ctx: Packet that triggered the control message
> + * @type: ICMP type (only ICMP_DEST_UNREACH/ICMPV6_DEST_UNREACH supported)
> + * @code: ICMP code (0-15 for IPv4, 0-6 for IPv6)
> + *
> + * Sends an ICMP control message in response to the packet. The original packet
> + * is cloned before sending the ICMP message, so the BPF program can still let
> + * the packet pass if desired.
> + *
> + * Currently only ICMP_DEST_UNREACH (IPv4) and ICMPV6_DEST_UNREACH (IPv6) are
> + * supported.
> + *
> + * Return: 0 on success, negative error code on failure:
> + *         -EINVAL: Invalid code parameter
> + *         -EBADMSG: Packet too short or malformed
> + *         -ENOMEM: Memory allocation failed
> + *         -EBUSY: Recursion detected
> + *         -EHOSTUNREACH: Routing failed
> + *         -EPROTONOSUPPORT: Non-IP protocol
> + *         -EOPNOTSUPP: Unsupported ICMP type
> + */
> +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int code)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
> +	struct sk_buff *nskb;
> +	struct sock *sk;
> +
> +	sk = skb_to_full_sk(skb);
> +	if (sk && sk->sk_kern_sock &&
> +	    (sk->sk_protocol == IPPROTO_ICMP || sk->sk_protocol == IPPROTO_ICMPV6))
> +		return -EBUSY;
> +
> +	switch (skb->protocol) {
> +#if IS_ENABLED(CONFIG_INET)
> +	case htons(ETH_P_IP):
> +		if (type != ICMP_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > NR_ICMP_UNREACH)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!pskb_network_may_pull(nskb, sizeof(struct iphdr))) {
> +			kfree_skb(nskb);
> +			return -EBADMSG;
> +		}
> +
> +		if (!skb_dst(nskb) && ip_route_reply_fill_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		memset(IPCB(nskb), 0, sizeof(struct inet_skb_parm));
> +
> +		icmp_send(nskb, type, code, 0);
> +		consume_skb(nskb);
> +		break;
> +#endif
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case htons(ETH_P_IPV6):
> +		if (type != ICMPV6_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> +			return -EINVAL;
> +
> +		nskb = skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!pskb_network_may_pull(nskb, sizeof(struct ipv6hdr))) {
> +			kfree_skb(nskb);
> +			return -EBADMSG;
> +		}
> +
> +		if (!skb_dst(nskb) && ip6_route_reply_fill_dst(nskb) < 0) {
> +			kfree_skb(nskb);
> +			return -EHOSTUNREACH;
> +		}
> +
> +		memset(IP6CB(nskb), 0, sizeof(struct inet6_skb_parm));
> +
> +		icmpv6_send(nskb, type, code, 0);
> +		consume_skb(nskb);
> +		break;
> +#endif
> +	default:
> +		return -EPROTONOSUPPORT;
> +	}
> +
> +	return 0;
> +}
> +
>  __bpf_kfunc_end_defs();
> 
>  int bpf_dynptr_from_skb_rdonly(struct __sk_buff *skb, u64 flags,
> @@ -12506,6 +12603,10 @@ BTF_KFUNCS_START(bpf_kfunc_check_set_sock_ops)
>  BTF_ID_FLAGS(func, bpf_sock_ops_enable_tx_tstamp)
>  BTF_KFUNCS_END(bpf_kfunc_check_set_sock_ops)
> 
> +BTF_KFUNCS_START(bpf_kfunc_check_set_icmp_send)
> +BTF_ID_FLAGS(func, bpf_icmp_send)
> +BTF_KFUNCS_END(bpf_kfunc_check_set_icmp_send)
> +
>  static const struct btf_kfunc_id_set bpf_kfunc_set_skb = {
>  	.owner = THIS_MODULE,
>  	.set = &bpf_kfunc_check_set_skb,
> @@ -12536,6 +12637,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_set_sock_ops = {
>  	.set = &bpf_kfunc_check_set_sock_ops,
>  };
> 
> +static const struct btf_kfunc_id_set bpf_kfunc_set_icmp_send = {
> +	.owner = THIS_MODULE,
> +	.set = &bpf_kfunc_check_set_icmp_send,
> +};
> +
>  static int __init bpf_kfunc_init(void)
>  {
>  	int ret;
> @@ -12557,6 +12663,9 @@ static int __init bpf_kfunc_init(void)
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
>  					       &bpf_kfunc_set_sock_addr);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_tcp_reqsk);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf_kfunc_set_icmp_send);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_kfunc_set_icmp_send);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_kfunc_set_icmp_send);
>  	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCK_OPS, &bpf_kfunc_set_sock_ops);
>  }
>  late_initcall(bpf_kfunc_init);
> --
> 2.34.1
> 

Reviewed-by: Jordan Rife <jordan@jrife.io>
