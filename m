Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA181E2834
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 15:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756999944; cv=none; b=HiTUGriL19YzCPre2tDnmY9BZ7iy3DstsJYj6O0EVCUSSLomejx2bVXkxNfVCdvnHXCoe6P77l9fMTavsRMfYLywAssKyvnMjTH/oJPwIwOSmrKShTLWCLjPvzd3m68jEFRdzCNXdm/TIz6Y93NBp1s4b2alag2vAscbtXCAHPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756999944; c=relaxed/simple;
	bh=rAl+okBMneM+srr+Ojw2wX0SvKPq8H30UsshuqJCtoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KN2ZAuuZ+eiFd0XUKsjxaWLvzUArYeE2wgkQj/L5/Z1asgOkCUeccq/trecSaOHIGdFLqvLhNpofw2eQw5l4kWr4DySUjMwEMZHhPghN6mgSiqI8J3ojJiyubyenGJcXQGEKvsAaTBZVOdJra/dghgz2cfNORzPKZxpy27DXl7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=XuNujSaZ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="XuNujSaZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EFQygIbtnaixIuqYqeWAo5j/kCJSJiNHd41hzth5fYc=; b=XuNujSaZjRJjYpbInCYsJE9pkT
	m4OII1o/YfiLJ/jjP4fFAeSsHIH9KjzkwIo+AxWFhZpx3bAlyYXdshHa+NunXbei7Id7r9ynmmN4c
	jYNxguMoajW5OBrQRJD9PIlYjKM0H+s3+pgKI6xfYDVwCuuCXgWG2FJtJRzYinyKK+f95IrPmcPkW
	pwWKH4AopIwvm/IUpcwOlj9EUe99LuCge7CYq+wPmyAFaP+Slve/nHgmwqT0T4SpwbLccN6pHqNah
	x4Fhcx4Zh2fZOnrcD32fK7d8aSKdQ46zaxeqkvOz0oOBSvV/zmdrOwKnQwXF0sUm0M5Mq+QIB1DYx
	mxWomqBQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuBwg-000000002bn-0BV8;
	Thu, 04 Sep 2025 17:32:18 +0200
Date: Thu, 4 Sep 2025 17:32:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLmw_YuwTsqeAsvT@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
 <aLmvgujSCAUpnnig@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmvgujSCAUpnnig@calendula>

On Thu, Sep 04, 2025 at 05:25:54PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 04, 2025 at 05:25:02PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
> > > With all test suites running all variants by default, add the various
> > > testsuite runners to TESTS variable so 'make check' will execute them.
> > > 
> > > Introduce --enable-distcheck configure flag for internal use during
> > > builds triggered by 'make distcheck'. This flag will force TESTS
> > > variable to remain empty, so 'make check' run as part of distcheck will
> > > not call any test suite: Most of the test suites require privileged
> > > execution, 'make distcheck' usually doesn't and probably shouldn't.
> > > Assuming the latter is used during the release process, it may even not
> > > run on a machine which is up to date enough to generate meaningful test
> > > suite results. Hence spare the release process from the likely pointless
> > > delay imposed by 'make check'.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Changes since v2:
> > > - Drop RUN_FULL_TESTSUITE env var, it is not needed anymore
> > > 
> > > Changes since v1:
> > > - Add an internal configure option set by the distcheck target when
> > >   building the project
> > > - Have this configure option define BUILD_DISTCHECK automake variable
> > > - Leave TESTS empty if BUILD_DISTCHECK is set to avoid test suite runs
> > >   with 'make distcheck'
> > > ---
> > >  Makefile.am  | 9 +++++++++
> > >  configure.ac | 5 +++++
> > >  2 files changed, 14 insertions(+)
> > > 
> > > diff --git a/Makefile.am b/Makefile.am
> > > index 5190a49ae69f1..9112faa2d5c04 100644
> > > --- a/Makefile.am
> > > +++ b/Makefile.am
> > > @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
> > >  ###############################################################################
> > >  
> > >  ACLOCAL_AMFLAGS = -I m4
> > > +AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
> > >  
> > >  EXTRA_DIST =
> > >  BUILT_SOURCES =
> > > @@ -429,3 +430,11 @@ doc_DATA = files/nftables/main.nft
> > >  tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
> > >  	${AM_V_GEN}${MKDIR_P} tools
> > >  	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> > > +
> > > +if !BUILD_DISTCHECK
> > > +TESTS = tests/build/run-tests.sh \
> > > +	tests/json_echo/run-test.py \
> > > +	tests/monitor/run-tests.sh \
> > > +	tests/py/nft-test.py \
> > > +	tests/shell/run-tests.sh
> > > +endif
> > > diff --git a/configure.ac b/configure.ac
> > > index da16a6e257c91..8073d4d8193e2 100644
> > > --- a/configure.ac
> > > +++ b/configure.ac
> > > @@ -155,6 +155,11 @@ AC_CONFIG_COMMANDS([nftversion.h], [
> > >  AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > >  CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
> > >  
> > > +AC_ARG_ENABLE([distcheck],
> > > +	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> > > +	      [enable_distcheck=yes], [])
> > > +AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
> > 
> > Oh no, with distcheck-hook: this is a lot cleaner.
> > 
> > Please revert this.
> 
> Sorry I misunderstood.
> 
> You only applied four patches.

Yes, sorry. I started collecting unrelated fallout again to avoid the
added dependency between two patch series. This is really a bad habit as
it makes reviews harder.

> My apologies.

No need to, thanks for bearing with my mess. I'll check what I can
achieve with distcheck-hook, thanks for the pointer!

Cheers, Phil
