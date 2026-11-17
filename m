Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794908456;
	b=mGkeXrAAzv0ue1zhrGwKMWJauraZpiRIzfB/VWgSEaL18myR3inD8tLwiIwyZTHjDnGq
	 M0n/bAnhB9d8cdawgx0xf3Ca92iIcrNtuq8gOB4gH1KmCO6fWkHJEDloNEzNyhE42C6ud
	 35XzUGbiK3W1EaHxVrXGQ4+0iOQ7zoNlwcG82OVqYPa29KDz1LJi3hAobBiivPxQK1o6F
	 eruY7ue7WHZVuakt2kBsFs7rS23N+rd5M8vfo+OPBYtkzCpBDmQ+c2p5vTgDEni4ZWKtM
	 oWqnTBMBxjLfhvEzdONYzqWiuRuQmGFFHa/LnU4WFKH7Taj48yibtVNYiQVXfGFEueQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794908456;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=aIlny92Oczs7zbQwn8DM7qSzZOMaavkMmiwpKTUsCbw=;
	b=GUXctOza0c2pizgGWpKU+i2IhC446YAdZqwQjHHAeQW3pplT/9d9afAQPQgRxgiPlUBs
	 0wCvTqyh80y1I/QsFzEKwRjkovYP5xbVKpQodkLVFrspjB8upesBZmW6t7eEzZFI224px
	 w2kwRk1o9vkDZOsCWexRKoW5ume5U94NZBQmoHqrsXhStspZBjKwAhL2i+RNJ8JR9pSZG
	 DPzuQaochdAQqsqnja4I95h8jJOQp4U3cma9pA+BNX9mDPtiAzfhXP3BhoFGXqsxpMV2q
	 qrqUklv9DPlIDP4YOLoblIIgFUmrsQFOY4jluJv07SK6qQMiv9wZTLxCOGhotod6J6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DIAZ52Xz;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Z83MLS9U;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9FA606A329
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 09:40:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F9FA606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=DIAZ52Xz;
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Z83MLS9U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794908454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aIlny92Oczs7zbQwn8DM7qSzZOMaavkMmiwpKTUsCbw=;
	b=DIAZ52XzS2/IgFZZVwu0TyQo+Lru71Iez4Foyo/aW6MTIP2phcDYBbC5gOJI2uyFk1ntGS
	8eDV2y2DFiQhcpYQysaebakBpmqneHLc9qEwYVm9OZIAgOw//7jU3/mahW0t46r1GD1+3h
	VTfkST8EyWVtXavKC3bRH1rMEPzuVbY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-ZXUG3PSIOciNjTzWK3aPsw-1; Tue, 17 Nov 2026 04:40:51 -0500
X-MC-Unique: ZXUG3PSIOciNjTzWK3aPsw-1
X-Mimecast-MFC-AGG-ID: ZXUG3PSIOciNjTzWK3aPsw_1794908451
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4b0a307487aso20787415e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 01:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1794908451; x=1795513251; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aIlny92Oczs7zbQwn8DM7qSzZOMaavkMmiwpKTUsCbw=;
        b=Z83MLS9USuR77z6LKE+onks878LLCBYQ5WjjINDuRVTAqzi3Z9hI8APk++16zIhIAw
         ohabGJsYRHnuzI8c3RdSTHu0yzMr/04qWVVqDC+g+11KGXYnbdTTd3TeSUEsYOYIgUlS
         soi9Gq+8rajNmMTNIWoZ/uBN2pmNKuAd+2BHTMXsqpXW99URiC/i3J6reWDRjmSw7aZ4
         iYgBOHSjDYeWI00wH3rYCJZa8pUZugL+F1WXZnSICpJTZ3C3IIZK2t8QWye8f758e3Hn
         wKVc/Tnai4t3i/8X04A4JdshU1C5LRvMZbSKJTBUgVZyM6zNkNkzD0l3xnqvK8cFBl8J
         EKxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794908451; x=1795513251;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aIlny92Oczs7zbQwn8DM7qSzZOMaavkMmiwpKTUsCbw=;
        b=hSiAAQuK3FmNF/RsX30LodX2c9myuasJ9STt2olAP2AmLxmHh6CP1ctxUvmn5webdj
         66J0S5AWpwnYGeyrQjvqYyXVyqlfDUN9a3JIqQrCCYKsazExoAKROB8To2shexiUdMOB
         U7T/1DkMCJb4O0GxHDy6lAynC8ZmqDTwX+HVyRa6SaanzD1f0KIU43xAZrHfBTtUqlHP
         Z3WaahPx18TpnBrpmBAA4jItrUOrkz28jj7xHfuM2Wsen2qDPF88rkLhmbyNKnSnn7E2
         nWup9L8oSX4Lvv1dQWigh6ohyzC2+wvHBBcxNHG7WlVE5Id38bn2fMe4YMmRZCk8Bli0
         JfXw==
X-Gm-Message-State: APuU4Z/3k4MiBnZuayr9opJBVLzB03A63srkUe9PyH64bGk1rUuPYwIA
	KpZPYYxIajYJUxfIOQv7elXqFT0h2Y1/i40VDXjD40S9Oa3ZtGHlozELPfJBdnZPJVp6GT9qjyJ
	LLqu1wy4oW2j85Fh2KySgsm48qk7YRTK7/vknPdw2ZAtwIYeon1SQPB048gmfDn24F/rwRw==
X-Gm-Gg: AYBFou1GWMU55p9fQ84Ko9xzNcnw3jnmJcXa53l/mFVYwn6ORqZJtO3FGfcqriPDMKV
	N3Isc0urJz8wPlcDchLsNg1Sm1aFLEx/9oyXpNVWEEtzpcYKvS2GgYB0V5bwaeNTOiys71FvjH+
	ERd6OBSQdhlyYC7Nn0qFjhj5XnLMz7ofJk+Bt4w7cZJlQqh9QfxqrQVNCVohYCPVAHF6P8Yyhzy
	JSXfSHRme/eQgYOnENvATeNcBqiO7BAJ28zaVUWzvHEar/X2i5u6rae+p3Nj0AWhU30ZvFFBPLZ
	GzcfgS1cb0TLaeyy1A5rHUyfGsn3LMNYVBt6zrtZQ7CeG36e6Vy78K9sYVLlJTEQe7pAdYNymuz
	xstLly8MfmBZ0YEioWCPJR09ZqGg5Dhlt2tSPv+p3Hh0rVVJHL5Pk8bgnYTMX2eZ8ETOtnT3mjC
	ZrgJVfmP+hMHo3nRoyGTnZt334FekvfEH+BhbYKGiiERrT
X-Received: by 2002:a05:600c:1daa:b0:4ba:2bfc:c8ab with SMTP id 5b1f17b1804b1-4bb55a4801bmr284210005e9.15.1794908450711;
        Tue, 17 Nov 2026 01:40:50 -0800 (PST)
X-Received: by 2002:a05:600c:1daa:b0:4ba:2bfc:c8ab with SMTP id 5b1f17b1804b1-4bb55a4801bmr284209625e9.15.1794908450299;
        Tue, 17 Nov 2026 01:40:50 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb571f6a40sm138644185e9.2.2026.11.17.01.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 01:40:49 -0800 (PST)
Message-ID: <9ead5297-c706-49d7-8226-99955d81ccae@redhat.com>
Date: Tue, 17 Nov 2026 10:40:48 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 01/13] netfilter: flowtable: do not hw offload
 flows in teardown state
To: netdev-bot+sashiko@kernel.org, pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@kernel.org,
 horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261116001612.2806263-2-pablo@netfilter.org>
 <179487496421.3136.13242797618262399074@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <179487496421.3136.13242797618262399074@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/17/26 01:22, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 0 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] The fix is incomplete.
I understand from discussion on v1 that the above is understood and will be
addressed as follow-up. The same for the mid issues in patch 2/13 and 3/13.
@Pablo can you please confirm the above?

Thanks!

Paolo

