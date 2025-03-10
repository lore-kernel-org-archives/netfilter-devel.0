Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D344B1A7046
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 10:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741602466; cv=none; b=Xtb+Xq+NSm5nTrH6kpPFOCWhCiKpGQqzhuuHHtxQ79Q7v32uLojna910ugkJ1GamUzVhGlD1ygQIIq1oEgDiPUTcaS1tdDubIvtSub5jA5UUpQQ8FDYI2tsRICeohe1/MMg0UyNeZbF8/bQ+scN6wvjoaPrr44grkBUoX1jfwdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741602466; c=relaxed/simple;
	bh=Y7IPoU5/0Je2hcfwlJi7TnLUlwrdD8Fc/CtSVrvEp9Q=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uqchd2ANCK9Lhf4zxSh3i/xIWsniK879OcRl2C4ymyhHSlZ8lCib0JYaleAEVCeynLAzhT6OmMNsd759Iu1/rjyAbLSC+DaZ3XJnarq9os8Udf3LB94MnhnSV8YJuTMDxDEc+q3cwWLqDrqDTw2iQ1B6ikXR4ZQfychucx0HLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IkFOlY1c; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IkFOlY1c"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-2fec13a4067so6068764a91.2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 03:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741602463; x=1742207263; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p2E3BagLfXhN8DNmJmX8Z1E8Otbru9o703qCNEwjPwU=;
        b=IkFOlY1c4uA9xofmhJGbUFVFWMnSpFpT+gc/fd7VavNzhIeoEXNWjyNSCklrmwmBRW
         c14o5vNrA3hmqluV1ATbOYPAt0T/rxauRlzudTB3rgYxVoRXKN9CJW0SdZTAJBoId2F6
         0t9tfEqo/LfAigO//1rV+pPyH7S7gYymO5sfhDiOXnRQCzQKGvSgk1UtCiX1cBL/NTYl
         UniAUPUm7pYhdLVF8Nc4aNzF97g0lLz//FCprtryV6uVuqhQYuQa2BJ7Zw0X3uconolg
         jo2d5hm1/LeCboIaWl+DC9dia9PSVWlFXNUkBYi2Ug/Z9CuXOaNxOwqHfSly5VhRFSy/
         y2KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741602463; x=1742207263;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2E3BagLfXhN8DNmJmX8Z1E8Otbru9o703qCNEwjPwU=;
        b=rDbsjpw8u8fT4pEmMYHA0CRiu081rp7PZVI0zEje9jBWenYsvnvkpRtIPv+wbE1scC
         cGM784aSdLDLEsaeSy/ruxUZ5eS5F3ZUMvEhl9r3NekqPqlS2/m+9+2RyY5SBRNm2HWW
         WCZ4RGVnUeXPuMVztlw+2W0SbWCRLpGZNieiW+nsAZkmRe6ExXUV8tHkAlALjnhWPUoW
         vPlnss2idEvCSciG0bweWe42LaUUsaE1F6TigaJReuLM3MBOukMCYqW99d/T4s0A1vDD
         isgNBYJP5UfZTsYzfKxag4OhMHfvypQSeOrMyCI7VQJHoTADvHQzk9dIMJFLo5j9ZC4/
         s6VQ==
X-Gm-Message-State: AOJu0YyTKF3EOlvOH0+N0kKPCt1ESDqKP+/Ka9127PafFfNqWHbrRdMn
	STi5bc0FS2G0zesJ3Qrh56ZgzNYfmhWp8bDkXksjHMrxTbooMhGp5Q9wGA==
X-Gm-Gg: ASbGncvSR9ccntHrkPTMTyYQLUQJ6PhtpqbZrgVcWV21yxgaWbT8msM0GKpBbtyDBwY
	cpUViqWxKPXrUW+H9idHId3rIx/Y/bWymt/yaGktajOWtrMfAIBM4WBCBPkTejBx7zuGBkQyVwa
	UCcgbLtcSyGMDf1USNJggNySVXSWhjnSfxHQYxDT9tb0j99LS1Mqhk0zYxnKBaWIax4Xm9JE3p1
	LQfyRY9CpfuLfunHTZuZzKxyzMibSHSZiaqS8ZaKkPHrr9vupeMF2/BJwSrWDoKeus/0mrVGmLp
	+C5x4BXX9Dla85Xfeu3CuhkqAWQxb4erqdr6GDGhbIfpgI8jbnuIOwssexI0WafU4t6kod+Pfee
	weToHqk9/oXZboaNbJabHlA==
X-Google-Smtp-Source: AGHT+IGa9e5vnkzSQ8C2uhrBP5h9Z6I2L+3idpmUWwhIUr2xBF9EZ8Agl+HIJ23htWWWMDkrpwLtFw==
X-Received: by 2002:a17:90a:d605:b0:2ff:6ac2:c5a6 with SMTP id 98e67ed59e1d1-2ff7cf31844mr19192880a91.31.1741602462325;
        Mon, 10 Mar 2025 03:27:42 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ff69374622sm8531064a91.23.2025.03.10.03.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 03:27:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 10 Mar 2025 21:27:38 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_log] build: doc: Avoid autogen.sh
 contaminating the repository
Message-ID: <Z86+ml15+fqSVypD@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>,
	Florian Westphal <fw@strlen.de>
References: <20250310014658.9363-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310014658.9363-1-duncan_roe@optusnet.com.au>

Hi Pablo,

On Mon, Mar 10, 2025 at 12:46:58PM +1100, Duncan Roe wrote:
> After autogen.sh fetched doxygen/build_man.sh from the
> libnetfilter_queue project, git log would show
> > Changes not staged for commit:
> >         modified:   doxygen/build_man.sh
> The fetched file has had fixes, workarounds and speedups
> since the local copy was comitted, so get rid of the local copy.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---

Please ignore this patch.

Cheers ... Duncan.
