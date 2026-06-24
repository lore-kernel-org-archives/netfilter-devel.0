Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562593A1B5
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2026 00:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782259799; cv=none; b=bSEh1cdhGJbhRw5D8iJ5Xf56Fb1z8qPfFIE/6aMsAzNNfOqAVOkCB8368L50Gt0DEVLXvKYNM80BHwNy4P5uhf1TmiY8JCOegMDKaG393veIK/SitlqmLuE++AwMRDBCWy3qvP9J5Taz1x8dL8DJANVuUIaVp1uxdiI1OXpNTN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782259799; c=relaxed/simple;
	bh=0XYbSaKDOoQduMhTFPk0faWObl2M7CF+88yrRNTkwwc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=ORX7rDo8wsOcHcQegy6Tui+8tWZNtKvqrrOkEr38kmrcEE2zIpMvGhiaCXHQbF+2FXiGq2lQkduxwChxRjQCUzNr2bcMhzhPfjpQan4vC457lJq8c6TdK+nMIBqWcl0rMG3sLGatM72qu9LmzoTTdmsnRgk1vV8gP2G6vOT+sDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com; spf=pass smtp.mailfrom=etsalapatis.com; dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b=yPdDeSi/; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=etsalapatis.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=etsalapatis-com.20251104.gappssmtp.com header.i=@etsalapatis-com.20251104.gappssmtp.com header.b="yPdDeSi/"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-30c6c8d7503so294967eec.0
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 17:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsalapatis-com.20251104.gappssmtp.com; s=20251104; t=1782259797; x=1782864597; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8oF7gaI866b4fh2rX0QoDVma7OKpRu/EkO3XgX53kE=;
        b=yPdDeSi/Tr2gqG/UpLxRu4RJ50CYw3+LqV6ACLBjLE1IOtJtXqrpVP3/DdMdC+B94H
         kD7KHfaSURNiYzFNnGLcmk8gNKTJj/LInMItHkrFVqwxKijDy5UIRubGoh4l8so+C93o
         LfXAQrquRhj8tu/uTtxh2IrFOKVSPbexuHKP/ZZI2JnT0kdGhYeKmDpV23JvOBFud9QH
         gifvsRKPxhCum00TvuENKCiPO5fkPeSu6wce/9EagyD6A8a0Ol3tRc0szeTJ/8fL4Qgb
         KNvBfkoQQ7B3o8fX+PFSDuxif6j6tKUwApS1Io2XmWxzrY4Teh/EabxvXppwXEUjPJAx
         87SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782259797; x=1782864597;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8oF7gaI866b4fh2rX0QoDVma7OKpRu/EkO3XgX53kE=;
        b=N06nqyFk5vH3ea5aG6ujCjrAf2V3Ml5n03lfSMq7rkpHaISyt+bXW8zvv+KeTrzzNq
         1FlKHXSV3P0rU+9YSTbBK3dfb8mbXiGI9RZ5CLZDXLM7Tk+H0XtH1KtWhf0TovxOtQiy
         8RgQu7c5m8DmVUvICDDUCXqGvcsnqd75J7c/d2RzjuMFXkWxrwUXtoKlDLu7T0GbXnna
         oYeYnw5IitUCpJh4pw0/Iae3BlZfy5vSrJlNHNnrgH2ohCpXk1HUsq3IizBTQFd7Y2NR
         fjvWVIdqi3iv9JDzuBYrs1NDsbkpPsot5CM7g4+yAcLOsCmqVyJX+iKZ95gmrxYdTX+t
         vrUw==
X-Forwarded-Encrypted: i=1; AHgh+RrHIz1FAKyLT66jJeTADkWZ09hQ4RCcnE8BFEFcqhd8c2s5dkPeDtAr12fp/8baAhFbhRY1t0OTYfPwOotxT2M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKP8bWTNNMeWChQFBfbh9u8cvjUWvOSn54ql+ztcpRrplbbKiY
	baZ7ubiTujrNn2AVG2LBufaywEID2tHCttKitH6UApZUACOuz0uQfdFyDW+2qDdfC88=
X-Gm-Gg: AfdE7cnJJfx/FfPmFiY9oG/SzBRuOKniCmaMI7CGdjHkmOAbOgDzioOxuFm3WrWo4n5
	rU/YI9C7YJDieLDQJERydmJPOyFfmM1qmNt9HwPzjoVv/LfPIRGp4ZmktGp3TOw7lD2/y2VCeRG
	CjURijatGCnKnu4/Ah2DvCLAkj6oO2/tieevEuszDsudoBTrhvI6M24j7qis70NAaIl7JkaRhTO
	H+VYYFpL81unkREMMY9SQbj07E8QwEfO+ZZ2SlDHpRwkb20zwWcH4QSTdSxAECch+EGoo25SCNs
	ISFsEDHMnI16R1JSXWNj6390AFf5fc0rZqBNj5804dUi99TO6oy5jyHaWcTak+nkEV/FCspzaIY
	lQaXjEoBIyO732cM/E18ljSksgVxqGZWHJ5Sl5agUfq3Gx06a6Whzx+CYL0qYc8gMTWcWUBWseO
	l6KSUd
X-Received: by 2002:a05:7300:4304:b0:304:d14b:b706 with SMTP id 5a478bee46e88-30c6937271bmr1341249eec.27.1782259797305;
        Tue, 23 Jun 2026 17:09:57 -0700 (PDT)
Received: from localhost ([2620:10d:c090:600::2526])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c52daf89dsm9570073eec.31.2026.06.23.17.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2026 17:09:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jun 2026 20:09:54 -0400
Message-Id: <DJGUDAI4O70K.38X2CYVLBBLI7@etsalapatis.com>
Cc: <andrii@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
 <edumazet@google.com>, <john.fastabend@gmail.com>, <jordan@jrife.io>,
 <kuba@kernel.org>, <martin.lau@linux.dev>, <netdev@vger.kernel.org>,
 <netfilter-devel@vger.kernel.org>, <pabeni@redhat.com>,
 <yonghong.song@linux.dev>
Subject: Re: [PATCH bpf-next v8 1/7] net: move netfilter
 nf_reject_fill_skb_dst to core ipv4
From: "Emil Tsalapatis" <emil@etsalapatis.com>
To: "Mahe Tardy" <mahe.tardy@gmail.com>, <bpf@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260622120515.137082-1-mahe.tardy@gmail.com>
 <20260622120515.137082-2-mahe.tardy@gmail.com>
In-Reply-To: <20260622120515.137082-2-mahe.tardy@gmail.com>

On Mon Jun 22, 2026 at 8:05 AM EDT, Mahe Tardy wrote:
> Move and rename nf_reject_fill_skb_dst from
> ipv4/netfilter/nf_reject_ipv4 to ip_route_reply_fill_dst in ipv4/route.c
> so that it can be reused in the following patches by BPF kfuncs.
>
> Netfilter uses nf_ip_route that is almost a transparent wrapper around
> ip_route_output_key so this patch inlines it.
>
> Reviewed-by: Jordan Rife <jordan@jrife.io>
> Signed-off-by: Mahe Tardy <mahe.tardy@gmail.com>

Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>

> ---
>  include/net/route.h                 |  1 +
>  net/ipv4/netfilter/nf_reject_ipv4.c | 19 ++-----------------
>  net/ipv4/route.c                    | 15 +++++++++++++++
>  3 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/include/net/route.h b/include/net/route.h
> index f90106f383c5..300d292cd9a1 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -173,6 +173,7 @@ struct rtable *ip_route_output_flow(struct net *, str=
uct flowi4 *flp,
>  				    const struct sock *sk);
>  struct dst_entry *ipv4_blackhole_route(struct net *net,
>  				       struct dst_entry *dst_orig);
> +int ip_route_reply_fill_dst(struct sk_buff *skb);
>
>  static inline struct rtable *ip_route_output_key(struct net *net, struct=
 flowi4 *flp)
>  {
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_=
reject_ipv4.c
> index fecf6621f679..c1c0724e4d4d 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -252,21 +252,6 @@ static void nf_reject_ip_tcphdr_put(struct sk_buff *=
nskb, const struct sk_buff *
>  	nskb->csum_offset =3D offsetof(struct tcphdr, check);
>  }
>
> -static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
> -{
> -	struct dst_entry *dst =3D NULL;
> -	struct flowi fl;
> -
> -	memset(&fl, 0, sizeof(struct flowi));
> -	fl.u.ip4.daddr =3D ip_hdr(skb_in)->saddr;
> -	nf_ip_route(dev_net(skb_in->dev), &dst, &fl, false);
> -	if (!dst)
> -		return -1;
> -
> -	skb_dst_set(skb_in, dst);
> -	return 0;
> -}
> -
>  /* Send RST reply */
>  void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *old=
skb,
>  		   int hook)
> @@ -279,7 +264,7 @@ void nf_send_reset(struct net *net, struct sock *sk, =
struct sk_buff *oldskb,
>  	if (!oth)
>  		return;
>
> -	if (!skb_dst(oldskb) && nf_reject_fill_skb_dst(oldskb) < 0)
> +	if (!skb_dst(oldskb) && ip_route_reply_fill_dst(oldskb) < 0)
>  		return;
>
>  	if (skb_rtable(oldskb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
> @@ -352,7 +337,7 @@ void nf_send_unreach(struct sk_buff *skb_in, int code=
, int hook)
>  	if (iph->frag_off & htons(IP_OFFSET))
>  		return;
>
> -	if (!skb_dst(skb_in) && nf_reject_fill_skb_dst(skb_in) < 0)
> +	if (!skb_dst(skb_in) && ip_route_reply_fill_dst(skb_in) < 0)
>  		return;
>
>  	if (skb_csum_unnecessary(skb_in) ||
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 3f3de5164d6e..f24609933fbe 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2942,6 +2942,21 @@ struct rtable *ip_route_output_flow(struct net *ne=
t, struct flowi4 *flp4,
>  }
>  EXPORT_SYMBOL_GPL(ip_route_output_flow);
>
> +int ip_route_reply_fill_dst(struct sk_buff *skb)
> +{
> +	struct rtable *rt;
> +	struct flowi4 fl4 =3D {
> +		.daddr =3D ip_hdr(skb)->saddr
> +	};
> +
> +	rt =3D ip_route_output_key(dev_net(skb->dev), &fl4);
> +	if (IS_ERR(rt))
> +		return PTR_ERR(rt);
> +	skb_dst_set(skb, &rt->dst);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ip_route_reply_fill_dst);
> +
>  /* called with rcu_read_lock held */
>  static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
>  			struct rtable *rt, u32 table_id, dscp_t dscp,
> --
> 2.34.1

