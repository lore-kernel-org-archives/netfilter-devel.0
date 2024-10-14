Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4EC14A098
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2024 08:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728893359; cv=none; b=pJNt8YwyvEv6nxt9yjusRFYaBUBUtmsMWl7nZNvcWF59qpHwpIWBsHRjxdXGpV5R2TH9QuzgbKQdEFmlQHWPZPkQNvMiLk6QNarZ6rftA5bsmSjfnsE7y3aTsUYQteeqCaEuakbphU7s1xkpZC7AMuCmXGPDDOL5w3Vc/sN2I2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728893359; c=relaxed/simple;
	bh=PdiMtVUdc+7KCIVkva1uuKrh40PjEoXa5Bcn32Rxs30=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2+Fhq2nOkg3+hfQ00ZUoe2dhQ3Kt3+JGTLfWPImqY+9n0NfBofyuJjoXUGswtx8CrDiiGypEsvA2f9S5f8RmrHFB076w8SaJz6NMExuose7VgSP18CZbYV/jdWKIrZQgOko6B7MImLoZCOhDMfj7zM3aIWb3w7RKFlLcr8GkJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42206 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t0G8W-005vQj-KF
	for netfilter-devel@vger.kernel.org; Mon, 14 Oct 2024 10:09:06 +0200
Date: Mon, 14 Oct 2024 10:09:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwzRn6EQpRJWxYA-@calendula>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwzOgRoMzOiNfgn0@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZwzOgRoMzOiNfgn0@slk15.local.net>
X-Spam-Score: -1.7 (-)

On Mon, Oct 14, 2024 at 06:55:45PM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> > Make it option, after this update it is still possible to build the
> > documentation on demand via:
> >
> >  cd doxygen
> >  make
> >
> > if ./configure found doxygen. Otherwise, no need to build documentation
> > when building from source.
> >
> > Update README to include this information.
> >
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  Makefile.am |  2 +-
> >  README      | 10 ++++++++++
> >  2 files changed, 11 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile.am b/Makefile.am
> > index 94e6935d6138..6ec1a7b98827 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -2,7 +2,7 @@ include $(top_srcdir)/Make_global.am
> >
> >  ACLOCAL_AMFLAGS = -I m4
> >
> > -SUBDIRS = src include examples doxygen
> > +SUBDIRS = src include examples
> >  DIST_SUBDIRS = src include examples doxygen
> >
> >  pkgconfigdir = $(libdir)/pkgconfig
> > diff --git a/README b/README
> > index 317a2c6ad1d6..c82dedd2266a 100644
> > --- a/README
> > +++ b/README
> > @@ -23,6 +23,16 @@ forced to use them.
> >  You can find several example files under examples/ that you can compile by
> >  invoking `make check'.
> >
> > += Documentation =
> > +
> > +If ./configure reports that doxygen has been found, then you can build
> > +documentation through:
> > +
> > +	cd doxygen
> > +	make
> > +
> > +then, open doxygen/html/index.html in your browser.
> > +
> >  = Contributing =
> >
> >  Please submit any patches to <netfilter-devel@vger.kernel.org>.
> > --
> > 2.30.2
> >
> >
> Why are you doing this?
> 
> I don't like this patch because:-
> 
> Distributors typically use the default config to make a package. That would mean
> libmnl would go out without any documentation, hardly an encouragement to use
> it.

We do not have control over the specific items that distributors
choose to include in their packages. Each distributor operates
independently and curates their packages based on their own
preferences. Therefore, the final decisions regarding package contents
rest solely with the distributors.

Moreover, documentation is specifically designed for developers who
are engaged in the technical aspects. Most users of this software are
building it because it is a dependency for their software. Therefore,
for non-developers, this step in the building process is not relevant.

Please, note that users can still opt-in to compile documentation as
it is documented in the README file.

Thanks.
