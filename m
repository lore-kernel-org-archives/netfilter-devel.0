Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F21E8348;
	Tue,  8 Apr 2025 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744138569; cv=none; b=HrG1AA5L2hzCDvxRo5y1YfgbHY8npbYEjeQ2oUk9H3ZMy0cionPhOT/uIqPvusYWSGKIQhNIhZew7R2cCPbpWJS0B4ebQ2KsPUt5YaPl/XKpwecHQRFCW/Ssi31Vbq055pYxl4QBFf7aSbvPcFvRI5vden5riyz3CULWS2NHsBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744138569; c=relaxed/simple;
	bh=DXhjXBkNql5ejtVG8/vipeyKelZRQVr0LdEjFC79IoY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZVHfuCXfuE5SCzwFFsBN7dLUKeixIEUmVqKaNGyZzpQ1a5ErmChVmuXILDcZF9h1X1yJBvmqC2K7xa6274hXjLBCMpnfO5FJHuYKcIiypnZanHrREKthDI3gn4/fMb8WQA6y57LlZdlUGSH5eH89ubdn7P9SsnOxyvmdnitLHhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ivqrggEb; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ivqrggEb"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ac73723b2d5so1223894466b.3;
        Tue, 08 Apr 2025 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744138566; x=1744743366; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2RLobX/NWAoO5M1cQ5CruPiTUctk6qBhH262aYUiAZk=;
        b=ivqrggEbHrKqLvopVNhtYtQQUE6Sn9r9Tfhc9Zb8wboSZkUMmeWpyc11s4NXv4az+v
         6+ZEde9gXJksz7id0nRcrXocn1ZAOTR7T+pjxLJcYMTxEZu71B0JRt8szJKzr0R/oKhU
         9BorKAlbxSD6IV8S+WRrIvXoOVAlNBmcn50gJHw5SBsH2YGnit7CC5G2PZZU3iaNN04A
         eqaFqeIa4rzXBHkmWZ6JGg/3eHwB8sFuwqfCweR3pqU5OoboTXI1tAYMM4zTw/55uoG4
         pRV/pGkF8wiP1fH/ibg8z73vHZAot7B5YpYKZQujYatLfeNOTa7Bn3ME9qIFOsnL0eZF
         S47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744138566; x=1744743366;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2RLobX/NWAoO5M1cQ5CruPiTUctk6qBhH262aYUiAZk=;
        b=DpmkyRJyIksnArnc8J1L1P9EOZDsoPcs0PeofB+TLpzo/9HDKvCi0AU1XWnStdjWZI
         TExhAj0XGi6BkngC0nejGgsPYll2GF/WcpXvXLVKTSmzFu+V+4V259WgYosyCq8nEqEH
         7ZnqaPOgeWnAFERdCaZxF+HbTfA8j/8nHwZ9ERoBwKZY4xWj9qV4x60YRaTpAaLGz5LE
         3kb2h8Q95Ox4kS1afzXLuWPmzxzdXuQOJj+3GENNLT/V585jVpXe3l5Z+AtIuwItI+1q
         hJR8MdK80PMlOEdfgPHOiswnlT/X2vNEMJyQTLHXKyOmogH9PCO/uMCJ9q8JBjCAjyOu
         QFHA==
X-Forwarded-Encrypted: i=1; AJvYcCUp1jEeYfJIQlv5HEcawS5w5v1lw9Dc4ivnwl/y5Xpp8ZiTBPhKkqZKivyiT0EmIKKhyYJIejo=@vger.kernel.org, AJvYcCXex8A80eAH/g5QNr1GDV3N4PCBSYMuEPSgdssKRwtvh71uIhIohLNPsrwZbUzpbVYRG9wXi7FqACVv+H3AHzDZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyCqqvt4FXsTD7F+s4EvV6+yNddZ2OQ0ux3puNSFv9WZCA+NzbV
	eCn8/GB5qmFKK6+A1kVvqp+Byu870WdMDQbJZKFqJr+i4lEYukhW
X-Gm-Gg: ASbGncs0tjTivSTQJsYaDdguUy5G11Pqw3ZX5hUz5UuInOvULLnTDrYbyYmSp9hHsNx
	TKRwhbQ8Smw2rj28ppU+TYiaEISQ+BPT3qGnKde6ky0Gy49Hrp64eDWJITDVIZgvBZmMyvlJS5h
	dbIJwXC5vnnUQHKCq4mFYxwVJNaTybRb5C8gfS344gT+fKKiKjzF6ixliQ9eepNuuzGtGGrTGLm
	MELj/WMZPPY2jKz1GoxGSm2yddOAudoXKCRSYvtIYqk1FuE+MBrWbPcgTXEyLQ+JXjAnwzRhXnT
	qMun2yA/sA1+b8tDrx7uEGSwNhcgslO0ugmENIIE38sWMDSWVRm1WdxBePWKUVYs7mYGWZ4aWsq
	yJD3C4buE6+akcY2xZJyjM8H0Da26jayXw0qjRHZ+nrgkBaDZQU90+HvziNeBPAS8ZynzCgTVPL
	oLEN/cdb7fOZHbzypOq3I=
X-Google-Smtp-Source: AGHT+IH4mGT3NxwOkcdKKPFRdtQ3Hu0EU2qa6tlBAPh/EvQuYNLT/psRLecdEUxrQodG3a9UegN+0g==
X-Received: by 2002:a17:907:7f8c:b0:ac7:c5de:97f3 with SMTP id a640c23a62f3a-aca9b7462a9mr26773166b.45.1744138565924;
        Tue, 08 Apr 2025 11:56:05 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7bfeddc88sm964443866b.76.2025.04.08.11.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 11:56:05 -0700 (PDT)
Message-ID: <41eb417e-60ea-4e1d-a293-fac362d52403@gmail.com>
Date: Tue, 8 Apr 2025 20:56:04 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Nikolay Aleksandrov <razor@blackwall.org>, Ido Schimmel <idosch@nvidia.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
 bridge@lists.linux.dev, netdev@vger.kernel.org
References: <20250408142619.95619-1-ericwouds@gmail.com>
 <20250408142619.95619-2-ericwouds@gmail.com>
 <20250408163931.GA11581@breakpoint.cc>
 <fc34e774-e264-492c-9ecb-20eaf7bd87e8@gmail.com>
 <20250408184806.GB5425@breakpoint.cc>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250408184806.GB5425@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 4/8/25 8:48 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> The thing is, single vlan (802.1Q) can be conntracked without setting up
>> a zone. I've only added Q-in-Q, AD and PPPoE-in-Q. Since single Q (L2)

I forgot to mention only PPPoE here.

>> can be conntracked, I thought the same will apply to other L2 tags.
>>
>> So would single Q also need this restriction added in your opinion?
> 
> I think its too risky to add it now for single-Q case.

Indeed, this would be a regression. I will look into only adding the
restriction to the newly added tags. However, it is inconsistent, which
is the point I was trying making.

