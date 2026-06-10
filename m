Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF8140D580
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 21:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781126824; cv=none; b=Ag7eNTlwbCzHmOAUKsxomHYmcez/IRZgtrIb4OcinfkGDUZCyubq/6aCbXjgIqcK5NoyveFcxpg7ZNNJU4mTxvzrBti8TruCjmaAIj/ujqxHVRtQUUCC32v9VoKn4kXbPQuIgCweG+KFZGZ4F87L/fiCDz5IXOr+y+Q9tb0Tozk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781126824; c=relaxed/simple;
	bh=DBoW9AsUGjGeetGeIyAHVw8lwC7jPjASgdRrsnUlLtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5402jigpH9Wps/xolwFC0jM1kO26wJrL3A1G9K3iGRaoCT6Tk2X7jv48nqmGIZbccD5TtpfYxuOewIpGohSJIH6vzPgSRiJgBXhR6M80lIynvzL6biLOhgIp9RfGLsuqHjKx4N+0HTpy3xaJXsNfz6TIGs9q3TVaA6m1KE8stM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Q+9ARkPr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Q+9ARkPr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zl+bRuHmseo39MH/bjJxn5dlLl7iLpH+fWScC084neQ=; b=Q+9ARkPretULd+MYReu3gsXraG
	8nP00zujACJA/qSKpQxqN35GOqikRFdnisLZz18lP4ss2aTWfMYuXNrzSMj4yf5Sif/3/yxtAo+yc
	vq/r4zdpi0maOxvSOVtbk+H+sp5T6M9sXWx5Qmd1awRfBL4/UHgr53If0hGv23OY9JezXC8L0Zvf7
	4c1mgFAbNR4p3ld/7gc+3mlp/V0GN0uHTIUPlem13Saaelpn2TAh7K2YMp+YDbFIc1MGfnvGsY9Jd
	o0OYiafZVMyxsn4LwML3n6kPIZmYgGmZJSZ2o6OPDF8nn9XSq5bPO5m7QEjQwdryOwAB633uTOKoG
	yYOHI80g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wXQRv-000000004sS-2hte;
	Wed, 10 Jun 2026 23:26:59 +0200
Date: Wed, 10 Jun 2026 23:26:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: Re: [nft PATCH] parser_bison: Fix for bison < 3.6
Message-ID: <ainWo2lYfwv3D2nk@orbyte.nwl.cc>
References: <20260610115709.3982133-1-phil@nwl.cc>
 <ail_1zfc4s__gnNI@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ail_1zfc4s__gnNI@chamomile>

Hi Pablo,

On Wed, Jun 10, 2026 at 05:16:39PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jun 10, 2026 at 01:57:09PM +0200, Phil Sutter wrote:
> > Support for 'custom' parse.error value was added in bison-3.6. Fall back
> > to previous value for earlier versions.
> > 
> > This is harder to get right than it seems: On one hand, preprocessor
> > macros can't be used in parser_bison.y's declaration section and
> > automake forbids conditional changes to AM_YFLAGS on the other.
> > 
> > Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
> > Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  Makefile.am        |  6 ++++++
> >  configure.ac       | 12 ++++++++++++
> >  src/parser_bison.y |  4 ++--
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Makefile.am b/Makefile.am
> > index fa71e06eefee5..ddf145a87c810 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -164,6 +164,12 @@ AM_CFLAGS = \
> >  	$(NULL)
> >  
> >  AM_YFLAGS = -d -Wno-yacc
> > +if BISON_CUSTOM_ERROR
> > +YACC += -D parse.error=custom -D parse.lac=full
> > +AM_CFLAGS += -DBISON_CUSTOM_ERROR
> > +else
> > +YACC += -D parse.error=verbose
> > +endif
> >  
> >  if BUILD_PROFILING
> >  AM_CFLAGS += --coverage
> > diff --git a/configure.ac b/configure.ac
> > index 0d3ee2ac89f69..b6cad3117a51b 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -45,6 +45,18 @@ then
> >          exit 1
> >  fi
> >  
> > +AC_ARG_ENABLE([extended_parser_errors],
> > +	      AS_HELP_STRING([--disable-extended-parser-errors],
> > +			     [Disable use of parse.error=custom and LAC in Bison]),
> > +	      [], [
> > +			enable_extended_parser_errors=no
> > +			AC_SUBST([BISON], [$ac_cv_prog_YACC])
> > +			AX_PROG_BISON_VERSION([3.6],
> > +					      [enable_extended_parser_errors=yes])
> > +	      ])
> > +AM_CONDITIONAL([BISON_CUSTOM_ERROR],
> > +	       [test "x$enable_extended_parser_errors" != xno])
> 
> Can this be made transparent? ie. if bison >= 3.6, then enable it
> always. Otherwise, disable it.

This is the default behaviour (which is the "else" case of that huge
AC_ARG_ENABLE). Users may choose to override the version-based setting
via --{en,dis}able-extended-parser-errors. Fine with you or am I missing
your point?

> Then, include this information here in configure.ac:
> 
> echo "
> nft configuration:
>   cli support:                  ${with_cli}
>   enable debugging symbols:     ${enable_debug}
>   use mini-gmp:                 ${with_mini_gmp}
>   enable man page:              ${enable_man_doc}
>   libxtables support:           ${with_xtables}
>   json output support:          ${with_json}
>   collect profiling data:       ${enable_profiling}"
> 
> and here with -V:
> 
> # nft -V
> nftables v1.1.6 (Commodore Bullmoose #7)
>   cli:          editline
>   json:         yes
>   minigmp:      no
>   libxtables:   yes

Oh right, I keep forgetting about the summary (which is really useful as
reading config.log needs training).

> Maybe add:
> 
>   bison >= 3.6: yes
> 
> or similar?

I'd go with "extended parser errors", to remain consistent with the
config option and also because it calls out what actually changed.

There is one other oddity still which I should check: The configure
script always checks bison version, but 'make dist' tarballs ship with
parser_bison.c and thus don't need bison at all. So this patch might
disable the extended error messages for tarball users which don't have
bison installed.

Cheers, Phil
