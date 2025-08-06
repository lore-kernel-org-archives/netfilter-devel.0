Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FAA233D9E
	for <netfilter-devel@vger.kernel.org>; Wed,  6 Aug 2025 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754499908; cv=none; b=aqI732tYgaxk03D85yhq6MzlUNxKGHqc9ytifdWfJd8RBhIJ70rdO85ztf3Um7pRz0U5RpB1YbXewMHMYLWAZdadQYbmxX7wiB7ea3aeRfawYSbJsNl86RlOCvh+j9G4EMHjF7VTHg9pSJDDydR7/io8Um7Zvx/sNtubD18pALQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754499908; c=relaxed/simple;
	bh=k406wlrizvIMcLqLv8ZCZNu5fnBrc/9JXGFd7cUAFJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P2W5aRpz2jhx0PVFf3kUDD+ByDgPC/LNgaWTz12vzc5lNUJaDCBUCbe9yTaBWKrl2gvYYKTOKU+rJnZ5u4K74Nsg50rJc+02/QyHyj61LhFnOYQVIQ5LDTNEdTM9/8XcRs+2ng2oWsq+y089cNPNYmepANGT6sz4EstPOL/PZUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XeuT4Hdo; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=M70pvBjZ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XeuT4Hdo";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="M70pvBjZ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 425F0607E8; Wed,  6 Aug 2025 19:05:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754499905;
	bh=q4iI5MFgh1DagvkrDjLFfEMfYG5YajIQa8uiXH7UbGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XeuT4HdoV5vEbQaiJZEIPKIV+OmGBuSQJu8OcSRWkVfoM98WK8Gd4sO+F7kcs2tZ7
	 WZSeA0IbckyyibGxoxB3vJbjQ2y/jFF1TDkpVIfv3c93orQBYUNLSrRikTGA5FYOLs
	 4VkZs+Fclm1kCJz/TeAkOH3SpsMW7bVJlVtMCWzWKzWMaCCthQmx1838hqsLwVDU9z
	 hIB0LzR1xiZ2NMLKzEIalMYk+EwIkFHc82fK/pTpyW0nOaCQId0bwaGHzPHnsCcmep
	 fidMAeIE1HES23MPq3MFUygSoqynZOzJres3XO9DSodzJhEvdzdh/Qc+pStcEJaOzA
	 ibJfs+5FRDsOw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3DB96607D9;
	Wed,  6 Aug 2025 19:05:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754499904;
	bh=q4iI5MFgh1DagvkrDjLFfEMfYG5YajIQa8uiXH7UbGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M70pvBjZgN1VGOfnzqyii9wfwTNxQnqk1hCGamhLHHVT5VNw1/5N9SVyPCF20EMHm
	 2VSRyz97cSbwsoAPYxl2J/o+J0VjEUE0auGQeEvByvy2yoWAvRZXMjRkPlfYnZuVAS
	 6WS+RS7vvW9WwRPVejijHSoxoCMY/kRI6ou7FBbKcilrcjaiF45X8Ho58+1yBMvuzP
	 s7GgSg0ULvwRs2Ycg8R6Ufbpmb1bviFW4tFmCHMGGYlua4MiPh8P1B5baRwLhxocuz
	 Ngm4zOu1ScYy++56sfK3qdEUYPndYca9muXqb54C66y8QgyHY0+X9IRcsPs9Vtpx1l
	 wJ7Je4oxKKz+A==
Date: Wed, 6 Aug 2025 19:05:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aJOLPp-1TWYfGCQF@calendula>
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250801161105.24823-7-phil@nwl.cc>

On Fri, Aug 01, 2025 at 06:11:05PM +0200, Phil Sutter wrote:
> Add the various testsuite runners to TESTS variable and have make call
> them with RUN_FULL_TESTSUITE=1 env var.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  Makefile.am | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index ba09e7f0953d5..4fb75b85a5d59 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -409,5 +409,11 @@ EXTRA_DIST += \
>  	tests \
>  	$(NULL)
>  
> +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;

I use make distcheck to build the tarballs.

I would prefer not to run the tests at the time of the release
process, I always do this before release, but I prefer not to inline
this to the release process.

Maybe we can make this work this way?

  export RUN_FULL_TESTSUITE=1; make check

so make check is no-op without this variable?

Does this make sense to you?

> +TESTS = tests/json_echo/run-test.py \
> +	tests/monitor/run-tests.sh \
> +	tests/py/nft-test.py \
> +	tests/shell/run-tests.sh

BTW, there are also tests/build/ that are slow but useful, that helped
me find this:

https://git.netfilter.org/nftables/commit/?id=0584f1c1c2073ff082badc7b49ed667de41002d9

Thanks.

>  pkgconfigdir = $(libdir)/pkgconfig
>  pkgconfig_DATA = libnftables.pc
> -- 
> 2.49.0
> 
