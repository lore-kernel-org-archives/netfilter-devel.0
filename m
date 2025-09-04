Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E55B212576
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757005080; cv=none; b=unmwY/UGpUEvHedNOOp6i+yelEWlS2Bqi3DkuTGWftk1v8nAYZaUnC9n48nMdCuQAa2BrFKsgCv+IXfoISx7+NmUSvC6YG6M6/kw3uHXvhgE3II/OwR7xzQRtH9BkpWpmZCtjNMNvJVhr27rCrLCCY31vzk0KeiNNAOil09n6xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757005080; c=relaxed/simple;
	bh=SELMW7bbNKdn7YmxrIYpgmP99sLCnWd7MmNlP6YjmQg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mN6ZLf8ntI53VPY0iWTXyEr2ePFv7goIXd+uz28mpNLgMgDffm5LYXirN0cbV9tsj4DdOFrfOIUKQxWewPVriv7eD44k66IyUEZRvvJxqq3tiRmLmhtPwVZT3KEzDpJL+sg3F3DUtltz/up+Hyf6U6miyMfzygK1HFuJ0HVZC8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=r6PBOfE+; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wIetcLpX; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="r6PBOfE+";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wIetcLpX"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 7AAE0608B9; Thu,  4 Sep 2025 18:57:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757005075;
	bh=hCW1RPXji+zf4iq4yJ1x3in/uJMzAJG3nJjuUFgeD/U=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=r6PBOfE+tlnB+YInTCEERdw67LSm3yKzsh0gvN4zXMuK7ZmFWkcbMWn4oBH9mL6oZ
	 vOgcmhLjORosNFLxW7GJb2Y6HoWIwfEJ8L+9AN/JtRNS2lzvMHXXesibt7AaH8uhwX
	 R1RWEQJ096jUiLrcZcAscYqEuQhZX1btw0YX7RrapQ7QOBamgPDH7CtcZCjxFDyRpl
	 YIpxLZJxorzrGw5N7B511PH3IW7JiPMzkd+CghT08laFv2YIw4NpJHgv+AG6nXdwyt
	 n28ZAoOTzyeD2aH3l5mU0tDCwzKzX1eW68aXkg6TcJN08WSiaDHCtrUscbtHZWAzYc
	 tsCn0/bX3V9Vw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AFA84608B9;
	Thu,  4 Sep 2025 18:57:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757005074;
	bh=hCW1RPXji+zf4iq4yJ1x3in/uJMzAJG3nJjuUFgeD/U=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=wIetcLpXuJGQWQRldoJntiswmFPvgjHXxYTAf7EmzzuAGTNE7wdsRH3G9DZjD1Zu0
	 /SwuFGwsuX/Eh+u5cbzhNj+psefi3ziHtdvnlxp7Z+/aKB8ZIa/qeuC+tbbjo9lY6y
	 7loj54ajY6NJX1mGLLXlmwUDTZC7SFKeSmzUyhuco6zaCxiXMnqViE0Wop3qjvxOxq
	 s+zRr0Ln9CyhqrqBSZT+SEbT7hYyI3K+gmHvMnqeoZoHRxfrv5Amv6FzW3ZTNqU9K3
	 jfrF0v1CPnDd+5LPTDLRDkyeoL1IqHhEqax+SjxQeVLdWwvIh4ukfLU94Bi9kCwOLD
	 nbiBZs2L9wwpg==
Date: Thu, 4 Sep 2025 18:57:52 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLnFEDmuqOckePL8@calendula>
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
 <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>

On Thu, Sep 04, 2025 at 06:21:59PM +0200, Phil Sutter wrote:
> On Thu, Sep 04, 2025 at 05:24:59PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
> [...]
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
> 
> Hmm, I really don't see how it could be used for this purpose: It is
> called before starting the VPATH build, here's an excerpt:
> 
> | mkdir nftables-1.1.5/_build nftables-1.1.5/_build/sub nftables-1.1.5/_inst
> | chmod a-w nftables-1.1.5
> | test -d nftables-1.1.5/_build || exit 0; \
> | dc_install_base=`CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
> |   && dc_destdir="${TMPDIR-/tmp}/am-dc-$$/" \
> |   && make  distcheck-hook \
> |   && am__cwd=`pwd` \
> |   && CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_build/sub \
> |   && ../../configure \
> |       --enable-distcheck \
> |          \
> |       --srcdir=../.. --prefix="$dc_install_base" \
> |   && make  \
> |   && make  dvi \
> |   && make  check \
> 
> So by the time distcheck-hook runs, there is no Makefile(.in) I could
> modify, only the top-level ones (which are tracked in git). What am I
> missing here?

distcheck-hook: could set a env var so test just print a [SKIP].

Similar to your previous approach with the env var, but logic reversed.
