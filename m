Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18081D362B
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Nov 2024 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730806129; cv=none; b=QfdE/fO74zRRRyIZh39kCMCs+QRjr4Tw8t1jJQ1S6oP1rgIvjtuXQWfbmZ41qbMRmXZF1Z5XvtDKaUGlRBpTb71bu379g5EeSx86yNb8EKy3p26DwVrB8kHqnZGIZbUz6Z4qdRvtIQimNwaIoLB5Usj66SzNvuZIwvppOVZjk0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730806129; c=relaxed/simple;
	bh=V4Fx4ZCsZ/W2CFev1srbqlkLsaSDBUC/Uyf8xKL5iIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZeKU5BH20visFf9yTixgB+zlEvymh4z2M4SyqoGbDGMGw9x/cOPnkIPQPq8QP1ji09yyhwpKIwCVXebThD0y9sckA+oDcDQe+8GgvIOTYKqd+e74FdNkG3siKYGLZ6IjXa7Dnr2Gra1xLV9NfOCmj2hyQoiT8Q9fsGrjg6sS05o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L3Ir2mOd; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3Ir2mOd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730806126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YRw+ZI+EHriAqyQtRKFNEP9Ziutm6hGWEIK6wHEDZ+0=;
	b=L3Ir2mOdM7jbmFwgJcIZtD9zIB8YTJ7OE4p3+o8+se2Jc8DkmJMG/T5vD9W+u/g68pHlVQ
	JmC9o/PokhfRZTg0TwqRODNEdZ0HQJJLTIukh/QOvpbtZQ4j1evQSlZWl/5b+qCUv3I8oW
	Kcx5ZD5lHmFIJ8EK2YXMyq33UmTnJBI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-pw31G5VKNAiq1TeYvZ_IjQ-1; Tue, 05 Nov 2024 06:28:45 -0500
X-MC-Unique: pw31G5VKNAiq1TeYvZ_IjQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-431ad45828aso35826505e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Nov 2024 03:28:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730806124; x=1731410924;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YRw+ZI+EHriAqyQtRKFNEP9Ziutm6hGWEIK6wHEDZ+0=;
        b=rt9swczoLXjmREKlFXcpwF/+LJFyrH97kQJo+QOTNGbIw2xkV/9vgcy9uNqfnAX0kY
         pfndm/SqugbgA9X9rrjOBPpx4H0XQZWPENatGYmDlNmLaCQPYITwRjvFGXnjLpnQLG9k
         Qt4FFpUi6dX83v/og7KpEDRocag1b2p4CtaYmbV9Co1tZ1A/vVgpyxtG2SdHZzRtkBHh
         UzIgjv+JQ4/eSAKylckPf/79rmNa+dyMyRTdLF9WTlqC4HXfRZNHrMlEI4Nba1eLIVji
         pEYxFaNtO9SlgqqCQ533XSfbyGqf4ucfH9Pd1Elnp3VJLGwdJRHuapB/vSXKR9l47J9B
         Jd9w==
X-Forwarded-Encrypted: i=1; AJvYcCU7wx/4vzqk8maTBUv8WTb4T6jhQ945+NYMxT1Cn8KpMNgtkf+qP4uLuJQzzvI0NL1t5TxBlWFG8AV/B9spL9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz0r6lCfE4wyD/+rEJvTCwddFLeSplxuC/2A6LcEUXkCn+09xZ
	5vMkNC53/P5+sNYBXCXF+ag0hWX642DamiT36uKGkSsbYru0RUxRG1fxh//lUPR2InHKsRA7PhC
	OMQf4Zkb1zCX2tZUzbDhU9fuRgeDjdstbnixgYnrGH4iM9586J7zWx52x6YKUb7PmEA==
X-Received: by 2002:a05:600c:511b:b0:42c:b1ee:4b04 with SMTP id 5b1f17b1804b1-4319ad2a786mr285264995e9.28.1730806124612;
        Tue, 05 Nov 2024 03:28:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEq0nB0FHycAeDiC2A5BD6S2GD2q8CvrjAwmkeMdjkaet9mg4xQ5NJoly7MhpdN9Xt3xtfwQ==
X-Received: by 2002:a05:600c:511b:b0:42c:b1ee:4b04 with SMTP id 5b1f17b1804b1-4319ad2a786mr285264515e9.28.1730806124002;
        Tue, 05 Nov 2024 03:28:44 -0800 (PST)
Received: from [192.168.88.24] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c10b7d2bsm15879593f8f.16.2024.11.05.03.28.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 03:28:43 -0800 (PST)
Message-ID: <8f83725e-1ea9-438f-8ab1-ff528ca761fb@redhat.com>
Date: Tue, 5 Nov 2024 12:28:41 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND net-next v4 9/9] net: ip: make ip_route_use_hint()
 return drop reasons
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 horms@kernel.org, dsahern@kernel.org, pablo@netfilter.org,
 kadlec@netfilter.org, roopa@nvidia.com, razor@blackwall.org,
 gnault@redhat.com, bigeasy@linutronix.de, hawk@kernel.org,
 idosch@nvidia.com, dongml2@chinatelecom.cn, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, bpf@vger.kernel.org
References: <20241030014145.1409628-1-dongml2@chinatelecom.cn>
 <20241030014145.1409628-10-dongml2@chinatelecom.cn>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241030014145.1409628-10-dongml2@chinatelecom.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/30/24 02:41, Menglong Dong wrote:
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index e248e5577d0e..7f969c865c81 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2142,28 +2142,34 @@ ip_mkroute_input(struct sk_buff *skb, struct fib_result *res,
>   * assuming daddr is valid and the destination is not a local broadcast one.
>   * Uses the provided hint instead of performing a route lookup.
>   */
> -int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> -		      dscp_t dscp, struct net_device *dev,
> -		      const struct sk_buff *hint)
> +enum skb_drop_reason
> +ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
> +		  dscp_t dscp, struct net_device *dev,
> +		  const struct sk_buff *hint)
>  {
> +	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  	struct in_device *in_dev = __in_dev_get_rcu(dev);
>  	struct rtable *rt = skb_rtable(hint);
>  	struct net *net = dev_net(dev);
> -	enum skb_drop_reason reason;
> -	int err = -EINVAL;
>  	u32 tag = 0;
>  
>  	if (!in_dev)
> -		return -EINVAL;
> +		return reason;
>  
> -	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr))
> +	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr)) {
> +		reason = SKB_DROP_REASON_IP_INVALID_SOURCE;
>  		goto martian_source;
> +	}
>  
> -	if (ipv4_is_zeronet(saddr))
> +	if (ipv4_is_zeronet(saddr)) {
> +		reason = SKB_DROP_REASON_IP_INVALID_SOURCE;
>  		goto martian_source;
> +	}
>  
> -	if (ipv4_is_loopback(saddr) && !IN_DEV_NET_ROUTE_LOCALNET(in_dev, net))
> +	if (ipv4_is_loopback(saddr) && !IN_DEV_NET_ROUTE_LOCALNET(in_dev, net)) {
> +		reason = IP_LOCALNET;
>  		goto martian_source;
> +	}
>  
>  	if (rt->rt_type != RTN_LOCAL)
>  		goto skip_validate_source;

Please explicitly replace also the

	return 0;

with

	return SKB_NOT_DROPPED_YET;

So that is clear the drop reason is always specified.

Thanks,

Paolo

