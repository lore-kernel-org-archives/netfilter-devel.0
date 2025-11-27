Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C12127E074
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764256139; cv=none; b=P7++Pd6uG2m0TgW/FsGu+N5J2Zi6IXIiw5nBSLkd0QnoHIHeCOat/q/U/9YB0ZzJUic4z5K+Y8VlJNQmgaQQ1G/DL5rOEwzVMnOwPsR3i4b++qlveas6WvGWj72zVxSwQpkuRJgH0urKC7ZaZTe+vZhrBAJ+GAVfrB0j+fXJhoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764256139; c=relaxed/simple;
	bh=r4ZzWf622tsNVtnWwIdu20nyqNsXO5bOWbpImO2ygDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dTYK92vl8pjZ6k5AuYoCnjQuyK8F62g6W4FzSALWIcnbTrvysY0vNEeP2LSYV5XXi64V3u5vrT1G6RgzQlwGoPJXKd8pTuQAF5YeHoyi12oYVKr/5kFp7rcmtDhJlGmgmwiRcLneS+cjDFtZgbNXKSdyPOQBEyvs/huK2cW1bLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=izeMkxUc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4p5nSWA; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="izeMkxUc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4p5nSWA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764256135;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=975phbBgu5VyA1MivZ3ZkCvdliAL8o8g367hqsGdYL0=;
	b=izeMkxUcEpi9N2BZ/ZRKCw3A8n/LBtjZ1oriu7joYBpRVZ1AWhqG3Jr/DmUnq4SxOShRyR
	hgASRRI0x9TZsVZvrp+7AMOiCZuU0zGf91+TCyVCisVDRYzMMBalQG7QVRLClyF6mQzTdJ
	Vxc/0+WiHGL8MQoPJ4XH+30oF7eeLrU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-x2QuU3LBMPazm9aO4TaZcg-1; Thu, 27 Nov 2025 10:08:53 -0500
X-MC-Unique: x2QuU3LBMPazm9aO4TaZcg-1
X-Mimecast-MFC-AGG-ID: x2QuU3LBMPazm9aO4TaZcg_1764256132
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-b7689ad588fso92462966b.3
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Nov 2025 07:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764256132; x=1764860932; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=975phbBgu5VyA1MivZ3ZkCvdliAL8o8g367hqsGdYL0=;
        b=E4p5nSWANwxuXM8zq0rhGoqCVu6E6wrGVYyPMolnMCdFHSm2SKcji8uTCGMxMgN/3U
         3mHa5sfewNpy5Xy3jfBbTPTSRzVacaAFqSNyyTeZyJ8iQhdhPq11pkJGKO9FxPGE/7vu
         jsTHo5QIDeYNEAkSTW5BqFYs6IUXIGUUqpHkJB5dYZTpIYJT05We0FxHO7vJc1fEi676
         CP4eN3deWXznE2e+ilxFWkbZPoXnV3F6SvnOakuIzJKZDKsyAEYfk616WlnMbttdMB77
         1tV43w76464HznRlaf3zNAL2AD8U0eeoscXnMuxlG6QX4kyMlB7FXzl/QSDgSImyOTt8
         QP2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764256132; x=1764860932;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=975phbBgu5VyA1MivZ3ZkCvdliAL8o8g367hqsGdYL0=;
        b=CawUaI38KueitKlLQ7zp9PdKB5aNyGQvTgKaTmzDcYOF7ks5JZBMxVOQBcUviJkAgp
         AEpANW51ydDJornpExMK23wDlK3eBhoYcDlCimnY2VCxlt2CmpzU9uxW1/xZkq/RiNrK
         15xbkvRt2X9sMbIiXCh3m0XrUEABRcumRIBzmW/sTffc0uNcwjobuuDZN66Yyg8ilwdm
         xIr7wa76L6RrkR5WP8+LgjTjO+R1revA5oca41Xv1GPi1oTzScHyktfsG8cQKOnzbYs6
         l+Cb8tKtk+6345dZjmleK4mL7DkFfSCPJb3y+rDP8Sn7wnXJrlFu0GDcsC8a79qiCEgU
         c5Kg==
X-Forwarded-Encrypted: i=1; AJvYcCWKdzMvLsvtkhsySzsCxYeSZDGWYXjO8rJ8QinS2VXj4yYa+Uu2xh0E2NLr2uo0ilAVwNLxqK86vDghDZx0TB4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yylrb16nVghdOneBdUko8Xd82bUCBCJ15oi9fTpHsBGw6Dmcset
	iIVncsk+8twm06iOYrG0qpQKAGQy78xAp6/ShsLiOMvE3EdgduZgZyXCrd5PJuEyk1Jf3x5/6n8
	N5MfyPiHEkySKnmZsZHGn16v24kTBLhqSmAI5JhI+ku8BISxtl7rwiCkDM5sRcQyqN9y6Jg==
X-Gm-Gg: ASbGncvM4br/swlJI8r64v1YMinYUZVCuOMEbh+ia6VJeHjytFOcKb9U6v+L2zJ0nFb
	kpbNit9HWpQYQDqTUYiOiW6BeQqts4+E8lChB+fLWjVdb+3RGNPIKs2RNIL4Dpse3Qz/pu9YZPR
	vos51A/7h8IwjAUm00RSdtnKwsPpE2+p34fFMOqjndjfQK14HWnSRmQ5XaOjxQOR7DuWYF32e+I
	Au+AU0OcKQn6C3sURnw2MXVKmkCJy+gXiZm2xYhwo/2vI6l13DLVKw1/73Qq8sNVdvRHKaXxovT
	GHY6atj+bkInGTUxWSmNGPihe7KVX5fqtkptjDZbaY9Ve/U2ynhX5qMUUAeMQsE2JbOOu5Hv8JS
	EHBKJ98TCwKUosA==
X-Received: by 2002:a17:907:1b0c:b0:b76:3dbe:7bf0 with SMTP id a640c23a62f3a-b767150b850mr2168750866b.2.1764256132433;
        Thu, 27 Nov 2025 07:08:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGb4ULpaNMWei1hmL/IxRSlagWdzmISZEpog2WtfT3XFsalNSmZPmRvV9TSFmgMpjPfhmMZ7w==
X-Received: by 2002:a17:907:1b0c:b0:b76:3dbe:7bf0 with SMTP id a640c23a62f3a-b767150b850mr2168747466b.2.1764256131941;
        Thu, 27 Nov 2025 07:08:51 -0800 (PST)
Received: from [192.168.88.32] ([212.105.155.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5163903sm195890366b.7.2025.11.27.07.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Nov 2025 07:08:51 -0800 (PST)
Message-ID: <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>
Date: Thu, 27 Nov 2025 16:08:49 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next,v2 00/16] Netfilter updates for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20251126205611.1284486-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20251126205611.1284486-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/26/25 9:55 PM, Pablo Neira Ayuso wrote:
> v2: - Move ifidx to avoid adding a hole, per Eric Dumazet.
>     - Update pppoe xmit inline patch description, per Qingfang Deng.
> 
> -o-
> 
> Hi,
> 
> The following batch contains Netfilter updates for net-next:
>  
> 1) Move the flowtable path discovery code to its own file, the
>    nft_flow_offload.c mixes the nf_tables evaluation with the path
>    discovery logic, just split this in two for clarity.
>  
> 2) Consolidate flowtable xmit path by using dev_queue_xmit() and the
>    real device behind the layer 2 vlan/pppoe device. This allows to
>    inline encapsulation. After this update, hw_ifidx can be removed
>    since both ifidx and hw_ifidx now point to the same device.
>  
> 3) Support for IPIP encapsulation in the flowtable, extend selftest
>    to cover for this new layer 3 offload, from Lorenzo Bianconi.
>  
> 4) Push down the skb into the conncount API to fix duplicates in the
>    conncount list for packets with non-confirmed conntrack entries,
>    this is due to an optimization introduced in d265929930e2
>    ("netfilter: nf_conncount: reduce unnecessary GC").
>    From Fernando Fernandez Mancera.
>  
> 5) In conncount, disable BH when performing garbage collection 
>    to consolidate existing behaviour in the conncount API, also
>    from Fernando.
>  
> 6) A matching packet with a confirmed conntrack invokes GC if
>    conncount reaches the limit in an attempt to release slots.
>    This allows the existing extensions to be used for real conntrack
>    counting, not just limiting new connections, from Fernando.
>  
> 7) Support for updating ct count objects in nf_tables, from Fernando.
>  
> 8) Extend nft_flowtables.sh selftest to send IPv6 TCP traffic,
>    from Lorenzo Bianconi.
>  
> 9) Fixes for UAPI kernel-doc documentation, from Randy Dunlap.
> 
> Please, pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-11-26
> 
> Thanks.

The AI review tool found a few possible issue on this PR:

https://netdev-ai.bots.linux.dev/ai-review.html?id=fd5a6706-c2f8-4cf2-a220-0c01492fdb90

I'm still digging the report, but I think that at least first item
reported (possibly wrong ifidx used in nf_flow_offload_ipv6_hook() by
patch "netfilter: flowtable: consolidate xmit path") makes sense.

I *think* that at least for that specific point it would be better to
follow-up on net (as opposed to a v3 and possibly miss the cycle), but
could you please have a look at that report, too?

Thanks,

Paolo

