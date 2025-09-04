Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C30251791
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 18:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757011187; cv=none; b=kpnyoehrij54tPeooxil4MZWDe5sx5n4H0AOk+Mft6tuYo3qiJV6gtcZYM4aiXHBRrg5xM5oeAf9w1F3rihixye2OhR6skpzoaa697a7KsF1fjaY/ntdNK5AUf656xJVQDnLR/ziF7e08UD0kIDlSu1Fq7Hhw2/lYmto6KE48FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757011187; c=relaxed/simple;
	bh=c+zJQ+EMH/byDG5wFBE/n0c5seO95DpGsPAeK4EBHGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O68w+CSjs1JJj9pusSMYob+j0tA405w00KCQLQmaJ1v/VI2tHX0Jd859mgl4Bwc5Lw4rP1w1RfeHawqP5doV9HIJ30bF5a0G2jn9a8PI+hHy7/eAE4ua5hcoZUoy+ZzFNWZdSw+DsPfsiabtDr5baHzsfEEPLTkBs0V195ryvxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=ObwTyucL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="ObwTyucL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sQy/yjOj8cnlLZOZQ2v3zrI3kdpMwnZSX9sTtgn4oEk=; b=ObwTyucLCTkQnfF0EXOnUjVqHs
	MK5gKi1fCmDI8vtbqoaG1j0y56y3nKKB83+4RvCiXCB689+Ky2BOYqFUQ53qdHOXSf/ejEEyokBg1
	ksZbEQwAqNpsmy1l7Xg4rmS/CJlqFsFZ+/fFC2L8vuEIwwfPLYA1Rs90ewz1j3bfBbe+QCYCz7dYp
	/sXpWUKqBtTgJwY5v6Fv8roSwKUxBzUl9ZBmcvx2N6lg+yv3hVCWZIDamoKqoJW0ztviV6k6pi3qg
	bzSmbgFN81gBUvOkjBp6X5WdN7fGVQHSUwwmnR4npM4sujMis3vTxulKWuYq5m3MarU+PILgDTyCA
	YqYyU9pw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuEs0-000000001JN-3Hoa;
	Thu, 04 Sep 2025 20:39:42 +0200
Date: Thu, 4 Sep 2025 20:39:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLnc7AidZLW9dCbY@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
 <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>
 <aLnFEDmuqOckePL8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLnFEDmuqOckePL8@calendula>

On Thu, Sep 04, 2025 at 06:57:52PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 04, 2025 at 06:21:59PM +0200, Phil Sutter wrote:
> > On Thu, Sep 04, 2025 at 05:24:59PM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
> > [...]
> > > > diff --git a/Makefile.am b/Makefile.am
> > > > index 5190a49ae69f1..9112faa2d5c04 100644
> > > > --- a/Makefile.am
> > > > +++ b/Makefile.am
> > > > @@ -23,6 +23,7 @@ libnftables_LIBVERSION = 2:0:1
> > > >  ###############################################################################
> > > >  
> > > >  ACLOCAL_AMFLAGS = -I m4
> > > > +AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck
> > > >  
> > > >  EXTRA_DIST =
> > > >  BUILT_SOURCES =
> > > > @@ -429,3 +430,11 @@ doc_DATA = files/nftables/main.nft
> > > >  tools/nftables.service: tools/nftables.service.in ${top_builddir}/config.status
> > > >  	${AM_V_GEN}${MKDIR_P} tools
> > > >  	${AM_V_at}sed -e 's|@''sbindir''@|${sbindir}|g;s|@''pkgsysconfdir''@|${pkgsysconfdir}|g' <${srcdir}/tools/nftables.service.in >$@
> > > > +
> > > > +if !BUILD_DISTCHECK
> > > > +TESTS = tests/build/run-tests.sh \
> > > > +	tests/json_echo/run-test.py \
> > > > +	tests/monitor/run-tests.sh \
> > > > +	tests/py/nft-test.py \
> > > > +	tests/shell/run-tests.sh
> > > > +endif
> > > > diff --git a/configure.ac b/configure.ac
> > > > index da16a6e257c91..8073d4d8193e2 100644
> > > > --- a/configure.ac
> > > > +++ b/configure.ac
> > > > @@ -155,6 +155,11 @@ AC_CONFIG_COMMANDS([nftversion.h], [
> > > >  AC_SUBST([MAKE_STAMP], ["\$(shell date +%s)"])
> > > >  CFLAGS="${CFLAGS} -DMAKE_STAMP=\${MAKE_STAMP}"
> > > >  
> > > > +AC_ARG_ENABLE([distcheck],
> > > > +	      AS_HELP_STRING([--enable-distcheck], [Build for distcheck]),
> > > > +	      [enable_distcheck=yes], [])
> > > > +AM_CONDITIONAL([BUILD_DISTCHECK], [test "x$enable_distcheck" = "xyes"])
> > > 
> > > Oh no, with distcheck-hook: this is a lot cleaner.
> > 
> > Hmm, I really don't see how it could be used for this purpose: It is
> > called before starting the VPATH build, here's an excerpt:
> > 
> > | mkdir nftables-1.1.5/_build nftables-1.1.5/_build/sub nftables-1.1.5/_inst
> > | chmod a-w nftables-1.1.5
> > | test -d nftables-1.1.5/_build || exit 0; \
> > | dc_install_base=`CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
> > |   && dc_destdir="${TMPDIR-/tmp}/am-dc-$$/" \
> > |   && make  distcheck-hook \
> > |   && am__cwd=`pwd` \
> > |   && CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_build/sub \
> > |   && ../../configure \
> > |       --enable-distcheck \
> > |          \
> > |       --srcdir=../.. --prefix="$dc_install_base" \
> > |   && make  \
> > |   && make  dvi \
> > |   && make  check \
> > 
> > So by the time distcheck-hook runs, there is no Makefile(.in) I could
> > modify, only the top-level ones (which are tracked in git). What am I
> > missing here?
> 
> distcheck-hook: could set a env var so test just print a [SKIP].
> 
> Similar to your previous approach with the env var, but logic reversed.

I don't think the 'make distcheck-hook' call is able to inject variables
into the following 'make check' call's environment. It could create a
special file though which all test suites recognize and exit 77
immediately.

Cheers, Phil
