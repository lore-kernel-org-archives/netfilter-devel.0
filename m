Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795885480;
	b=Afqlq27UMTgFD9mRYJmpfH97fV3kiFE65aTgIXWIhTdjYMqibd08y7PgTt8cAxjnfgrF
	 5hB9fs0ZCWquo/HmWN/taZuMiA4HkYPH1JD7P2tSYyM3lZ9rI25g6x1YtSfq+zyy7oIUv
	 7cAbFBqWAaXGwSuyTwQUccB7Hm0h5RHsVbp0DMPv0qCoo3Sxfy43r67AdRDMMhsRBnfAA
	 kF3oFW+m9FvUeCDFoWRL2U+nzQbbnYfTtwBuil+lxTeKJ38SCr0zlUdDey3MZ/2By0eqW
	 BcfcNfeDp3PRnkRN9JQSAFWx48JIAA4LaKTGInraqZUjP6loClCgf1tHTzZXsMRf9Tw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795885480;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=YFk6Za4CYwXIVVpxUdtvGqdseF42wvFF5V+WRnpuZmQ=;
	b=YsvYUAS2Or+7lqEs4SHuMeL2xcCuszeSeHceDfs2s/af45Ez37HCMq1/9zgtOiX2jupT
	 Zcy567D6tSF3NOzb6nPu4DOM0sboKWNXx0mRfRy+5qKosTV1DaiKXGe39X3sAvFSGCqZW
	 HMhED+35pYjwkuMAjHpdyciUIk6WFPwdjlxDEeSjMH7smLAl8lp1Gzsy8eC/2DOfHHE09
	 WwocYC5yBhPUwmItGYjuo9F/whePOESd+w3CFChSHX7zShxT5R6Fa07VqMTCivF/R+DGE
	 lxCvYds3loUbEjIZyvSYtcY4Kp42QIfozkT5Q/4NWFGLWLGe9HpzyBdREwDmTzM+adw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rz7iziIF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.230.72
Received: from mail-lr2-f8.google.com (mail-lr2-f8.google.com [74.125.230.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B50606A324
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 17:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0B50606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Rz7iziIF
Received: by mail-lr2-f8.google.com with SMTP id 38308e7fff4ca-3adf2030cdbso40190061fa.0
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2026 09:04:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795885478; cv=none;
        d=google.com; s=arc-20260327;
        b=QejXzchLVY5Hvrji2ubGLS0003sUixL0nvHKLEzsHxMU1RZcCmhYx8Dd76rLlyjfaE
         qAB4oxkCGRIOVLusESXdBCRcwJHokOHs17EM1qchQA3kjdvHypjoev1G7Axbnw9yKSRV
         +S9MG6MwBMMN9RUbza60oL0WudeXxbOWjsYlS6mA58DwOjxvbFPxM94JjK+hP4aRVOnZ
         68gOLVO0hDfpoM8veigjGRnfDBUR7Hv/2hoaAjLbYGCg/U7NoHAbdUQ2JDWGeeRsq9rM
         uHRaAF3pkseoLlhT331gDXjx4rl6CYb/UesM9NRWFJSJDlHPPJmwiJPoLqu9fRrU0zuG
         06uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YFk6Za4CYwXIVVpxUdtvGqdseF42wvFF5V+WRnpuZmQ=;
        fh=tTQ78PpNorjcdjIOVG5imUKT2sUbZiAm82XF3KfkyNk=;
        b=dornHU1Oy81A0plBRFkpjK8bM+S9a+HJZBzeD7mF2uVN6vE3F0QftWagYwTO7YouMA
         AEPwyOPwFYNBNvsxNi6M0lB+BhIAcMjLJRuqZKGZxqU2JFBx4dttfxwW+ry3HcjWI2jm
         5de+oz57lALkJVLXUuW2rjMuh4hkd7QOnFD0lkAEzzfn/trNRymTpj9IcD+v+JymniQM
         549ShlgLY4K0Cle630rPZijuoG/p2dO24zGiQby8HI1d7smZvc6+Db17OKHi6C3uet0m
         U9t2A6BMMhDouA7MUmQYaQTHv5+zMj4wD5p0AiDHMcLtuakxifC+gvvmYgu8Xn+fGoKz
         TqZA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795885478; x=1796490278; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YFk6Za4CYwXIVVpxUdtvGqdseF42wvFF5V+WRnpuZmQ=;
        b=Rz7iziIFE1nPpNcIHczT3U3TqLFlE1boSvszBAoE9Abu+y3M0l695MSdXxJr7drNKE
         8A//vfZ52z0K63ZB/1eM9rnUrXn1z+UZHnP1+FQrmXa4/k3SzBhNya3U6BPioxtLtvJa
         s/gfeQYzWe7aiJfs+f5xlegXRDAMlzf65dgnF7e+xh7SEl/ikvgTV9hKrxJacHQmMCRU
         SM/RnWo8dOQOtN0BBhaHBRUoI2X3VdQCddEbelGSoY/N2YdyV5bEwmkn0tABQbqA9P12
         +mF57fO2OFEGI4EzexZ2Hprrp+BTeONfKpGjFpaPUD/gQg6fksEN3JCXiZneB4bXTllg
         vM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795885478; x=1796490278;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YFk6Za4CYwXIVVpxUdtvGqdseF42wvFF5V+WRnpuZmQ=;
        b=CnlIMZuG/m3g4HR+NStgnOD2lqynpCnnlOYv+bubAcGxsJ1VqYWwlg/phgrIgpNNYT
         VZEj8OjVuLo64H7PkgPMkSYXylbsUFmXHjudEuLAxBB0xceyydK8EfRZ7PvPdnwZN+y6
         o8ZsHVQRp1RpOvvYw3vMGTib7yID1QVsmoGhnhVcAo0pNA3O8rXlFdUG3Oze/c+BvvlW
         hN7dfHQZA3zdKRrwjwvJiXy75KynK7tDRTPRoRan7c+/Qy0PRPgDhwXq5tma5AH0UlLI
         s+Jozxj2b36KWafzD9RvZm8DauupxT0AKa7VtX+cCnWm1YOHGUUQ6X6/UuPrVmTAHRBL
         udjQ==
X-Forwarded-Encrypted: i=1; AL+hErF6O9bzIBzCm63xGA15NnqWep9GCnOrlIGK9p3iv1s/hVPzsScq2gUWBbuR36x4UHJJk+9dkvXzzVSZtsoeXUA=@vger.kernel.org
X-Gm-Message-State: APuU4Z/sxNEZTNxtT21AA0pCljn54hquM/OyqWAhPuNcGIL6HBE+zC5P
	ap9Wc+sc27A+TnvXvfx1Mr0PnkHcUoF+JrVAxKr+N4lwGF0lNwPErA+mRl6WSDqSmKAXngtGja+
	+tYA6/tNNoFgFcmILHjXcQqBSn/Z+n1A=
X-Gm-Gg: AZFdTZf1NnmlturrTISwL2eNHjcNseXgXCtvijUw5UxSLNwYZ7Bjhq6BvT7gXPOxpya
	kIGt46QqiXgRF9wDbrGN4gH8ikY0JKFWhrLRHghZT75N4CwZVEkE/1d4v8KVxlqMQmxqMRJO7YN
	E3TARUGBVkY/R8KQ+S7UoqnuZQ3c8It9gyhDrJw+rMv2AC3QH8d8r9ws5xcad0QUkgArN6DzTxK
	SDDB9aqnkrJTnScE9ltQPH2dkYls9wDUEdHGFCfK7jjpevnsDPYxcsIg8cPpr3GMpdGR1qr82hK
	GNK3H58xcpHkbEWPIK7Ym44wSALriyvl10MhJPjnrQ13PnYMXWnw4n2xH2GtxosOpE6I0ERP7lp
	mqqCVvJlNNg92kA9zzUKxBrP4FPwwLAwMKzaDFQ==
X-Received: by 2002:a05:6512:3187:b0:5c1:9752:4a4a with SMTP id
 2adb3069b0e04-5c1bc85a157mr7454419e87.65.1795885477641; Sat, 28 Nov 2026
 09:04:37 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128143710.811389-1-bsdhenrymartin@gmail.com>
In-Reply-To: <20261128143710.811389-1-bsdhenrymartin@gmail.com>
From: henry martin <bsdhenrymartin@gmail.com>
Date: Sun, 29 Nov 2026 01:04:26 +0800
X-Gm-Features: Aa3M54r4mxqw4hOwuSyAiB_We0PbACcqTXIjRA3xrvM7mv69PygmogMNYPuod0s
Message-ID: <CAEnQdOpWPRRjNepc4zoL56hQqPFr32UoUbuaGmHKj8TPRkADjg@mail.gmail.com>
Subject: Re: [PATCH net] netfilter: ipv6: fix out-of-bounds write in fragment reassembly
To: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Simon Horman <horms@kernel.org>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
	Peter Oskolkov <posk@google.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry for the noise - this posting is a duplicate of

    https://lore.kernel.org/netdev/20261128144437.819730-1-bsdhenrymartin@g=
mail.com/

 Please disregard this copy and follow up in the other thread instead.
 The patch content is identical in both postings.

 Thanks,
 Henry

Henry Martin <bsdhenrymartin@gmail.com> =E4=BA=8E2026=E5=B9=B411=E6=9C=8828=
=E6=97=A5=E5=91=A8=E5=85=AD 22:37=E5=86=99=E9=81=93=EF=BC=9A
>
> nf_ct_frag6_queue() trusts the on-wire payload_len, which IPV6_HDRINCL
> lets diverge from the real packet length.  A fragment whose payload_len
> is smaller than its extension header chain yields end < offset.  Only
> end =3D=3D offset was rejected, pskb_trim_rcsum() takes the negative leng=
th
> as a huge unsigned value and does not trim, and the lying fragment is
> queued as is.
>
> inet_frag_queue_insert() walks the rb-tree by offset, so a fragment with
> end < offset lands on the wrong side and breaks the invariant that
> rb_first() is the first fragment.  When the queue completes,
> nf_ct_frag6_reasm() mistakes a small later fragment for the head and
> stores the trailing nexthdr byte at
> skb_network_header(skb)[fq->nhoffset].  nhoffset is controlled through
> the extension header chain and can point far beyond the head buffer.
>
> The result is a one-byte controlled out-of-bounds write past a heap
> object, which corrupts neighbouring slab objects and panics the kernel,
> e.g. on mainline v7.4.0-rc4 (KASAN build):
>
>  Oops: general protection fault, probably for non-canonical address
>  0xed6d696d6d6d6d6d: 0000 [#1] SMP KASAN NOPTI
>  CPU: 0 UID: 1000 PID: 78 Comm: poc Tainted: G        W
>  RIP: 0010:skb_release_data+0x1e7/0x640
>  Call Trace:
>   <IRQ>
>   sk_skb_reason_drop+0xbd/0x320
>   nf_ct_frag6_gather+0x13f2/0x28a0
>   ipv6_defrag+0xa6/0x190
>   nf_hook_slow+0xa5/0x1c0
>   ipv6_rcv+0x147/0x260
>  Kernel panic - not syncing: Fatal exception in interrupt
>
> Fix the class rather than a single comparison:
>
>  * reject a payload_len that promises more than the skb holds before it
>    is used to derive end;
>  * reject end <=3D offset right after the range check and before the
>    MF/LAST_IN state machine, so a dropped fragment cannot leave
>    fq->q.len and INET_FRAG_LAST_IN modified;
>  * apply the same ordering to ip6_frag_queue() and ip_frag_queue(),
>    which share the check and the rb-tree invariant.
>
> end =3D=3D offset was already rejected; end < offset is never a valid
> fragment.
>
> This issue was discovered by Tencent CodeBuddy Security.
>
> Cc: stable@vger.kernel.org
> Fixes: fa0f527358bd9 ("ip: use rb trees for IP frag queue.")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
> ---
>  net/ipv4/ip_fragment.c                  | 13 +++++++++++--
>  net/ipv6/netfilter/nf_conntrack_reasm.c | 18 +++++++++++++++---
>  net/ipv6/reassembly.c                   | 17 ++++++++++++++---
>  3 files changed, 40 insertions(+), 8 deletions(-)
>
> diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
> index 0688be8142c4b..3cc12e8b1786b 100644
> --- a/net/ipv4/ip_fragment.c
> +++ b/net/ipv4/ip_fragment.c
> @@ -294,6 +294,17 @@ static int ip_frag_queue(struct ipq *qp, struct sk_b=
uff *skb, int *refs)
>         end =3D offset + skb->len - skb_network_offset(skb) - ihl;
>         err =3D -EINVAL;
>
> +       /* A fragment must carry at least one byte after its IP header,
> +        * otherwise end < offset and the rb-tree ordering breaks.  Rejec=
t
> +        * before touching any qp state.
> +        */
> +       if (end <=3D offset)
> +               goto discard_qp;
> +
> +       /* tot_len must fit in the skb; IP_HDRINCL lets it diverge. */
> +       if (ntohs(ip_hdr(skb)->tot_len) > skb->len - skb_network_offset(s=
kb))
> +               goto discard_qp;
> +
>         /* Is this the final fragment? */
>         if ((flags & IP_MF) =3D=3D 0) {
>                 /* If we already have some bits beyond end
> @@ -317,8 +328,6 @@ static int ip_frag_queue(struct ipq *qp, struct sk_bu=
ff *skb, int *refs)
>                         qp->q.len =3D end;
>                 }
>         }
> -       if (end =3D=3D offset)
> -               goto discard_qp;
>
>         err =3D -ENOMEM;
>         if (!pskb_pull(skb, skb_network_offset(skb) + ihl))
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter=
/nf_conntrack_reasm.c
> index f25ff2a12a824..953eb25e440c7 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -184,6 +184,14 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, =
struct sk_buff *skb,
>
>         payload_len =3D ntohs(ipv6_hdr(skb)->payload_len);
>
> +       /* IPV6_HDRINCL allows payload_len to differ from the real packet
> +        * length.  Never let it promise more than the skb actually holds=
.
> +        */
> +       if (payload_len + sizeof(struct ipv6hdr) > skb->len) {
> +               pr_debug("payload_len exceeds skb length.\n");
> +               goto err;
> +       }
> +
>         offset =3D ntohs(fhdr->frag_off) & ~0x7;
>         end =3D offset + (payload_len -
>                         ((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
> @@ -193,6 +201,13 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, =
struct sk_buff *skb,
>                 return -EINVAL;
>         }
>
> +       /* A fragment must carry at least one byte after its fragment
> +        * header, otherwise end < offset and the rb-tree ordering breaks=
.
> +        * Reject before touching any fq state.
> +        */
> +       if (end <=3D offset)
> +               goto err;
> +
>         ecn =3D ip6_frag_ecn(ipv6_hdr(skb));
>
>         if (skb->ip_summed =3D=3D CHECKSUM_COMPLETE) {
> @@ -236,9 +251,6 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, s=
truct sk_buff *skb,
>                 }
>         }
>
> -       if (end =3D=3D offset)
> -               goto err;
> -
>         /* Point into the IP datagram 'data' part. */
>         if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data)) {
>                 pr_debug("queue: message is too short.\n");
> diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
> index 91a65fe673500..2f20b0f745cf5 100644
> --- a/net/ipv6/reassembly.c
> +++ b/net/ipv6/reassembly.c
> @@ -124,6 +124,13 @@ static int ip6_frag_queue(struct net *net,
>         }
>
>         err =3D -EINVAL;
> +
> +       /* IPV6_HDRINCL allows payload_len to differ from the real packet
> +        * length.  Never let it promise more than the skb actually holds=
.
> +        */
> +       if (ntohs(ipv6_hdr(skb)->payload_len) + sizeof(struct ipv6hdr) > =
skb->len)
> +               goto discard_fq;
> +
>         offset =3D ntohs(fhdr->frag_off) & ~0x7;
>         end =3D offset + (ntohs(ipv6_hdr(skb)->payload_len) -
>                         ((u8 *)(fhdr + 1) - (u8 *)(ipv6_hdr(skb) + 1)));
> @@ -138,6 +145,13 @@ static int ip6_frag_queue(struct net *net,
>                 return -1;
>         }
>
> +       /* A fragment must carry at least one byte after its fragment
> +        * header, otherwise end < offset and the rb-tree ordering breaks=
.
> +        * Reject before touching any fq state.
> +        */
> +       if (end <=3D offset)
> +               goto discard_fq;
> +
>         ecn =3D ip6_frag_ecn(ipv6_hdr(skb));
>
>         if (skb->ip_summed =3D=3D CHECKSUM_COMPLETE) {
> @@ -178,9 +192,6 @@ static int ip6_frag_queue(struct net *net,
>                 }
>         }
>
> -       if (end =3D=3D offset)
> -               goto discard_fq;
> -
>         err =3D -ENOMEM;
>         /* Point into the IP datagram 'data' part. */
>         if (!pskb_pull(skb, (u8 *) (fhdr + 1) - skb->data))
> --
> 2.53.0
>
