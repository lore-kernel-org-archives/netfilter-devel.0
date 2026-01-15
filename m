Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744D35FF44
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768472586; cv=none; b=Y8lm5X0D2itPediOvgIM6BK2rVSqAZCDbAwSSWSlb0KBAAnL8LvZ7N0iAJ29FVLw57eep1air7rO8af9E/PxW+WiLxZboVxtduqskTYs7AWtiTdwqx2DKxB6jvflClP9s8dsMLvVKKEsRjQRjbCI/RZSZf4Tp8l8qiF5LB98xOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768472586; c=relaxed/simple;
	bh=KY40kM638NlIdHs/JAxVo5KCQ/kQSuzRNhfaex8x0KU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gi3SBBgqmLOrlqI6dx0gpnDOr4EPd02iK1vNH+I9EA5G0G76C6Qe0Xje+dx7CHFvc4iAVK3M/732E23RVsmVOqbXei4TqepybEGxU/aG4amsCBEwACm+Gtwjh+qv2K1AaRIvb5p0CVkAQZKeEGVynFhu79PjtCHKAJz8qy31xdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BmdePVnn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=WzDb6dsy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmdePVnn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="WzDb6dsy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768472583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KY40kM638NlIdHs/JAxVo5KCQ/kQSuzRNhfaex8x0KU=;
	b=BmdePVnnWcTdWpq1NgKtmEq2O5SiUXxZR3g4SqcSYtsPfMEFHXjJyBrRsnhkWMEmlHiune
	BKadU3k9muUdHsuKkinKWJDMh8MlM53YuVl/FFVsiDTbD+mE/bvo8RV3kZadsXBIuqmPcv
	ygbysDlC2izknn3NOIPv8ZrLGn5P7Ic=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-4SXljocSMQWhzzgTwU7BhQ-1; Thu, 15 Jan 2026 05:23:02 -0500
X-MC-Unique: 4SXljocSMQWhzzgTwU7BhQ-1
X-Mimecast-MFC-AGG-ID: 4SXljocSMQWhzzgTwU7BhQ_1768472581
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fe16b481so378557f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Jan 2026 02:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768472581; x=1769077381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KY40kM638NlIdHs/JAxVo5KCQ/kQSuzRNhfaex8x0KU=;
        b=WzDb6dsyq9aQHb6wZj9KII0p3iq526bBqrAAJKyXqSTBDBaZDyuHA9t1Zg9egTxWO7
         Bagd9h3PNFr2BCpenz6UVYiRSd4z5Otxeh5VZrKNw7oo05tAGT6bbBtpW4Wjus2xQHxY
         omKBGyOasJX2B/CcltqTBGDKhldxThD29ee4i2Y9Oiu2FdRYtkNe9SEPdj86Phse4Gxw
         Y/jXYR+IaZ12+CTTMyR/cXCI4h+DdlODW0IyiAKEdvnnvdxUpRejDT9A3iT0dsWSxpEe
         sDzP7PqOd3mxSeCSlGsef/OUAV2eiD+LadYpKzprDvn1ER+zPNB9puFR0Ju02lwuTEex
         pv9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768472581; x=1769077381;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KY40kM638NlIdHs/JAxVo5KCQ/kQSuzRNhfaex8x0KU=;
        b=TC/duU/SOxtyfZ3sapBSLGbfP511sGlM0hhKPZKxEYq8du3cMZaNlBP3er6cdYmso9
         bSaJJXXsaIu6b/PTjqcqIGWMfT97KPbQNlfL6yYI7u0y4MhZOVyv3UQ5KmWTzOy6Vrwm
         7JeKKlUOVNgc04dY4aJpYuqIzpi4tlm0s+LqBApMkBkJE9UsTfsvbQMSl6Sr2SNSQuzn
         h3/A6VbKef+XJ+X7b6EUViGjnqMSwSQU7wsRjkqnULHNfsGpOomof+RPlLVYqgjjepGh
         +4whkvEv3kkY+3O9Aw0Ewnbr52iJXstRvtf9nPuLCwf2ae+dmJCaWj9fDPaH2Xn7owKr
         YnIA==
X-Forwarded-Encrypted: i=1; AJvYcCWA1tPQoHYhTvycBUljwcA51v7PhLXRzFKo98CwwmsNXpJQL9KjT7qzDgv/gy6BNEAa2LAuP4rVvnABB5g3+KY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWMcxDrMaU/JlpID7/o+rIN3mTfayTH8gRQimhCu22Xd2/QDFL
	gIpojcPRPCvuQ6TVPj8hPmVgDLy/BznMSdKYGROyJGBoYAm9q3NA2mPlPK6K/H3BvfIjo7EQdtB
	c7eR+TPK/CXQrC7cVryJSJltF3kSNOMMXvTpsQGZqT8HlqU7B4Qgb0AgzxbZDoqjAlOFB2g==
X-Gm-Gg: AY/fxX5l9MnUXEolDdDAemGXAoeaTcGdRYPsCvKd/ZhDX/NIguc5PbM9WRY+EA8l/rf
	FnZ5F5WZJB3KfoYYQdFrDAhu/85oMNVUMhmtSdBenXffR7yzELZVIgdzzdpRoIAmHB1EdDQk0uD
	V74vJUe9DFYsh1n7j5FlNGhZqCrYwPZDz9K4ADZeHnFRGvNOObxRR7Gk3J4BY1/0m0jql3TePIX
	iH0rypbZ5XeLgJUfaBH2GouEFuzseUCiQL3k0WpM/Qze7m4gyS3aezRwI+7ljlJofAak+J69wXL
	6wrfK8JNhnSwI5eqiqiazmqa3rlc3ftoQ3Y04b8AA8dhbPfgjtyKpDFaqGG4zfk2jwzf4eGQNnI
	0QL2A+fZDQ6kUnA==
X-Received: by 2002:a5d:588d:0:b0:432:851d:35ef with SMTP id ffacd0b85a97d-4342c547dbamr7818779f8f.42.1768472581013;
        Thu, 15 Jan 2026 02:23:01 -0800 (PST)
X-Received: by 2002:a5d:588d:0:b0:432:851d:35ef with SMTP id ffacd0b85a97d-4342c547dbamr7818742f8f.42.1768472580610;
        Thu, 15 Jan 2026 02:23:00 -0800 (PST)
Received: from [192.168.88.32] ([212.105.153.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af6fca86sm5029391f8f.43.2026.01.15.02.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 02:23:00 -0800 (PST)
Message-ID: <d42f0c80-e289-4e0f-8608-10580d315fd9@redhat.com>
Date: Thu, 15 Jan 2026 11:22:57 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
To: Jamal Hadi Salim <jhs@mojatatu.com>, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 victor@mojatatu.com, dcaratti@redhat.com, lariel@nvidia.com,
 daniel@iogearbox.net, pablo@netfilter.org, kadlec@netfilter.org,
 fw@strlen.de, phil@nwl.cc, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, zyc199902@zohomail.cn, lrGerlinde@mailfence.com,
 jschung2@proton.me
References: <20260111163947.811248-1-jhs@mojatatu.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260111163947.811248-1-jhs@mojatatu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/11/26 5:39 PM, Jamal Hadi Salim wrote:
> We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we puti
> together those bits. Patches #2 and patch #5 use these bits.
> I added Fixes tags to patch #1 in case it is useful for backporting.
> Patch #3 and #4 revert William's earlier netem commits. Patch #6 introduces
> tdc test cases.

Generally speaking I think that a more self-encapsulated solution should
be preferable.

I [mis?]understand that your main concern with Cong's series is the
possible parent qlen corruption in case of duplication and the last
iteration of such series includes a self-test for that, is there
anything missing there?

The new sk_buff field looks a bit controversial. Adding such field
opens/implies using it for other/all loop detection; a 2 bits counter
will not be enough for that, and the struct sk_buff will increase for
typical build otherwise.

FTR I don't think that sk_buff the size increase for minimal config is
very relevant, as most/all of the binary layout optimization and not
thought for such build.

/P

