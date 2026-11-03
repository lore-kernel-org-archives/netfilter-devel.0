Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707490;
	b=Ko5B7mcZqrKc7vgKYxfGMb2j572yeVRW4pwebQmUb4LD9UTC9HidJNKtxcgq7IRY5+en
	 8wgfY+tGZqJZrtMRBm+fra8aas3ppqo2CckokGp1O/jeFuKC2nn/2FuYlq8PC5rD8B1/v
	 CKXHo5qbFy8DNhmu26H3hhQ6DXfQ2p5Rvx3OhFSXcCsFjQ9KYj8Tb3w0Nqqom2d0aR0+K
	 n5PWdHOt5uleSJQWIzpv4T05Ja8ejM3f1x5cPXcum4rbkpawiXFN1A4chscjFywluBrvA
	 C8+HkqF1Ucyj2FDU+XV2+Uq6gTGxNyS60g/GuFdC6/0F3QztEEbEymrorJLf/t74yBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707490;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Date:MIME-Version:User-Agent:Subject:
	 To:Cc:References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZqbSq0DrPxgLJkLEtNhIYD4V8Brh3IAUvvQYZu839C4=;
	b=TGGCZO426+VeK7/ZYolVSrt2vaStZdCifFwlhSAm4s/u4cQa2vA9Is3EaP29UouB5Hvr
	 mgAJz0TXyWCbEp7HwDmtHbrkfUgAcjqhLdC0G1zLsz368zymFB4Bb9UCvMWtB+xisyqTs
	 WvSrMczqJZGQN3crQY7odtVBAg8fihlXioU7Ne/n6cKL90BGlYCoBUgmx4UzAJlwrMPl6
	 7rgZ8fQW4a33GgNVhE7ExmgkeI7dlXqMMXSWkE4Or7jBsVFnGK6q4DwO1ZvvnSArh2iBK
	 J4qhorCKehbcHE89gSgggz7JESNtbvmU9IjqDbweJkp8A12RxTeOw4Av8HFxLexS6EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="E/hAtRlk";
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Bcv5UaEo;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C31606A32F
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 12:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76C31606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=E/hAtRlk;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=Bcv5UaEo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793707488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZqbSq0DrPxgLJkLEtNhIYD4V8Brh3IAUvvQYZu839C4=;
	b=E/hAtRlkoasODsw0XEk4KaC1jzEn/wjaj7yhJQiMvXcKR92f0g7i7MrhcrU7lJZ4kGzzZM
	WU//LwnjkAJyX1mt2gn3zxzk0rFPDQCWa7kNguu9sBzlnaPOrhf6qmV9hx87eeZrmRxgIL
	s2BDyj8g0tJa6vyG0sd4PM88WwPZqqk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-620-HlG3djIfMjWQVe2B1cNypA-1; Tue, 03 Nov 2026 07:04:45 -0500
X-MC-Unique: HlG3djIfMjWQVe2B1cNypA-1
X-Mimecast-MFC-AGG-ID: HlG3djIfMjWQVe2B1cNypA_1793707484
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a2b0669946so29147875e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2026 04:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793707484; x=1794312284; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZqbSq0DrPxgLJkLEtNhIYD4V8Brh3IAUvvQYZu839C4=;
        b=Bcv5UaEoGLBHQ59uWT6nvW6UZt2kp4IhlKocyy/pIFO4Sprz6UqgQHQtbGn2rdBnV8
         EychCn+5m6MgAiD4NDZ85BFSyXKb0vWz6b38FS5kt9bwb/uM2zKoBLGNnQYUarFFmY7/
         wFPtvyxt6faL8mkoQOLAbVE2/Gjb0naqrh5GNdObrwYQGjzb/S4F1pGgwn4EHgd+Ou3w
         2nmigrHXm410w1WTKO6xFoWQEb+s5FRq0v8Y0yWa2Pr7T/2mkUSdY5Z715bsfhBUlMbZ
         zcERtr7Dr/9AjdYjZVBSaf6bnDgS6Jj2SpP9ykFS0XjfG/9zQRPoUfiM27d2IgTUhua/
         RDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793707484; x=1794312284;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZqbSq0DrPxgLJkLEtNhIYD4V8Brh3IAUvvQYZu839C4=;
        b=io07Ghv1kGikHhj0Yp6XJyAeW4RYKFLXOfZvvhp2gycbdzLJZouVxBekLzMnh7Rqih
         70Xo0sJVnM8f1fil/0qmjaH+50eD5TY6G1wpnulMOhcRl4NSyTVFVNsQztmFfEYIz3JI
         8aKSugBQvhil3iYe4PMEbzZc9nFw8j7iS3SiYCT59KUnITkmHP9t+XrdWfsuX2Y2dKGD
         PwLCcAKTHyslgh4EwdGGN9nAMsszsLsoGGSy9RiQHn3NWosN6kIJScJZ9uSVbErFDsiQ
         CqssUOnkgNabzMwsUV/Bybt1lgZS3wt8HXBWOVMDLD5aHgu0W5w6qjIQJeaTZe5PVJdP
         qNZg==
X-Forwarded-Encrypted: i=1; AKwUvBx/6EvwKZIPNzd3wjGc8pifkx2XdaWceBMt9x3pld5qVRg1HzJWAgOtoXEAg6AoMDLayTl352Ws/VsvkVzfRdQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z8ESWCiaqJwdlO8GJMBhKMZMUySUdL80OQBErFStHoXq9bQ8WxZ
	SPMSMn7gS0wr/m0lYydL+vON0QyeIE+tiFScbsOGIDrwVNMrP6V77yickbwiufzqfxVfJl/7EOp
	WfDN0fyJCdAa4JNtmua/jUoqGjmFLQzopMyOUTjwkJ5yq/8SqL4GV5uB7SOY/+cKspiu5rA==
X-Gm-Gg: AYBFou2K7Tew8r5YHZCZa5TgbqxXR3qDLs10kwjxlwrbpaN8of7DiThuZ1IfAOFI+z/
	neHZ9YAP6fKXW3i2ZTS9ujIw4wYGQqLimEwUGWsS6zm+PURcTnlAKYRrn6ZlDeyn9O9X7K3TqqR
	slM/IcbIwezIowBhDvI13L4JkP8FrD96pLqL1MXJ7Nw5xFeCHFWoR/7OUaUyajUJhF0jwk7xSx9
	3BihbXevTeoPUCBZcXlGbEbbb8ZaBDPopLTVmW1/RYDamD8q9HHnE5qH8sF35hxJh7pRDWreo0I
	3BtnkfYg+aeZfPYHJ4X0BOQ3mr/+T9BnLbt8JIzrWTkjrPZBx7td/hr7yavAc36FRDG+Ofh5GCr
	6MvJIUWnjskweM/9bI6jIBGr9XSpdo/zHXh8/d4ndeZNB86jAZx1ppdplJQdPL2zwEZsOiwakge
	wbAM6l3YflMPByzbvegrqFegCgNTXW/RifR2+OhvCqANU=
X-Received: by 2002:a05:600c:1990:b0:4a7:462c:6b9e with SMTP id 5b1f17b1804b1-4ac1923581cmr280827055e9.32.1793707483812;
        Tue, 03 Nov 2026 04:04:43 -0800 (PST)
X-Received: by 2002:a05:600c:1990:b0:4a7:462c:6b9e with SMTP id 5b1f17b1804b1-4ac1923581cmr280826555e9.32.1793707483404;
        Tue, 03 Nov 2026 04:04:43 -0800 (PST)
Received: from [192.168.88.30] (ip231-128-192-82.pool-bba.aruba.it. [82.192.128.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b2ab3ea6a9sm80111865e9.15.2026.11.03.04.04.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2026 04:04:41 -0800 (PST)
Message-ID: <b452b25b-37fd-48ab-a88c-feec6b82e9ec@redhat.com>
Date: Tue, 3 Nov 2026 13:04:39 +0100
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 00/15] Netfilter/IPVS fixes for net
To: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
References: <20261102005654.532438-1-pablo@netfilter.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20261102005654.532438-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/2/26 01:56, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following batch contains Netfilter/IPVS fixes for net:
> 
> 1) Add recursion count to nf_reject infrastructure to prevent stack
>     overflow, from Fernando F. Mancera.
> 
> 2) Address a infinite loop in RCU list traversal with the TWOS IPVS
>     scheduler, from Darong Lu and Julian Anastasov.
> 
> 3) Use kfree_rcu() to release IPVS parent application to fix UaF,
>     from Chengfeng Ye.
> 
> 4) Fix UaF in IPVS netns removal path due to releasing per-net protocol
>     data too early, from Chengfeng Ye.
> 
> 5) Fix unbounded growth of stale, unmatchable IPVS connection entries,
>     from Julian Anastasov.
> 
> 6) Restrict maximum master conntrack chain depth in ctnetlink,
>     from Florian Westphal.
> 
> 7) Preserve recursion count on nfqueue reinjection, from Zihan Xi.
> 
> 8) Restore GRE timeout in the flowtable, otherwise, WARN_ON_ONCE()
>     is reachable, from Michail Andreas Michalopoulos.
> 
> 9) Check non-null gc transaction in nft_rbtree before queuing it for
>     processing, from Xingyuan Mo.
> 
> 10) Replace WARN_ON_ONCE() by DEBUG_NET_WARN_ON_ONCE() in
>      nf_conntrack_bridge which is reachable if the protocol of the tag
>      of a frame differs from the vlan_protocol of the bridge.
>      From Laveesh Bansal.
> 
> 11) Check x_tables target name is non-null before accessing it when
>      building a new table, from Fernando F. Mancera.
> 
> 12) Fix out-of-bound memory read in nf_conntrack_sip, from
>      Joas Antonio Dos Santos.
> 
> 13) Fix a memleak in nf_tables hardware offload when double deleting
>      the same rule, in the same batch.
> 
> 14) Use a mutex in xt_recent netns exit path instead of spinlock,
>      since proc unregistration might sleep. From Cen Zhang.
> 
> 15) Zero the nf_nat_range2 struct before filling it up, to avoid
>      using stale uninitialized stack data to configure NAT with
>      an esoteric NAT flags combination. From Florian Westphal.
> 
> Please, pull these changes from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git nf-26-11-02
I'm sorry, but something went very wrong on the nipa side: the tools did
not pick this PR. Do you mind repost it verbatim?

Thank you!

Paolo

