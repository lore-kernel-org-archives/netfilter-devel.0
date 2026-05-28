Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CFD35E1C5
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 22:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780008927; cv=none; b=fKarQgFnW/z6bhpIMkwxsJMPP31IaQ8YfqeqiaplGofpLX2PPW/SkHSV2Na9H5DGYeVweEsLlUzspLB7GqiWxPZxa/mPKDQRGEQmZ6wcyl1Tqmkv4e0YroAV6PnsPHycMmbnQe8rjFMPt3kNlmEkv2TKbNcQ/k47Pgw/hVXBevw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780008927; c=relaxed/simple;
	bh=gUg4kL9iR5hB8Ypqz6110iEcJAPWiMTNoFdNb4h3p3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUNMEYoKSy1po5l2MB66C3i7jMxETde4GusrPTqlPgbyGBqwWYvkA3duzbIIePvTlN/3A3clgMhXUioQ00bzZfmse213VrWMh9v1k/alxP4vgefLHDYsIxS4RRZ6WLeekPexRI6zuPbx9FnVhFOxaL3JzGKRER2a+SADPLE2148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io; spf=none smtp.mailfrom=jrife.io; dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b=bA7fTj1+; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrife.io
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=jrife.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrife-io.20251104.gappssmtp.com header.i=@jrife-io.20251104.gappssmtp.com header.b="bA7fTj1+"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-304e86ecebfso42964eec.0
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrife-io.20251104.gappssmtp.com; s=20251104; t=1780008924; x=1780613724; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/OI0XBr71m8+fIw8mop/p1lSkvQIE4q6RcEBq9LfRZc=;
        b=bA7fTj1+e40zuuBMtYzWDvnHZVpbNjKmVEAc02maNe203V7hWg0JiWU2hDZDOCjvk7
         ut+8oh5DEE3hEbh8Wmud0DernOhUqDDHZdtj6erfdpnDB2Guke4H0W5aC0SJdrGLqkxc
         ZvUtpxBJFO0VOvh99Ems7x3B6c2tATIeSFAzkSXa04q4oX7ZGEWJ83IagXglykx85MY6
         S+ycZi7sIw43wMckdYBOg/hI5NktO1e2Tsr42+1vuYp3d09PsnXOh6aWjr/bQcsnOVBt
         9x4hEqX7Nxp7HP4FUpxUlqBFc2mxE33UzB7IVm0B1NkKsx8Ll2fH0vPpEvPJXpZ/+jMP
         Bi3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780008924; x=1780613724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OI0XBr71m8+fIw8mop/p1lSkvQIE4q6RcEBq9LfRZc=;
        b=j5gtYon5vpgAjsY/8dWxm/He1sGNhGBht++ZB/oh50ZKSsd/+Uo1m3/mc3jW5gIJE5
         i8Ja6zn3fCuAAe3N4a3GzlYLu5vqn1kAKO9jjT4ERzWfeS9HNT6FNriakLjSCYsmzwPd
         wvMJ7pwU7anyZmlJDZN8SC2BnMUjBCKhacCSykBwxJV2nk0LViXieQsLw+rQfcEOLyU/
         w5CwfMKtll8v9TZ/RXIqNCACK4rpfuZFpjw7QdS33yGHMG/9bG1w7pw8dfkhas2Ayum0
         q0vpQfXZ9OIHJd2mRdpgtH1dqT7E2bd2qrBofjxLkMzUDC7tLHOWSLBzXj2hWs5spLbH
         mtNQ==
X-Forwarded-Encrypted: i=1; AFNElJ880B0tyNLWaoJRs0LePAvPopmVLas1i8WV6cNOJaExdyeh9K+5iaVipLMtQVbI0upAL65F1HSVLtGcEEidJgc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxX9IlHOL1rnUrnZ3KSc237MsLyXaKQtXdcn+IPbDLAxTUekKFP
	MD8TOfKRRquZkZPNVeIxst3HZdsqxO+dbIEML8rh6mcyO0HKZ7akGc3IK4Z4lc+h7zA=
X-Gm-Gg: Acq92OFUzJ9AvNxeDV8IkXfFQe0kLejsnI2BOD4k3Fr+TxCSztThHT/2fFkJme6Jwjc
	Yu795Cp/CWnDV8OBHpoWS7NToBPb0QSPhYCZ4/YghiwtP/e8OiCOOA9vR936zbzoS3UQTZ0U1dW
	DbvzCupw5Pe8LI4SoePMY0T0uwaM+v1b48K+s/0Bf9LdFG7Rg2NH8vuX4gKy1gXuabjHtB9OYiH
	JOMSK4CU72F8c/D1vqvwWIRDhRi/7aBPVqaGFURQqUUDCCkyjcAV5921eomXB65CYgdfHa5wUmV
	xO7qbdzAeGXJIL0Jh1DWC3XBDGt2RS5TOWO0ZGQrhe69ntvxOhlzehK7P85Oe/DmdvzujYeivJQ
	fYl3nhaEo/EIuNv0qFZ7qMfT5A+UQgUC0d5ask2DBcfIWM4HCHv857zOaV+kP50NpaEpJJHNpKq
	+umRoCIncHr2/zyUeaFciR+NZa
X-Received: by 2002:a05:7300:5b89:b0:2f0:ddce:8468 with SMTP id 5a478bee46e88-304eb24dfbfmr92855eec.8.1780008923733;
        Thu, 28 May 2026 15:55:23 -0700 (PDT)
Received: from m2 ([83.171.251.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-304ebcc77f3sm236627eec.22.2026.05.28.15.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:55:23 -0700 (PDT)
Date: Thu, 28 May 2026 15:55:21 -0700
From: Jordan Rife <jordan@jrife.io>
To: Mahe Tardy <mahe.tardy@gmail.com>
Cc: bpf@vger.kernel.org, martin.lau@linux.dev, daniel@iogearbox.net, 
	john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org, yonghong.song@linux.dev, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, edumazet@google.com, 
	kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH bpf-next v7 3/7] bpf: add bpf_icmp_send kfunc
Message-ID: <d65aepu3gg5mzqy6umxvhwyvwq7gvpezle3f4u6dla7sorndt3@nirsf36ozbii>
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

Won't this prevent the kfunc from working for traffic emitted from
kernel sockets like those used by NFS/SMB mounts? I can imagine there
being a legitimate use case where you'd want those kind of connections
to fail fast as well by emitting ICMP*_DEST_UNREACH.

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
