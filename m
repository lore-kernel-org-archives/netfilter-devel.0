Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636438BF92
	for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774103127; cv=none; b=HiR0/S/Pi1trSF8Z6ceePL+dLzN+K/jNaUohSXK693RuYgNdpRLy6KuSm1LpF2/7FCaPVDcqfnvo/UWe+qZLkKfnnqA91PplGKLqEcQbxLx8meJiYQI6QZ9lEVFMqrpDxNw8AvlGn45gfld+yl1dzaJzaaYnj44osQMeLz0HkiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774103127; c=relaxed/simple;
	bh=ZMZeqy6sIbirITTWd/6iALnbgyRhiV8SSIgLeWcYrnU=;
	h=From:To:Cc:Subject:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Type:Date; b=Pqn/Uqtx2JaA7ls4LsEryl2WqbtdGLIIoSoiOZ5CkmHvsL3YbgT9fyfx114rOKXZezyEV+vgi3opy8+Y9kFQofBlf51CbzeEu88QiXG41ImdVlFHRCwY7yBmZGho8UFVN1AWbM5s7HG0FpL3gsFqCvzNgpOB3ynmYC+mTn79Xx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eO5D31Be; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X1xMsqlq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eO5D31Be";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X1xMsqlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774103125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KhKnnrmrFmgqQYmYoxQ0MJrYi8aeSThzMTI2uIhI0Ng=;
	b=eO5D31BeV9ZfS+5kjC5Kr/o+uGgC3mJ9jdX4ol7rEmlZvWsOyRLkQUUPkqizPt+wHUE4Un
	p5idqNGKxsHYEjbcTnebud1k1Chp0aWJmYyeJkgd/ZxhkDDBCoqNljBQSRsxOx92susVpo
	bLI3xyvQSiJPZuLXl+tUycToX/8crSY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-gxnQOAa0N0iF_pZ7iAfFNQ-1; Sat, 21 Mar 2026 10:25:23 -0400
X-MC-Unique: gxnQOAa0N0iF_pZ7iAfFNQ-1
X-Mimecast-MFC-AGG-ID: gxnQOAa0N0iF_pZ7iAfFNQ_1774103122
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso15086055e9.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Mar 2026 07:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774103122; x=1774707922; darn=vger.kernel.org;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KhKnnrmrFmgqQYmYoxQ0MJrYi8aeSThzMTI2uIhI0Ng=;
        b=X1xMsqlqK1UFuqfy2rLUfK7L60AoPCnIMPcNzMt4NN9sVqU2JUzxUbK59myFNep+u3
         GBqvEMcH6P5iwbfshSkvobMjq6rUXp8yNWdWxDdebyDfUaakFpx9ymLyHoF8Z5kpRi+V
         P+kESBVWBaCFR9G0kKm7Wh5JOwJEKK+yE0NCP4k6BpTvs1qmOwhPmGYfrzUeRN23a9w7
         84qoncpmLObjEE02H9vvxiLL0gGpWSTh2sUAHtfLH5OrlJM4mn5Cf30Sy/dEhObUvICS
         mMyyH6zcHqxlGrHOW1k+Hhas8EnfUVteUb0cTdTBVemxAzxmi09jF8tf4d7Pbi31NEqd
         eSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774103122; x=1774707922;
        h=date:content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KhKnnrmrFmgqQYmYoxQ0MJrYi8aeSThzMTI2uIhI0Ng=;
        b=HyO3xWVYNPBCsz3o2HduQEKzG4vl1HqObzMhxb2i2kYZZKs1+0dscLq8W7tgoLYWND
         UBhuXVpHdqem0U523AksXEFpFx4E4V1MWzrKXZLv3F14/XrX2p6Ai8i7jwNeu94lEVdv
         EE0fc+JWNqF3S/yKrLlK+NMsZS+YqpvoTsxNydQR8N7nQIfP3LDysjANkJ3A0vuY+ANV
         PWOsnGMkLIT490H/VwOzJS6UXvRewfDT5CeqP7VeefhrfyTW47Nj9eqiwawgaOP9kSF7
         wkKRSRko+kHAG0XkF46qEAy1Gs0/WpAICH778g1xnZ9+pfTWTJwxIS/b97NnHnETTuHE
         8uRg==
X-Gm-Message-State: AOJu0Yxi5uU9GVLJm5ib9MHAdCEM5J9F8x5xucX9XnparXWoe15ez/k7
	mmi7YDrJGu1mD8sSwLtuQLz4BJJf6Qy1dfd2y5ma1BsXjTVPNXc4Zk48lT7D+Vqqmgh3/+HR/2i
	D8Y2NyUPWxzTKAQUTluSEHb7m3apdV7fNHFfAyM1z4p7QLypcFMy2psmaA+XYoeJILiNVpA==
X-Gm-Gg: ATEYQzwlpxnPw3zHpNBzFJY55l1849LoWAWNYoa0snKrRcPD/SaNszC9/AUK2aIb5jq
	MhMT70amJt3GNmuMiCIWi3HYx722+3xVimzPsASpwwJELgr4ZAicWwmE+3didaCsNkjGLVq5ZzC
	/ACyAplQhOaWcLicWztf2ecn8GveC/QTrWbtDgT9F6uVvTwZ+w5JkW35f/ay1TXnD8GiS6i4MbU
	DvAZq8mwFLICD1Gck1X3FgTnsrUOZxra6iLfBLTTODT/LwWmsUQOk7IKvmG3/bQ2bToRd1flmgU
	QlHDfGGvmCOqaZAWAC2FviMWKQKmB0PsSLvvGUWoZjGfxoeBxLgJrhllBe4sYYERhf3buKBvh6w
	pfugZhU6wOyRu0GJdwyAg8vYK8Uwg2cmc
X-Received: by 2002:a05:600c:a4a:b0:485:5c6e:8a38 with SMTP id 5b1f17b1804b1-486fee0fbabmr84886805e9.17.1774103122329;
        Sat, 21 Mar 2026 07:25:22 -0700 (PDT)
X-Received: by 2002:a05:600c:a4a:b0:485:5c6e:8a38 with SMTP id 5b1f17b1804b1-486fee0fbabmr84886615e9.17.1774103121779;
        Sat, 21 Mar 2026 07:25:21 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fe7d6c54sm329358915e9.4.2026.03.21.07.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 07:25:21 -0700 (PDT)
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_set_pipapo_avx2: remove
 redundant loop in lookup_slow
Message-ID: <20260321152520.041dedb8@elisabeth>
In-Reply-To: <20260318134217.1596-1-fw@strlen.de>
References: <20260318134217.1596-1-fw@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Mar 2026 15:25:20 +0100 (CET)

On Wed, 18 Mar 2026 14:42:12 +0100
Florian Westphal <fw@strlen.de> wrote:

> nft_pipapo_avx2_lookup_slow will never be used in reality, because the
> common sizes are handled by avx2 optimized versions.
> 
> However, nft_pipapo_avx2_lookup_slow loops over the data just like the
> avx2 functions. BUT _slow doesn't need to do that:
>   pipapo_and_field_buckets_() + pipapo_refill() already handle
>   everyhing for us.

Ah, right, indeed.

> All other iterations boild down to 'x = x & x': Remove the loop.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

