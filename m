Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE17413D6E
	for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 10:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787221617; cv=none; b=nyjzLpOACNsltpE4leV2wBjkgqGk35fQupVunly/tYxaOMGVJVeMYGfDOSaRI+OSJAhTezy9VbMck7QoYxPXU0lU+Tw94ETO3Q02hqTsUKKJDXhnFVobKd8PgZG+Ab85HLiB9l9FGX0DyOkFCYp4HxPK9EiZ1dF/NFOmWFJJJbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787221617; c=relaxed/simple;
	bh=bMqcPCyNgfU6qizssxjNwkfBRqE+hJLoReApgCWJepA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hZ804lm8bkOyiWo21jaEiwhljejbWbm874oZxt8xDz4pVvZkKcxoz3dLfOH8QP8usEbu4VCbtneHTERHnjR+g1pGs66O5jmCdBWp6Q8uoTgQsmfobO/6rmDku7YRMEXVyGZmLcXZOdBAFfGaCk0uGQKFXbuMRW9ICZNqDGEzMPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MQVFjCqB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=natCF/UE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQVFjCqB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="natCF/UE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787221604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pyw3EZ/t9k/GcnByzESslFgBYkRvy5+O8+sE89RYu/E=;
	b=MQVFjCqB3noLUd9PRxTKH1i3HXqRIovD6uUBlPZhSnNl72XTwJNU+75Bdv21hfwr8BC334
	kCEhvn9wUinJuACKR5zs7hywXU+IVQpLpcGqkiqOH1AcS1ctUwwtrmyrTtCrrFUIrNHtJ0
	RKcoPxY1JbX66cLLb4w/qbz+ksdWg2U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-219-Vi0h63KoNMq96JRoLuvgdQ-1; Thu, 20 Aug 2026 06:26:37 -0400
X-MC-Unique: Vi0h63KoNMq96JRoLuvgdQ-1
X-Mimecast-MFC-AGG-ID: Vi0h63KoNMq96JRoLuvgdQ_1787221596
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47eaa4006a1so393997f8f.0
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2026 03:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787221596; x=1787826396; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pyw3EZ/t9k/GcnByzESslFgBYkRvy5+O8+sE89RYu/E=;
        b=natCF/UEyQqZth8fiZLEiqWsK+dYoF6mcLbwZFqwCYe6siN1+7LR53ViEXYKqTOHgi
         EVA/AjbpOglw9jJDOpnEVFVyX3CAzqE14guEY2Xvn3viombQNDC/e/frsPkB6C3J4ycg
         mB/KZ7JWM8/lNcnIT/D+6O3xufGCz+LafqUsYFH/vtsUEIVxwGq/1yti+Ios55qBYPM7
         SC9kwytLRZ5XxW1cFKefPwilwoeFfBwQ8QLdt8fCcyIpwa1zXQv6njlOcR/oa9QUvQR/
         f5NlJpKcxDDcDEaqLs1wNX37Yj/dwbC0qjWNbqABetA3qSnc95SbznKNHoauhHQXTswu
         yIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787221596; x=1787826396;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pyw3EZ/t9k/GcnByzESslFgBYkRvy5+O8+sE89RYu/E=;
        b=gU4hm6+kP+FNX6XEA1K4wPj4gUVjWIoSzR9YPJJQ1qcRe4se+KV7QkpDtUEgqcShYi
         dcTNoXtl+1l26BRuf1cAkvg6F+RQAsXLUufsvit4TKXAZAqnbI3Szs/JFM/w4GFA0OmF
         TXmIl/aDGvn6WXbXsj6mE3Y6cCBh7WIUSRGdy+MpL7zdEJwU/EuRTabtlUdzf+5pcaG2
         v16UWlWVU5g9X2pCuljoPL8sRX1BI1bqV1uee+frCj8xXSNNc7ZH/e6afRpVbimQDXA+
         SBQO5+UPh4ibPj4qIGAw2hx6guiaTmNKZFI4Nn73Ir4k/DaV2ZSzYUF9Q7YNuR5wb9dZ
         uyZw==
X-Forwarded-Encrypted: i=1; AHgh+RrbjYVKq+4KI6EvqXwEHAoveAgkQng9klCALl197OLt0V2C9plJNZa9q6UDdRrt8ZjiWWl9SpxQQnvXkXPKUKw=@vger.kernel.org
X-Gm-Message-State: AFuF++ltjv2QmEBMHZcQzPajBGDfEgIDnM6J2JCZNzS2HvCAgd0QeyZW
	wKEk9CalwASjYVtY/cIOCIB2l2gOGjUN6k8FK6M1/X3qyez8kVo5URDGDVhTWx6/xpMeNhxC/OL
	yAnA9bXHJZo4sBbSycOqBzshXKHG4ixVBbcztFUgr25A4DPaK4TmiiIQD1kAUq1DsPnHWJQ==
X-Gm-Gg: AR+sD13RXQ1X/TP0xmt0Nya/WBO+i9PeFzof+LMbHYKG53ySeKo96gmIgw517bOyZcW
	66XjIS5D5kwldSrtiYxTIrxvQ0ooW4CXJRdNUX6VyfHxlIYaf2jj9Cg25vQb84+LmMpdszbyYKM
	xTacK5miEDZ+qtUJmmmziLaCnA9SFgXhI7kTEEh3r4gvgnpQvo1uCxF4VJSxPS34HoDC9VMGG8w
	lZIAsvpk2EdVZu9ov8Bc9it8fk+H1G2R16Fvk87i5+6T83vYhyBPyiL3mIRbgKcmUVHLZZIx3n8
	4XujDYEa1RkDNfrGc+Jpj9/Z5noL4nf5ZdqofjBWXEg/judPcBFCX1yEGf7LaCCGPlUZEhJWqhh
	StaGl86U1X+ldhFw0yUiDyeBk2YvVoOWjM3yL6xw1vysJndrfhlYmV8RlVMYpcB+HJ7Zn1mLU7F
	0=
X-Received: by 2002:a05:6000:4a17:b0:47f:ece1:1eca with SMTP id ffacd0b85a97d-482b78100a4mr9785312f8f.1.1787221595831;
        Thu, 20 Aug 2026 03:26:35 -0700 (PDT)
X-Received: by 2002:a05:6000:4a17:b0:47f:ece1:1eca with SMTP id ffacd0b85a97d-482b78100a4mr9785225f8f.1.1787221595308;
        Thu, 20 Aug 2026 03:26:35 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482bab42f8esm4232205f8f.28.2026.08.20.03.26.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 03:26:34 -0700 (PDT)
Message-ID: <eeb04db2-3c08-4b4d-97a0-02e418ed2537@redhat.com>
Date: Thu, 20 Aug 2026 12:26:33 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 0/8] Netfilter/IPVS fixes for net-next
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
 horms@kernel.org, ja@ssi.bg
References: <20260817232957.1281637-1-pablo@netfilter.org>
 <aoTzAYyHk7E-HTE_@strlen.de> <aoYlM3J0SP51Kpoh@chamomile>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <aoYlM3J0SP51Kpoh@chamomile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/19/26 11:50 PM, Pablo Neira Ayuso wrote:
> TLDR; I can post new v2 for this PR if needed, the left-over of
> LIST_HEAD(set_update_list) in patch #6 is a bit embarrasing from
> cosmetic standpoint because I will need a oneliner patch to remove it.
> And I can re-target to net.git as Paolo already mentioned.
> 
> Anything else can be addressed by follow ups.
Note that we are waiting for Linus to pull the net-next PR, so we have
to wait a little more to process this one.

WRT report, I think follow-ups are preferable where possible and really
reduce pressure on the ML, but if _you prefer_ a v2 please go ahead.

Thanks,

Paolo

