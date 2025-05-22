Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D2C2770B
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 14:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747923014; cv=none; b=IgRDublK4CZyBRxRbdRG+ZJIiRdm1gBMfFs/ST0fWKGjYuNXyzeVSnZunp/4oSkhJLTRl4o7JVvl7wIygxLLKP1FzjskEpKCSZXd3hDZTSHDiD/RaYEq1yXQGAo2rzOUSwidkuSB/eWGrIIcVMvU1Yaa+mBI+LUKbjl9ZqOiIyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747923014; c=relaxed/simple;
	bh=D9jT123o/rgdvMENfKGZme/iraOXX3qYEZeNYWJeeGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lWR1WuEvq94vInPkudXsjYCZYGBdp3N5RqTbO5OSLABtp4vlc05UzMioltnlXwAdr8qtRGvA8BNvlgyqq6bKLpcImR2jNDuryhHBc1bb2m728+NNOniB7AhFToK9iBfCF4aAyxqZ0WILVo8lONKmkWvNjguljwzJq5BYnHh0grY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FIzo6t0e; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FIzo6t0e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747923012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dEp3t9donGMcPjRNVFwKRlkntQpcJvUEeFhsZVRvNl4=;
	b=FIzo6t0e8hYvR/H02mcTAAQkHdVh5k772MzoQHOV306xvOU4ZM4K5nU+bYsh/hAPuG3DwT
	6po1stYOVV0FvYWF59Wwgwbx+jg4GP2xMQ3sW50P00r0ffaSPSpcQeDaQROz/YezYrhQa4
	tn66dpjSl73IUHOToZHORBUo8CBJBg0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-133-4VJg1PxvPSyZiSQ_p_YdNA-1; Thu, 22 May 2025 10:10:10 -0400
X-MC-Unique: 4VJg1PxvPSyZiSQ_p_YdNA-1
X-Mimecast-MFC-AGG-ID: 4VJg1PxvPSyZiSQ_p_YdNA_1747923009
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-44a3b5996d2so4535435e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 07:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747923009; x=1748527809;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dEp3t9donGMcPjRNVFwKRlkntQpcJvUEeFhsZVRvNl4=;
        b=odX7qzTWe+WpkDi99i+MiOe8B7j5D6xYFIB4TRFKIaWXKVNRzCxS3iUgEKtkEn0Pwd
         c2572Oaa8DsjYy1PcenE7oAWurdSfrnWagh+UiQp0K1QLmq1KQoG6Yzqo1fkaQz4IwfH
         8wBdxIfQTqOx+kquthzSPHv3BceLIPsSMmYu05iuY8ibzXhoaSwzhZtl5moRK5FR8gXR
         PQJ0yFLkI/CBIvF6bRCZzUo8x2zGUT52hBxL4FvqDTlKLR852sXm3UdaLg63oVLKiLpQ
         YrzdeDqdk6uIQJXVsUV5RT7pYPNcqMngi1Ay7rJ8igPOvIotIbDOxUs7StIuWtn09GUz
         Bopg==
X-Forwarded-Encrypted: i=1; AJvYcCWdSoQ920Y1oQL4M/AmoA7zG8WJQNAecTVL9gN+LpEq+ynZHbT6g885oELCb3RqQ1I/toqFzzjR+fSkBRGDYV4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNChxZ8ezv6zpxi/YeOttwSvmzKFExVZLSbp/nfIVVJDEmdLBH
	OtLR4+8mg643628B/IyIxkQOelAttykyl29E7LiB6OrP8xobe/mCbrtLPy/l/2bysnZWsVhrO3g
	LW+Nhkm29N9eK22SrpKx2rFgv3NcUtzRC1A8uzJYS/DDkKBnf79tsQsya/OaS6KTb+R5uVqDuer
	597ceq
X-Gm-Gg: ASbGnctxmyY1cKPRHzTfNzjKJBxO51/U5gSkpN2udJbuPkFDg+iHiXvSoE5W+cLVMhe
	bUdwlfbKav+L4CcP8Y9ZbHUCqFJTdQ5a2JPVS83FMxsGkB5LgGBow3FrQSv1FIchju8nlrb/It+
	wXGHNf5xdfyv/u2Am/ainadYB0O/U+HbIOfxf0m3vsUF5gXDGNqBPMoijY+gjnP0V31v+9f6HUL
	8BG3LrVKwU5h/GUB8X1gcwWjF8fj9HPlTkKWwB+VR5N9JbBO/3iix5uaUFb6mPkvu4SP61672Dp
	slzm2KfNM6TZp410GaQ=
X-Received: by 2002:a05:600c:1d88:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-442fd64dfbfmr254182675e9.19.1747923009258;
        Thu, 22 May 2025 07:10:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF5M59KObi5W8JNqVE07ZLmiBRpyTYe9HIISKhG9Pya++Nlbo01Uat2vr+m/UJdQlRyHJj9LQ==
X-Received: by 2002:a05:600c:1d88:b0:43c:fffc:786c with SMTP id 5b1f17b1804b1-442fd64dfbfmr254182175e9.19.1747923008776;
        Thu, 22 May 2025 07:10:08 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:247a:1010::f39? ([2a0d:3344:247a:1010::f39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f23c07bfsm107580585e9.23.2025.05.22.07.10.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 07:10:08 -0700 (PDT)
Message-ID: <649e3d9a-48b4-4660-99c5-1609e3cd06cf@redhat.com>
Date: Thu, 22 May 2025 16:10:06 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: nft_queues.sh failures
To: Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <584524ef-9fd7-4326-9f1b-693ca62c5692@redhat.com>
 <20250522065335.1cc26362@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250522065335.1cc26362@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/22/25 3:53 PM, Jakub Kicinski wrote:
> On Thu, 22 May 2025 12:09:01 +0200 Paolo Abeni wrote:
>> Recently the nipa CI infra went through some tuning, and the mentioned
>> self-test now often fails.
>>
>> As I could not find any applied or pending relevant change, I have a
>> vague suspect that the timeout applied to the server command now
>> triggers due to different timing. Could you please have a look?
> 
> Oh, I was just staring at:
> https://lore.kernel.org/all/20250522031835.4395-1-shiming.cheng@mediatek.com/
> do you think it's not that?

It's not obvious to me. The failing test case is:

tcp via loopback and re-queueing

There should be no S/W segmentation there, as the loopback interface
exposes TSO.

@Florian, I'm sorry I should have mentioned explicitly the failing test
before. Sample failures:

https://netdev-3.bots.linux.dev/vmksft-nf/results/131921/2-nft-queue-sh/stdout
https://netdev-3.bots.linux.dev/vmksft-nf/results/131741/2-nft-queue-sh/stdout

I was wondering about this timeout specifically:

https://elixir.bootlin.com/linux/v6.15-rc7/source/tools/testing/selftests/net/netfilter/nft_queue.sh#L329

> I'll hide both that patch and Florian's fix from the queue for now, 
> for a test.

Fine by me.

Thanks,

Paolo

