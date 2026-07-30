Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56448372070
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785393503; cv=none; b=a6Mr6nJmQMLYp/c/XkSFGGEoR4J92dU+ZdFvhzqtcRnMdtIlLJ4j0fOkgyNePK67BS7hsBSHMFX29t3DERprDNy6asRTOp8Gi7LHraDeU79FinyUbPJetMMut4mAEEBOhgGxeyih670VLKCDKLAdQoZXK3dCoFty2Azdyhg3E7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785393503; c=relaxed/simple;
	bh=ccS/vynfAjtPWGb8cQXbw2Ma7u9Kc2So5zt5lpzwcaM=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=Yw+qZEoUgrkSLmvhAr/S8GHe69fM020NSezsZ451zTo5kT7hPmPEpjUzUtf78nDtZ52ndA2YX1w7XvPjDHftYpdtZ6km2tNAZvdQtMcWZWlbJa0oFp7vJ3YVfWM4X5m7PkS2a7BITLSbtoCfGi/XG0QjDvm0Sy/Orl3ap2BGvos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=pHZHCR7C; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="pHZHCR7C"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso20092105ad.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 23:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1785393500; x=1785998300; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=gGidP0vHSPV0NPul0Vyzr/cFRYrRFVowQdSQZFiXkIw=;
        b=pHZHCR7C3tPT3Z0r4VooonpWF4QZlEuUJnGudgBKFC2RitXrAmnzkSPkhrhLlF2fKs
         mLHD1MaDmhd1yr1tGy4JyXW3FhZ1dO88b04iMaW76E+hURKiq0Eu8DNLqtYVF+SpZ5+G
         gRPSWAhWz5L7D/SLEhZjJip+i+OlQTPK+NRpxxTQokfvn/lCbBmcILN7fqI88WBDcv54
         TPUQnkIZpb6pI2vwh4FIAoCWPSFWStSLMz7MZkB8F8KmMZhs8GpUy/Wyow/DEpy3aZL8
         T7s9YAVkd/I74rwyfPjcTpImFB7z3fJ+ysE2CVA/Eh9Hrl7Xi61z72WwOSWu6bAj/RmP
         Mjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785393500; x=1785998300;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gGidP0vHSPV0NPul0Vyzr/cFRYrRFVowQdSQZFiXkIw=;
        b=hK+C12neWl49o03LKdQxFsIj563g7uALBMcxcdO7UUXMPZJ+SD3tn107kiJJI4DD1+
         QiQhF+0fPzWyp2pt7nrS7/YGuR9+gHxzxTZG8fSV/Egd90ASQzVkouJK4n7jxxQqPFa+
         Ltb8lS573hYEl42vOyk2i8SkSXdKBR72Taq+E0PSWQSpK9rUIXiuLGotIYUwSXpvqxM+
         Xs9BiyTTrtVvetfyxElCUC6LCOTE78KHyYinumGdP9YAdYvCJKZNssGRTgDf/RcUkHp5
         L91SdQJ2G+3whEE6aERHkSp+PB/fcGAj8XfIH2hPUBmxxwkTkaV1cKiwuANtG2YgG21/
         1A3w==
X-Gm-Message-State: AOJu0Ywqp9prmYW1kr8OiTNj42HDmvf38llK/xZ3yddF7KEXVw9wZvnV
	b8HcE37K9y53NCwjwI39Jr+Zwbzly5bI5zZcUzWpZV9d83ivqpT/KGAcm40AdAo0etw=
X-Gm-Gg: AR+sD116JgcBEIfuVJNyGSZQC/+jPKmsxnB7sf2sXR6eUeiFmOSthTdvyr/Z9LEfAsO
	1ZHsP2UwxmXYs/Axgta7fVcOlqf8hWHrjgMn/+VMPW7LD7tPQqdyygul1R/y0J0HmAbS662FmJf
	QShxb0/4w1ujHHvYXkdsrCeuLOd3Cbgqsdo+3T+i9U9qWKQuLs3PM3zAIgB5p7015E/fUB5x6iY
	8niq5X4DSkNfMs2611Qosp9fUir5zVVCVfHZWqdHP5CGkj007Pz+SJWsYfZjjBWyfQ9tZPJ1h6V
	Ty8B4qdOscrc69L1p6cNlZCv6BC19++3G1hhC5br+yZgL7uy0ANZOxC3Z44CkqW9NZL1+7k5Nag
	KCsq0WLn89+CwZFWJ3p2cx2Ycw1UrkhEs9+WlwIIgk7uRnm2d2HfQu/uS3RmLzmVy5Jss7LOpNS
	hiL+UizdrHQvnaPCaVHIbaM6rPgGaytJFgVt8whTbN2x1ayEZ6tuWZBn8q3ZGBMz31lfitn1dXJ
	5d1H/Pa7C4DiuZKRw==
X-Received: by 2002:a17:903:1a2f:b0:2ce:8e70:3210 with SMTP id d9443c01a7336-2d035bdde67mr15176115ad.16.1785393499622;
        Wed, 29 Jul 2026 23:38:19 -0700 (PDT)
Received: from localhost (107-190-31-17.cpe.teksavvy.com. [107.190.31.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022a15303sm21373135ad.3.2026.07.29.23.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 23:38:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Jul 2026 02:38:18 -0400
Message-Id: <DKBP6A3V5I02.3GNQ1SEZST1F0@etsalapatis.com>
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Chengfeng Ye" <nicoyip.dev@gmail.com>, "Pablo Neira Ayuso"
 <pablo@netfilter.org>, "Florian Westphal" <fw@strlen.de>, "Phil Sutter"
 <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet"
 <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo Abeni"
 <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Jesper Dangaard Brouer" <hawk@kernel.org>, "John Fastabend"
 <john.fastabend@gmail.com>, "Stanislav Fomichev" <sdf@fomichev.me>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo Bianconi"
 <lorenzo@kernel.org>
Cc: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf] bpf: Fix netns reference imbalance in conntrack
 kfuncs
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260729163141.213611-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260729163141.213611-1-nicoyip.dev@gmail.com>

On Wed Jul 29, 2026 at 12:31 PM EDT, Chengfeng Ye wrote:
> The opts argument of the BPF conntrack kfuncs can point to a shared map
> value.  __bpf_nf_ct_lookup() and __bpf_nf_ct_alloc_entry() read
> opts->netns_id separately when acquiring and releasing the network
> namespace reference.
>
> The reference imbalance can occur as follows:
>
>   CPU 0                                  CPU 1
>   read opts->netns_id (-1)
>   skip get_net_ns_by_id()
>                                          write opts->netns_id (id)
>   read opts->netns_id (id)
>   put_net(net) /* no matching get */
>
> The reverse transition leaks the reference.  Repeating the unmatched put
> can destroy a live namespace and crash later users.
>
> The kernel reported:
>
>   Oops: general protection fault, probably for non-canonical address
>   KASAN: null-ptr-deref in range [0x00000000000000e8-0x00000000000000ef]
>   RIP: 0010:bpf_prog_test_run_xdp+0x52c/0x1700
>   Call Trace:
>    __sys_bpf+0x1662/0x50c0
>    __x64_sys_bpf+0x73/0xb0
>    do_syscall_64+0xf9/0x540
>    entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   Kernel panic - not syncing: Fatal exception
>
> Read netns_id once with READ_ONCE() and use that value for validation
> and the matching get/put pair.  Each invocation then consistently uses
> either the calling namespace or a referenced namespace.
>
> Fixes: aed8ee7feb44 ("net: netfilter: Deduplicate code in bpf_{xdp,skb}_c=
t_lookup")
> Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert C=
T")
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Sashiko is right on this regarding all other fields of opts having the
same issue. While they can't lead to a crash, let's still snapshot them
at the beginning of the function so they don't change from under us.
This is still far from ideal - we may read an inconsistent snapshot of
the struct - but it's backed by BPF program-controlled memory so AFAICT
this is the best we can do.

pw-bot: cr

> ---
> Please queue this fix for stable kernels.
>
>  net/netfilter/nf_conntrack_bpf.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrac=
k_bpf.c
> index f98d1d4b42c3..8b540846f299 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -122,6 +122,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_s=
ock_tuple *bpf_tuple,
>  	struct nf_conntrack_tuple otuple, rtuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	s32 netns_id;
>  	int err;
> =20
>  	if (!(opts_len =3D=3D NF_BPF_CT_OPTS_SZ || opts_len =3D=3D 12))
> @@ -134,7 +135,8 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_s=
ock_tuple *bpf_tuple,
>  			return ERR_PTR(-EINVAL);
>  	}
> =20
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	netns_id =3D READ_ONCE(opts->netns_id);
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);
> =20
>  	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
> @@ -147,8 +149,8 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_s=
ock_tuple *bpf_tuple,
>  	if (err < 0)
>  		return ERR_PTR(err);
> =20
> -	if (opts->netns_id >=3D 0) {
> -		net =3D get_net_ns_by_id(net, opts->netns_id);
> +	if (netns_id >=3D 0) {
> +		net =3D get_net_ns_by_id(net, netns_id);
>  		if (unlikely(!net))
>  			return ERR_PTR(-ENONET);
>  	}
> @@ -171,7 +173,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_s=
ock_tuple *bpf_tuple,
>  	__nf_ct_set_timeout(ct, timeout * HZ);
> =20
>  out:
> -	if (opts->netns_id >=3D 0)
> +	if (netns_id >=3D 0)
>  		put_net(net);
> =20
>  	return ct;
> @@ -186,6 +188,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net =
*net,
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	s32 netns_id;
>  	int err;
> =20
>  	if (!opts || !bpf_tuple)
> @@ -201,7 +204,8 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net =
*net,
>  	}
>  	if (unlikely(opts->l4proto !=3D IPPROTO_TCP && opts->l4proto !=3D IPPRO=
TO_UDP))
>  		return ERR_PTR(-EPROTO);
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	netns_id =3D READ_ONCE(opts->netns_id);
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);
> =20
>  	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
> @@ -209,8 +213,8 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net =
*net,
>  	if (err < 0)
>  		return ERR_PTR(err);
> =20
> -	if (opts->netns_id >=3D 0) {
> -		net =3D get_net_ns_by_id(net, opts->netns_id);
> +	if (netns_id >=3D 0) {
> +		net =3D get_net_ns_by_id(net, netns_id);
>  		if (unlikely(!net))
>  			return ERR_PTR(-ENONET);
>  	}
> @@ -225,7 +229,7 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct net =
*net,
>  	}
> =20
>  	hash =3D nf_conntrack_find_get(net, &ct_zone, &tuple);
> -	if (opts->netns_id >=3D 0)
> +	if (netns_id >=3D 0)
>  		put_net(net);
>  	if (!hash)
>  		return ERR_PTR(-ENOENT);

