Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E06B256D;
	Tue,  8 Apr 2025 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744136365; cv=none; b=oWg+zDIKXus2i8/k/w/cgZzrYjxOPw1fRIdOIkOz+J4fs2rfKiIrWFm4Gy9qZQNm3mU0BQn8qSXoXNyr6XWYCZ/lgAv8vq/sMkrxXGtH85gBCqsJCJ9E+taPpJB6mzFHCv+5qCqL71u8sis81EtKtrM2rHMPfQfxnF9ohqHYwBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744136365; c=relaxed/simple;
	bh=DhCoX1Om1GBukViz1M++rrfKjQ++dzj41kr7PwORWeQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gIgk6wV7BKe+ayACRvq8rF5dFN6MyHMBbVYSFPl1ihxE8VpKoze9SUmHhEvRDoGQhsvdKpsYeivCDW41j9BJuOyv4kUu2TYuzc/gtD2alRHk9UYKCkl7c7cQF9whQqvgr09tKXByFfIqX9PsoqVrgi0QJxpbUduAzqqrxqYdFmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJQak5Vp; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJQak5Vp"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e614da8615so6004890a12.1;
        Tue, 08 Apr 2025 11:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744136362; x=1744741162; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zNORPrNxwkx4cAl/1tA8h4G6Spk016FAoAzvRh/FTVw=;
        b=aJQak5VprQOhFmjn5het4Eg0VSdRKbEFed36OOxORkFyFl9y0n7rfrhwmbA4qLmApf
         7RgPTBa2LEkYHIG9+7nuqk01klsvJWuSelpR3H/1Vax2x1YnL5hJZ2J5nbHOmV27lEw9
         C13Rb7wDPARm7LyH726Cw1FtSPBwTp/OYOevSPHKYYeunKjsjLwLmBaUpWCyNvm9okuD
         BsMw0Y6S+FV0hdQb9gRAuWGTzKIaJmWx2z92AQAh3sXUeRf+GsqFn5KHOgLHQlHhblof
         U3Lkb3vIQFMhHbxwYanmhHJcO5PttGSRO76fZLEeLRx31mApcBR7L5RRX7avHqWEVV9T
         MI7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744136362; x=1744741162;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNORPrNxwkx4cAl/1tA8h4G6Spk016FAoAzvRh/FTVw=;
        b=JQoSt/YW+O+gFMb0svb4qFyYjex291rc/AZQfcVYiG24FCn6fYFtFfet122A79KDWA
         bq0eVXv+MqHkIsjnIEP7vFNnYydoj5T88gYvLe1U+MoLTOl2t6MGq0Txw5iNltKQRct/
         7MLU4l7LXY8siiBiS765QyhuCP/cEbAebQWsFxpKzguLR+r67QA7Xvv3KUpGPwyVRqbt
         2/OTLSLmtgEQojL9Q97E0OaO/9p4gDT614jW5d5VHEUcm7LYotRPayCce4xo0fW3s7Tb
         MmoNDYZPb6va1OfWQxlEuXZUZjp9/XRWjIuX1SoUx57ecRMXOTKk0dEnY8ZYgMUeoOQK
         p+ew==
X-Forwarded-Encrypted: i=1; AJvYcCVyGYWMEzLCCJEyj17sAo1e9g0jUpS33YaHSh1z6JnWzTkUhab0+wVitjJZL0mzNgoKGPXC3Ce2QYh3tHUYOUHM@vger.kernel.org, AJvYcCWA6h2SBOQXF2oY/QSla/bSgaH7+rnhrocgbh2A13YzI31AAsnkHX8lcVCYTlj+UBnRyRynHxMr@vger.kernel.org, AJvYcCWAvk47lNgQob4oTpWImy5yQVnaVtS4erBWOQTvM+E3i7l56XKS2+4E09hETqorw3o87ZgEprrAk66lkZZXIoI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVCXznd6h4R3cV+axFhsCQ9Daq4Qrd2e6loHz8p0fnb3yid5RG
	VoWAnf6L5sk/1qB26jgElONRPBGxHc19oA7idoFjzZH7oelIe3qR
X-Gm-Gg: ASbGncuTvdOznnU5IcNJ2cbyN1FKnS7p8bpPj5Dg1dOmuCCjkc9Ioa1uf/Qpq5R6U8v
	UxOq7+Z2KEb+k5hMCmapevK/RN4Cqc5qdQ5NtTlvbtWuIZKbypEe+gWbqGqbHBfoQU5U9tXaImt
	esYWpwzjuwLKppfN/toYcesfQAN88NcG1RNta5QpfuUgU3HqZ4TE/kx/rhVaK21Lro43KzE5022
	Daj72bpdr72L7bZeuRbfosrfEl4t46reTh6xE3J17/0ertz6MWzVabCe+X+88ycZp3NFwWrNrCH
	1XUWxwuglzDwyvIL59/Ms+U69wJ0xftXDsu5KX1JXZLcrNj39lmSbPBhgN7Z9uWg7CHZP2+fLdO
	jOaNkJMfDAGTjdAB5Y3Kn3rSPCn0xn0WAFOYG6peANLwR6qQ9mm+KgBT13m41b8/lXMg4qH7O1l
	iTh1ZOMWzU7XRynU4e+V0=
X-Google-Smtp-Source: AGHT+IG0N32kj2fVGY5ihLdMxtZfKugGqgZa3VNsCrizgxD5kPyBIBtPb74TE3tQ523G5LlfE7p24g==
X-Received: by 2002:a05:6402:354a:b0:5e0:752a:1c7c with SMTP id 4fb4d7f45d1cf-5f1e3ca8f81mr4067983a12.1.1744136361630;
        Tue, 08 Apr 2025 11:19:21 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f087f0869csm8306969a12.38.2025.04.08.11.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 11:19:21 -0700 (PDT)
Message-ID: <5ef69d2b-8be6-4d3d-bf1c-d6bdc9a21d95@gmail.com>
Date: Tue, 8 Apr 2025 20:19:19 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 nf-next 0/2] Add nf_flow_encap_push() for xmit direct
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Simon Horman <horms@kernel.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20250408142425.95437-1-ericwouds@gmail.com>
 <Z_VIpa9SP05rsW18@calendula>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <Z_VIpa9SP05rsW18@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/25 6:02 PM, Pablo Neira Ayuso wrote:
> Hi,
> 
> Please, one series at a time. You pick a good target to start with.
> 
> I already provided a few suggestions on where to start from.
> 

Ok, I view the patch-set 'conntrack: bridge: add double vlan, pppoe and
pppoe-in-q' more as an added bonus to the bridge-fastpath. It is quite
separate from the rest. I would consider this patch-set as low priority.

May I suggest we focus on patch-sets:

'Add nf_flow_encap_push() for xmit direct'

and

'netfilter: fastpath fixes'

After these issues are addressed, only then it makes sense to add
patch-set: 'netfilter: Add bridge-fastpath'.

Thanks

