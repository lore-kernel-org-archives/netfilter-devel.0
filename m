Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8450429ACF3
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752755898; cv=none; b=FM0Q5l01O3JTT1A+tbWiUTb63cmBKyVr2OGyNIP7HyoCbiNdiR61V+O4MAkZOynFmPrTsnMcjGbUbMR+DhlfmVhkShslaAl3/cLlD0MLMdbsPvMcYoa1a5Ov/Gfvn5OEDheM0ybJnOJtFMoIac2yXmgtT0lh+E+Z+X7AUO62jG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752755898; c=relaxed/simple;
	bh=N3UgBmXMJ82HmWUgVZJoB81u9rw5HUAhpMTxqxV4OLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nEEmjsJJDQ1WxT5fSkB+xzOj7mLHVJscYxEfAYEYF8UKARxgp8nbVRMusRVkHEav24/z66oTvNbGwMZu5CCgMMgqJ+JLdrC0c0jFOxIS95Wz5zRVLErjcQ2EUTG/ZLQWFnH+LFwhva+HvpClqUBjBETu1sQgppAmqlDcUuzLT3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GGaKIKve; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GGaKIKve"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752755895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bIQorcRmryvxVCzpJ5J62xkHuGe+oWK34LGznXnYv6E=;
	b=GGaKIKvefKjGqMDir4vCLF6h/LwFkFEFiGThlWxlnS+NoGQ78Nk7lIzZweStl+svgwdVhH
	Nv5wh/m773Vk0071YKR4mBYANpe8jHC9TK5Id2oPHwEv+Urz1EOorUyQRiKzW88pB2X/y0
	FH6e+1j/4CI1CR4A/5GNc6p2gwGHDzA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-mURXrkzmMTeDHKHFszp6ZQ-1; Thu, 17 Jul 2025 08:38:14 -0400
X-MC-Unique: mURXrkzmMTeDHKHFszp6ZQ-1
X-Mimecast-MFC-AGG-ID: mURXrkzmMTeDHKHFszp6ZQ_1752755893
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4538a2f4212so4453995e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Jul 2025 05:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752755892; x=1753360692;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bIQorcRmryvxVCzpJ5J62xkHuGe+oWK34LGznXnYv6E=;
        b=kWkgsEot5TA0hvhtlevlznhTHe7xBucvEJ5jP92N7uEYP/FUN9hh2ppYteN4FzHNXQ
         OOlbZDVSyfqMe8COmi3ZxXduiXz6GclPEM5IZYwbk23ap/Y3vBUyjz26wc8feb3l2fS2
         KAc4uIlcQKkaqSuF6VfwqESxGF5yQCw6vWv/RxxuAAi+3AMDzX5wjXePZ2oH5tsU7UKN
         C0aSnPYm/JX+HeNHrTVyecZHNNU7kPzCfcRcGY/jVWcr4yyHTdd451ZQQ067WOgkG8F6
         Ss4v5IW/HNuiz5NA5UfTvlRNI0dQZQaLviD1ZO7DvOOysVMd8JPjGjLTsVdDmwOeVA/c
         HBvw==
X-Forwarded-Encrypted: i=1; AJvYcCVHis6RmvlBxxYv8e6zww+XUwUOuj+Ayk9Cjl8Dz0020NFABj09O/ssXzsFGbD+aH0tFs65U/WtbUk/2Kw6HJM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0OxRaEanjdiGPHJxmYRTB0vnTq6wm4pFxhiBIzzUC/RfyaBKN
	IuYF/S4sDNIiCHbxoSHUKu82IcjAl3KEThr/cEXLpa9B86NOq3OP4DlaVDdDVFidwrITmz3dAV6
	7z5KH2ioChIvXXNk6w7Qh/ziL9kTTN2cXcyq9HMWjMuZl0BxeB7UitoG8k5NPSWrc2bN/HPwPfL
	xRzQ==
X-Gm-Gg: ASbGncuZWoikQpkZY40Yq0ROOAQCTWvXZMkg4ZAlL4H4CLP5oWsoy4x/5XVzl+V/0Vw
	j6xoj9kf4vzph8huyfWUAnMIaiOL71KF2Qe+MmeKpBXRtbKA01B9R8E73wlKwFP18Byr3yVwE37
	DZGVkuKXOC3KgjNqm2raSvI7Ujm+UJZ7yplPYyDBWi3rF+h0rXM0L4AFvMmLSc9CsIJsmXEgvOw
	6VEHb7IHZdduEHUHcjiY+1r2DYJU4FKq4sxB20J8ssnDuPlFUNo/yzABYgs4+SYr/SnoA/lILfj
	LaSoHrRtUrWVU8xfbtvS+MSLN2Cu8HNSOzKdk7y/lDq1/jNGRjlRnNhOWUo+3OPCGoSvvCzRR/Y
	oaYBv5Nj8sJo=
X-Received: by 2002:a05:600c:3b11:b0:456:11db:2f0f with SMTP id 5b1f17b1804b1-4563532c395mr25752635e9.16.1752755892260;
        Thu, 17 Jul 2025 05:38:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCYvQxFSEXEQ1G0sQev9OTHxjbK7UpkTBTpCyZ5G8y/kfOQnfprc297mGkFHriICQL9Vbg+g==
X-Received: by 2002:a05:600c:3b11:b0:456:11db:2f0f with SMTP id 5b1f17b1804b1-4563532c395mr25752335e9.16.1752755891844;
        Thu, 17 Jul 2025 05:38:11 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2712:7e10:4d59:d956:544f:d65c? ([2a0d:3344:2712:7e10:4d59:d956:544f:d65c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2e68sm49942235e9.1.2025.07.17.05.38.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 05:38:11 -0700 (PDT)
Message-ID: <33ce1182-00fa-4255-b51c-d4dc927071bc@redhat.com>
Date: Thu, 17 Jul 2025 14:38:10 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net,v2 0/7] Netfilter fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org
References: <20250717095808.41725-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20250717095808.41725-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/25 11:58 AM, Pablo Neira Ayuso wrote:
> v2: Include conntrack fix in cover letter.
> 
> -o-
> 
> Hi,
> 
> The following batch contains Netfilter fixes for net:
> 
> 1) Three patches to enhance conntrack selftests for resize and clash
>    resolution, from Florian Westphal.

The first run of the newly introduced conntrack_clash.sh test failed on
nipa:

# timeout set to 1800
# selftests: net/netfilter: conntrack_clash.sh
# got 128 of 128 replies
# timed out while waiting for reply from thread
# got 127 of 128 replies
# FAIL: did not receive expected number of replies for 10.0.1.99:22111
# FAIL: clash resolution test for 10.0.1.99:22111 on attempt 2
# got 128 of 128 replies
# timed out while waiting for reply from thread
# got 0 of 128 replies
# FAIL: did not receive expected number of replies for 127.0.0.1:9001
# FAIL: clash resolution test for 127.0.0.1:9001 on attempt 2
# SKIP: Clash resolution did not trigger
not ok 1 selftests: net/netfilter: conntrack_clash.sh # exit=1

I think the above should not block the PR, but please have a look.

Thanks,

Paolo

