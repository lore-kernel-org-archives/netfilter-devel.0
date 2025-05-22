Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8D7221F37
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 10:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908564; cv=none; b=s+pA1LY32A/dbBp6WTO9gpk4uCsYo+zriH1NKJbyEmxwCUFXf94PPwzRpuMTHB3iQK0B0o3kJNyqm7f/TdD0UZlIQUTXjnkGjF9qohOaftLvPbQkLyXTE7Ge4Y9PlxmLAtRJ5ELq49JCoGmEKfuJ3/cqZBg6vXHSKfR+5jxnw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908564; c=relaxed/simple;
	bh=ZhOeW2TscYoFyXeYm71KTwS4Bp1Zf8k1T9tqklWASlc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tcpNWpKJOPHZRUwGYlVHiUVGw0mXzV9EigFbR8OfMldzvj1hn24M8wnQSjmeZnuW/LGZgv3Z2A+MSfoSakzwJTc0Y00hS3CAnWK0eggjwF0hbkmGRQqAFJ77sGS4tqik8f5e7Kk5OIx43tKXGPr10MOqTKsNHOrpvdAc2T4MXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bzNSKQH7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bzNSKQH7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747908553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ZhOeW2TscYoFyXeYm71KTwS4Bp1Zf8k1T9tqklWASlc=;
	b=bzNSKQH7mB/sLB6KFPWTUbQi571Uqgi2/rwrQr4QE/sl4wvIxVBTLNCDLDiYlEQKqDdWcp
	164U/RB4qPelCYTVrLshxpPrS0tkCdZg3leYNS4lp85/YpOtw9FqdtgZdZKpcWVIrZZYov
	chYFXEed9mX40NJadxfZROeYZpW2L8s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-AF5xfefZOQWbq01p9Yy3Xg-1; Thu, 22 May 2025 06:09:07 -0400
X-MC-Unique: AF5xfefZOQWbq01p9Yy3Xg-1
X-Mimecast-MFC-AGG-ID: AF5xfefZOQWbq01p9Yy3Xg_1747908546
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a35c8a7fd9so3358020f8f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 03:09:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747908543; x=1748513343;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZhOeW2TscYoFyXeYm71KTwS4Bp1Zf8k1T9tqklWASlc=;
        b=Djf5wJg911dH7OJP+ndP0OBKhJK+id4h8hqDwLdk09kCHE5TKY4pHnIPQdSm5VXxfG
         jlkgwV0gDE5JFPt1D2NT/f0i8QVwrP6/26+ZGHUCi1ViEYWzzXo7106p3iHGlckbMyKa
         SwePdtKRMB37Hryk6pS0NBqvdC9PYD4U3JbWSIUMA9/46zXZfAnJ3V8IPZlUYrqqgWdS
         y1aRrn9M0pRYEh+Y/zcjqAXWTXthVDibXuGuXS0DiserUNuiEtor2XC3vaY5MyW/RZ34
         oTsLwdZxLCcqkXFJkubWJyleBoSvjWXzQTtpY01kN/e/N2zPHVXLiANj/FOF1kuJev83
         IYBQ==
X-Gm-Message-State: AOJu0YxdNnlmxl8ik2hGJNhvKpbeB3ioKy6gx4H/if2PHpWrJrldfaX2
	DPEFKRVhd5Td3HmJb0xk7R5vzMJ+XPEyonWnH1jlE3ecM+3U31RdAaMEiknXWKuzGl2kstC7UUa
	kHsFO5awOi7ieiOfPdkJoFGy57LO1m41gml9QkBCJNkkUlBof/UDTguPh5p5/7jcEuEgdNQ==
X-Gm-Gg: ASbGncug9fjnNLkO+ZMhe+AL2xr11+yWRuCt8Q1LaHKqoltaV/KPoe8gf+WjvrGkxZw
	9EhfhHaxbm6NzJv7RKZSu97+ArmjGgE27ZoliN7VKUienTHwCFIkBBwEADb/FqMF1mjC9rb4hK4
	QzbDc30pwfk08JYjiyAgFc2Jm93zaChNeijdzMYbvpydEkfX/Sclv2k1dLUZ182HFERJjVuuBXm
	yIpge3kPut0zOlIToendy+vapm13PXUAvOo/iuHlA5FVG/gk0u4WsHkVEMXjIebiNHI4LmTBT/m
	qtGFJsLjRRFqxB6ql7s=
X-Received: by 2002:a05:6000:1a8c:b0:3a3:76e2:ccb7 with SMTP id ffacd0b85a97d-3a376e2cf3dmr11914682f8f.5.1747908543039;
        Thu, 22 May 2025 03:09:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/SOeQ2+VqjWJn117XcAJWF/NFDn8srPYGjQvlAENU5/eAr/jU/bIRTzUhN1KOmiMGW0ftlg==
X-Received: by 2002:a05:6000:1a8c:b0:3a3:76e2:ccb7 with SMTP id ffacd0b85a97d-3a376e2cf3dmr11914661f8f.5.1747908542744;
        Thu, 22 May 2025 03:09:02 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:247a:1010::f39? ([2a0d:3344:247a:1010::f39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a35ca5bd8asm22981891f8f.33.2025.05.22.03.09.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 May 2025 03:09:02 -0700 (PDT)
Message-ID: <584524ef-9fd7-4326-9f1b-693ca62c5692@redhat.com>
Date: Thu, 22 May 2025 12:09:01 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Florian Westphal <fw@strlen.de>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
Subject: nft_queues.sh failures
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Recently the nipa CI infra went through some tuning, and the mentioned
self-test now often fails.

As I could not find any applied or pending relevant change, I have a
vague suspect that the timeout applied to the server command now
triggers due to different timing. Could you please have a look?

Thanks

Paolo

