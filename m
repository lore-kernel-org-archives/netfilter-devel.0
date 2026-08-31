Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6F251354E
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 15:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788188550; cv=none; b=S443adxrCgFR8J7vUXaerGtBb7YVMG/T+z498bRaZvwXX0RVa1rH3xA7prBz3r8jQVU2HtCJ6zRSkpJ/CgS0EQyddqazusMxF1uo1bE85QtcBXSe8EYGs97gs67ZA0nUYG/VLl9BfEAFCsu4ydJy2PVb8xQeQK2XC5zZW1vvVk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788188550; c=relaxed/simple;
	bh=HSnboxbpsW90gxuWiGNXPGt0tEov7Ts+8KQUql8T92s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lwlFGA7kn1JsdX9DOQa5zRXDkal2uBZJnGPDMZxQIf0MmGEtCKZIXcWw3s1yX31QlfKjBQmwHvKDr1nUzlpxUoQ1Ak1xDg/yJ2hQjToHnfnHh09IY2npu/aQYGg0a8lfCpPE1DINvv9oSTeTPjftWFCa9Qj6LakXXiu7e9zuFdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org; spf=none smtp.mailfrom=blackwall.org; dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b=awTHj13U; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=blackwall.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=blackwall.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=blackwall.org header.i=@blackwall.org header.b="awTHj13U"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso28904415e9.0
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2026 08:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall.org; s=google; t=1788188547; x=1788793347; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vaQG3GXKeg9xt0fLDmCHU8Ok+VGDPEdyK+biHWwHWhc=;
        b=awTHj13UCTXJAv5sarpbV7hKNmgDmfJNnSVDLw/hBRuO9wCOAkmNC5BnwYY1YHu1tA
         C5fUPHsnw257LexITF/LPu6fDEsmWv7eHLwwFi++2VnBbCdK3+c5xx1IqvY5Y/lPDDTy
         v78etcfJkthRMik+yozvF1dZYOt5T0Oi/6vGZCGEbQ2Pt6aWnD/l2bHQ/M7n8NBmJjwk
         e7SHkWqFXIAOM3ze8Z1PwajNYIGwrLZxtmU2qie9xJxwczhUjv7pJXM6NXgWYMGqYlfS
         lYECLeYnIJF+nlkJUFghFiVYm2HcGGHwssvG3SCvfe6CNenvzDy4ke2y/WM6LVB67Cqv
         9H/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788188547; x=1788793347;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vaQG3GXKeg9xt0fLDmCHU8Ok+VGDPEdyK+biHWwHWhc=;
        b=LKl0xWGIEJPLJpJACKudyLwFGWC3YoHaGxq2VbrCQQYQ2dLNiqGJuHT4k6Tr+2AAWD
         8PC6o1e+AFeBbassmpiV8erOL1Gdh1dy3oRsuyIvMSD+SpUgiXEkNqZ7LSqv4ESKWrji
         g3MvbypF1Qs83a7zXcbpUbLbZhv06iBcK4M+wuOI9j6T96USoDlnrlcAc8AXNWreovaK
         Dd/vJm8xiC3EA4bEm+zd5mCrBcFsVR6ONwoEwQEXmZpZmE7/+wHqeLU6H0djMW1N2z3E
         CkxquUB0R5nVZl9sQrAXTSe9nwfaqvCJ0SrwmMwTDFALKgBp6NJjE7hG+niO0FizcGan
         b2TQ==
X-Gm-Message-State: AFuF++km/rN7TTvifAfYgOZ6rmxHczIg3KgUpmsJLzY5qagEsasjgPaO
	n7wZwxK9ff2Ts9EvUU4dXwGx4s0M4c7V++4EMYdN44W/lvAaHvHUOKI7i29biTioKKzZOqxohhE
	pwrllIEs=
X-Gm-Gg: AR+sD112hURfkXehG2jkdu6cSqP4MNzWcg3dYKRgGuYc6LwlbOV/O0SUoTjpXBNnX87
	eHBC0w2FN5a2npkVOv20WDc1wubws566tlTv1LWo5h2FhSYVI7PQNeoIKVK5j/etBZg1BkxJAyh
	112scVPMYCjy2DWTcMXa8g5LEmnFsb6yRnbS4FJyYdoHF+9dxVw4jeqW7FFYHPs+hXcraYp6gjQ
	smi97YDlY2Oy9k3DjJ5vaxoddxNGGAtuercnhEl4cWXQmp4i9GYnkY7AuiMQtrY1zN5HCyhlJ+Q
	bbcarWthvwOfUbQ1EC/X3ahCu/3N9wYbzdTMLxXZRCKdzI6AFirFsOkTPQNGlHh5h0NH8+j0qKE
	UzpGFanZCNQMldteqvHDnGJ+HbcSZXes1Pj2i1pdXwd5avkOLAl2RVL4bCDG2sA1MTxA93ZRlYc
	gns/DvFcpwewBPs6IS7UOLdXnhOfq6F8/a9f3JoZ7pFGXNZ0FIRMZoPqszFTC89WSQgBLwdBNAv
	Ye0QQmOHa5ekvB7trM=
X-Received: by 2002:a05:600c:699a:b0:49c:799a:177b with SMTP id 5b1f17b1804b1-49cd5312c62mr172627405e9.2.1788188547060;
        Mon, 31 Aug 2026 08:02:27 -0700 (PDT)
Received: from [192.168.0.161] (78-154-15-182.ip.btc-net.bg. [78.154.15.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cd53a4678sm123660405e9.13.2026.08.31.08.02.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2026 08:02:26 -0700 (PDT)
Message-ID: <4a8ab11c-48b4-475e-8a0d-99b4e22d9be6@blackwall.org>
Date: Mon, 31 Aug 2026 18:02:24 +0300
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 nf] netfilter: disable br_netfilter in user namespaces
Content-Language: en-US, bg
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <20260827181431.21720-1-fw@strlen.de>
 <347de812-4502-4f40-9d8e-028ec8ea35c1@blackwall.org>
 <apWUfi8yTkf1_nJ1@strlen.de>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <apWUfi8yTkf1_nJ1@strlen.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 31/08/2026 17:49, Florian Westphal wrote:
> Nikolay Aleksandrov <razor@blackwall.org> wrote:
>> The patch looks good, thanks!
>> 2 minor nits:
>> BROPT_NF_CALL_IPTABLES is per bridge, not per port. Also please update the
>> Netfilter section of Documentation/networking/bridge.rst that it won't work
>> in non-init ns and is scheduled for removal.
> 
> This sound good to you?
> 
>   The bridge netfilter module is a legacy feature that allows to filter bridged
> -packets with iptables and ip6tables. Its use is discouraged. Users should
> -consider using nftables for packet filtering.
> +packets with iptables and ip6tables. This feature is scheduled for removal and
> +not available in user namespaces. Consider using nftables for packet filtering
> +instead.
> 
> Thanks!

Sounds good!

Cheers,
  Nik

