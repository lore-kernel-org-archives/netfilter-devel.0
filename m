Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DD22417F2
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756824353; cv=none; b=MOe0Bm4X3NUTha87woQhKguDwplgOraox20jE54J5BdPA1Z7Cr2iOZwNsAIMxbtGGTNAO+W96x/Z6Gyv9QgrEc7JMT7Wa7Hz1wturCw5+Vv5CYLJ5FXE7nZ4xsKLTvfztXmnnHY2BT0bOWvt7JjSu3T3WewVUbiT8LvTgA90JvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756824353; c=relaxed/simple;
	bh=biRJlKlb81XoyudLR3aHqnq7GEKKyEWcNJSK6akobqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bRiJJ7tyxn+VWGvvAS1ia7V+2qvBHOLyq/F5wxkgvjV7rmb8FzZmn99k8PWJR++ceOex2tpjso5ryXXb8vn1PwmkZaoCK5YTws0wyidInYbmG9MsWZulLdc1ncj2H0kSikQ08J/WJAXgoYPe6D0aNT7IXjmkm3cYBi6MIxkajQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DxyXGqi8; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qLuuuVfv; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DxyXGqi8";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qLuuuVfv"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2490D60712; Tue,  2 Sep 2025 16:45:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756824349;
	bh=LC/wttymgYXLSAtJE94wi3jR4TlFcontajVTYcp0j6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DxyXGqi8dhlDp5/aeSznbq79jlJ05adwy61Ccs/fe3Qe1shIoLRPTdLbfQX+++CfQ
	 xMLL5aejnLR+qIPv1q9gAshxi9jcSQcOnippqrwDHB/S0OkHPXjJMVzq9OZfFwuCnh
	 /rWNEhz8SwfyoLnN2a2lYA4Wu6hHz1Rd6v9e2Yjp2XdSuHITEiqD0npr+T4J5eoJOj
	 TXSeRSWr0v+UAnvnVJP5KaCKPr6OPyYDVayL2bklwKXuxbH7FScv4746GNFgz3rW90
	 PA0Nn0UvqpFT1NmxdiXUkFsYtrlJN5jZ3MkvtBnp4wwjTiOdf9tU+HJOVm5a4n9RYw
	 TXinQYYzpeLyg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B2DF60712;
	Tue,  2 Sep 2025 16:45:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756824346;
	bh=LC/wttymgYXLSAtJE94wi3jR4TlFcontajVTYcp0j6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qLuuuVfvxtc8cnzWdGvb/4zFbveL/iQOAh+aqY7JYhRWzcjcUnwFoSFr+psMC1DCh
	 3V3cxtyp38dzLNRojSyptO71n+oyRPcFdUao9O/2mK1HF+UM4zAwJNp+8H+6PEECGS
	 2QbpIwcAf+hGVaiKHQt5AnDg8FSabBnmiuyiCTh9Fy52K5ltywQxdyaEPyb49n1xQD
	 M5c8/0mS5jBJehKC/mQLhGvRIdo76dwDIbxWym+GcQfBv2Os5ayUkIW1FtSesg/k74
	 9eqlZx6TR2OZLNYI10mq/wj7HAuvAXASifjztaCtnU0l2f4UR18xseTQ86BkBLFAHA
	 V1nU9gefrTZFA==
Date: Tue, 2 Sep 2025 16:45:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 7/7] Makefile: Enable support for 'make check'
Message-ID: <aLcDF_OEWQ5KmkZr@calendula>
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-8-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250829155203.29000-8-phil@nwl.cc>

On Fri, Aug 29, 2025 at 05:52:03PM +0200, Phil Sutter wrote:
> Add the various testsuite runners to TESTS variable and have make call
> them with RUN_FULL_TESTSUITE=1 env var.

Given you add a env var for every test, would you instead use
distcheck-hook: in Makefile.am to short circuit the test run and
display SKIPPED?

> Most of the test suites require privileged execution, 'make distcheck'
> usually doesn't and probably shouldn't. Assuming the latter is used
> during the release process, it may even not run on a machine which is up
> to date enough to generate meaningful test suite results. Hence spare
> the release process from the likely pointless delay imposed by 'make
> check' by keeping TESTS variable empty when in a distcheck environment.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Add an internal configure option set by the distcheck target when
>   building the project
> - Have this configure option define BUILD_DISTCHECK automake variable
> - Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
>   with 'make distcheck'
> ---
>  Makefile.am  | 10 ++++++++++
>  configure.ac |  5 +++++
>  2 files changed, 15 insertions(+)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 5190a49ae69f1..f65e8d51b501e 100644
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
> @@ -429,3 +430,12 @@ doc_DATA = files/nftables/main.nft
>  tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
>  	${AM_V_GEN}${MKDIR_P} tools
>  	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> +
> +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
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
> +
>  AC_CONFIG_FILES([					\
>  		Makefile				\
>  		libnftables.pc				\
> -- 
> 2.51.0
> 
> 
