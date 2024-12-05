Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5931DFD8B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Dec 2024 15:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733411787; cv=none; b=bQmFw1JQp+HVYv4awtgG1qGhV8n8cs0sR4tZEerDtoDeTBPUx12uTqIEHm+3UjItoV1zklc0O1WjnKtuy2UOASezYCcOeNFwVDmGcmAnKpTSLOqRmVrORsg+bqsh76J1VpAu1d3oneYs57WFLlMncZbNpWBkEn4/koaTH1M0wdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733411787; c=relaxed/simple;
	bh=iM77qGeIh8E11wSG/JuOvn32bq1eD8WN4o1Kl4395UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWtAMNnfVNSO1CTR4/5PZMhwCiSwEUOmE3FZjn1z1CrcAGaXWgD+Y97C0PjveLDjCfNNWq4TWpLN3SXnYZ6wVdMWmOeqzN31crrfZLAZwwI+rJ2/w+kg6ki8r4h1Txj/a6iIg3hrf/SUFyIILiFzIxvF9ToTtQUkpNt8LeiJjVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RE6haTGh; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RE6haTGh"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-434a044dce2so11882285e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Dec 2024 07:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733411784; x=1734016584; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NNGzfvQhuEu1gaOMEO/yBEPHJg32agZ5235X4zgBXpI=;
        b=RE6haTGhV3liX7qr+Q2NMrC2oFdxqq9RKmqpf2zZh0pPGIzqXzmJy8g9WD4zw3DQ1z
         6E7t2pA1ZvUaVnZZ89wXDo1y1VK+Ad8lSA/WFi/7HtapicB+I05jxZOOg4z1aaYZhetu
         xsjMdy9x7TbgXd4L1JFh8Sr5JYOoRQC0wj4tUfcs5LncisLZumh9VrdvlgNsrUAfVYDD
         jY9UIIQkyomwR0i4ORe1C1Bgp3ilrITy2iXa++uxipk9U5sb0IgdINPs+mVm9XWkPxFY
         TK7zBeFrUZ/5u85HAf+F2sr8VqEMe8ao2VNc83OK4Qzp+Rohvesodde8sL6u0WxOACHU
         pezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733411784; x=1734016584;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NNGzfvQhuEu1gaOMEO/yBEPHJg32agZ5235X4zgBXpI=;
        b=jnhMw3P0LjyHjLSt9XB7fxLGAW5p8ZZA29hhM8wi7kqVfP8JZfBJ0mWgwmc6BP9ZQp
         N/raR05Nt5MId/5RWWCGuC+XW0GCCmX4/3VndSSHPs58svh5sarTUzIutUt5t03kwVW/
         Fj30RCtatdfVYUMNpwkqzOIAcg7Y2PzvE2I06Yt5KtvhrVzZUCQeEe2byYYGAL0t2fHE
         nUSguZLemmQVKCnUMmDLV6ZYifNuvEnBWdlBOmRvae1C4AxOJGxBQo4qblj2pFEVUFLe
         eu2iYpJUhSm2MDoVeOXFRu5Jdzl6XSOne4zbegvLLNhFuoH/pD5pn0zpNZqAYvCLNVNT
         ajng==
X-Forwarded-Encrypted: i=1; AJvYcCUjWzyu+C8v/i4Zl6990xhQYdFnlpHpndHmrmxfgeDpFWBEtCwwUMsDD2sM/1DpZs9sQu0B7wvBjM92uXjdKSc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMgn5Np+JGn8EQbNGURMrVay7Z2ul6rDZNOhaj+H4g021YW2vi
	nXR3BnNSIKCSGtgfJT45NGdXWXIhpcS5zLv5GLtM3zXM8rV93pquC3nTkHBAXYY=
X-Gm-Gg: ASbGnctpIgHLRuaXuy+3wLFYDnAdr1oWooNb2uqrG90MVWQy4sBU3gHO5WcKjYRiW4u
	d/Cw2Dr3mZZAnicWNPvFKF1p0vfUivuMxSCMHj0Vkpl2mWm6ZLGZ1Tj9h2+CoSmCDPaDR7ANnsJ
	Ae+cxMBbZ6HphD4Ito+VYjOmgjFcM6aCddejAIFmE4RR24dohF6WM9p4uBK6Es/ko1KJVhvrGrM
	BUnIBGvkZguYiYHt0dKWpIc96NxfEFYJPtkicGT8JpYyCZ6DTmX4Dg=
X-Google-Smtp-Source: AGHT+IFSHLZmIu9wSayLDq7ycBQ+roAuUKEE2td9KEmSdlWo6X+wsBQeahWHpQwNkTLYxu/aVfztNQ==
X-Received: by 2002:a05:600c:1989:b0:431:6083:cd30 with SMTP id 5b1f17b1804b1-434d09b2a75mr103448145e9.6.1733411783803;
        Thu, 05 Dec 2024 07:16:23 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861f59d651sm2179270f8f.44.2024.12.05.07.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 07:16:23 -0800 (PST)
Date: Thu, 5 Dec 2024 18:16:20 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	David Laight <David.Laight@aculab.com>
Cc: open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	netfilter-devel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>, toke@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, kernel@jfarr.cc, kees@kernel.org
Subject: Re: arm64: include/linux/compiler_types.h:542:38: error: call to
 '__compiletime_assert_1050' declared with attribute error: clamp() low limit
 min greater than high limit max_avail
Message-ID: <8dde5a62-4ce6-4954-86c9-54d961aed6df@stanley.mountain>
References: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com>

Add David to the CC list.

regards,
dan carpenter

On Thu, Dec 05, 2024 at 08:15:13PM +0530, Naresh Kamboju wrote:
> The arm64 build started failing from Linux next-20241203 tag with gcc-8
> due to following build warnings / errors.
> 
> First seen on Linux next-20241203 tag
> GOOD: Linux next-20241128 tag
> BAD: Linux next-20241203 tag and next-20241205 tag
> 
> * arm64, build
>   - gcc-8-defconfig
>   - gcc-8-defconfig-40bc7ee5
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> ===========
> net/netfilter/ipvs/ip_vs_conn.c: In function 'ip_vs_conn_init':
> include/linux/compiler_types.h:542:38: error: call to
> '__compiletime_assert_1050' declared with attribute error: clamp() low
> limit min greater than high limit max_avail
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> include/linux/compiler_types.h:523:4: note: in definition of macro
> '__compiletime_assert'
>     prefix ## suffix();    \
>     ^~~~~~
> include/linux/compiler_types.h:542:2: note: in expansion of macro
> '_compiletime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro
> 'compiletime_assert'
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^~~~~~~~~~~~~~~~~~
> include/linux/minmax.h:188:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>   BUILD_BUG_ON_MSG(statically_true(ulo > uhi),    \
>   ^~~~~~~~~~~~~~~~
> include/linux/minmax.h:195:2: note: in expansion of macro '__clamp_once'
>   __clamp_once(type, val, lo, hi, __UNIQUE_ID(v_), __UNIQUE_ID(l_),
> __UNIQUE_ID(h_))
>   ^~~~~~~~~~~~
> include/linux/minmax.h:206:28: note: in expansion of macro '__careful_clamp'
>  #define clamp(val, lo, hi) __careful_clamp(__auto_type, val, lo, hi)
>                             ^~~~~~~~~~~~~~~
> net/netfilter/ipvs/ip_vs_conn.c:1498:8: note: in expansion of macro 'clamp'
>   max = clamp(max, min, max_avail);
>         ^~~~~
> 
> Links:
> ---
> - https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/
> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/log
> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/details/
> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20241203/testrun/26189105/suite/build/test/gcc-8-defconfig/history/
> 
> Steps to reproduce:
> ------------
> # tuxmake --runtime podman --target-arch arm64 --toolchain gcc-8
> --kconfig defconfig
> 
> metadata:
> ----
>   git describe: next-20241203
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>   git sha: c245a7a79602ccbee780c004c1e4abcda66aec32
>   kernel config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/config
>   build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2pjAOE9K3Dz9gRywrldKTyaXQoT/
>   toolchain: gcc-8
>   config: gcc-8-defconfig
>   arch: arm64
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
