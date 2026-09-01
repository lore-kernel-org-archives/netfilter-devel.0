Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62CE469855
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Sep 2026 07:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788247901; cv=none; b=rY4jrIRRNvC4DgNt7bOQJok2uGgHRC64/d/4cQ8EOWPtC+3eL8zE6Eh3dEpeCdXfxRu/O+FtDecr6du1gzx191ZXUqdd/1jYin8u+lp1uDiRSiZ8Ka1qjgyFj7q0cMHkUgqDSo0aYvJfx9a5I/CZmYzDKo05TzRU6BB7VVlBEMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788247901; c=relaxed/simple;
	bh=zGhJ9HaYyZ7K+ijAn1Ufy6dOppFjBPbx8iBoOPASPKI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K93rkD+g30pz3i1ri00ik8sBZmmCwB5nzKvm3or/Lw+jYm6ek800tRTpfXHk/LGIi3Sk0fIUpWbkJXzoWQPsMapQTit1tdZtO4MQBCyH58/dOlFCyEEtV/Q+llxNkgRmvCcViiU+ZoyLau2u/ruUK/UxlEkYvgb3X1SjHmubNBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q1Wa+7GT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=d3+2Pgsu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q1Wa+7GT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="d3+2Pgsu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788247898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=996Do7cli1wrzMhcoRVI4Dpnoxul8kFICpQpjRm0D38=;
	b=Q1Wa+7GTKlMbY30qBPm1Urd7SVdZkxruKDfLKXKsSSGFaYGdYBpJOB9LlDpFWysPVLCHOu
	xRGpEQIa9zSKPC/7diSSpizmsoJUapR2jPC+a0w0q7h6uk9xoYLWP+eTKSzIDx6T/Ik74I
	8pzGLHm2VxZfsyDEtZaZkYhRFkuPuK0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-676-L0QEuMtxN2aSFPMkjf67yw-1; Tue, 01 Sept 2026 03:31:37 -0400
X-MC-Unique: L0QEuMtxN2aSFPMkjf67yw-1
X-Mimecast-MFC-AGG-ID: L0QEuMtxN2aSFPMkjf67yw_1788247896
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4955fd77c18so23857355e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Sep 2026 00:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1788247896; x=1788852696; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=996Do7cli1wrzMhcoRVI4Dpnoxul8kFICpQpjRm0D38=;
        b=d3+2Pgsu5au1M4JiH/POPF6OA8Xseak3F9Vd33GIWXM7MNyI/2ipxh2azm35l012Z5
         NH0gIzHi+YbfdaLGv1xNNa073tzwlsSfmnEcVUpVu0vNgneS22il0i4khfnpoFOvzEdD
         6Ik2n5KBqpI7QhUq7o7nopBh4r7zfJ8MbxQ33wgniwVdJCcKHRC0wHwTIO6ejJhGprhz
         qT/OxUB2fi0WFsy7Sn6HBEqhHrb07iKrKqFeyoM4qUla8rhYkMyPgFExWZi3mCkijvL6
         yIuO7d2czFx5Z9BK28Eca0GKvS6uiM2hg2zFm6AzAfyzHvhgeep/IAc3+LOGf2sxgXbc
         BD7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788247896; x=1788852696;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=996Do7cli1wrzMhcoRVI4Dpnoxul8kFICpQpjRm0D38=;
        b=Ur9ZYaJ5yyMVLZI+UDu/GBevy6PUXvVNrsZachzSKSf3uEsqD3wBWAdsAGxl+4dmzF
         4q8aXDHMs5XG3SigI/w4L3gS5KxLO1w7W8oimrIdZpiUaePyh3S7Nw9v42vD7MBPE7Q5
         r6q05+RdG9QMuFkZc21M0y+1es7oCi1Km2PL8cGj4EHW+0zyvl8RrITwKqggFrnpdisM
         2mRfKjokvGYYLkKI6ntIjPlsAnVYVu/upnHaIxOn+V/T3DYPWOL5TsOzewXHBhIdP9cS
         W1jH6Xy798m5ILxcEfaKfVLZc3k/oDfLik79hyn4XDhT4bA4aelTWXAc2Q/TzC1E/WD6
         QqpQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro/aLvuzLkgOgHl7m36iZ+yhdaX/0ILFVPyhTcRtjFKhgn5CD+ItBs+1RQILVc0J6mHIlx0/y44WcuJ2RHQ7Pg=@vger.kernel.org
X-Gm-Message-State: AFuF++nMwnXRhF2mmd/J/WXKhgZkWNNuAOXQnSYitD8uxwhLBmEuJNtv
	EHJAPWXeqGwLsNqnkH0mLYMCIKBXvf6aHVULoL2tdKP5pULOPuHKWeYjB+sQKzE2Rutev82T8H4
	Ex9OAAILfS/eCjTg5i0lBZy8dalR/1J39VNZOc42bBbdRhfyALVwRWYwH9VxD14PSBege1Q==
X-Gm-Gg: AR+sD126bXmGwqYqNBTV6qW7EOBIrStPAKFkmVDFS09DKDl+pUlFu76Tfw07x9E62Ve
	gUQupkzAqadENEFi1PDx67rYIqXzUoNSvxCEdeJdyytm5whya7v5xHmCDWuOByMTETB2wuObBe7
	yTp/mpo3+Xr6Kh5z0sClfXu/9u8kqi1I1nJV4UmmQyadUnr0kdT1TW/B1wq/uUNVgPxjA8IqeY2
	ncDhwM4h1IOLF6UDg1u6dgKZnuj1LzX2QTRBnY2a0lBZxGGSTHdR3Lag17gTjHr2IVg+xzjwIJb
	fFwAT6QAijFjyJ/KpmDl06t48ekwYsHHv5RB6VCv39W6bO9DMEqdB6pU05/wsC5Sp9/tT8fAWRo
	IgulHkCHBrzQw6l32VP7vYy18LDJBC172E+mFjwnXpi/5iUoc0EEf+5RzIFNew2x0LRjsShLRlg
	==
X-Received: by 2002:a05:600c:a114:b0:49b:9438:7785 with SMTP id 5b1f17b1804b1-49cdc429f02mr92591605e9.4.1788247892935;
        Tue, 01 Sep 2026 00:31:32 -0700 (PDT)
X-Received: by 2002:a05:600c:a114:b0:49b:9438:7785 with SMTP id 5b1f17b1804b1-49cdc429f02mr92579265e9.4.1788247886584;
        Tue, 01 Sep 2026 00:31:26 -0700 (PDT)
Received: from [192.168.188.103] (ip245-45-231-195.pool-bba.aruba.it. [195.231.45.245])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce10f08sm49011395e9.7.2026.09.01.00.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 00:31:25 -0700 (PDT)
Message-ID: <3b647dc9-6653-4a75-b0f9-d934337ac2ef@redhat.com>
Date: Tue, 1 Sep 2026 09:31:24 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ANNOUNCE] A Syzbot-style Platform for Verifying and Fixing
 LLM-reported Bugs
To: Guenter Roeck <linux@roeck-us.net>, Yuan Tan <yuantan098@gmail.com>,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org,
 frankw@nebusec.ai, jhs@mojatatu.com, ksummit@lists.linux.dev,
 kuba@kernel.org, kerneljasonxing@gmail.com, roman.gushchin@linux.dev,
 jgg@nvidia.com, mchehab+huawei@kernel.org, torvalds@linux-foundation.org,
 ben.copeland@linaro.org, gregkh@linuxfoundation.org
References: <20260830115546.3942129-1-yuantan098@gmail.com>
 <98d4603b-0559-46ea-8b76-1f0245b3b266@roeck-us.net>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <98d4603b-0559-46ea-8b76-1f0245b3b266@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/31/26 9:08 PM, Guenter Roeck wrote:
> On 8/30/26 04:55, Yuan Tan wrote:
>> LLM-powered tools such as Sashiko and Claskiko produce a significant number
> 
> Is "Claskiko" misspelled ? I don't find a reference to it.
Clashiko is the "informal" name for the sashiko instance running on the
networking subsystem CI. Since it's ongoing under constant improvements
and changes due to a lot of effort from Jakub, there is no formal
documentation on it.

/P

