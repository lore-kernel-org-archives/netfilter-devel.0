Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4295114B951
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Jun 2024 09:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717578575; cv=none; b=WI9p9/6sfip/VjCN8peRwj7HfvJHHVj3+rVBV2UeGku9DZ39r9/EfdAptKGA2tbk76RZgajwVnMYgzmNQ6hZ2dO2ODbnKT7Ib9QTQFn6xe3c5RQ3l7IqVhTuRKCKDKJRTNIWExGFck9Qgz9uSLnXTG3YMTVAlP64BOAtlrHeSzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717578575; c=relaxed/simple;
	bh=H/xOWZ5L4n5xAiHYw2Q4KfjoBz5ywAXTZXlV5booVn0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=leGuhfJ2N98p61DUKWS1kh1sL21ujCVz4qhZ4gb5Kgcilu1mhcglvJs3Gmww+xHr0fuK26ppRspK6KLI3aR3p2XDghFIStKqRC/3WDPnsD1y6VQuiJpCaUaPkjyNo1ObbMXbSDrJf1siIDkbSeZkc1k1dLxXJkUMdaA6EycyXZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=OKi2oKjX; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="OKi2oKjX"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-35e5604abdcso406376f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2024 02:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1717578572; x=1718183372; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+UmpGA+ZeMi4kfohJdgrNuGbikeEYkKaVXbYI+HeV3g=;
        b=OKi2oKjXLSiCEhQQMwK0i7lhWxpjwASPfPZgW7c4YOqDsBzmmYXOG7z/j9M5DMloir
         9iYZRfgkWdh3umQWcUCD9K1R1cu8Si56viYGGqueGGsrYf71OfOOa01ZSb661WZohyZE
         omGrhlLyufgkwA0SP0zK0t3SP7YFP4ACq67ZMvSOln3xoV1YqCw9TDGh4CZKbSrboACR
         +AsTJBx8i+4WidyJxyqTEAPNBNEadkV5bDXMYrEvE99EkqYru+JcBtxOlmKaDw+07kxG
         VyFlHmWVpoDWOXoqv9G8CMiRzacPPX+46HhPIQBx/vi6p1CayiQhCoajpVbHo9g+UOnw
         8tkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717578572; x=1718183372;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+UmpGA+ZeMi4kfohJdgrNuGbikeEYkKaVXbYI+HeV3g=;
        b=a+T831Ttug/Tq2aglBaM+TevCUdJFRm/aQY+ecF3N+hMNpCThiLwVSNxdqnp7Isk9M
         Z1iq0oS94QSEpUSJ1wyyHyOakGOiLrAwvWmnnDFhJJUZ4/JXlYQP74ka4QC4sZt//g/0
         WoYgoZuLhHaNqKPHE6yIb0simzVP43MI6WppKUlvjooAGC6uXCCjDdtTssYtPsvhFkSl
         RcT6IRpCkF0fZXY2W4dWZsC7LrFI0GCRvWSktLcyQv36/3uKj048Ez1SJ3fIk/cxmEgp
         cIsFj+A0QZLR3n9ZUSEgzkAOqobNP8p/daE+KZ4qFu22vXxGqccRuyG7hkthyY6xJixZ
         AFCw==
X-Forwarded-Encrypted: i=1; AJvYcCXOMd6o561dWJa6Yqe1oz/PrvF50YvGEi5F+qQ3075qW11eJIJERkA2Wzb8Mml7GZZtw4gVtTU10HyMPETXeYFo7EtGjS9TaX3BaG9D4mxS
X-Gm-Message-State: AOJu0YyMp9J1l4KTq2Qoj5z2y4AAktXf82OXVdS9eKcJKNYA8QwCEfkx
	XQdUOFIn1C6TpD28cNfWdj8T83P3eA0C8VEzq+zC1RMRLdQIoal1YTKSN4OuPurLw5UdXvHlc4R
	/
X-Google-Smtp-Source: AGHT+IGigeZlMKJ5xlsed0h4vjvUJM8+w/gb50iEjVMBFpz47EWxxpTlL+2yqiHfs06YqiZSo8wp3w==
X-Received: by 2002:a5d:460e:0:b0:354:dfd4:4f62 with SMTP id ffacd0b85a97d-35e8395b176mr1559128f8f.5.1717578572641;
        Wed, 05 Jun 2024 02:09:32 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:a705:b9f1:ebc:16a5? ([2a01:e0a:b41:c160:a705:b9f1:ebc:16a5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-35dd04ca434sm13841259f8f.30.2024.06.05.02.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 02:09:31 -0700 (PDT)
Message-ID: <c527582b-05dd-45bf-a9b1-2499b01280ee@6wind.com>
Date: Wed, 5 Jun 2024 11:09:31 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] netfilter: restore default behavior for
 nf_conntrack_events
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, stable@vger.kernel.org
References: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
 <ZmAn7VcLHsdAI8Xg@strlen.de>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <ZmAn7VcLHsdAI8Xg@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 05/06/2024 à 10:55, Florian Westphal a écrit :
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
>> Since the below commit, there are regressions for legacy setups:
>> 1/ conntracks are created while there are no listener
>> 2/ a listener starts and dumps all conntracks to get the current state
>> 3/ conntracks deleted before the listener has started are not advertised
>>
>> This is problematic in containers, where conntracks could be created early.
>> This sysctl is part of unsafe sysctl and could not be changed easily in
>> some environments.
>>
>> Let's switch back to the legacy behavior.
> 
> :-(
> 
> Would it be possible to resolve this for containers by setting
> the container default to 1 if init_net had it changed to 1 at netns
> creation time?

When we have access to the host, it is possible to allow the configuration of
this (unsafe) sysctl for the pod. But there are cases where we don't have access
to the host.

https://docs.openshift.com/container-platform/4.9/nodes/containers/nodes-containers-sysctls.html#nodes-containers-sysctls-unsafe_nodes-containers-using


Regards,
Nicolas
