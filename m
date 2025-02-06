Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C893F1C6FF5
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 14:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738851661; cv=none; b=OT4KzdtbhvY/oMmGkSP+3RLFJgAR+WvMTV+XY5GofGQNZTUDgg/3AE7rmf71aOqo3AOoo8IUZr0TS7rJHq/V3UO61B0MXIpgEHT93ybLL+Zwpf21zl1Qq4t7EGdGPjkMwoEIqTf0Ar4G9TU6Golm5A0qFDPP4EyCvJBSMH4HG6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738851661; c=relaxed/simple;
	bh=GUKOfJix9NBXsxH+M69y63dFCyCl1cade5SQsOM6nME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZ40ruzRKgTz3DXWq4O3hPbGpQ36Q5B9ZBIBbMxqnvKzxoyH62tI78x84e7z3uBJMi/Vo0QAhFcA+XDRd5HIvCdXSZ9Nw0fj+GKswEjPxc0hRrBIr52/Qr7DgmrLkT7Riz++M5Jlg4AQEYXODlxp/admnNZBdiazHJknBznbwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b=NEpLqjKd; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall-org.20230601.gappssmtp.com header.i=@blackwall-org.20230601.gappssmtp.com header.b="NEpLqjKd"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ab7740ca85eso114032466b.3
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 06:20:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20230601.gappssmtp.com; s=20230601; t=1738851658; x=1739456458; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IjndcfyqjqX0suK3BJwJI5MpJWEUcpM/zhKh9Jt/IFw=;
        b=NEpLqjKd7eE3kGKrV4ZGaM4SAdsOAftS5wS/0yTO8f5+XKacSzkZK7pUvf4mgOWwyO
         NRtH2tRUGOK+Wio5NOEFR6MCbiupkdq3aDzHt3KLtGZ9r/k63WKxIzXKJTJMS1KDoBKg
         LliFAnIRaIVqzigLNtZb+TjqjtTo4HaLzdaOpQm2SSJUbNzdDQVK8PS7l/Ta65iJZ+wV
         yTPOF8Ev72zpyQs7MGFdWCdhBKZiDfojMxC3jRlJPG4bUAdZ2+hBwtihSBg6a3LD9Jxb
         4pgLfQpMpvsPMYo5U+6SzdVISq/Vq9B1D1R6Qsu7qLYAitigyBXCfAV4cqpt20+4KjtG
         UC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738851658; x=1739456458;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjndcfyqjqX0suK3BJwJI5MpJWEUcpM/zhKh9Jt/IFw=;
        b=wsfxM4yxItZlPdnAq5tA3itYFpjPqTz7F2u38YSTeqJIsYwi5M9VL1MXJupI4336Dt
         26XuChVj3lBmK4sR5m0TdFgaM9LR2azlV7bnUR8gGr44MIvO9MiHvzm9uKxrwWahVotZ
         nKQZhnlgCCFXzhJafidksyqThnxVnzqn1PaGx+tpIgArEY8cn8frFIUrsDf7IPUyEMfx
         qWQmAcQOlk79W8nLQiDgWjxcxLcnfsFK3gaTFB0IwHqwV2n2sHG7QqR2T37kLl4l3EOO
         I8WEqpNkdJqp2L2J+E7Nr1pRP/j1/9ce5TeZa0UquLO3xV82NakoRoixmYV20sYPX966
         XfAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWosFk6buQOUiopYbqhYtg1gPafGScvyTcaLI9WX1Sb5PnIQ/GE2UIlvokwW/pGwp+tGdZ5ljjhoaUXYmmNpyA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzghr+JSBu30HN683+TnKTlF5kmCo0YWctnSSjZCNh30bXZ0sNd
	NIplFoRlaUve6Fub8qgrk9XO9GKz9OGQ12Q4zY1ODPg22Vh0eqOEmkB0CQgwePU=
X-Gm-Gg: ASbGncuS5pd7oXk+WUc+7LEF2FGvIvpj9CPFnIdI2h3/qCUdquWnZ+TOS0iO/Zp6gId
	lfzi0yJtXkPXxEuRz8Qe7pVmlGNBppjEiwwc5jiFzxRFyEG5iA8caoATnOtfRWNfA5r68m8Uf/b
	3AD207yBRkRpLGl3lQXjXUcJXX/m27+PU3HjbR1SeqZpoNBiYKMMqJHlEKaaXD22+h/Uz1VPgOH
	KNgXN6Bg+8VR0zUlVh4TrzpduSYOMU6YigS9pvRsxdS7fblFiYdP8pi7olqE269mG2r+yf2Ikk5
	XCu+aMj+hH9u4szoMh6VItoyoS53UBzNlWy7ZBMK8KrSVqs=
X-Google-Smtp-Source: AGHT+IEtj41Y5GMmmjFUnay2iogZtTrhXfr7uhOofHHSDx3vmcnEYXA/d41IrDMa8vkMQ4WmCAfDEQ==
X-Received: by 2002:a17:907:7e8e:b0:ab7:4262:686b with SMTP id a640c23a62f3a-ab75e2f2a97mr822408166b.40.1738851657921;
        Thu, 06 Feb 2025 06:20:57 -0800 (PST)
Received: from [192.168.0.205] (78-154-15-142.ip.btc-net.bg. [78.154.15.142])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dcf1b7ade9sm931494a12.25.2025.02.06.06.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2025 06:20:57 -0800 (PST)
Message-ID: <5de3c769-68b8-4f59-8a76-1b81d51040b1@blackwall.org>
Date: Thu, 6 Feb 2025 16:20:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 net-next 03/14] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Eric Woudstra <ericwouds@gmail.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
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
References: <20250204194921.46692-1-ericwouds@gmail.com>
 <20250204194921.46692-4-ericwouds@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20250204194921.46692-4-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 21:49, Eric Woudstra wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 81 ++++++++++++++++++----
>  1 file changed, 69 insertions(+), 12 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 816bb0fde718..6411bfb53fad 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -242,53 +242,110 @@ static unsigned int nf_ct_bridge_pre(void *priv, struct sk_buff *skb,
>  {
>  	struct nf_hook_state bridge_state = *state;
>  	enum ip_conntrack_info ctinfo;
> +	int ret, offset = 0;
>  	struct nf_conn *ct;
> -	u32 len;
> -	int ret;
> +	__be16 outer_proto;
> +	u32 len, data_len;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
>  	if ((ct && !nf_ct_is_template(ct)) ||
>  	    ctinfo == IP_CT_UNTRACKED)
>  		return NF_ACCEPT;
>  
> +	switch (skb->protocol) {
> +	case htons(ETH_P_PPP_SES): {
> +		struct ppp_hdr {
> +			struct pppoe_hdr hdr;
> +			__be16 proto;
> +		} *ph = (struct ppp_hdr *)(skb->data);
> +
> +		offset = PPPOE_SES_HLEN;
> +		if (!pskb_may_pull(skb, offset))
> +			return NF_ACCEPT;

You should reload ph because pskb_may_pull() may change the skb and it can
become invalid

> +		outer_proto = skb->protocol;
> +		switch (ph->proto) {
> +		case htons(PPP_IP):
> +			skb->protocol = htons(ETH_P_IP);
> +			break;
> +		case htons(PPP_IPV6):
> +			skb->protocol = htons(ETH_P_IPV6);
> +			break;
> +		default:
> +			nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
> +			return NF_ACCEPT;
> +		}
> +		data_len = ntohs(ph->hdr.length) - 2;
> +		skb_pull_rcsum(skb, offset);
> +		skb_reset_network_header(skb);
> +		break;
> +	}
> +	case htons(ETH_P_8021Q): {
> +		struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data);
> +
> +		offset = VLAN_HLEN;
> +		if (!pskb_may_pull(skb, offset))
> +			return NF_ACCEPT;

ditto about vhdr, should be reloaded after the may pull

> +		outer_proto = skb->protocol;
> +		skb->protocol = vhdr->h_vlan_encapsulated_proto;
> +		data_len = U32_MAX;
> +		skb_pull_rcsum(skb, offset);
> +		skb_reset_network_header(skb);
> +		break;
> +	}
> +	default:
> +		data_len = U32_MAX;
> +		break;
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
>  
>  static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,

