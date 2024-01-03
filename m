Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97361A706
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jan 2024 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EyNUSSbt"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bc09844f29so1976128b6e.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Jan 2024 06:53:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704293607; x=1704898407; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OvKtOTQla9gbESEeJYUao/mK1wkd/4OrX88uqdJgpjE=;
        b=EyNUSSbtt4Be5Clyo8p25xgWp4zFQnV0H2v8UeD/dFn73Zo8QPbrajacowLg6WFUxR
         yEfEPFtjQi4PTUwgdmqDYGrMuRUe1QkefZ8tRaSVj/pTMTY6fmtO8iU8+Fdcr1k3sfOj
         MHn1WSEYghJTFOq4ZShYEFGnnxpPmZZSuNrag45HbX3LmIY/hAB8UIVjmTCjXJWK0AkZ
         zXy7GodNL68fLIIW9tIe1GS7Dm0r2FUnebMoK70HwUXVcLg/zks9QdINVmSVtUI2v5nk
         to52DBsuyAFi6TipOGquq60Wx0nk98SA5R5UvnYVSnUpKkxY1XMwaYEqNxVvo3z3Kzie
         eYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704293607; x=1704898407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OvKtOTQla9gbESEeJYUao/mK1wkd/4OrX88uqdJgpjE=;
        b=GNFa7ITDs9reaNJbmeA5V9njNtJDdQddqyMb6WMSG3nzk8hUrlR1RrTGMgTJjCb2PT
         h/zTrCbOBOXMF8Uhdk4yVoixQoq+Grk5hkJnNlXl7RGxNHHlVv+cy8/eXtI/YKqzKoFQ
         164ws3Jg+W97WynK78cVRvhTONNInGrYNIKJCu/Do9yyz7spNz9DegCgXnoj5fBxFYrD
         tFvX16cdz6OJoaHKMCQqSekmMhVW+I/8ReKes8eb3wYpwuDcvUcP0vuPDdMimnPBRNly
         DliTo65KOfzmzdP+DFLvdJSoPGRyGbbaGrbVSkhm7q5/kV4qnL2fl4zJkCkjNnuQRb+i
         eJgg==
X-Gm-Message-State: AOJu0Yz5sbybvs3ph1d+ZDtnL5hXxPZ5mM6vr5iKlL+yrZuOk9L0VnhI
	f7wTtTcFuXnctuj0T8MsnWX3glUABOs=
X-Google-Smtp-Source: AGHT+IEzPMLlJm5KuMwFikKO8TPBngbFDCOCnRUX6iCQqoSz0y1lX836j32FBwjdMkeR/sO+T4f5Wg==
X-Received: by 2002:a05:6358:27a6:b0:175:5890:d283 with SMTP id l38-20020a05635827a600b001755890d283mr1154443rwb.27.1704293606645;
        Wed, 03 Jan 2024 06:53:26 -0800 (PST)
Received: from ?IPV6:2602:47:d950:3e00:e895:751c:cca6:f658? ([2602:47:d950:3e00:e895:751c:cca6:f658])
        by smtp.gmail.com with ESMTPSA id u11-20020ac8750b000000b00419732075b4sm14037744qtq.84.2024.01.03.06.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 06:53:26 -0800 (PST)
Message-ID: <25d59855-3604-489c-b2d2-2b68e0bd72e7@gmail.com>
Date: Wed, 3 Jan 2024 09:53:24 -0500
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH libnftnl] object: define nftnl_obj_unset()
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
References: <20240102132540.31391-1-pablo@netfilter.org>
 <20240102175058.24570-1-nvinson234@gmail.com> <ZZU3wJKLfQdmatV3@calendula>
From: Nicholas Vinson <nvinson234@gmail.com>
In-Reply-To: <ZZU3wJKLfQdmatV3@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 05:32, Pablo Neira Ayuso wrote:

> Hi Nicholas,
>
> On Tue, Jan 02, 2024 at 12:50:58PM -0500, Nicholas Vinson wrote:
>> I manually applied this patch and got the following build error:
>>
>>      error: use of undeclared identifier 'nftnl_obj_unset'; did you mean
>>      'nftnl_obj_set'
>>
>> I think a declaration for nftnl_obj_unset() needs to be added to
>> include/libnftnl/object.h. Other than that, this patch looks OK to me.
> $ git grep nftnl_obj_unset
> include/libnftnl/object.h:void nftnl_obj_unset(struct nftnl_obj *ne, uint16_t attr);
> src/libnftnl.map:  nftnl_obj_unset;
> src/object.c:EXPORT_SYMBOL(nftnl_obj_unset);
> src/object.c:void nftnl_obj_unset(struct nftnl_obj *obj, uint16_t attr
>
> the header file already has a declaration for this (which was part of
> 5573d0146c1a ("src: support for stateful objects").
>
> What is missing then?

A mistake on my part. I failed to revert to properly revert my patch 
before testing this change.

Everything looks good to me.

Thanks.

>
> Thanks.
