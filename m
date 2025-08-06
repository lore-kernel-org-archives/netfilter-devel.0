Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A361EEA49
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2025 09:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754470849; cv=none; b=XOHNV8dNbeW5jUxac4MrmmH2ekniz4/iBSVffGnhT3ezrAvPraXNyHu71tB8QhOG9uENiSmF8cXlND4gqI2OeRsJaDvRm0Erk6BC86A1k+fQz/GKD1FuZ5k1TIAhouuIBde23CuAvrWG4soR3aEtwgWs5zIoWJiB19OSx0G2nJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754470849; c=relaxed/simple;
	bh=Rjfi1UQGZ6KFWUZLLSfDhUXwb/P+ihESd3Zl3g/srsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qV2LuhJAs4o/56fZ/Qj4amdRsGKPMxgHu7UzGMYyOeOzNs7GoYZvW89FSkZ7k2z9rokAREJf9g9/Fd6nAEM3ygsLvY5vXKZWRw02XCW4vlV+HEJ0imo0V839GA6yaSoXsw/AZayVDaqDRHj4e1+LCNJPtHb6P0Djs2L+grkpwUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=RfpTy5cz; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="RfpTy5cz"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-458bd315a76so2379195e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Aug 2025 02:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1754470846; x=1755075646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=AS20fYcg+JBveakkFyf9zBX11AsBWg1BQHTkOuw0RRo=;
        b=RfpTy5czTuwbyBW0bn1OIt0BipEiVy3nfa/0n1wun6AebS0/ue/N1qXO8ci0h1ou6e
         8JflSI3a/ex2A+OZjV3RarIszQuygIlrYkOqaV7gx21Q0J+FwHovJnsYkF0jgEtzkqIs
         oGYdH9q4kNuIXLSG3LvglFQyiCb1yrZ2MEkDFJ/GTPXv1YYDG34B1vqv9nBuCgmyPVsb
         bHXAha9Js/hkK33htYrcOcEWpip2TAVdQXgNMYHrp65nFZOpl7XJjKvILZznZ3iQj6pE
         iKH9IQpc5qwuhDFi4qr8y3/DFOImioXlbXZohhTq/IZmGzHFFXFOgaCcnzHGA/mxuOcB
         cUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754470846; x=1755075646;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AS20fYcg+JBveakkFyf9zBX11AsBWg1BQHTkOuw0RRo=;
        b=jvgA+PavQWwcno/xe2vEbSy6WEP1d1Cluvqo8IxNV+PhkWkWm2DyF9CbwFN577yYbJ
         GedsrnmdfE+JP4oEFIiztjihb3xYlbaXFRr7qfEcUZsk/4XN9tOPTMeAIFHsHlwaQz1B
         NHI4ZD8FzNoy2nHFNj1q/HqXjQnFBsg5qcT4EQOZmrNHN/4zkWKx+hntA6TziB8ngZlv
         EijvcbyJoMEUtB+mOJIHIgGuxcoMg2EMjkYpc7rKaNCyOaEWhH+/lxXVJ9/wM13kW9ug
         85X7+85uJ8wMFYNj1wB8AdO+TrCmXkVDNZmZhPJckcQGIQmr1enM14wm2+ezmJ1gDs2c
         948Q==
X-Gm-Message-State: AOJu0Yx5HCRkM7W/lKcaZfkh74La/BVc2wir1vKiN98LpYrOkkU280zA
	sYDCvZOEa5nWt950Xf29EorhsQH0wI5oaJbgOMpq7X1hREEFJSbYbx5bXqhjf601c88=
X-Gm-Gg: ASbGncvWGr1TBmjCypGazuDTVi+A3juLOCt9NDlLUqicRMPXBeMt2OdSR6+tUNXz3eN
	9gGy2Y4lHpB0UqqWwPG1AKEkXSHv+F2tPGvUk9R32qIV9fnvLNwxGFDLbcpV3g2h/lveJGJIqEw
	5zy5dVODsbcT6YYgTUVo/hFx5kbUVH+aWG5ctx/Om5gToA3+XVg8KGZs2yJOM9rOfk3u9Inc5ke
	SXMa+6CeIQZbwqCwrhJyWO0oZqkkPyfqfk1dV909Y+fcM8SEiD/5t1c0TUxAbdj0ExOd90INOOy
	hT0sdgn8QvMm+a+JU7s3CD/CPQ5oI56xQz0UVRLsrYNJNZZC1MJPlCvswYKmlY8b8D02rYGJNma
	FQcaU5t5xde2CHb4i6sT7VN4rphANUbECkrmvLNctoa7rgTs1qkSZRggkgmzwJyQdu4Fn5JiYjG
	h0C8xi4w4HPQ==
X-Google-Smtp-Source: AGHT+IEhb+BggPN/CI2vNE/LgY/nbRZn/giDOrRTOMSN8GN+JdcTwX5Rvb8hvEEs/+aNZlsz8gDb0g==
X-Received: by 2002:a05:6000:381:b0:3b7:98bc:b853 with SMTP id ffacd0b85a97d-3b8f41cb986mr744335f8f.9.1754470845857;
        Wed, 06 Aug 2025 02:00:45 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:c0b8:f5d8:24be:e371? ([2a01:e0a:b41:c160:c0b8:f5d8:24be:e371])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458b8aab8c0sm171537685e9.19.2025.08.06.02.00.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 02:00:45 -0700 (PDT)
Message-ID: <0e6f765c-89a1-4628-9234-3d89425c3ca6@6wind.com>
Date: Wed, 6 Aug 2025 11:00:44 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: When routed to VRF, NF _output_ hook is run unexpectedly
To: Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
 David Ahern <dsahern@kernel.org>, Florian Westphal <fw@strlen.de>,
 Pablo Neira Ayuso <pablo@netfilter.org>
References: <f55f7161-7ddc-46d1-844e-0f6e92b06dda@average.org>
 <2211ec87-b794-4d74-9d3d-0c54f166efde@6wind.com>
 <7a4c2457-0eb5-43bc-9fb0-400a7ce045f2@average.org>
 <ed8f88e7-103a-403b-83ed-c40153e9bef0@6wind.com>
 <c5909e04-35c7-4775-bd17-e17115037792@average.org>
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Content-Language: en-US
Organization: 6WIND
In-Reply-To: <c5909e04-35c7-4775-bd17-e17115037792@average.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Le 24/06/2025 à 17:27, Eugene Crosser a écrit :
> On 20/06/2025 18:20, Nicolas Dichtel wrote:
> 
>>>>> It is possible, and very useful, to implement "two-stage routing" by
>>>>> installing a route that points to a VRF device:
>>>>>
>>>>>     ip link add vrfNNN type vrf table NNN
>>>>>     ...
>>>>>     ip route add xxxxx/yy dev vrfNNN
>>>>>
>>>>> however this causes surprising behaviour with relation to netfilter
>>>>> hooks. Namely, packets taking such path traverse _output_ nftables
>>>>> chain, with conntracking information reset. So, for example, even
>>>>> when "notrack" has been set in the prerouting chain, conntrack entries
>>>>> will still be created. Script attached below demonstrates this behaviour.
>>>> You can have a look to this commit to better understand this:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8c9c296adfae9
>>>
>>> I've seen this commit.
>>> My point is that the packets are _not locally generated_ in this case,
>>> so it seems wrong to pass them to the _output_ hook, doesn't it?
>> They are, from the POV of the vrf. The first route sends packets to the vrf
>> device, which acts like a loopback.
> 
> I see, this explains the behaviour that I observe.
> I believe that there are two problems here though:
> 
> 1. This behaviour is _surprising_. Packets are not really "locally
> generated", they come from "outside", but treated as is they were
> locally generated. In my view, it deserves an section in
> Documentation/networking/vrf.rst (see suggestion below).
> 
> 2. Using "output" hook makes it impossible(?) to define different
> nftables rules depending on what vrf was used for routing (because iif
> is not accessible in the "output" chain). For example, traffic from
> different tenants, that is routed via different VRFs but egress over the
> same uplink interface, cannot be assigned different zones. Conntrack
> entries of different tenants will be mixed. As another example, one
> cannot disable conntracking of tenant's traffic while continuing to
> track "true output" traffic from he processes running on the host.
> 
Sorry for the late reply. I'll let netfiler/vrf experts answer these points.

> Thanks for consideration,
> 
> Eugene
> 
> ========================
> Suggested update to the documentation:
You can send a formal patch for this.


Regards,
Nicolas

> 
> diff --git a/Documentation/networking/vrf.rst
> b/Documentation/networking/vrf.rst
> index 0a9a6f968cb9..74c6a69355df 100644
> --- a/Documentation/networking/vrf.rst
> +++ b/Documentation/networking/vrf.rst
> @@ -61,6 +61,11 @@ domain as a whole.
>         the VRF device. For egress POSTROUTING and OUTPUT rules can be
> written
>         using either the VRF device or real egress device.
> 
> +.. [3] When a packet is forwarded to a VRF interface, it gets further
> +       routed according to the route table associated with the VRF, but
> +       processed by the "output" netfilter hook instead of "forwarding"
> +       hook.
> +
>  Setup
>  -----
>  1. VRF device is created with an association to a FIB table.

