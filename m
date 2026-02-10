Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF739319877
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2026 11:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770724183; cv=none; b=lasqMNmaFvfQ11gXbK1iZ9ANJ8n8D5+gDJZH3jaDyq4ITG2lqly15/7Fak5c3+uItMltuwFU7htmYqydNhehvIywEALWl6YomKZIjLUf5D03X/gIAKNHcW4VAk5eXpvF6D4Titp4Z+5UZae75zn6U3YyjZIcwYtT6mMRR3RCmI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770724183; c=relaxed/simple;
	bh=mrkNb3rbgK7YfxAuoJpWlRE33I+PEErjk6Htu3RLU80=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvTYpoQMTgxLWJElCyBlAzlJD+zMQ+vvVirqdSWEiVmT2cghnOtrbwLtzYFQLvsKhHID4i+3jnd7JMiBjffWh3zap5Dmbi9vlO5eGRZLzXBWNaPrROoVxfwChc1cERXxtnE4lwHEHto+hSSEDemFYA07b6pgjztv9BBdBKP7wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=X9kXVtlx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pWilL2Vu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X9kXVtlx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pWilL2Vu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770724181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hlzQkM6TK6bLR0L/ZsqhZZas3Rl/gzbWwjZgTp29r0s=;
	b=X9kXVtlxYTUV15fQpBlofRzfirsgJ48qE8HugJWzxZutM7Km3M+ENCl50QUu798JHjGPJ0
	bm3mZCPHdTdCA60ekphWP7ex5NHZyJWkesvocMkjlRknLcMtc6OlMvwDOotjOHGYcCIklO
	t7HMOgMo16+ErfJt5r1eYIr+2OezPHQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-MJSBmr1OPoqhlbxjUvLSdA-1; Tue, 10 Feb 2026 06:49:39 -0500
X-MC-Unique: MJSBmr1OPoqhlbxjUvLSdA-1
X-Mimecast-MFC-AGG-ID: MJSBmr1OPoqhlbxjUvLSdA_1770724179
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4831192e66aso49663015e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2026 03:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770724178; x=1771328978; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hlzQkM6TK6bLR0L/ZsqhZZas3Rl/gzbWwjZgTp29r0s=;
        b=pWilL2VuxE4NtQqryo73BE5T0oaGi1a5KO8gKIsRYhQBK56+esUFIH0X6hy59AkZzu
         kBhlW3pTyi+wqu0V6J8Z6bCDItrdUHnYg4+9rWsyibHuI/ysFzG7CK9PbOe498qvYZnP
         W9f5FHYwhbqqLkLvn6Q6vNWf8mfNMZt3U14bIlOUacWOuAp3wWZwmyk+lnBB8vsdo04s
         kSYJNiMK50RAMDba4C4XSdUxovkuhgXvfVpGwse+56znW4zAll2wJM/IDfVHPEdHRj7E
         ecIfTanBCIbCZ4DtGxXrKI3sBuhgmU2SsFXIS7aRzWZf8AdP8PRwbeqrDPNcvr8s8YbJ
         +vgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770724178; x=1771328978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hlzQkM6TK6bLR0L/ZsqhZZas3Rl/gzbWwjZgTp29r0s=;
        b=rXbqrJOQSCp3sz4FJ9+uc8fkV0sGiZHzXVYw9v60VSbl/t7bMjAPHVtFO6Y14lGebR
         cVWu6cOEN15su8UAZ1ITEF45b/9yG4QRGZFxeRV930kzx7+flCauiMXwuH4UT5HBkZVu
         H1yWaGLb9rOosF9cpgPaT760KjebKYyTnw7auM6NbreM7xJVkfin3HNYHA07lkIFIMP3
         tx2z/UMJVuI33LzdrNYSyx+LesDWshb/Il+QwUJrfX2uO4ombSWKtVAcUYRCfNS2p4vh
         zGXW8YOGqjkIqgn7C+6Sk+kNjvKYmfbF3+pGWM9ykeRwLMiTYmg1syTZL42l/MjeT1OF
         cYyw==
X-Forwarded-Encrypted: i=1; AJvYcCUoN+8odANGfwZ8BAeqfMvOLff2LXPMXkskEyBf8W647ElCI78bn7NZOKCJV4upbMahNPH8jaKt1154QT0Eak8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyXSrR7ZnKSwgRmOe1WPra4v4l3KCPC0OkI89Xzey0YI4umSZp
	rOI4MkJQCKNVZEZCXjLtYY0Ze+r5ooYklDMCnj/4P5lqcE7n9zPKtcGintRwUDglIDCqyZ7d/pP
	/jnfiQHLboaoMB0pjV+HV9PXXtLRo4gc80fc6RrplA3J3E5gZG9xMboIFPodRYC4WQeVnRau4BE
	vifg==
X-Gm-Gg: AZuq6aLuIXJ/DoMEd/IDoWSVTG/sn9wBwb/w8zGYmvXybyTTD+O4OHNbGeXrCN3XFhQ
	8rUe+XJ96XxURqvB1suSBbh9/BmgcMzp4zUkoHz1FZ8i4+Afsu+RUaqwMFy74A2Xtm6SuRbQVLF
	KNunVqm6uRguhkt89itI6zKRAPFlwkxqsFhRqTi5bYH7MjtTmUbmkirTNPrlnl8u21NTld8TKOi
	W1eOIt5ZVCdkq/iFu6h/KpRB4m36j04atIPFD0RElV1V4DAVntrmfdhtH0ndX6bD0ewKqFtQ7eu
	zmNfiXixhGSj8sogzbiCSLhcqOFgxWcV3cE+c+Mq97chycUYHYKV9+yGgjiz1FSu58gDlNclrzB
	1fZ6lfvS1l+5npInXUUtizbw=
X-Received: by 2002:a05:600c:8b12:b0:480:4be7:4f53 with SMTP id 5b1f17b1804b1-4835083392dmr29281085e9.31.1770724178300;
        Tue, 10 Feb 2026 03:49:38 -0800 (PST)
X-Received: by 2002:a05:600c:8b12:b0:480:4be7:4f53 with SMTP id 5b1f17b1804b1-4835083392dmr29280795e9.31.1770724177867;
        Tue, 10 Feb 2026 03:49:37 -0800 (PST)
Received: from [192.168.88.32] ([150.228.25.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4832040a3cesm190456925e9.3.2026.02.10.03.49.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 03:49:37 -0800 (PST)
Message-ID: <4d02b8fc-ac17-4fd7-a9dd-bff35c3719e4@redhat.com>
Date: Tue, 10 Feb 2026 12:49:33 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 net-next 11/11] netfilter: nft_set_rbtree: validate
 open interval overlap
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20260206153048.17570-1-fw@strlen.de>
 <20260206153048.17570-12-fw@strlen.de>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260206153048.17570-12-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/6/26 4:30 PM, Florian Westphal wrote:
> @@ -515,6 +553,12 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
>  	    nft_rbtree_interval_end(rbe_ge) && nft_rbtree_interval_end(new))
>  		return -ENOTEMPTY;
>  
> +	/* - start element overlaps an open interval but end element is new:
> +	 *   partial overlap, reported as -ENOEMPTY.

AI noticed a typo above, should be: -ENOTEMPTY.

Given the timeline, a repost will land into the next cycle. I guess it's
better to merge this as-is and eventually follow-up later.

/P

