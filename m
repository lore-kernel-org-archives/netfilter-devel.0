Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458ED3B3BEB
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785434890; cv=none; b=D87WKGrUNyoltqMMKhS+TWtb9L8sH+t6sBilIqCXLv3vHNPjzN/3IGivH6Q50muFPOj0oAaX53jy3mmqlhpdmTuSKk+pZPyu9E7fMR0B8BhZhUD8lCdAjv+FLVh5sGsjljEfaUyfAMJxgrla0gLyEBD/+0sdl5bLR6u8UyBQUb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785434890; c=relaxed/simple;
	bh=tSrfAlD2lgvetemBvKtXVwnOZ3zgTipsfi54/ygirdk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=YOF9UF0RGNrdbHJfdnRLi9nSSRFg8f2JrXwie+XM9e+lw1z9VofRsAGlMX/Z5ECEDF5+SmfHpbuLBhxwE2R/ngUwehZeEWQ7OBPz0gS8flfy/++jybYjfhtar8/2pH+OKeW53E+jB0AP0PKPQsOaZPsrX7IN07wiXjdeSEXLfe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=F4O1RutH; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="F4O1RutH"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so1161785ad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 11:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1785434886; x=1786039686; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=MACLsRcN4y51CiS0cg9uBHC3yOz6OO5aiyPbHKz0564=;
        b=F4O1RutH5IeHSzSijnjVocM1MevwxvLe6eAp7cFBulON+cfgjjHsAuNcD4uIOFXD/q
         uZP+GdHXEOejEfsg8x79ILuL6FL5azukOHtPe+lJ9YWpvyKAkFT4t+MZLDL+HrkBaYwZ
         nDwcvG9iqmXbM125tjkeZCrrUaKA8rdXylb1rK69c+3a7sD/vxn5UHcOVcMWprjMwHZ2
         iZJ1/706phe3wEOvGVIHM80Bi7GGw5UWZxA0QAmS1n72KNW6pNyHao9n3QbDbBUj2P79
         2G/Ba8FE1Vyb1nANAmA+oB3b7DH824xeqFR6o4Tqj1DT1ZgEFLthChidf/xqgcqcYvbq
         HXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785434886; x=1786039686;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MACLsRcN4y51CiS0cg9uBHC3yOz6OO5aiyPbHKz0564=;
        b=hkUqN7syX2CLY50HZpjnMhU4lfdTERhnb3gPuEglQ3zQ60qBTYVYJoMGLXrGOHHEHk
         QXZbzxStmO4cgY1T2prEMwfdpXJ/hRtHvXtGjMbB10nwCUn3KvNrUzU13BA3pO9l7cgs
         WL08pe2cteAeVhfI2Qwl7pJzw/CzsNwnTt920IdKKcFqfM4H1mKQU1fh5b8DYNndCZs/
         IZK7kLPG9AnBrBN/cfdB4o6Wx6vpQTptLxD/C9iC3tHQ66/oZvsa/QWbaVWZMRWiIxr5
         4Ylj658aNo6qch7TBRLs6mBx7lPp8mYaZ1/Yuj86DQOEsCzxgxjp6LG5mFc7I3fcWVq+
         bDSA==
X-Gm-Message-State: AOJu0Yw3zKjguRVg9r93rg/MkdCB2/Dc/pQBkfG6RfFxW6+N0b5cn9a6
	2Lt/W3f++5+0Hp/ap0CgAc20W+xl5JIfs/a5RaRMJ1BdQeLjlaHf8nYoY1b+Wz3Evdo=
X-Gm-Gg: AR+sD12NYCGZT3LwIEik9ncFFrqPU5xkWa6gk1+Zv5GG4Uyr0yFZoInMjjnM3wo1kma
	DB9h3qnMqzaVPQsSk99zMevV55NATspsmADPqBX8SCaistbICs8ANwcanVT63VvNQI86jiwdTKb
	dAqrPdwpfgSYGK8k1PCZnjOXmSS9q1/yi7KiRHzHTftNcxHP9Sbmp8ADrKfhRWk1Sn3NJI9JCG/
	6xSFMy3a53PbAeiaoGbVcqVgoKZI9ohDed2k3rtFPt7c7+Fn0SIuESxUuOF1dpQKkbMgptGBH08
	cpdfuP/UHYm4fPmymTjX4yadl44Ecy+mQtuM88UjJ1D42kIqv8Vnh5SmXFylPLRsiE6d1UGHq5Q
	v0YcfvAH8CufTYdHFCysKHm10f4gTs6aVya9gK4DJLGpwGvAVH0NxWa3grxSXG+kF1b7fdZaAfl
	3Wbzn4/3Jtbikt1jBv4n1+ebNKzhesPdIy2kIct9xHzd16985gb8Cin5+VegZyiB25HnSK0syZH
	DUYs/gDzVJAVMmbfg==
X-Received: by 2002:a17:902:ccd2:b0:2c6:90ec:f601 with SMTP id d9443c01a7336-2d035b85755mr32939755ad.8.1785434886244;
        Thu, 30 Jul 2026 11:08:06 -0700 (PDT)
Received: from localhost (107-190-31-17.cpe.teksavvy.com. [107.190.31.17])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022bf845asm29948135ad.60.2026.07.30.11.08.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 11:08:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 30 Jul 2026 14:08:04 -0400
Message-Id: <DKC3UER7LFE1.229F428MUH14A@etsalapatis.com>
Cc: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
 <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf v2] bpf: Fix netns reference imbalance in conntrack
 kfuncs
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
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260729163141.213611-1-nicoyip.dev@gmail.com>
 <20260730082958.2065194-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260730082958.2065194-1-nicoyip.dev@gmail.com>

On Thu Jul 30, 2026 at 4:29 AM EDT, Chengfeng Ye wrote:
> The opts argument of the BPF conntrack kfuncs can point to a shared
> map value.  __bpf_nf_ct_lookup() and __bpf_nf_ct_alloc_entry() read
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
> Snapshot every input field of opts with READ_ONCE() before validating or
> using it.  The netns_id snapshot keeps the namespace get/put pair
> balanced, while the other snapshots keep the remaining options from
> changing partway through an invocation.  The individual reads can still
> observe an inconsistent combination during a concurrent update, but each
> selected field value remains stable for that invocation.
>
> Fixes: aed8ee7feb44 ("net: netfilter: Deduplicate code in bpf_{xdp,skb}_c=
t_lookup")
> Fixes: d7e79c97c00c ("net: netfilter: Add kfuncs to allocate and insert C=
T")
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>

Looking a lot better, one nit: We don't really need to read reserve[]
into a separate variable. We use it only once, so reading it into the
stack isn't giving us anything, in contrast to all other fields.

The bot's ordering nit is also a nice-to-have.

pw-bot: cr

> ---
> Changes in v2:
> - Snapshot l4proto, ct_zone_id, ct_zone_dir, and the reserved bytes in
>   addition to netns_id, as requested in review.
> - Rebase onto current bpf/master.
>
> Please queue this fix for stable kernels.
>
>  net/netfilter/nf_conntrack_bpf.c | 76 ++++++++++++++++++++++----------
>  1 file changed, 52 insertions(+), 24 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrac=
k_bpf.c
> index f98d1d4b42c3..c3395cb98c00 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -122,42 +122,56 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf=
_sock_tuple *bpf_tuple,
>  	struct nf_conntrack_tuple otuple, rtuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 ct_zone_dir =3D 0;
> +	u8 reserved[3] =3D {};
> +	u8 l4proto;
>  	int err;
> =20
>  	if (!(opts_len =3D=3D NF_BPF_CT_OPTS_SZ || opts_len =3D=3D 12))
>  		return ERR_PTR(-EINVAL);
> +
> +	netns_id =3D READ_ONCE(opts->netns_id);
> +	l4proto =3D READ_ONCE(opts->l4proto);
> +	ct_zone_id =3D READ_ONCE(opts->ct_zone_id);
>  	if (opts_len =3D=3D NF_BPF_CT_OPTS_SZ) {
> -		if (opts->reserved[0] || opts->reserved[1] || opts->reserved[2])
> +		ct_zone_dir =3D READ_ONCE(opts->ct_zone_dir);
> +		reserved[0] =3D READ_ONCE(opts->reserved[0]);
> +		reserved[1] =3D READ_ONCE(opts->reserved[1]);
> +		reserved[2] =3D READ_ONCE(opts->reserved[2]);
> +		if (reserved[0] || reserved[1] || reserved[2])
>  			return ERR_PTR(-EINVAL);
>  	} else {
> -		if (opts->ct_zone_id)
> +		if (ct_zone_id)
>  			return ERR_PTR(-EINVAL);
>  	}
> =20
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);
> =20
> -	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
> +	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
>  				    IP_CT_DIR_ORIGINAL, &otuple);
>  	if (err < 0)
>  		return ERR_PTR(err);
> =20
> -	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
> +	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
>  				    IP_CT_DIR_REPLY, &rtuple);
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
> =20
>  	if (opts_len =3D=3D NF_BPF_CT_OPTS_SZ) {
> -		if (opts->ct_zone_dir =3D=3D 0)
> -			opts->ct_zone_dir =3D NF_CT_DEFAULT_ZONE_DIR;
> -		nf_ct_zone_init(&ct_zone,
> -				opts->ct_zone_id, opts->ct_zone_dir, 0);
> +		if (ct_zone_dir =3D=3D 0) {
> +			ct_zone_dir =3D NF_CT_DEFAULT_ZONE_DIR;
> +			opts->ct_zone_dir =3D ct_zone_dir;
> +		}
> +		nf_ct_zone_init(&ct_zone, ct_zone_id, ct_zone_dir, 0);
>  	} else {
>  		ct_zone =3D nf_ct_zone_dflt;
>  	}
> @@ -171,7 +185,7 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_s=
ock_tuple *bpf_tuple,
>  	__nf_ct_set_timeout(ct, timeout * HZ);
> =20
>  out:
> -	if (opts->netns_id >=3D 0)
> +	if (netns_id >=3D 0)
>  		put_net(net);
> =20
>  	return ct;
> @@ -186,46 +200,60 @@ static struct nf_conn *__bpf_nf_ct_lookup(struct ne=
t *net,
>  	struct nf_conntrack_tuple tuple;
>  	struct nf_conntrack_zone ct_zone;
>  	struct nf_conn *ct;
> +	u16 ct_zone_id;
> +	s32 netns_id;
> +	u8 ct_zone_dir =3D 0;
> +	u8 reserved[3] =3D {};
> +	u8 l4proto;
>  	int err;
> =20
>  	if (!opts || !bpf_tuple)
>  		return ERR_PTR(-EINVAL);
>  	if (!(opts_len =3D=3D NF_BPF_CT_OPTS_SZ || opts_len =3D=3D 12))
>  		return ERR_PTR(-EINVAL);
> +
> +	netns_id =3D READ_ONCE(opts->netns_id);
> +	l4proto =3D READ_ONCE(opts->l4proto);
> +	ct_zone_id =3D READ_ONCE(opts->ct_zone_id);
>  	if (opts_len =3D=3D NF_BPF_CT_OPTS_SZ) {
> -		if (opts->reserved[0] || opts->reserved[1] || opts->reserved[2])
> +		ct_zone_dir =3D READ_ONCE(opts->ct_zone_dir);
> +		reserved[0] =3D READ_ONCE(opts->reserved[0]);
> +		reserved[1] =3D READ_ONCE(opts->reserved[1]);
> +		reserved[2] =3D READ_ONCE(opts->reserved[2]);
> +		if (reserved[0] || reserved[1] || reserved[2])
>  			return ERR_PTR(-EINVAL);
>  	} else {
> -		if (opts->ct_zone_id)
> +		if (ct_zone_id)
>  			return ERR_PTR(-EINVAL);
>  	}
> -	if (unlikely(opts->l4proto !=3D IPPROTO_TCP && opts->l4proto !=3D IPPRO=
TO_UDP))
> +	if (unlikely(l4proto !=3D IPPROTO_TCP && l4proto !=3D IPPROTO_UDP))
>  		return ERR_PTR(-EPROTO);
> -	if (unlikely(opts->netns_id < BPF_F_CURRENT_NETNS))
> +	if (unlikely(netns_id < BPF_F_CURRENT_NETNS))
>  		return ERR_PTR(-EINVAL);
> =20
> -	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, opts->l4proto,
> +	err =3D bpf_nf_ct_tuple_parse(bpf_tuple, tuple_len, l4proto,
>  				    IP_CT_DIR_ORIGINAL, &tuple);
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
> =20
>  	if (opts_len =3D=3D NF_BPF_CT_OPTS_SZ) {
> -		if (opts->ct_zone_dir =3D=3D 0)
> -			opts->ct_zone_dir =3D NF_CT_DEFAULT_ZONE_DIR;
> -		nf_ct_zone_init(&ct_zone,
> -				opts->ct_zone_id, opts->ct_zone_dir, 0);
> +		if (ct_zone_dir =3D=3D 0) {
> +			ct_zone_dir =3D NF_CT_DEFAULT_ZONE_DIR;
> +			opts->ct_zone_dir =3D ct_zone_dir;
> +		}
> +		nf_ct_zone_init(&ct_zone, ct_zone_id, ct_zone_dir, 0);
>  	} else {
>  		ct_zone =3D nf_ct_zone_dflt;
>  	}
> =20
>  	hash =3D nf_conntrack_find_get(net, &ct_zone, &tuple);
> -	if (opts->netns_id >=3D 0)
> +	if (netns_id >=3D 0)
>  		put_net(net);
>  	if (!hash)
>  		return ERR_PTR(-ENOENT);

