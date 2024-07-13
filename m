Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535312B8B
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jul 2024 01:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720833383; cv=none; b=ERL7z8QP07Fz3oQ7DnERKMDhKj/1GcYrEg0em9COWZvmvu0mZDVjGx8og3B5MsbO/FBAvEsjRIRjVZlkGr7iMHpY6aO98Z/lzWQRffkmKD3QeKbf7DfJr2vkiRRd1CjkO2Gb4t8wSKP8AcaNydUdNKNivmEirxAh1o1u/r/IhIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720833383; c=relaxed/simple;
	bh=asqfrdooWVFA+Kg79tbm7ogOLgraq2F/VvKwagSnlLs=;
	h=From:Date:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YeqmAp8GCr9ITOEi+4dN+E/HtTj/YLxDT9VR/UtNqzlpkwhm/9I8J9aJ531tK0jqCMjtleEftq/floNzGqeiS6GjwvGy0Zt3t88eFxNj7oSPxedUnDNgM3/evMbMyJADsu2rdYAQT7qOiPqEFsy3O/ZN2rRoLSedAeGwqVYDSmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SqTssZ5R; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqTssZ5R"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-25e3d8d9f70so1451131fac.2
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Jul 2024 18:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720833380; x=1721438180; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IOVc3kNZHYMT7kN1z9l4ICRlAaN6ls+t8nbrfpoJ+sc=;
        b=SqTssZ5RQrribckCFxgk1/h5P4QRMU36WCvPaBfTW26zSGFZVWJxukmSL79N72GSxR
         drt+eFVoqBuDASF07fIulEanOnOwI6l7hSIyBhe7c0DJSPZ0755k2oi7+12QRId3UX33
         vz+RS+0yb8r2tljPUZmz0xaijox4R4beWwKUt5G9O8gSRZynYLzgCJIiYzT3ZcU3YUCx
         kFM9Cp6nSLeM0vhIMajKZdPI4m0aOQinwrpIarL6HxnU95oy1IowxIB8sbWxGfAyZbIq
         JpjMNLbPfOM+FLl7eZNlEjPx5uvUBrfyMdzJ/QzHmJ4Vc2Tg1xg6VOipNspovEmKQD2S
         pVCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720833380; x=1721438180;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IOVc3kNZHYMT7kN1z9l4ICRlAaN6ls+t8nbrfpoJ+sc=;
        b=eukjoGA8mkftVWo+r5STiwdtXIdmrP8WGAeiu8r4uWaIdHvp8P1ovGCC+o4tdKBc6z
         wV0jW2sL+E5YAsaro81tj2x2kEWkCkyrQheIZSUwGV+ttWS+3yuVBdS8N9svI4IetUAV
         HR9MTces+E9pK0FQnxhSxjBdv2NlVBIygcxm/ZzwxuLtzoBkTmNPaLShK07YjP5HbDtu
         iMv6mP73P7i+dpX1r05IF0JkynXbO5t1LATKkrGWmUVG5QHqaeDzdz631/LgqQJ1vEq3
         xwzYadW84ARHNZUfdAOhZOnZcGKtOrMcZTtQ/6Mp6y7JEzwI8/Om9Vyb3bJ+s1eBiaCY
         aQPg==
X-Gm-Message-State: AOJu0YxDWZ8b1LGkeJu1H22L1prl5bubyPbqSMen5zBfgsBrohu8k9aJ
	x9njuifC16sJ7/0ov+tLC2SMnIv1e54ebApJQ6Jy7woiISiEM3s6imXMoA==
X-Google-Smtp-Source: AGHT+IEeh3TnG0ftRiiku6GJITtQLEHLCRIy2cYIgiHMtikTcjj8VuCOTxckcN0O0MkxgVmK2KGzyw==
X-Received: by 2002:a05:6870:ac0c:b0:25e:24a0:4c96 with SMTP id 586e51a60fabf-25eae784929mr9178035fac.11.1720833380122;
        Fri, 12 Jul 2024 18:16:20 -0700 (PDT)
Received: from slk15.local.net (n49-190-141-216.meb1.vic.optusnet.com.au. [49.190.141.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ebb7845sm169482b3a.79.2024.07.12.18.16.18
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jul 2024 18:16:19 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Sat, 13 Jul 2024 11:16:16 +1000
To: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] configure: Add option for building with musl
Message-ID: <ZpHVYBPB5rPAIw6k@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: netfilter-devel@vger.kernel.org
References: <20240712123859.1108496-1-joshualant@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712123859.1108496-1-joshualant@gmail.com>

Hi Joshua,

On Fri, Jul 12, 2024 at 12:38:59PM +0000, Joshua Lant wrote:
> Adding this configure option fixes compilation errors which occur when
> building with musl-libc. These are known issues with musl that cause structure
> redefinition errors in headers between linux/if_ether.h and
> netinet/ether.h.
>
> Signed-off-by: Joshua Lant joshualant@gmail.com
> ---
>  INSTALL      |  7 +++++++
>  configure.ac | 10 +++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/INSTALL b/INSTALL
> index d62b428c..8095b0bb 100644
> --- a/INSTALL
> +++ b/INSTALL
> @@ -63,6 +63,13 @@ Configuring and compiling
>  	optionally specify a search path to include anyway. This is
>  	probably only useful for development.
>
> +--enable-musl-build
> +
> +	When compiling against musl-libc, you may encounter issues with
> +	redefinitions of structures in headers between musl and the kernel.
> +	This is a known issue with musl-libc, and setting this option
> +	should fix your build.
> +
>  If you want to enable debugging, use
>
>  	./configure CFLAGS="-ggdb3 -O0"

Niggle: Since at lease gdb 11.2, `info gdb` section
'4.1 Compiling for Debugging' says this:

> |   Older versions of the GNU C compiler permitted a variant option '-gg'
> |for debugging information.  GDB no longer supports this format; if your
> |GNU C compiler has this option, do not use it.

I suggest `-g3 -gdwarf-4`. This enables gdb commands like `info macro`.
There is also a `-Og` option. Personally, I'm not sure that I like it.

> diff --git a/configure.ac b/configure.ac
> index 2293702b..7f54ccd1 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -77,6 +77,9 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
>  AC_ARG_ENABLE([profiling],
>  	AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
>  	[enable_profiling="$enableval"], [enable_profiling="no"])
> +AC_ARG_ENABLE([musl-build],
> +    AS_HELP_STRING([--enable-musl-build], [Set this option if you encounter compilation errors when building with musl-libc]),
> +    [enable_musl_build="$enableval"], [enable_musl_build="no"])
>
>  AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
>  saved_LDFLAGS="$LDFLAGS";
> @@ -206,6 +209,10 @@ if test "x$enable_profiling" = "xyes"; then
>  	regular_LDFLAGS+=" -lgcov --coverage"
>  fi
>
> +if test "x$enable_musl_build" = "xyes"; then
> +	regular_CFLAGS+=" -D__UAPI_DEF_ETHHDR=0"
> +fi
> +
>  define([EXPAND_VARIABLE],
>  [$2=[$]$1
>  if test $prefix = 'NONE'; then
> @@ -277,7 +284,8 @@ Build parameters:
>    Installation prefix (--prefix):	${prefix}
>    Xtables extension directory:		${e_xtlibdir}
>    Pkg-config directory:			${e_pkgconfigdir}
> -  Xtables lock file:			${xt_lock_name}"
> +  Xtables lock file:			${xt_lock_name}
> +  Build against musl-libc:		${enable_musl_build}"
>
>  if [[ -n "$ksourcedir" ]]; then
>  	echo "  Kernel source directory:		${ksourcedir}"
> --
> 2.25.1
>
>
Cheers ... Duncan.
