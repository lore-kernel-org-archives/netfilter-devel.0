Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760291F55FA
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756305983; cv=none; b=UmSp1jbnlW4vGoGCR6XJsyI5n3Opccsn3L+x+5wr1OxDC7jDHXJ0kZoxm3wbYHY5TVrlm1iO+JiWLvzzftIO5pjwr13frQ+6AEcX1kV/edka/EAu4NqCvjtk76x09AMFaC19PMqYRbDdQI1phgYeILrQZvZc2Bf9BS8iRroZ1wQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756305983; c=relaxed/simple;
	bh=YhHyFFKDGJXI+gUrsdtN2WWkI2fWCBmiybY7rGwfwx4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvWk19DV2l60Jn0mj7Drq2v1PL5hXNuiYKSIb2TniYa3vR4GtjmonIRYeoSiDnhdZxu8nGBPe59rsac7lvkxRzOIW7J9gSNVOhx5V0MnTsMJ1p62Cg8jWbfvD4QC02aEP/0NrU+kM2pDH6o3OEaP3WTe/L2ez/78ukiOv/ax7yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SZ1yFRVI; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=aJpD0agX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SZ1yFRVI";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="aJpD0agX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9A77A6027B; Wed, 27 Aug 2025 16:46:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756305978;
	bh=92uMguDluDsWD0B/K5org8m4fSehu8qtviYaJEfwZ4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SZ1yFRVIRjogcuYPdz1Vzs9WFLwpHHkn4racXCSmhFdYOoyghugyiTKOSCrXT0lee
	 xBma9FehJDLjK6fev0J/enVa4bYhfbzczYcSmll36B31HRwzuX9crXONrywTWZirGX
	 j9BYdLVs+0wXm34Sk7wo2oMD2nYXqSjJL4EChkM8kDFg8U36XkijHTOKDTFzd1ze2H
	 UJbM0rX0oAf74CRESWW5+vW7QUIrP33l1ZA6OpYPc4uqcc76ngfRcLeGn441Y/GleA
	 CLp9NXkLobpcseYhaVDoUC8plcfZNyWcQYeJ7mPqM7AQUfXdanQC3fzgyUvWNksilb
	 uo6XbygLCGR0w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 716B060264;
	Wed, 27 Aug 2025 16:46:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756305977;
	bh=92uMguDluDsWD0B/K5org8m4fSehu8qtviYaJEfwZ4g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJpD0agXKysLIwJoben5XSBz15WYDD9bY+SyZCafIURe5mpWVVzZ/piscKI8vci/v
	 gcM9iZlaNq8h8QzBROdbWypoiJ8RTc2jOQabaUXDjpDQuPfwkYFMDDrced6dEugX0v
	 rC9JvNiZmZV0ibm8/Z06zYRYPBuSE3mp62v5P0MhuPJ3hGZrJLzVVFc+hIA6i8kjLE
	 2WqknBX9wMXFnF8F9DTL2UJWGPi1qHc7yC1IIBgyR9pwx6JjcML+IvGE2U70aPialb
	 fR+6AEgPMcw/PCe72byMJ3+VTl//2dMWt9BlHOZsgE9HlHOVy+cnle8DTbdX8Wddai
	 LBeP5OFDLGEmQ==
Date: Wed, 27 Aug 2025 16:46:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jengelh@inai.de, phil@nwl.cc
Subject: Re: [PATCH nft] build: disable --with-unitdir by default
Message-ID: <aK8aN4h2XsLnTdT6@calendula>
References: <20250827140214.645245-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250827140214.645245-1-pablo@netfilter.org>

Hi,

Cc'ing Phil, Jan.

Excuse me my terse proposal description.

Extension: This is an alternative patch to disable --with-unitdir by
default, to address distcheck issue.

I wonder also if this is a more conservative approach, this should
integrate more seamlessly into existing pipelines while allowing
distributors to opt-in to use this.

But maybe I'm worrying too much and it is just fine to change defaults
for downstream packagers.

On Wed, Aug 27, 2025 at 04:02:14PM +0200, Pablo Neira Ayuso wrote:
> Same behaviour as in the original patch:
> 
>   --with-unitdir	auto-detects the systemd unit path.
>   --with-unitdir=PATH	uses the PATH
> 
> no --with-unitdir does not install the systemd unit path.
> 
> INSTALL description looks fine for what this does.
> 
> While at this, extend tests/build/ to cover for this new option.
> 
> Fixes: c4b17cf830510 ("tools: add a systemd unit for static rulesets")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  configure.ac             | 29 +++++++++++++++++++++--------
>  tests/build/run-tests.sh |  2 +-
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 42708c9f2470..3a751cb054b9 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -115,15 +115,22 @@ AC_CHECK_DECLS([getprotobyname_r, getprotobynumber_r, getservbyport_r], [], [],
>  ]])
>  
>  AC_ARG_WITH([unitdir],
> -	[AS_HELP_STRING([--with-unitdir=PATH], [Path to systemd service unit directory])],
> -	[unitdir="$withval"],
> +	[AS_HELP_STRING([--with-unitdir[=PATH]],
> +	[Path to systemd service unit directory, or omit PATH to auto-detect])],
>  	[
> -		unitdir=$("$PKG_CONFIG" systemd --variable systemdsystemunitdir 2>/dev/null)
> -		AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
> -	])
> +		if test "x$withval" = "xyes"; then
> +			unitdir=$($PKG_CONFIG --variable=systemdsystemunitdir systemd 2>/dev/null)
> +			AS_IF([test -z "$unitdir"], [unitdir='${prefix}/lib/systemd/system'])
> +		elif test "x$withval" = "xno"; then
> +			unitdir=""
> +		else
> +			unitdir="$withval"
> +		fi
> +	],
> +	[unitdir=""]
> +)
>  AC_SUBST([unitdir])
>  
> -
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> @@ -137,5 +144,11 @@ nft configuration:
>    use mini-gmp:			${with_mini_gmp}
>    enable man page:              ${enable_man_doc}
>    libxtables support:		${with_xtables}
> -  json output support:          ${with_json}
> -  systemd unit:			${unitdir}"
> +  json output support:          ${with_json}"
> +
> +if test "x$unitdir" != "x"; then
> +AC_SUBST([unitdir])
> +echo "  systemd unit:                 ${unitdir}"
> +else
> +echo "  systemd unit:                 no"
> +fi
> diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
> index 916df2e2fa8e..1d32d5d8afcb 100755
> --- a/tests/build/run-tests.sh
> +++ b/tests/build/run-tests.sh
> @@ -3,7 +3,7 @@
>  log_file="$(pwd)/tests.log"
>  dir=../..
>  argument=( --without-cli --with-cli=linenoise --with-cli=editline --enable-debug --with-mini-gmp
> -	   --enable-man-doc --with-xtables --with-json)
> +	   --enable-man-doc --with-xtables --with-json --with-unitdir --with-unidir=/lib/systemd/system)
>  ok=0
>  failed=0
>  
> -- 
> 2.30.2
> 
> 
