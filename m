Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3F3163
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Sep 2025 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757002923; cv=none; b=YdUdSCbvtPBe9ZUgfb5bYJDOlxrjPg9qOyQ8t00kPxNqb1AJ+OtdJCzQYRpXxL/z4NeCEwKKNIq/327FCKqqWLQAZfJlihKhbgchjOEIY9h9EIZ4IsBhCAUMgr0undZnC2lDYybtq487gxqLZ+tlu0XR5mLt88VensmwioN+DRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757002923; c=relaxed/simple;
	bh=OEJjwRjFrBqf7QHkcjRViliHRVp7qaoMYlmsMPhsAp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NNK+w/mraauGTKbgLbLh3dYRw2ul6ScUA1FUeVDqEtPuHWXhMHKCoR7LiXH8G7Rq76lH+ySJAHpyPjqMw8uV5gyLilTfOyXWYbVibzIqRJEavHb4nSFVbL6bP+FOoR5t1iDMaDgwuHoOlJJjR09kZVxw6r/6vlG2tippnoOQrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=FOT7F/7s; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="FOT7F/7s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1BOiLrZRDfS+r4HXDjWJYprYN9UEix2wgKGp80ricz8=; b=FOT7F/7sYvdTr1T4utwJIDfrz6
	LxCfP7N59GLTBRHwVeQiNedP3Pt7HloslLWQx4xHNMws8/Kox+LPQnPm6CWUTa3YmjT5TVqh1eg5r
	BSDO/nO5cbFkGKrvZxp5ry2ffjM7Nrt26jZ7GtdLi30FUO0C+yMuyBB4robGq11GrIqkfkyz3vpGS
	COqsH2MTRq9johOk1Fn205j08omIPnzrOZCafL3xsBBe/rKWkEcmC7bZf2bgEqhJC7wv1kSK+9ONR
	1gB1IaD72KDrFDxKFzitR+3+qLjgHrbUV7pYlU5yLU6W12VQ42l9I1Slnk9Sf1tTFmGn5d4+56hGe
	i6n5vwAQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uuCil-000000004mH-0glr;
	Thu, 04 Sep 2025 18:21:59 +0200
Date: Thu, 4 Sep 2025 18:21:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v3 11/11] Makefile: Enable support for 'make check'
Message-ID: <aLm8pkZu0r1hrlUf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250903172259.26266-1-phil@nwl.cc>
 <20250903172259.26266-12-phil@nwl.cc>
 <aLmvS0buvv-vFyPx@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLmvS0buvv-vFyPx@calendula>

On Thu, Sep 04, 2025 at 05:24:59PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 03, 2025 at 07:22:59PM +0200, Phil Sutter wrote:
[...]
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

Hmm, I really don't see how it could be used for this purpose: It is
called before starting the VPATH build, here's an excerpt:

| mkdir nftables-1.1.5/_build nftables-1.1.5/_build/sub nftables-1.1.5/_inst
| chmod a-w nftables-1.1.5
| test -d nftables-1.1.5/_build || exit 0; \
| dc_install_base=`CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_inst && pwd | sed -e 's,^[^:\\/]:[\\/],/,'` \
|   && dc_destdir="${TMPDIR-/tmp}/am-dc-$$/" \
|   && make  distcheck-hook \
|   && am__cwd=`pwd` \
|   && CDPATH="${ZSH_VERSION+.}:" && cd nftables-1.1.5/_build/sub \
|   && ../../configure \
|       --enable-distcheck \
|          \
|       --srcdir=../.. --prefix="$dc_install_base" \
|   && make  \
|   && make  dvi \
|   && make  check \

So by the time distcheck-hook runs, there is no Makefile(.in) I could
modify, only the top-level ones (which are tracked in git). What am I
missing here?

Cheers, Phil
