Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367D2156237
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728892552; cv=none; b=Z94OI1BtCuYGMsEYzqqxJmY47JEJgyhTrWnHN3GfRlbSQ02x/RwfFk/FM1aG91b7UX5y5IBZJVMuG+4DKgC0BucY775ULA/V9BYZ/2Qcg1ykThIfCf9V5balbCAxnIDqpeeJ0ZXFVsJZJugmSYrYRdYDvMJuywQAVsvbiyMMzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728892552; c=relaxed/simple;
	bh=2blHwZ5iKYltvZFtkEpNOfbggv5V9gHjWe9h01bnZRk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USEA8sKZmakNA/ZbpkEoaknAhGe9lQbS6L+SW7NXdIyKqfNtX0z8IxLD6/BqIpw2hvK5g4AxkqruDIuubV9L2O9gqZLngUfIcZnVSn44W/9U2N1WRO2KLfscPSFYT0V4KhrSiS/ehNx7SBjsLjjps6vmy3euxiKVCXyl5SnXvDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k1RT3H6A; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1RT3H6A"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20ca388d242so17208975ad.2
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 00:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728892549; x=1729497349; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BrxFI44ivxwiYNuyfe+wy4NTTcN96kdwbsBBYheUiEk=;
        b=k1RT3H6ApO6mRzaS3JS7aS5ooP33teqDahj0sC+mGKDD7mHvGLWSN3rDV0gzN3TuK9
         gjqiL2hBtdyQWTnz47xm2QfgzpxRMLTMhRs7QgMchhWt1XqBTAGklskPtP3lB4O0FdxD
         RV3QCqna3hjHjAlQoVJbd6PIg8jEfqqaZkXdNf0AqqSPWL+AiPOCgN9YuSqiz7ur5+vP
         fk1aOpuHJwZac8okIZLylveoi4W9PRYefeAd+ULfAh6VSTAwSK9eYaEi2yc2V3tacUSl
         6WDOaNtLaS6DUnnMclPYQneNJ3dRq03VfSBTgIztypgdawbj3HdwEGYBEHAWUdmbUoxU
         LgwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728892549; x=1729497349;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BrxFI44ivxwiYNuyfe+wy4NTTcN96kdwbsBBYheUiEk=;
        b=p2JL4lVnddkk0IOejdV80egB4ENcQuf0szvxPu37TPCQ/6mWVcYmbt1VXVa+XjYZFh
         sBknb4VOq4EwZFTZ/2VldWZ2cQODk0xXs2052kimtfBJ0GnfZQoGWtCPaim09V8m0nqH
         UVqiTgYoXycuTCVPfIhVM7Jhv389S9g0hqrzq6IOzV+9LmvINSS1+ZCqQIWhJW0eKBWh
         zCra2PwM02NQsc2X4kmayM2OJ1VgCjRHo0eQ4hZvNo//LR1gOaOqBKz6iR5PbRY7L7uX
         tbF2EtKJCW2pKgi8F5kmhhI89i6Sy4JlgXwGfWew6LzfZbEW9YKbxOQCy7wr1ntPgVTW
         ecTA==
X-Gm-Message-State: AOJu0YzGHDz6GUVywEjPbP2shw8CxwW4LsZqskz+OZEJWp8Yy9W3GW5p
	sU0x9XJhxQSjIiyrsm87JoAs2jZSfZW1AOb71gyzcoGqm0+1lbd7J8qaWw==
X-Google-Smtp-Source: AGHT+IGLbmti06CFb67hQ83uTH/ihop3fcn/O+2q4XkMDZ0oIQF5A/foGbpsi7qDLxUtNAA46U8isQ==
X-Received: by 2002:a17:902:cec2:b0:20c:7485:891c with SMTP id d9443c01a7336-20cbb24ca76mr96669635ad.54.1728892549441;
        Mon, 14 Oct 2024 00:55:49 -0700 (PDT)
Received: from slk15.local.net (n175-33-111-144.meb22.vic.optusnet.com.au. [175.33.111.144])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8badc3a5sm60981225ad.39.2024.10.14.00.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 00:55:48 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 14 Oct 2024 18:55:45 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwzOgRoMzOiNfgn0@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20241012171521.33453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241012171521.33453-1-pablo@netfilter.org>

Hi Pablo,

On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> Make it option, after this update it is still possible to build the
> documentation on demand via:
>
>  cd doxygen
>  make
>
> if ./configure found doxygen. Otherwise, no need to build documentation
> when building from source.
>
> Update README to include this information.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  Makefile.am |  2 +-
>  README      | 10 ++++++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile.am b/Makefile.am
> index 94e6935d6138..6ec1a7b98827 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -2,7 +2,7 @@ include $(top_srcdir)/Make_global.am
>
>  ACLOCAL_AMFLAGS = -I m4
>
> -SUBDIRS = src include examples doxygen
> +SUBDIRS = src include examples
>  DIST_SUBDIRS = src include examples doxygen
>
>  pkgconfigdir = $(libdir)/pkgconfig
> diff --git a/README b/README
> index 317a2c6ad1d6..c82dedd2266a 100644
> --- a/README
> +++ b/README
> @@ -23,6 +23,16 @@ forced to use them.
>  You can find several example files under examples/ that you can compile by
>  invoking `make check'.
>
> += Documentation =
> +
> +If ./configure reports that doxygen has been found, then you can build
> +documentation through:
> +
> +	cd doxygen
> +	make
> +
> +then, open doxygen/html/index.html in your browser.
> +
>  = Contributing =
>
>  Please submit any patches to <netfilter-devel@vger.kernel.org>.
> --
> 2.30.2
>
>
Why are you doing this?

I don't like this patch because:-

Distributors typically use the default config to make a package. That would mean
libmnl would go out without any documentation, hardly an encouragement to use
it.

It has been on my todo list to bring libmnl documentation up to the standard of
libnetfilter_queue and libnetfilter_log (use build_man.sh to produce acceptable
man pages; make more use of \returns, \note and so on; add required #includes to
synopsis; fix grammar etc). Default would then be generate man pages. You would
have ./configure options --disable-man-pages & --enable-html-doc.

Cheers ... Duncan
