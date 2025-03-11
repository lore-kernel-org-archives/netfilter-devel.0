Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB1A1EB182;
	Tue, 11 Mar 2025 08:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741681361; cv=none; b=M7wI8d2hE6rwBXR2MzcFJ7TrC9jdo/lREwEhdEZBrfYJkpLAuFgcBflE0rhfWrqbLXry2dab8dvJFbUuDKj4vd4F8V1si7BT2bHOujFN1E+/4EolfimeClDyCNw2jTe02NJGTzKO7ST7oO3q3KtU1TCg070b35C8xfJSY1KvcRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741681361; c=relaxed/simple;
	bh=UFNNBRGR/6gDpDCHdvz/G/BUoK1siPWwMWJCgE09xoA=;
	h=Message-ID:Date:MIME-Version:Subject:Cc:References:From:To:
	 In-Reply-To:Content-Type; b=EKcB2N8oOmOeCHtpMThcfXpxzBNxWwlgbBEE+RG+GSuQxi7Wav7u0TfQLOoPjXMiCKDmuvwLr6p+tWYEG8PRdQLYchM01crCltLQ4aful1Do76zXNsOiGdVwZM534b21YWLqT2hbC7/vt03bL9uH2VbQGuYrZ7vFAV3yW+nhv2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k4eUPaWD; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k4eUPaWD"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so6303663a12.3;
        Tue, 11 Mar 2025 01:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741681358; x=1742286158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:to:content-language:from
         :references:cc:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UFNNBRGR/6gDpDCHdvz/G/BUoK1siPWwMWJCgE09xoA=;
        b=k4eUPaWDRKJBzVskNX5h82cXsdLBnSenekb1UNAW/A8CvxQps2GlZv98gAcXFtxs5g
         dmeoSaBum1KDmpi4uL2pzxi8qcA0GA6RSwquXeOj8YPtUwsPqxl+JpjWakY/+STpNEPN
         Tmt2sGeMZFfN6mRO5taeNsupyuqU2FO0bSQ7NVQX1pKhzOGvgT/rGc+imxGpbXMgiFlC
         geG8V05mvE6dpwOkiHxM+AldAXGivkETSZpwf2/fDCCPVTuQScoB/4yRwEN+BHHVEFe8
         tP9jqH8HTrFLUegg4lHM5iGKAQwoZPl1huRl78fp/4CHn/PONZtFtEx7bUSNsKUBtWhi
         PIUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741681358; x=1742286158;
        h=content-transfer-encoding:in-reply-to:to:content-language:from
         :references:cc:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFNNBRGR/6gDpDCHdvz/G/BUoK1siPWwMWJCgE09xoA=;
        b=hkHso5/esosbIwSRE3eaUHPiybudIRJOnT2BVRQt9gFQ7wSYgxDQf16mXbHslpENMw
         S0i9VeheYEPHBESm9AS+AUVKYru3afIAWDeD1JjQEzvcV2yq9ZgTWolW8ZY/KzQr3L3O
         FMacQ8a7u8fRah42D0EzGPnN8S8yxoK6iURNjm70qy7N3gYtmFNCYy38EGQRxmJhcrCP
         jD9ghbZpLAewIfqvlGy4KCWji8j/fxF0RV9SI3MwbZFMevsLw8xeN6PjjFyr+pBGeDi5
         SuoGx/2eCY5UMenGbqqQZ6CELlTSkjOq71uhKBhl/zdZX1fkgVNYaEVMEyzS0I9bp8y2
         y0/w==
X-Forwarded-Encrypted: i=1; AJvYcCUK+HHfeqwlRx1+8Dciib1FayTsZQb5x8hL+HRDB73GR7+vyDRLSttSib4jGWYoxdj1TaGf6CXdG1yFWLzILe3v@vger.kernel.org, AJvYcCUtoLQ+Rq+SYTdMXVnOA9lLKrUReCThYup/L3nECppvF0Yso/WCXLgHgQ9Y98I7ldHwHEn2PsADOP1RpyIE@vger.kernel.org, AJvYcCV66mtRXXgegyI1LtxqXrlYzgam7vOOmXABCbzlGMQQX+APl1rX/rdA8RVW9YvIg5CJQIoQNffVr8p+N691Mlc=@vger.kernel.org, AJvYcCXcRLYYTvbLGekhXNUyg86zJZ6wggoZOxGbmDfKu0LDUAWQF+rmZGpZaKLqaqF/dRTiqK4DvWI3@vger.kernel.org
X-Gm-Message-State: AOJu0YyheTMxVW27y29nMWdJKWxHP+DYwqm+bftxXGVjgVvO3aDdSXaj
	eUZsbWfFeZsMFmRtoiDzQLubZMYwyXovUw4ILzniQpOpOnca4IBB
X-Gm-Gg: ASbGncvVwMMjs1DriPqYuLdQh5HSnOG0mnVEVTzPhwWM65AiCR3zd1xIlCOgFG4kiLI
	cEWpLK+GLGZbjbiXadzY1AIZ1MGtUUAgVfbNEzArUEeefPyt0mWZg/4FoVi7RQmvsCiqhKdnGZI
	Kt0Y31lPtBKoMc3PpNLn5Rg86TZocjOtKMb718mJfx0KPf0wXD4Dxv7s2GTMpmocq28iaiqCDWS
	mPpzjo+5QWiGhP8upiTqEGdADiqqb+f9n14AOYwA+1MvDrtR/9DgnDu2jJRIszf02TBnFQ7vxhb
	h5qGeKefcqnzxB7iPt2vpv53cuSLPvK/sH7CDDgZv5qvNv5c8aUEMnfuio6zA+3gUGP3pHGZE5r
	RMgtJxPppxUs9wjXV/aSC/aCrcW9slcgHDrkJKKNAPrMya9KGe5Z0A5f0z4PMqPl0GJGG4wIEGz
	EyV01wEGUk8wjA2BVXr6c=
X-Google-Smtp-Source: AGHT+IHVZMV/MbyEPPexb7J3WeNZYZ5CxjZ+VTFaUFe+rZPsUq+igvni96NJQxPQP+jJ8ClbAvXlfA==
X-Received: by 2002:a05:6402:4302:b0:5e7:7262:3bb6 with SMTP id 4fb4d7f45d1cf-5e772625471mr1960367a12.29.1741681357815;
        Tue, 11 Mar 2025 01:22:37 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c76913bbsm7880931a12.78.2025.03.11.01.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 01:22:37 -0700 (PDT)
Message-ID: <897ade0e-a4d0-47d0-8bf7-e5888ef45a61@gmail.com>
Date: Tue, 11 Mar 2025 09:22:35 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 nf 00/15] bridge-fastpath and related improvements
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 Nikolay Aleksandrov <razor@blackwall.org>, Roopa Prabhu <roopa@nvidia.com>,
 Ivan Vecera <ivecera@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Simon Horman <horms@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Ahmed Zaki <ahmed.zaki@intel.com>, Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
References: <20250305102949.16370-1-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/5/25 11:29 AM, Eric Woudstra wrote:
> This patchset makes it possible to set up a software fastpath between
> bridged interfaces. One patch adds the flow rule for the hardware
> fastpath. This creates the possibility to have a hardware offloaded
> fastpath between bridged interfaces. More patches are added to solve
> issues found with the existing code.


> Changes in v9:
> - No changes, resend to netfilter

Hi Pablo,

I've changed tag [net-next] to [nf], hopefully you can have a look at
this patch-set. But, after some days, I was in doubt if this way I have
brought it to your attention. Perhaps I need to do something different
to ask the netfilter maintainer have a look at it?

Best regards,

Eric

