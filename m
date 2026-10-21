Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792599514;
	b=SnLb4qayIjg758qLsiLyHskecEHDwbGlsWSRlwPDS3BuPtd1pNeYnQbr/MxVNk3rU25w
	 e/UUtpU/69csMyzpfLPiOSUs4oKf3GNskNuzcG+w2XDydGsP39e4AjJ64uyAkF4i6Anws
	 BpkJrMVmKjRLtH5i/5ljvJv8TK58fBStSGHfOhwCiW4ncEqCLiY26epCwQcpCMm3MlxFy
	 cYn/urd/WCY0gBzvAddMct4GInIJgBIm27ob9yUzyws2Jl1Ta30oK276AJAiDmyGo2F4i
	 TwCM9+zOZXP/MW25dniR4/oi4XbwhX3fsAs15j/pogxcFF++uVwec9GB8SKuVnelZ+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792599514;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UrbNAcrvvqBJ2+CGBxSM/krMHIMJIRsTQjY9f7twsUM=;
	b=Apmz2Lz0XLqaCeeG9y0Q5/jqZ+zpbVbiz/EQznQtnHU2H8/G2D+Fk1LQvGEMkuznTWkm
	 TC6BNEgzG9jDT4wMmBro+ZjmL0CWR05gSmYAJJz3TcaCXyTMk2Yo7Az9ZjYijmdIrnHKM
	 fbU+WtvFIqBELEapMu1r/kIIJFmF9opBuNS5OVS6kIo1Z/EsbX5vcb4OloIiEalQx4bN3
	 Ir1w4uTFWWWfiQZU7Ae1L3gYqcbM5zBiIMy6yjA/8ePPLXyExOZNWLg9oGqvBvkwq/38b
	 uUTBVYUEs03PEjgWzXSTkQvPNxybbqVLIybxqF9i2r+g8Zwsblw8qrJ945tniJsibew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JryTpxW9;
	arc=none smtp.remote-ip=209.85.222.42
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8B606A322
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 16:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64B8B606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JryTpxW9
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-97ca72f2cd9so590879241.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 09:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792599513; x=1793204313; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UrbNAcrvvqBJ2+CGBxSM/krMHIMJIRsTQjY9f7twsUM=;
        b=JryTpxW9sA3qgDc6w0OI4sgjqiV1VJqlQCAAH2NLz1aeF7tdSyLCIHbXYSjqHwIKRu
         Aro3upjhu0Vwe24oYk+djjQ17zEu2D9zfbGNJa9OsEoe1ljXVZExNF0GW7ogav1wXBLP
         jKUBtCOxgvy7fWWO+kSrJoVmmLchOqtMxf33gDDpTEhTw0fZo4A7db+su2GLOtnsMf9L
         2XhJjwbzmBSUrykW3CXhhciDKT/NR8wZRTfu+XykGIesrxGF8OLKewg47aI22Ga6f399
         Y1mGwr93UvKKvMU4T8g987HNB+eoNnKihh7mtSV9H2VdLJhytvi4W2+0HZKwrjPFcXTX
         jRTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792599513; x=1793204313;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UrbNAcrvvqBJ2+CGBxSM/krMHIMJIRsTQjY9f7twsUM=;
        b=Rlg9Sq9uc7HTGtmDr1EP1hmbm3MFgiV6Op4lkobFLMlN7zQj7f4P2tG+3e4dUtJ8Nu
         ikINcKmymjPHtLbLsq4jxx2weVzApXa+s7cESLGxJDgo6PmS6RkKMjGRtagkNSpvqh7F
         kRaUZtNeL6ItnpbxzwP+riJs+DqYw9Notme1l2AwiukNwpCGSqFBbAVs6IGOcbaRGeE9
         QhMO3TEunKMAv5DsYXuKquezr0dIbAm4xE8t1gVBYpvO2WJbTOCUfj1nq8YmhGIX5rl1
         zlBsujm2+jopCDr4+fol2if+8xH9vmUVP1rL/B58qaLxERBBBhrRlOFDnCcdqQqPV+57
         mpRQ==
X-Forwarded-Encrypted: i=1; AKwUvBxXh/T6TBfXYjPOdH9eJQ0glOcpx85Hwjbv4Qxb11nZVIPOh72IWcNoOgoIEllGiejWC/2gK1+70VZu5IxBhKU=@vger.kernel.org
X-Gm-Message-State: AFq9FYKYSls+DtjmlsN9LjjKYq350J7oL3mdmZxiewVf2mgtzP4VKDsr
	Z2Z008sE38SqfXIfjx8E/hg0e40BLA8HDgESB3ml/0J2i4ei5WxJQbHmVP+sTA==
X-Gm-Gg: AYBFou11TOMP/RlUWndmVuLjI6Bv4g76iKWmnfDLjvIsO9SPmH59H3oYRLCLSzUBNNw
	Ef4DEI9soKh/2id2jEQjlMPT9ZvXThrKgUuFQDSR+1bcnmJGUlngUNP3Aczwyj7/ClJDM98YgHs
	NbvIk9jQMbuyHcISZZYQHlzfprcKX7gSDcmD12IXy80sDZmSnx3GL3GwjmsvVvWjhWWGCwpTzKC
	KV+pw1Uj6vWFLVrzHowSYJSPEO4+bvs1Ku4yt25FFASOG/qoW1F74D7RvsRfe9tM8yIJjzl0dXV
	V6gxm69t8YSPer2uwLDq+YE9+wjVpZoCqbFNKnqu/zuzPcFW9ft/7QnlBapMPh7kL98oHsyW0Eq
	OnSgS5ViRjb/DdiIQIF0tJdHKCOBex4RqPDnJW1H60tj+QkWtyMrwmkuxZUBxYUmKHwQWWAzx3N
	jVuYwB+bkRcVI1yoTbMAtWHPoGfIIoACUOjhiHZkjr1aIp+KupAtxsCx5jKUIMlqQiItsC05O6t
	1XYQgALNNSuOYpwDcNE09KuGEdfUH62vY9COQPeYuNZ95RVA1TwamBD2NRkrgPuKDtOJNaAvFUO
	JxQ+TR1ED+41SUwSEu1arj33tlXu0dU+9mdczOya+Cd1T/NqF+ZvWc5+xm00bZfk7TLKvGGOdC4
	bC3fX0/AYxyms7Y2naOtIVU26R06ZmIP4doq2m1g8
X-Received: by 2002:a05:6102:3e8b:b0:79e:2b00:b4da with SMTP id ada2fe7eead31-7cc9263e66bmr1074589137.6.1792599513253;
        Wed, 21 Oct 2026 09:18:33 -0700 (PDT)
Received: from gmail.com (111.46.245.35.bc.googleusercontent.com. [35.245.46.111])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cc9236f63csm3160917137.5.2026.10.21.09.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:18:32 -0700 (PDT)
Date: Wed, 21 Oct 2026 12:18:32 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, 
 linux-kernel@vger.kernel.org
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 Chris Arges <carges@cloudflare.com>, 
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
 Phil Sutter <phil@nwl.cc>, 
 Jason Wang <jasowangio@gmail.com>, 
 =?UTF-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 Andrew Lunn <andrew+netdev@lunn.ch>, 
 "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, 
 netdev@vger.kernel.org, 
 virtualization@lists.linux.dev, 
 Max Krasnyansky <maxk@qualcomm.com>, 
 Rusty Russell <rusty@rustcorp.com.au>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, 
 Nikolay Aleksandrov <razor@blackwall.org>, 
 Ido Schimmel <idosch@nvidia.com>, 
 Simon Horman <horms@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 bridge@lists.linux.dev
Message-ID: <willemdebruijn.kernel.c4a4cd674948@gmail.com>
In-Reply-To: <aa1551c0357a149a84d01761872cb4d3b489d1af.1792565282.git.mst@redhat.com>
References: <be251d104f881a309cfef150455efa128ebb101d.1792565282.git.mst@redhat.com>
 <aa1551c0357a149a84d01761872cb4d3b489d1af.1792565282.git.mst@redhat.com>
Subject: Re: [PATCH net v4 6/7] net: add ip4_parse()
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Michael S. Tsirkin wrote:
> Multiple places in the net stack open-code the same minimal IPv4 header=

> validation: pull the fixed header, check version 4 and IHL >=3D 5 (wher=
e 5
> is the fixed header size in 32-bit units) - and locate the transport
> header at IHL * 4 past the network header.
> =

> Add a helper for doing that: it returns the validated header and
> the transport header offset, or NULL if truncated or malformed.
> =

> As noted by Phil Sutter, there are more places that could use this
> helper, e.g. ip_mc_check_iphdr(). They will be converted in a follow-up=

> patch.
> =

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> Reviewed-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/linux/ip.h                  | 30 +++++++++++++++++++++++++++++=

>  include/linux/virtio_net.h          | 28 +--------------------------
>  net/bridge/br_netfilter_hooks.c     | 15 +++++----------
>  net/ipv4/ip_input.c                 | 13 +++++--------
>  net/ipv4/netfilter/nf_reject_ipv4.c | 13 +++++--------
>  5 files changed, 46 insertions(+), 53 deletions(-)
> =

> diff --git a/include/linux/ip.h b/include/linux/ip.h
> index d11c25f5030a..aba37cd60212 100644
> --- a/include/linux/ip.h
> +++ b/include/linux/ip.h
> @@ -56,4 +56,34 @@ static inline void iph_set_totlen(struct iphdr *iph,=
 unsigned int len)
>  {
>  	iph->tot_len =3D len <=3D IP_MAX_MTU ? htons(len) : 0;
>  }
> +
> +/**
> + * ip4_parse - pull and minimally validate an IPv4 header

This only pulls sizeof(struct iphdr).

To match function comment and generally be robust: pull again
if ihl !=3D 0.

Apparently virtio_net_hdr_tnl_to_skb will set =

skb->transport_header to the thoff reported here, which may be
beyond the end of the linear packet.

> + * @skb: buffer to parse
> + * @nhoff: offset of the IPv4 header within the linear data
> + * @thoff: returns the transport header offset
> + *
> + * Only the fixed header is guaranteed linear on return: callers
> + * that need the options or the transport header must pull
> + * further.
> + *
> + * Return: the validated IPv4 header, or NULL if truncated or
> + * malformed.
> + */
> +static inline struct iphdr *ip4_parse(struct sk_buff *skb,
> +				      unsigned int nhoff,
> +				      unsigned int *thoff)
> +{
> +	struct iphdr *iph;
> +
> +	if (!pskb_may_pull(skb, nhoff + sizeof(struct iphdr)))
> +		return NULL;
> +
> +	iph =3D (struct iphdr *)(skb->data + nhoff);
> +	if (iph->version !=3D 4 || iph->ihl < sizeof(struct iphdr) / sizeof(u=
32))
> +		return NULL;
> +
> +	*thoff =3D nhoff + iph->ihl * sizeof(u32);
> +	return iph;
> +}
>  #endif	/* _LINUX_IP_H */
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index b3bbecbd023c..724ab8659501 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -53,32 +53,6 @@ static inline int virtio_net_hdr_set_proto(struct sk=
_buff *skb,
>  	return 0;
>  }
>  =

> -/* TODO: nothing virtio specific here, move to ip.h */
> -
> -/*
> - * Pull and minimally validate the IPv4 header at @nhoff.
> - * Returns the header and stores the transport header offset in
> - * @thoff, or NULL if truncated or malformed.  Only the fixed header
> - * is guaranteed linear; callers that need the options or the
> - * transport header must pull further.
> - */
> -static inline struct iphdr *virtio_net_ip4_parse(struct sk_buff *skb,
> -						  unsigned int nhoff,
> -						  unsigned int *thoff)
> -{
> -	struct iphdr *iph;
> -
> -	if (!pskb_may_pull(skb, nhoff + sizeof(struct iphdr)))
> -		return NULL;
> -
> -	iph =3D (struct iphdr *)(skb->data + nhoff);
> -	if (iph->version !=3D 4 ||
> -	    iph->ihl < sizeof(struct iphdr) / sizeof(u32))
> -		return NULL;
> -
> -	*thoff =3D nhoff + iph->ihl * sizeof(u32);
> -	return iph;
> -}
>  /* Defined in net/core/dev.c, enabled while any network namespace
>   * has net.core.virtio_net_hdr_validate set to 0.
>   */
> @@ -157,7 +131,7 @@ virtio_net_l4_start(struct sk_buff *skb, unsigned i=
nt nhoff, __be16 proto,
>  		    unsigned int *thoff, int *ip_proto)
>  {
>  	if (proto =3D=3D htons(ETH_P_IP)) {
> -		const struct iphdr *iph =3D virtio_net_ip4_parse(skb, nhoff, thoff);=

> +		const struct iphdr *iph =3D ip4_parse(skb, nhoff, thoff);
>  =

>  		if (!iph || ip_is_fragment(iph))
>  			return false;
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
> index 0a394e5f4391..e89da0e41542 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -206,18 +206,13 @@ static inline void nf_bridge_pull_encap_header_rc=
sum(struct sk_buff *skb)
>  static int br_validate_ipv4(struct net *net, struct sk_buff *skb)
>  {
>  	const struct iphdr *iph;
> -	u32 len;
> +	u32 len, thoff;
>  =

> -	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> +	iph =3D ip4_parse(skb, 0, &thoff);
> +	if (!iph)
>  		goto inhdr_error;
>  =

> -	iph =3D ip_hdr(skb);
> -
> -	/* Basic sanity checks */
> -	if (iph->ihl < 5 || iph->version !=3D 4)
> -		goto inhdr_error;
> -
> -	if (!pskb_may_pull(skb, iph->ihl*4))
> +	if (!pskb_may_pull(skb, thoff))
>  		goto inhdr_error;
>  =

>  	iph =3D ip_hdr(skb);
> @@ -228,7 +223,7 @@ static int br_validate_ipv4(struct net *net, struct=
 sk_buff *skb)
>  	if (skb->len < len) {
>  		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>  		goto drop;
> -	} else if (len < (iph->ihl*4))
> +	} else if (len < thoff)
>  		goto inhdr_error;
>  =

>  	if (pskb_trim_rcsum(skb, len)) {
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index 9860178752b8..5adf01763e85 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -500,7 +500,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *=
skb, struct net *net)
>  {
>  	const struct iphdr *iph;
>  	int drop_reason;
> -	u32 len;
> +	u32 len, thoff;
>  =

>  	/* When the interface is in promisc. mode, drop all the crap
>  	 * that it receives, do not try to analyse it.
> @@ -520,10 +520,6 @@ static struct sk_buff *ip_rcv_core(struct sk_buff =
*skb, struct net *net)
>  	}
>  =

>  	drop_reason =3D SKB_DROP_REASON_NOT_SPECIFIED;
> -	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> -		goto inhdr_error;
> -
> -	iph =3D ip_hdr(skb);
>  =

>  	/*
>  	 *	RFC1122: 3.2.1.2 MUST silently discard any IP frame that fails the=
 checksum.
> @@ -536,7 +532,8 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *=
skb, struct net *net)
>  	 *	4.	Doesn't have a bogus length
>  	 */
>  =

> -	if (iph->ihl < 5 || iph->version !=3D 4)
> +	iph =3D ip4_parse(skb, 0, &thoff);
> +	if (!iph)
>  		goto inhdr_error;
>  =

>  	BUILD_BUG_ON(IPSTATS_MIB_ECT1PKTS !=3D IPSTATS_MIB_NOECTPKTS + INET_E=
CN_ECT_1);
> @@ -546,7 +543,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *=
skb, struct net *net)
>  		       IPSTATS_MIB_NOECTPKTS + (iph->tos & INET_ECN_MASK),
>  		       max_t(unsigned short, 1, skb_shinfo(skb)->gso_segs));
>  =

> -	if (!pskb_may_pull(skb, iph->ihl*4))
> +	if (!pskb_may_pull(skb, thoff))
>  		goto inhdr_error;
>  =

>  	iph =3D ip_hdr(skb);
> @@ -559,7 +556,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *=
skb, struct net *net)
>  		drop_reason =3D SKB_DROP_REASON_PKT_TOO_SMALL;
>  		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>  		goto drop;
> -	} else if (len < (iph->ihl*4))
> +	} else if (len < thoff)
>  		goto inhdr_error;
>  =

>  	/* Our transport medium may have padded the buffer out. Now we know i=
t
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/n=
f_reject_ipv4.c
> index 59ec465a9df9..42d639854ddf 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -25,22 +25,19 @@ nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
>  static int nf_reject_iphdr_validate(struct sk_buff *skb)
>  {
>  	struct iphdr *iph;
> -	u32 len;
> +	u32 len, thoff;
>  =

> -	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> -		return 0;
> -
> -	iph =3D ip_hdr(skb);
> -	if (iph->ihl < 5 || iph->version !=3D 4)
> +	iph =3D ip4_parse(skb, 0, &thoff);
> +	if (!iph)
>  		return 0;
>  =

>  	len =3D ntohs(iph->tot_len);
>  	if (skb->len < len)
>  		return 0;
> -	else if (len < (iph->ihl*4))
> +	else if (len < thoff)
>  		return 0;
>  =

> -	if (!pskb_may_pull(skb, iph->ihl*4))
> +	if (!pskb_may_pull(skb, thoff))
>  		return 0;
>  =

>  	return 1;
> -- =

> MST
> =



