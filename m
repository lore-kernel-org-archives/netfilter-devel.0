Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53BC1E571E
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 10:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507784; cv=none; b=r4E/FOrKqv0Rr6I1pTTvFEb8S8HJMvRhGLevD6VW3WRHYNZKNVV00xG+dXvKRPs9svqayG8e2IbNMYxHhC9+3dJN3qdwryydcQVhwTClb9q6lJkbNWUiiRG7N3zqnq42z6UI8lcQUIQ/YghmCfr6zrnaOR6aecd4Ee5fzA2eQMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507784; c=relaxed/simple;
	bh=f25VOJ4jl4EZ6U5b3xJzeqopBjiOxy3HcpyoNBkD144=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=ccXLf+VUNF6EPKnivn4hwZlCyS9kplcyOnADYqdB4Xqoye9ommZ7LoL2f9bchqMGeYzM0/AqN3pAl08lX28zhFbtWy6PaQed1l6kaYVTWshoVIRJ4WKREZA29EjV//j0PTP2oBjYirP8+Yrk9S0cdd4u5tzDngd4GuwduwHQ49Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H0jSKisC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H0jSKisC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729507781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zl8NkxhsjOVprDoWW2Qzq8vxlGshkjvvdBctdUvmGdo=;
	b=H0jSKisC9yyRt7OQjMywdI98DZofpkSElVQYwVeVkKJFZbQtWW9MG8tnIYCGgiCsjdO+3/
	RXDYgtHIqmJQz4OZRqeE8wM3xsSqeTSbOJhMdayhZyvhyD3iTIakqgHVRSfO3W7apaGwkM
	ERAUr9rHEeFAIDnfa4KRqhwf8nHbgGQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-d7b_epg-ORWJ-79BCyuNwA-1; Mon, 21 Oct 2024 06:49:39 -0400
X-MC-Unique: d7b_epg-ORWJ-79BCyuNwA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4315afcae6cso22706495e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 03:49:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729507778; x=1730112578;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zl8NkxhsjOVprDoWW2Qzq8vxlGshkjvvdBctdUvmGdo=;
        b=c/CkbYFChCOQ4qNc5Yz6Ner2vb3q2oqFLRhfTFv/aDrQcRkKVWPo9zzJqhLSDO5Z1M
         TfUPODmog76GiXvDcyn/FJolumbLhvna6/5G89eYeOu1gjCTBSA3KV2Im9uQm9boxD4n
         oRmU3L8FPxGcx5k6Qa7OKWVfwEYyYAG03xS0LXboZetJ6yaShodkCr/+waaOG5a3/xj1
         rJPyqKyiFJbbO6pww930QC2oqMuWAJ+aT/6Be/dH6/77q2zf4mXepOUlkUVmTECNqk9e
         jCQawaNw9KR3XW4KDQKBJoWL/e8Wi2zjGOZweym1n6Qx/tthr3u6mlsrEmKgUz7atzih
         vCTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKZvQnhTwWR4tU2BJLEjj5VoyqQ3RBd+yYLFz1ITehenlJXe9g7Nv/WxuEvXe33OJ04asjU495ohZInVPCLvg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8lvr568/ur8+yiSm/P3ZGdmk3Aw9w+WQgMk4+YRF3bJ2VxWAU
	JAc4F0lh3BEaD44WvNhcZOPq5eJgh3cvmO07l418BQmMT6ZlLSARO+gSmYm6VAUUceSpgJ2zZHz
	0Q/D+vXC5Ur1RwIKvJNV3vrLwn8BdwKm/0zSOIrStQmLYQvVak7OTGYYfBYcrFuhttQ==
X-Received: by 2002:a05:600c:1d27:b0:431:44aa:ee2c with SMTP id 5b1f17b1804b1-4316163bb0bmr68211885e9.9.1729507778226;
        Mon, 21 Oct 2024 03:49:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPmc6ba7ssou9GTOtZg5r3s7a95KOOzPAX+9aC1kAiYD6uc9w3/zs/WO4t3sdTFuEXumAz/A==
X-Received: by 2002:a05:600c:1d27:b0:431:44aa:ee2c with SMTP id 5b1f17b1804b1-4316163bb0bmr68211595e9.9.1729507777852;
        Mon, 21 Oct 2024 03:49:37 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:1b73:a910::f71? ([2a0d:3344:1b73:a910::f71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4316f5c2cb8sm53805945e9.31.2024.10.21.03.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 03:49:37 -0700 (PDT)
Message-ID: <f792a828-8a61-4a14-bef8-ff318b5a4ac3@redhat.com>
Date: Mon, 21 Oct 2024 12:49:35 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 07/10] net: ip: make ip_route_input_noref()
 return drop reasons
From: Paolo Abeni <pabeni@redhat.com>
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 dsahern@kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
 roopa@nvidia.com, razor@blackwall.org, gnault@redhat.com,
 bigeasy@linutronix.de, idosch@nvidia.com, ast@kernel.org,
 dongml2@chinatelecom.cn, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, bpf@vger.kernel.org
References: <20241015140800.159466-1-dongml2@chinatelecom.cn>
 <20241015140800.159466-8-dongml2@chinatelecom.cn>
 <c6e8f053-32bb-4ebd-871b-af416d0b0531@redhat.com>
Content-Language: en-US
In-Reply-To: <c6e8f053-32bb-4ebd-871b-af416d0b0531@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/21/24 12:44, Paolo Abeni wrote:
> On 10/15/24 16:07, Menglong Dong wrote:
>> diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
>> index e0ca24a58810..a4652f2a103a 100644
>> --- a/net/core/lwt_bpf.c
>> +++ b/net/core/lwt_bpf.c
>> @@ -98,6 +98,7 @@ static int bpf_lwt_input_reroute(struct sk_buff *skb)
>>  		skb_dst_drop(skb);
>>  		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
>>  					   ip4h_dscp(iph), dev);
>> +		err = err ? -EINVAL : 0;
> 
> Please introduce and use a drop_reason variable here instead of 'err',
> to make it clear the type conversion.

Or even better, collapse the 2 statements:

		err = ip_route_input_noref(skb, iph->daddr, iph->saddr,
				   ip4h_dscp(iph), dev) ? -EINVAL : 0;

There are other places which could use a similar changes.

Thanks,

Paolo

