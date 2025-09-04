Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06810224AE6
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999507; cv=none; b=dGGbCNw1Gr6YVsJx4iyMHFwnzXwqTgaknKdK8xaylTrVj5UifkSLgzKkarE/PzNWgSlCIqM2XRiN114TsEu4EDR10/d61EpV4eJERw8jmVXbvcCrH7VZab8SObMAjIxdZ4N0CSGmgqswbIGeTSfUPGuI2dt9Db1k0jzX4wVMMOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999507; c=relaxed/simple;
	bh=QJLhLkI1kCXXyuUjTdcNhdpiIlu1fWQ1pwr3voUBO2o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFJiAKY5oamQjhCrrnYJbm6lu+JlT4ZkOVHFakRYuT5dv9OgR6vhhhqIyHYFQCxhDMfcAhoxy6tj+a4So13eyXlgwnR0m8PfxP04NwpzwLQMauRSBgzpamqkTy/S7Y99A6N/J5MytY4P9jxmtkoUSnjQXIBduhhp9DL5U88031k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sny2ALDy; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PXqyZ1JJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sny2ALDy";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PXqyZ1JJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 6EC10608D1; Thu,  4 Sep 2025 17:25:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999503;
	bh=GXNc060tWFEyDwSFcEdgWXlSnX0+VzEuwb7zNEPGzRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sny2ALDy+F5epG+lneOnPTtBdyAW2TbuA4eTUlSUIrI70/qLr4HZQea1MwdUzncgA
	 11Y+nKX7M0O1i4de3nQ25KvGxPZMOv6ZphRuNAzSFDvnwDnbt9yuviBitADQms20lA
	 PCZM0vCPorU2BvLJCPFsn3R202uu+6caKW9w0bGGwkJNzkm4oMF5nUHgnzs0LfvvSQ
	 seNMC1S27gJfXVziokM7kyKM5GgcpPUCq7maekhYDEM+kjGQKBOLPGlIplNDA6fZbZ
	 AjrClpcTTVK8m1b1yl5MMm73zsmJ3WPN+bWzpL3VsfSHNkLU35HhkT/VpsdppuUt5C
	 mpXw0QPQy2ogw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9434760856;
	Thu,  4 Sep 2025 17:25:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999502;
	bh=GXNc060tWFEyDwSFcEdgWXlSnX0+VzEuwb7zNEPGzRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PXqyZ1JJ9Pegn22aVWFMzMv9NMp9XqVuggcfrWuOXNHB7AXzQldSl71Itr6O5hQL/
	 x+v7EkjyarcFc2RF+2HzQ9jteZZC7yzmqLH+xiSv9s67uDVU+bXiJNPPrjw75Oqys9
	 zDvjv1FTZAlRIVyFTc2/P9TIv8Ch5POPFVT7pSgAAuF7GuLgtc9njyMA6qZN9G2Hyf
	 cjygwr8IaCqxAUDnYauGamA53TTyPa6SePIapjzeTF6s3RLTNC4iLD50PG2fuJkMdT
	 ZPQfPYShnaCpvsokE2s4yHtwrWJKlDfyyDbGeTVYakR58l1swLnchkvgcjru9FMuXR
	 fGS34QtzDFAMQ==
Date: Thu, 4 Sep 2025 17:24:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLmvS0buvv-vFyPx@calendula>
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250903172259.26266-12-phil@nwl.cc>

On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
> With all test suites running all variants by default, add the various
> testsuite runners to TESTS variable so 'make check' will execute them.
> 
> Introduce --enable-distcheck configure flag for internal use during
> builds triggered by 'make distcheck'. This flag will force TESTS
> variable to remain empty, so 'make check' run as part of distcheck will
> not call any test suite: Most of the test suites require privileged
> execution, 'make distcheck' usually doesn't and probably shouldn't.
> Assuming the latter is used during the release process, it may even not
> run on a machine which is up to date enough to generate meaningful test
> suite results. Hence spare the release process from the likely pointless
> delay imposed by 'make check'.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v2:
> - Drop RUN_FULL_TESTSUITE env var, it is not needed anymore
> 
> Changes since v1:
> - Add an internal configure option set by the distcheck target when
>   building the project
> - Have this configure option define BUILD_DISTCHECK automake variable
> - Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
>   with 'make distcheck'
> ---
>  Makefile.am  | 9 +++++++++
>  configure.ac | 5 +++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 5190a49ae69f1..9112faa2d5c04 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
>  ###############################################################################
>  
>  ACLOCAL_AMFLAGS = -I m4
> +AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
>  
>  EXTRA_DIST =
>  BUILT_SOURCES =
> @@ -429,3 +430,11 @@ doc_DATA = files/nftables/main.nft
>  tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
>  	${AM_V_GEN}${MKDIR_P} tools
>  	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> +
> +if !BUILD_DISTCHECK
> +TESTS = tests/build/run-tests.sh \
> +	tests/json_echo/run-test.py \
> +	tests/monitor/run-tests.sh \
> +	tests/py/nft-test.py \
> +	tests/shell/run-tests.sh
> +endif
> diff --git a/configure.ac b/configure.ac
> index da16a6e257c91..8073d4d8193e2 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -155,6 +155,11 @@ AC_CONFIG_COMMANDS([nftversion.h], [
>  AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
>  CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
>  
> +AC_ARG_ENABLE([distcheck],
> +	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> +	      [enable_distcheck=yes], [])
> +AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])

Oh no, with distcheck-hook: this is a lot cleaner.

Please revert this.
