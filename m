Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C012C08B0
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Sep 2025 09:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757411845; cv=none; b=TJ29X8YEv9068V/Ze6XBAgBJ4YWqsTobIYHjL6t64pu6GQ1BTjunBCKrOYH3xb+K33iglkMDHhALiCf1bARDGzVIh96E/mV9T0vLGGz/t1UVbK2WT3AEg2gyIf+cxxfMnRLdBZLklCFZNLn3Xj1k9YncwXEZ0i/UdbwnRG2tkTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757411845; c=relaxed/simple;
	bh=tCmHOaPVnBtBZdOydEgj7NALAzrNfYk8cH8Beh+alKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AYhKNkxwY7EPkzu/hCpimwk47yGciUMkPwtoqn/eXY9rySTy9VjhPOT3xWp095OaFLgRICs2wpaA1XMJMBK/W5HM+4Dvqlbfx85hSI3cggYNtzRNe1vEDXgGS9l3A3vO9qI8GRkGMPn3u8pVD4J1iWUbTU+e5e3s+KPu65CSZjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bbm4i3km; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=bbm4i3km; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bbm4i3km";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="bbm4i3km"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 913A66067B; Tue,  9 Sep 2025 11:57:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757411837;
	bh=4x1w6XCGcyCyRpAicyrMghf3BcBt7X/LEDLWtlVGU/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbm4i3kmf68WEcULwGDHWjmdgJSuCJ9QcV4F8zJBHhfuzTSBRBAmx+WlbBllCqjbT
	 GHT/rCOy1E9RhMB469NinJHMJWZAfG8lDHR5TTueo7g3wIpK5Cs1pu0eIdJXiNWDy5
	 N5cEZ/5O0iIdgKXBH8ImrNy4nNwqW5pfZwpwiIYO4NDMiIg6Pffxt8OBpiUvsyX0/p
	 IXkRkUmkqsFb+A4CnOR85qu7PUS9MOm+jm6QS/3ZBicxEq7Q5RMH0IYA7/JDmu3824
	 u5PV9Ft2w6SVf7INLQbSu5tym/Y9m2eYnFllZiso0/yx8nY3wa3rIzxjArlHgiy5dz
	 c0JZzrAy6g0jA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EDC8C6067B;
	Tue,  9 Sep 2025 11:57:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757411837;
	bh=4x1w6XCGcyCyRpAicyrMghf3BcBt7X/LEDLWtlVGU/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bbm4i3kmf68WEcULwGDHWjmdgJSuCJ9QcV4F8zJBHhfuzTSBRBAmx+WlbBllCqjbT
	 GHT/rCOy1E9RhMB469NinJHMJWZAfG8lDHR5TTueo7g3wIpK5Cs1pu0eIdJXiNWDy5
	 N5cEZ/5O0iIdgKXBH8ImrNy4nNwqW5pfZwpwiIYO4NDMiIg6Pffxt8OBpiUvsyX0/p
	 IXkRkUmkqsFb+A4CnOR85qu7PUS9MOm+jm6QS/3ZBicxEq7Q5RMH0IYA7/JDmu3824
	 u5PV9Ft2w6SVf7INLQbSu5tym/Y9m2eYnFllZiso0/yx8nY3wa3rIzxjArlHgiy5dz
	 c0JZzrAy6g0jA==
Date: Tue, 9 Sep 2025 11:57:14 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] Makefile: Fix for 'make CFLAGS=...'
Message-ID: <aL_5-hgKWiF877pb@calendula>
References: <20250908221909.31384-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250908221909.31384-1-phil@nwl.cc>

On Tue, Sep 09, 2025 at 12:19:09AM +0200, Phil Sutter wrote:
> Appending to CFLAGS from configure.ac like this was too naive, passing
> custom CFLAGS in make arguments overwrites it. Extend AM_CFLAGS instead.
> 
> Fixes: 64c07e38f0494 ("table: Embed creating nft version into userdata")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for fixing this.

> ---
>  Makefile.am  | 2 ++
>  configure.ac | 1 -
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 5190a49ae69f1..3e3f1e61092bb 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -156,6 +156,8 @@ AM_CFLAGS = \
>  	\
>  	$(GCC_FVISIBILITY_HIDDEN) \
>  	\
> +	-DMAKE_STAMP=$(MAKE_STAMP) \
> +	\
>  	$(NULL)
>  
>  AM_YFLAGS = -d -Wno-yacc
> diff --git a/configure.ac b/configure.ac
> index da16a6e257c91..3517ea041f7ea 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -153,7 +153,6 @@ AC_CONFIG_COMMANDS([nftversion.h], [
>  # Current date should be fetched exactly once per build,
>  # so have 'make' call date and pass the value to every 'gcc' call
>  AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> -CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
>  
>  AC_CONFIG_FILES([					\
>  		Makefile				\
> -- 
> 2.51.0
> 
