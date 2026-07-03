Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03333344DA0
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jul 2026 19:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783108775; cv=none; b=Vgi4uRJvPP0aQrBxD4rBhgTrT91z+oOorw7dUHtJ6l1XPeDN8bIVAsVcXmZiz+0/54vzsymFLFIa4wPqOp7aldQCaN8/Hy5FdnqfWSkQiaqYbD7d8hpy/dGCHamF2C7SG9I8izcyO/XJIiaj9HIslxpeG8usDvw9Q5MlNwFAbk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783108775; c=relaxed/simple;
	bh=2aYDZM6lYTfGT6BwqqoFiONE+cTXM8g6TG2Du8NB/d8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/D7U7uNbw1+Rv1hyMRI+WGTgN74G7b+nUA9Tm8EkeZZUEyOZDVHu6fqlHK1paknljfUHCRZfhk16Y2S3yS0E/wkPhGS5WiQ/RyEWglj+GaDaFZ6oUl9ivYzuTNKjn+rTZyPDyasTcaB11jSWLvCZ2VL5jlndEeF6Dht6RALFl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IfOY1Zgu; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EyHuTGpD; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IfOY1Zgu";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EyHuTGpD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783108771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T3+fkFqbL+y07nPa6LA75Hnt5NAmG/dS2fgU2WFQxqE=;
	b=IfOY1ZgulnX7ZpZiN1b6bbIIuSW7WSKfoFF44hJQAgxYkwH7oYs+FUFmPp4SXZ9jIZYcLR
	XIvqMQIw0aH9Q0LslmOW4yqH291jakxznzM7f/a9uqoEl2TpfsG00fIJ3Fxi8lKn6OFSSB
	j3VOvNu3VlG5jiMdZ6JbCnphONEnrVw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-JUVnAAlPMOK7cczkvEvr-w-1; Fri, 03 Jul 2026 15:59:30 -0400
X-MC-Unique: JUVnAAlPMOK7cczkvEvr-w-1
X-Mimecast-MFC-AGG-ID: JUVnAAlPMOK7cczkvEvr-w_1783108769
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47485fde05aso873960f8f.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Jul 2026 12:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783108769; x=1783713569; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T3+fkFqbL+y07nPa6LA75Hnt5NAmG/dS2fgU2WFQxqE=;
        b=EyHuTGpD4D8a8FQ0Vstb72umWJ1CgBkgE5nZapbkXSt2uFaKEdtTBwWsDNVtfnBtbY
         GaXMN0V672rVefvWf4cURbOr3sZHJoX8bYIjKUz272paxDsaAjRYr4mNEMWf3tD+VVtb
         noGy5z1O/n9Sh/a1GbaJw7Twj0fI1pPAvecULDOs1PkMQU29nQhqHIIwnySYZASAxF2G
         DG0dkHRa14vtohWgrOf72AUvv64K0G0yxCr2VwGTrzgRM9oY93en+VnFBKH3bHQi3z3A
         e0e0fV2S2vZ6Arwy2d6WQHrCVMrZw9Hdhi89NXjMrCD4UM/p5a9tf5jPHwCTg0VYfO3O
         JGJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783108769; x=1783713569;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T3+fkFqbL+y07nPa6LA75Hnt5NAmG/dS2fgU2WFQxqE=;
        b=ndS+MyNdFDfMawgTlnBX6CiRdt9vrzq015LVZrXNqunjAP5NxPcbI/WtVISarfhOyz
         8X350cOGlfIPDHjYxrpbn+e5ki0210pQgm4MGo9cEgMxVv0f38xyKnDAdx3v4krnEiYa
         Gh2IgudX0kpj/V0RS7BSmoMwWHQalN36n45JgvqtnjEql0JxnjA8BZFpyEdIY8CserQa
         UlyMFPlsznplVT9WUl1CsHsPpBvy7s/o0nlmga0PeaDr5VNNVdXEmFZ75IXmx//bSlqv
         K0dWmqv7n+pf363aA2w+N3Jlt9S+tP9WUaWhtIefCk7GzD3k26vtJMVLdu+jAYj3a9oB
         T4Qw==
X-Forwarded-Encrypted: i=1; AHgh+Rpm3KJaXPyu4B8Ca5iD2PRR5QjaGNBUaXg+Yrsk21tGrhI3h3NoSiDgSbPQtZnKsRKAJmlWH/3wRN4waJd3FwI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqoCUhBtdpxIPl/uI6UF20fLlIYHz6aijtzfKzjPaVohQQKNC7
	wZLPYcyu1JOBUPEiHsDJvT8M+B6L/v9jN6rxnN4xfFJfNnVGAR+yJqWaUr1oca2guHdZKenR0pP
	vaUYfPqGnZ+dsn0SHBtxV5C1TBRsnZWQP1sPE6PKgXmC/kvLZupBryGK6qLoeUWOkUHlQd5qvkH
	DX4g==
X-Gm-Gg: AfdE7cm5lP/I2nkdHT3yyxguFZgECxTqzOKm2K7LkMh7YHksRdjAAU2ZqKIYlvHH80r
	zurQevl28lDe/YoqAEyJaDTChB7unfnkvkDXvYujWDxu1g/+5XHzuQNMixZQoDrwf/LMyuRkMdf
	B3wpAQx+3QAe5EDGcgxUeJbbGLWn0aAsX5yXt5WrTiIrpWbUJrIbghgpj2G70HHBD7hj1/FfX+z
	um0nehKahB0XBq3c7RO/gnvb538HhyWIKRLuPF+BgMSb5GEwcs6sOdZHyorIxbt7Vi++1hziR41
	MF2SNYIq3aDkPeWkgqKs6QJZuNLiE8A2qXZq/xMLNTpyxToAczFv7Gr3qnK7byqz5/JwmD6REx8
	jCny08ED9hUDxIq7UHYnpINFqe/fb1w1qD3kTPXNk8zLLYGrEx7ZTF3CO72bEC6Of3tMDrDTkzN
	dSn94q
X-Received: by 2002:a05:6000:41f0:b0:473:53b7:e390 with SMTP id ffacd0b85a97d-47aa96997f9mr844531f8f.11.1783108768896;
        Fri, 03 Jul 2026 12:59:28 -0700 (PDT)
X-Received: by 2002:a05:6000:41f0:b0:473:53b7:e390 with SMTP id ffacd0b85a97d-47aa96997f9mr844513f8f.11.1783108768507;
        Fri, 03 Jul 2026 12:59:28 -0700 (PDT)
Received: from [192.168.0.115] (ip90-44-231-195.pool-bba.aruba.it. [195.231.44.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f21543sm1613520f8f.35.2026.07.03.12.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 12:59:27 -0700 (PDT)
Message-ID: <5439da45-f8f5-4fea-a21f-580c753a188c@redhat.com>
Date: Fri, 3 Jul 2026 21:59:26 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 00/12] netfilter: updates for net-next
To: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 netfilter-devel@vger.kernel.org, pablo@netfilter.org
References: <20260702105003.13550-1-fw@strlen.de>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260702105003.13550-1-fw@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/2/26 12:49 PM, Florian Westphal wrote:
> The following patchset contains Netfilter updates for *net-next*.
> 
> 1) Update nfnetlink_hook to dump the individual NAT type chains
> instead of the nat base chains to userspace. From Phil Sutter.
> 
> 2) Replace strlcpy/strlcat() with snprintf() in x_tables, from Ian Bridges.
> 
> 3) Start replacing u_int8_t and u_int16t with u8 and u16 in netfilter.
> From Carlos Grillet.
> 
> 4) Replace strcpy() with strscpy() in netfilter, from David Laight.
> 
> 5) Remove redundant NULL check before kvfree().
> 
> 6) Add parameter validation to xt_tcpmss. Ensure mss_min <= mss_max and
> invert <= 1.  From Feng Wu.
> 
> 7) Add checkentry for xt_dscp 'tos' match. Implement tos_mt_check() to reject
> invalid invert values.  Also from Feng Wu.
> 
> 8) Stop hashing nf_conntrack_helper by tuple. Switch to hashing by name and
> L4 protocol.
> 
> 9) Remove tuples from conntrack helper definitions and port usage from
> broadcast helpers. Add netlink policy validation to prevent protocol
> number truncation.
> 
> 10) Remove obsolete netfilter conntrack module parameters.
> 
> 11) Bound num_counters in ebtables: do_replace() by MAX_EBT_ENTRIES to prevent
> oversized vmalloc_array() allocations.  From Jiayuan Chen.
> 
> 12) Make expectations created via nft_ct rules work with NAT.

Sashiko gemini says that patch 1 may require a follow-up:

https://sashiko.dev/#/patchset/20260702105003.13550-2-fw%40strlen.de

/P

