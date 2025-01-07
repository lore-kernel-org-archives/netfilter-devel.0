Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3C61D5CE5
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jan 2025 09:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736242418; cv=none; b=kDR/wNc/fFJV2i57TnaOyhC3jMQu1dqtMH5Rh6GPxL3Kf4hKB5Bx3/6hVvV98vbShF8iEY3CbJeyHiuhuIZFnERnfaAM7E1ig4UqhW2Vp6vofLX2yVrGIlgjFg4XIQY76IUKDjhcTDRj64ZhBomekeDSOuqjZyhwlIodbrXeeOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736242418; c=relaxed/simple;
	bh=7ODgJWlOJO4/lGktleAYBsYNtDWOE8VlHBQim6ufeH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=opR3RRPW2zSVP/3sKV1lsaZ8NR6Pi6fk5Af0q+qei/2jqVAKL9TUZpVDpiKRwieMpTT+/BNlozHdOLYRugVu5ZqEeKGwqX0FQTiqYnMTYrukcW0mwmIKBSTTNQoSvC6NgHhof2Jcft4Pm3iO/HpBM30wQiKG/z+j9SXQINYPfEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=WhwptH6P; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="WhwptH6P"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-aaeec07b705so1749652366b.2
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2025 01:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1736242412; x=1736847212; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHxjC6h0Kfucr4tH2PqzFsx9yRATfufXfuxgz/uTgy0=;
        b=WhwptH6P40jf+ixkyZEmYyY+pmGKqE2SunRGQun2PJv9BQHI4b621042nRZKC33Mhn
         G1tpDtlWBXapFGHyhMIPonM3I7LKf0qQDymnn8+nAuPaKlNFLibNh2SKxoBkHdpqBsRn
         e16yInB//2yrQld8Cr+4PG66wkxFTFah949EtaFSm1GzXcOXaTe5ahORApG4GSQPe9Zy
         Nbyq6LMA4k3cWAa0+BcBKO/ZTsvdoZyFHtLILFuYfxm2fSqisVNz8sOOsh09fkI20vM/
         g+MljQeNfZuHiBUV4A7dt3S2Nu4D0KtuNR6jtbs2wOoXtu7uCr0AVXcoKcgCw9jXBmk9
         2Qag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736242412; x=1736847212;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHxjC6h0Kfucr4tH2PqzFsx9yRATfufXfuxgz/uTgy0=;
        b=c1tpXCaJFZ0DM4J5sUulhRbtaBCDoZwjeYd7dKOzrSqqVui3Rp/bZqBdnlaDGeXPcA
         xI0ee9Gvwt367umWkGlYK+AGloRM3zxfUYYD+Kik9GrFgTHVLTZQG/1wKH0Jz+HSqjcF
         hodkujzA/u6Ji96Kd57KW2ymY8BtuOeOVJMjDrqCjqq0jFagfk/9RBIsY8vkJjtbXbNa
         g82jrcnJ+bpqvM8Bsn3ooCwGW1i2MwZ16jQZEgm+ShIaBs/37c9DlHkigeD/VH6GsYAa
         M9xTVBI8uaCREynkKgaWticyI6pT+hRxceSDndnL5PMPKdpfVY/j93Of1PQ1rXD+sTV5
         DoQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXDfp1C0kdX6BH0+eUlME9AFtger9ZM9rD2hirE0GmlQChNo4HOYTZxGhvTo92MR1MFAVaO9k1qAihw/DsQjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMeZWj5IF48lwJwY87ng+z9kB6MUpil5o8FuGFlFus/dcOj1jx
	tlH0r7mGPC+GrBiImPxKOgrO4Z1mf0tijyfeON8sPjai9lDe3eTHCHgZ9S0oLmw=
X-Gm-Gg: ASbGncvgsf6jzJkFGy/r6gU1e1BbdmVfoQ72QbsQjGb+9DvbeJctuWFc1lXuL/PYZfS
	Y8oAFB3Sp/KAvkSbTMqjAosRfByBifM7kWD4/WdrSYFVaQEaGPHj4XDWHOwJphl5ql4ZypAHG3B
	2u/yxI6HMVjC/xJBgTGXNpmmPS+cXr2anQlYyGL8jgNOu/u3XMeMptUiS0PVBUutiwi+PHryz7B
	VEr11VdhMbJ4yvrxEoKENcoPhtEgxN7BNyFrCBysByuDc9npW52hx5oxd0I1a7w2Fc8/+3Po9sW
	GCfJKLU0wUwy
X-Google-Smtp-Source: AGHT+IGa/DGsAatcdI0vhBgT7pEyChI9fpmymNYGz7BLnI1zVom6ss0TkBiupaXLIbc8eDhgvofItg==
X-Received: by 2002:a17:907:724f:b0:aae:ebfe:cedb with SMTP id a640c23a62f3a-aaeebfecfc4mr3325114266b.51.1736242412236;
        Tue, 07 Jan 2025 01:33:32 -0800 (PST)
Received: from [192.168.0.123] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aac0e895080sm2354283266b.47.2025.01.07.01.33.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 01:33:31 -0800 (PST)
Message-ID: <2b2488d5-8e34-429b-98f2-0ddb0cce87eb@blackwall.org>
Date: Tue, 7 Jan 2025 11:33:30 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 net-next 02/13] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Eric Woudstra <ericwouds@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 David Ahern <dsahern@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Joe Damato <jdamato@fastly.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org
References: <20250107090530.5035-1-ericwouds@gmail.com>
 <20250107090530.5035-3-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250107090530.5035-3-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 11:05, Eric Woudstra wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
>  1 file changed, 75 insertions(+), 13 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 816bb0fde718..31e2bcd71735 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -241,56 +241,118 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  				     const struct nf_hook_state *state)
>  {
>  	struct nf_hook_state bridge_state = *state;
> +	__be16 outer_proto, inner_proto;
>  	enum ip_conntrack_info ctinfo;
> +	int ret, offset = 0;
>  	struct nf_conn *ct;
> -	u32 len;
> -	int ret;
> +	u32 len, data_len;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if ((ct && !nf_ct_is_template(ct)) ||
>  	    ctinfo == IP_CT_UNTRACKED)
>  		return NF_ACCEPT;
>  

In all cases below I think you should make sure the headers are present
in the linear part of the skb, either do pskb_may_pull() or use
skb_header_pointer(). This is executed in the PRE bridge hook, so nothing
has been pulled yet by it.

> +	switch (skb->protocol) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph = (struct ppp_hdr *)(skb->data);
> +
> +		data_len = ntohs(ph->hdr.length) - 2;
> +		offset = PPPOE_SES_HLEN;
> +		outer_proto = skb->protocol;
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			inner_proto = htons(ETH_P_IP);
> +			break;
> +		case htons(PPP_IPV6):
> +			inner_proto = htons(ETH_P_IPV6);
> +			break;
> +		default:
> +			return NF_ACCEPT;
> +		}
> +		break;
> +	}
> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
> +
> +		data_len = 0xffffffff;
> +		offset = VLAN_HLEN;
> +		outer_proto = skb->protocol;
> +		inner_proto = vhdr->h_vlan_encapsulated_proto;
> +		break;
> +	}
> +	default:
> +		data_len = 0xffffffff;
> +		break;
> +	}
> +
> +	if (offset) {
> +		switch (inner_proto) {
> +		case htons(ETH_P_IP):
> +		case htons(ETH_P_IPV6):
> +			if (!pskb_may_pull(skb, offset))
> +				return NF_ACCEPT;
> +			skb_pull_rcsum(skb, offset);> +			skb_reset_network_header(skb);
> +			skb->protocol = inner_proto;
> +			break;
> +		default:
> +			return NF_ACCEPT;
> +		}
> +	}
> +
> +	ret = NF_ACCEPT;
>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
>  		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		len = skb_ip_totlen(skb);
> +		if (data_len < len)
> +			len = data_len;
>  		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		if (nf_ct_br_ip_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		bridge_state.pf = NFPROTO_IPV4;
>  		ret = nf_ct_br_defrag4(skb, &bridge_state);
>  		break;
>  	case htons(ETH_P_IPV6):
>  		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		len = sizeof(struct ipv6hdr) + ntohs(ipv6_hdr(skb)->payload_len);
> +		if (data_len < len)
> +			len = data_len;
>  		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		if (nf_ct_br_ipv6_check(skb))
> -			return NF_ACCEPT;
> +			goto do_not_track;
>  
>  		bridge_state.pf = NFPROTO_IPV6;
>  		ret = nf_ct_br_defrag6(skb, &bridge_state);
>  		break;
>  	default:
>  		nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> -		return NF_ACCEPT;
> +		goto do_not_track;
>  	}
>  
> -	if (ret != NF_ACCEPT)
> -		return ret;
> +	if (ret == NF_ACCEPT)
> +		ret = nf_conntrack_in(skb, &bridge_state);
>  
> -	return nf_conntrack_in(skb, &bridge_state);
> +do_not_track:
> +	if (offset) {
> +		skb_push_rcsum(skb, offset);
> +		skb_reset_network_header(skb);
> +		skb->protocol = outer_proto;
> +	}
> +	return ret;
>  }
> -
>  static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
>  				    const struct nf_hook_state *state)
>  {

