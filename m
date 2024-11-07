Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141CF1DB534
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2024 12:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730983273; cv=none; b=pYXGiuax2sY934K0jf7vtOSHfNE0Hod9guVcSsEVKTOBDxMpFgKV86oeeXZbwSfO2R/5Z6uVk6bPTeyQB8UFqqo6gBeq5FhXHzfay/e3KluPiIF8eFu26bpDJUbpnKuX22KXt6KZ74avUUPczUJxNOz0jOiVuDAcm59vbPZKl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730983273; c=relaxed/simple;
	bh=0xOH2DwmBPvkKs25IRRpA5/+QjtzVAPgcJqdgeso+zw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Aum9Ux4TKnV6dlMIrq7Y88n0Z496EdejJiDlgLzDcphotcBOjpjkG9rA2N5h/bX+w1MTXYgMdX1yAOBn30MRYrfX+jBtldQGMaJ2LHj4Iqlo8qbRxmM026I74xSojEZL0+FjJJ5hFsX3/xmrQsBJhe3muvZO/9GBnYMAtbSGmoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CE9wZduG; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CE9wZduG"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cefc36c5d4so1199531a12.0
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Nov 2024 04:41:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730983270; x=1731588070; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivVKRH2yr9svH6beGCk8O17xcGU1F9I4JcusPh/IoEQ=;
        b=CE9wZduG8m5Zt0621niAxhZce2FmkDv1QHP+PcgKVe0+KAtP4deykks/xFrAV/SFZt
         pkiGu6AcvyaFS39IDEJ/mrqtK78lMN+dDQESxDCaiM5GhslHVROLR4Wy82gcIXhp1k3B
         6qYzGIRekN3ulif17OSGRVK8HMzAWEMOj770jJOKFnpyj0hJxb+3S52zk4FZK1wx5tNP
         0B/VMURqTTry6t8Kqse23o2+oe5irukxGBPvrp3BCrsaKMt3ZURUQFrB5z3lhhT7seGi
         bn17QTOIIB0JQ1nMPDm0dnkndAnVwMbBj25ogm+IlYeSKTj3C7nuN1sk6A3sCH1ApK7J
         K94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730983270; x=1731588070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivVKRH2yr9svH6beGCk8O17xcGU1F9I4JcusPh/IoEQ=;
        b=g3vcf8iilzHQHGZ/V7mjGwJJphUpr//rn2KhksDVzrRk/XtMDD8Cz/mD10hKvgVaTx
         Nx32+o0sD0J6pRfslZRTDWNOCaBQZpZGoGcyKS8Oib6k8Cnxvd1NjqPrlpwDEN2u7+4t
         UcS5Oqdugrqe0Kyv5fOkyUN/ldbZXE9jGSGVgv74qWPyPLyMaQHOzneRYQaImDJNNGwh
         tMq1AUf/kkbb3GPUEovMJU1qmV6jVjAi9VyBcQVn+C3cWrDtBYcEyy3nMDriRq4mFPz6
         L0g5AAma88zSDfM4wZZEwd0OlV2E64V4s6BD2BFDHNQpuatkR56g9nNx3sPEiZl/FRVu
         AVQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjuoafWjNEo6u7Io/HsKrA9w0x0kkUY7nPUDM1ZOYzdKDPq78TWUGcqvXwWRxM6sGZUlEbLDgNnuc9vzRWmkU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw43BBmgS1+XAlyHs6FbNmPNmhpb7jM7thCxUFNIdcs+zNn+vIy
	qgyYd4Q38K0naa6rUkUiMUX1fFQxNVPYFFlQ2/7xZvo0rv+Km2s5XuhophJOSsdAgiXj5PBAWaW
	cEIwHI+W5gjn3PtUZsCwKiVHuJfzlTtpG9B43
X-Google-Smtp-Source: AGHT+IHJfRifTh/VChuwfeR/jbYQWJZwkubJtQhT0PzG7sH947f2RX0vvvURIGGKney4qTqvLB52PLKMjkyZqME6nf8=
X-Received: by 2002:a05:6402:1d4a:b0:5cb:acdc:b245 with SMTP id
 4fb4d7f45d1cf-5ceb9282a67mr20231225a12.17.1730983270122; Thu, 07 Nov 2024
 04:41:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105100647.117346-1-chia-yu.chang@nokia-bell-labs.com> <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com>
In-Reply-To: <20241105100647.117346-10-chia-yu.chang@nokia-bell-labs.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 7 Nov 2024 13:40:58 +0100
Message-ID: <CANn89i+9USaOthY3yaJPT-cbfAcP0re2bbGbWU7SqOSYEW2CMw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 09/13] gro: prevent ACE field corruption &
 better AccECN handling
To: chia-yu.chang@nokia-bell-labs.com
Cc: netdev@vger.kernel.org, dsahern@gmail.com, davem@davemloft.net, 
	dsahern@kernel.org, pabeni@redhat.com, joel.granados@kernel.org, 
	kuba@kernel.org, andrew+netdev@lunn.ch, horms@kernel.org, pablo@netfilter.org, 
	kadlec@netfilter.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	ij@kernel.org, ncardwell@google.com, koen.de_schepper@nokia-bell-labs.com, 
	g.white@cablelabs.com, ingemar.s.johansson@ericsson.com, 
	mirja.kuehlewind@ericsson.com, cheshire@apple.com, rs.ietf@gmx.at, 
	Jason_Livingood@comcast.com, vidhi_goel@apple.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 11:07=E2=80=AFAM <chia-yu.chang@nokia-bell-labs.com>=
 wrote:
>
> From: Ilpo J=C3=A4rvinen <ij@kernel.org>
>
> There are important differences in how the CWR field behaves
> in RFC3168 and AccECN. With AccECN, CWR flag is part of the
> ACE counter and its changes are important so adjust the flags
> changed mask accordingly.
>
> Also, if CWR is there, set the Accurate ECN GSO flag to avoid
> corrupting CWR flag somewhere.
>
> Signed-off-by: Ilpo J=C3=A4rvinen <ij@kernel.org>
> Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
> ---
>  net/ipv4/tcp_offload.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
> index 0b05f30e9e5f..f59762d88c38 100644
> --- a/net/ipv4/tcp_offload.c
> +++ b/net/ipv4/tcp_offload.c
> @@ -329,7 +329,7 @@ struct sk_buff *tcp_gro_receive(struct list_head *hea=
d, struct sk_buff *skb,
>         th2 =3D tcp_hdr(p);
>         flush =3D (__force int)(flags & TCP_FLAG_CWR);
>         flush |=3D (__force int)((flags ^ tcp_flag_word(th2)) &
> -                 ~(TCP_FLAG_CWR | TCP_FLAG_FIN | TCP_FLAG_PSH));
> +                 ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
>         flush |=3D (__force int)(th->ack_seq ^ th2->ack_seq);
>         for (i =3D sizeof(*th); i < thlen; i +=3D 4)
>                 flush |=3D *(u32 *)((u8 *)th + i) ^
> @@ -405,7 +405,7 @@ void tcp_gro_complete(struct sk_buff *skb)
>         shinfo->gso_segs =3D NAPI_GRO_CB(skb)->count;
>
>         if (th->cwr)
> -               shinfo->gso_type |=3D SKB_GSO_TCP_ECN;
> +               shinfo->gso_type |=3D SKB_GSO_TCP_ACCECN;
>  }
>  EXPORT_SYMBOL(tcp_gro_complete);
>

I do not really understand this patch. How a GRO engine can know which
ECN variant the peers are using ?

SKB_GSO_TCP_ECN is also used from other points, what is your plan ?

git grep -n SKB_GSO_TCP_ECN
drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:3888:
skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1291:
skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:1312:
skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
include/linux/netdevice.h:5061: BUILD_BUG_ON(SKB_GSO_TCP_ECN !=3D
(NETIF_F_TSO_ECN >> NETIF_F_GSO_SHIFT));
include/linux/skbuff.h:664:     SKB_GSO_TCP_ECN =3D 1 << 2,
include/linux/virtio_net.h:88:                  gso_type |=3D SKB_GSO_TCP_E=
CN;
include/linux/virtio_net.h:161:         switch (gso_type & ~SKB_GSO_TCP_ECN=
) {
include/linux/virtio_net.h:226:         if (sinfo->gso_type & SKB_GSO_TCP_E=
CN)
net/ipv4/tcp_offload.c:404:             shinfo->gso_type |=3D SKB_GSO_TCP_E=
CN;
net/ipv4/tcp_output.c:389:
skb_shinfo(skb)->gso_type |=3D SKB_GSO_TCP_ECN;
