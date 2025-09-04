Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6486B18DF80
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999561; cv=none; b=WzLEtiU0GzYDXuH22fXE9id68Rw21zymKlO5XWEtW3IZwvlvMrbWrso1hyEicQA8O2xMtMcleTVaW797/YkPDf2KmPLVSQZNKtLtK3t8WD1UkkCBt4IIGsGWmz1uMGS8rFtOxC24DZfEQYBy3ShKgu113LQa+SAg+g7Bap112YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999561; c=relaxed/simple;
	bh=kJIwPhNf4WBs1eNex2vbunCTt4IiBWg7OvuCPzzrrPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U8j+NvIycuryB+AZrtEVUZFbTTUIcLOmN/fwoiVREgGobN0kZAGFv7u914o2p9/s6RqR4yMTpOtgSFggILnwpHlT0S7lsLBlQUUQCMhckptUcgWem+ZSpkuh668g2SlxwuDov5XHP2de4H0W4xUAaWGg4UhIKnBM00J4C7Y5fHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GwH3yHLS; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GwH3yHLS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GwH3yHLS";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GwH3yHLS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id EEAD5607F2; Thu,  4 Sep 2025 17:25:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999557;
	bh=64mi0Xld4bzVCFdLxl82YFXxKOZaDyyfnPGKJmAiv1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwH3yHLSc4PnDtkLkn0BHgYGN0EgP7Wb+UycrL9oU3ldXy4JpMaHc0K/eZ0QuC/FB
	 6Mq+jDlX0k1D14ll98Lp8UesU6qbC09H8jjLhwWwYY7gz/8lwGdFy4FtYfBrINUs0+
	 IakOllA46YuQIh3mBHIL7KgWEQ4L1pJCPDsrWufOUu+sNp5gu7hH8B1RWGLMh1JrOA
	 1l6l3BiFoKMCLoAPRstnzWl2h9hhtG1dSXl28pVJBSWMTZhZj3jGf9S+/bwEIZLRFz
	 6sPgsiSXxTkhNMxmhzaMTDOnKWRz5Q3QDY7ksXYHSqYyatoTYh52ZwNqNkoPZXOiLK
	 Docx+dZAGnvzg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1CDA6607F2;
	Thu,  4 Sep 2025 17:25:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756999557;
	bh=64mi0Xld4bzVCFdLxl82YFXxKOZaDyyfnPGKJmAiv1Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GwH3yHLSc4PnDtkLkn0BHgYGN0EgP7Wb+UycrL9oU3ldXy4JpMaHc0K/eZ0QuC/FB
	 6Mq+jDlX0k1D14ll98Lp8UesU6qbC09H8jjLhwWwYY7gz/8lwGdFy4FtYfBrINUs0+
	 IakOllA46YuQIh3mBHIL7KgWEQ4L1pJCPDsrWufOUu+sNp5gu7hH8B1RWGLMh1JrOA
	 1l6l3BiFoKMCLoAPRstnzWl2h9hhtG1dSXl28pVJBSWMTZhZj3jGf9S+/bwEIZLRFz
	 6sPgsiSXxTkhNMxmhzaMTDOnKWRz5Q3QDY7ksXYHSqYyatoTYh52ZwNqNkoPZXOiLK
	 Docx+dZAGnvzg==
Date: Thu, 4 Sep 2025 17:25:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLmvgujSCAUpnnig@calendula>
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLmvS0buvv-vFyPx@calendula>

On Thu, Sep 04, 2025 at 05:25:02PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
> > With all test suites running all variants by default, add the various
> > testsuite runners to TESTS variable so 'make check' will execute them.
> > 
> > Introduce --enable-distcheck configure flag for internal use during
> > builds triggered by 'make distcheck'. This flag will force TESTS
> > variable to remain empty, so 'make check' run as part of distcheck will
> > not call any test suite: Most of the test suites require privileged
> > execution, 'make distcheck' usually doesn't and probably shouldn't.
> > Assuming the latter is used during the release process, it may even not
> > run on a machine which is up to date enough to generate meaningful test
> > suite results. Hence spare the release process from the likely pointless
> > delay imposed by 'make check'.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v2:
> > - Drop RUN_FULL_TESTSUITE env var, it is not needed anymore
> > 
> > Changes since v1:
> > - Add an internal configure option set by the distcheck target when
> >   building the project
> > - Have this configure option define BUILD_DISTCHECK automake variable
> > - Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
> >   with 'make distcheck'
> > ---
> >  Makefile.am  | 9 +++++++++
> >  configure.ac | 5 +++++
> >  2 files changed, 14 insertions(+)
> > 
> > diff --git a/Makefile.am b/Makefile.am
> > index 5190a49ae69f1..9112faa2d5c04 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
> >  ###############################################################################
> >  
> >  ACLOCAL_AMFLAGS = -I m4
> > +AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
> >  
> >  EXTRA_DIST =
> >  BUILT_SOURCES =
> > @@ -429,3 +430,11 @@ doc_DATA = files/nftables/main.nft
> >  tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
> >  	${AM_V_GEN}${MKDIR_P} tools
> >  	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> > +
> > +if !BUILD_DISTCHECK
> > +TESTS = tests/build/run-tests.sh \
> > +	tests/json_echo/run-test.py \
> > +	tests/monitor/run-tests.sh \
> > +	tests/py/nft-test.py \
> > +	tests/shell/run-tests.sh
> > +endif
> > diff --git a/configure.ac b/configure.ac
> > index da16a6e257c91..8073d4d8193e2 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -155,6 +155,11 @@ AC_CONFIG_COMMANDS([nftversion.h], [
> >  AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> >  CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
> >  
> > +AC_ARG_ENABLE([distcheck],
> > +	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> > +	      [enable_distcheck=yes], [])
> > +AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
> 
> Oh no, with distcheck-hook: this is a lot cleaner.
> 
> Please revert this.

Sorry I misunderstood.

You only applied four patches.

My apologies.
