Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C35B1F30A9
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 02:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782266967; cv=none; b=HB+0hLwYGXy0M5ClMz8pCkcUpUHb0rZSVs+nU+aaAc1jsskmap/IAu/1WYhakh3Vp6EdDQLRRFRaN/CCF5SrRkJh2Gr4DWSfyWMmABbKo1wL84jsInyvabFkuq7QAB/Nnu6TUdUGCQOpTeyHYR5mzbJBeoJBUPpfBDnGfSEwDnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782266967; c=relaxed/simple;
	bh=G4PMbo4gAnTzujbJkIZfw7/qAPPtRarxDgz83R4PCvw=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=a/qshs+idYbEsyn3u1FFdtA6zyl485XCHw0zocdsu5HYHPoNmHVV90J8ov2sAnGw9oVANaG0BDxtf9ZCPTJzB9fXGT3MkJ60MCQ8ozZQliwRFFNLqPfRx8t248Bras166E+dXABI/0EJ8z/ha6oNFlIlzCDHp3tqsdj06vZ4lu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=rOkx3abo; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="rOkx3abo"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1397e093f90so1450676c88.1
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 19:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1782266965; x=1782871765; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j+uR5pjN31cxoCLjhADvr4TVIpAsDKEZa8OS2FHuarI=;
        b=rOkx3abouVWR4KZYJnHA2Go6sk8hYe+VNSHnfAsOOBWlrDSfdgluqum2Jr3TbzGndK
         i7dqENRDDykEpsv0dBd4Oo2q06Sdlzwqxo+JcDgzls+dprsdKlgyg4hn6h9GpnctVxov
         aDq/viN/+Bykv5vMnxFHPvlfhSgBIHRjNcR7uvqoDgU8qc9EfqKsAlfByYeFEMKoMxLI
         R6cSjPokUbOdPm7j4jaNTyxmHxnO0FqNe5O20kEQp4CWG6HKWgbGypsyf6UZ+DjodEex
         fgdz3+lYqJ/cfDWbAgOWCDCz1bffy2oiyLx6T8DSwxGpHZq99QDUF1s9dscbTyJHbKUm
         /4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782266965; x=1782871765;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j+uR5pjN31cxoCLjhADvr4TVIpAsDKEZa8OS2FHuarI=;
        b=Bm7SfeBgOPYib6DRvO4VwCUj4N72ec36dT7ckKHYKUAkut3mQIT1cg59NlmSDl7mMb
         zMnNhTdvO0yTYCvdlqfP6Wj5Fhl7lHURFIsWdPKVpQgaYRdOaCfOjI1dS+DWfoqUcHwh
         ADj8lUDYvKlgEnwgnV/UOcp4o7Ap4/k7noxOnLwPVprNS5FnoUUR7NJ0/FyjRDsVqfwg
         HGU0JQZAkYxMz2c4FiguaQDJ104grQvSGciO2OVaoOoUZHvvn4PeoU9Pmv8dXlKkRiEW
         RH0pAJIL15UVedhV7bO9TwWHEIqbleNUBNr3WGcRHpNNeuKwcRyfKfpf3Xpew+6lyhbY
         PZXw==
X-Forwarded-Encrypted: i=1; AHgh+RoWX6i9A5TD753uiWOlosBY8vgbw9tnTK0LfS9POozZIdqmST79yA18gdc11ImQXFaQ4lW+apyaBnh90nUFPF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNOi69IN2l0PG/QQkuzgx5ts/kIp004xXMJlHYtmjCDqv1TId8
	J55jLabPgtSVdL/b8QxcBZ9o6gYXEdpmS3bOqMLhm+MYcr4yGwRR575qiWDAwqxOpHo=
X-Gm-Gg: AfdE7ckVhccNlVBHjTfvEmSPcBAN3xGNjSe7ph6FyLm6jDCgn3154Im9KMCeYBMeJMk
	T2tZbBVYgm8VvYu8YDwHCMWWXygkPGXIx7HG2kb8YGKCqyVMmAfEUbaPiszOD55VhmHWmcvaLG/
	4itTwa7RvYg8sYswRJiDSFP0Go1Woipfsw+2HqPHDXic1IgKWK1iudZI4LXkNEUNk0uwnyVZ6Km
	Dm8Lr79efx3g8rRv980PncBNrHIyAKzuFMB2qdje5j1fCgxuXURCbccJSbjcNiUeMP7DatzLJNe
	mi12/5rsDmm3ket+pGlYrfiHF+iL6jdln4P6yKU32K/ebwCi14uulWOUGBFE2CWK48W8fIRefNA
	kN01f5AGS4ZUxFwyYTsztBuQe/msTerxeL65dPgFBvsHEDiMTaI0X054ganV0f9ef1FrPO/akdN
	bhtKtaaVIcuhu1
X-Received: by 2002:a05:7300:188b:b0:30c:61d4:d463 with SMTP id 5a478bee46e88-30c69126ce2mr1814952eec.3.1782266964407;
        Tue, 23 Jun 2026 19:09:24 -0700 (PDT)
Received: from localhost ([163.114.132.129])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c1ba57dc4sm19421070eec.9.2026.06.23.19.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 19:09:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jun 2026 22:09:20 -0400
Message-Id: <DJGWWQQD3B0P.2O1D9MO17YRK4@etsalapatis.com>
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Mahe Tardy" <mahe.tardy@gmail.com>, <bpf@vger.kernel.org>
Cc: <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <edumazet@google.com>, <john.fastabend@gmail.com>, <jordan@jrife.io>,
 <kuba@kernel.org>, <martin.lau@linux.dev>, <netdev@vger.kernel.org>,
 <netfilter-devel@vger.kernel.org>, <pabeni@redhat.com>,
 <yonghong.song@linux.dev>
Subject: Re: [PATCH bpf-next v8 3/7] bpf: add bpf_icmp_send kfunc
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260622120515.137082-1-mahe.tardy@gmail.com>
 <20260622120515.137082-4-mahe.tardy@gmail.com>
In-Reply-To: <20260622120515.137082-4-mahe.tardy@gmail.com>

On Mon Jun 22, 2026 at 8:05 AM EDT, Mahe Tardy wrote:
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
>   the SKB control block after cloning to prevent icmp_send()/icmpv6_send(=
)
>   from misinterpreting garbage data as IP options.
>
> Only ICMP_DEST_UNREACH and ICMPV6_DEST_UNREACH are currently supported.
> The interface accepts a type parameter to facilitate future extension to
> other ICMP control message types.
>
> Reviewed-by: Jordan Rife <jordan@jrife.io>
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>
> ---
>  net/core/filter.c | 109 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 109 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 2e96b4b847ce..fc69a14650e4 100644
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
> @@ -12546,6 +12548,101 @@ __bpf_kfunc int bpf_xdp_pull_data(struct xdp_md=
 *x, u32 len)
>  	return 0;
>  }
>
> +/**
> + * bpf_icmp_send - Send an ICMP control message
> + * @skb_ctx: Packet that triggered the control message
> + * @type: ICMP type (only ICMP_DEST_UNREACH/ICMPV6_DEST_UNREACH supporte=
d)
> + * @code: ICMP code (0-15 for IPv4, 0-6 for IPv6)
> + *
> + * Sends an ICMP control message in response to the packet. The original=
 packet
> + * is cloned before sending the ICMP message, so the BPF program can sti=
ll let
> + * the packet pass if desired.
> + *
> + * Currently only ICMP_DEST_UNREACH (IPv4) and ICMPV6_DEST_UNREACH (IPv6=
) are
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
> +__bpf_kfunc int bpf_icmp_send(struct __sk_buff *skb_ctx, int type, int c=
ode)
> +{
> +	struct sk_buff *skb =3D (struct sk_buff *)skb_ctx;
> +	struct sk_buff *nskb;
> +	struct sock *sk;
> +
> +	sk =3D skb_to_full_sk(skb);
> +	if (sk && sk->sk_kern_sock &&
> +	    (sk->sk_protocol =3D=3D IPPROTO_ICMP || sk->sk_protocol =3D=3D IPPR=
OTO_ICMPV6))
> +		return -EBUSY;
> +
> +	switch (skb->protocol) {
> +#if IS_ENABLED(CONFIG_INET)
> +	case htons(ETH_P_IP):
> +		if (type !=3D ICMP_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > NR_ICMP_UNREACH)
> +			return -EINVAL;
> +
> +		nskb =3D skb_clone(skb, GFP_ATOMIC);
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
> +		if (type !=3D ICMPV6_DEST_UNREACH)
> +			return -EOPNOTSUPP;
> +		if (code < 0 || code > ICMPV6_REJECT_ROUTE)
> +			return -EINVAL;
> +
> +		nskb =3D skb_clone(skb, GFP_ATOMIC);
> +		if (!nskb)
> +			return -ENOMEM;
> +
> +		if (!pskb_network_may_pull(nskb, sizeof(struct ipv6hdr))) {

Minor nit, but this may also fail with SKB_DROP_REASON_NOMEM. Now this is o=
nly
possible if the IP header is not in the linear space which may well be
impossible (?), but do we want to differentiate with
pskb_network_may_pull_reason()?

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
> @@ -12588,6 +12685,10 @@ BTF_KFUNCS_START(bpf_kfunc_check_set_sock_ops)
>  BTF_ID_FLAGS(func, bpf_sock_ops_enable_tx_tstamp)
>  BTF_KFUNCS_END(bpf_kfunc_check_set_sock_ops)
>
> +BTF_KFUNCS_START(bpf_kfunc_check_set_icmp_send)
> +BTF_ID_FLAGS(func, bpf_icmp_send)
> +BTF_KFUNCS_END(bpf_kfunc_check_set_icmp_send)
> +
>  static const struct btf_kfunc_id_set bpf_kfunc_set_skb =3D {
>  	.owner =3D THIS_MODULE,
>  	.set =3D &bpf_kfunc_check_set_skb,
> @@ -12618,6 +12719,11 @@ static const struct btf_kfunc_id_set bpf_kfunc_s=
et_sock_ops =3D {
>  	.set =3D &bpf_kfunc_check_set_sock_ops,
>  };
>
> +static const struct btf_kfunc_id_set bpf_kfunc_set_icmp_send =3D {
> +	.owner =3D THIS_MODULE,
> +	.set =3D &bpf_kfunc_check_set_icmp_send,
> +};
> +
>  static int __init bpf_kfunc_init(void)
>  {
>  	int ret;
> @@ -12639,6 +12745,9 @@ static int __init bpf_kfunc_init(void)
>  	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SOCK_ADDR=
,
>  					       &bpf_kfunc_set_sock_addr);
>  	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_=
kfunc_set_tcp_reqsk);
> +	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &bpf=
_kfunc_set_icmp_send);
> +	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_CLS, &bpf_=
kfunc_set_icmp_send);
> +	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT, &bpf_=
kfunc_set_icmp_send);

Based on Sashiko's feedback, since we mostly care about cgroup_skb
should we just make it exclusive to them and drop CLS_ACT?

>  	return ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SOCK_OPS, &bpf_kf=
unc_set_sock_ops);
>  }
>  late_initcall(bpf_kfunc_init);
> --
> 2.34.1

