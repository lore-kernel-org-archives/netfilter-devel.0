Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D09335D3
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Oct 2024 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728807694; cv=none; b=XoZYl3hT8muyU+LbD/CMArLccCP7E6b224Z7s7jstjJBDEP3IjpZLk0NxJipQmjOPnLHQ//N6uArTLekCJx2phQ6uJWRy4P6sL69IqLm1E/3msIEeQEwnP61+5Uvx5VoZtlHk6scTTeTIMvRYs6IJUVbMxGB7AL7GVTul+/zIVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728807694; c=relaxed/simple;
	bh=Tts9DnzOwh3xcnxyZf7zoFEj6sf8FVI0qhsvxG2zjHE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I1fwm2XGJwjc0vO4uUVPQlMw/g6zyqpx8IFVS6P8PQ9E5FjZxIybJLbH9DfJlAwV8oTFXSs0Wtgbz9CKEqEEm0AkMgCTT4GX54fAlKUpLA85bodzezIa2WFtUPtKJ+McFGR+U/5uAkMKJNCF712LCd5DpgK8ssJ5NYHM6dqyRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35804 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sztqv-003EGI-RB; Sun, 13 Oct 2024 10:21:28 +0200
Date: Sun, 13 Oct 2024 10:21:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libmnl] build: do not build documentation automatically
Message-ID: <ZwuDBGBiRqw0e2L3@calendula>
References: <20241012171521.33453-1-pablo@netfilter.org>
 <ZwrT3JOmxLigw9gC@orbyte.nwl.cc>
 <ZwrpiAv1PHEp1rwY@calendula>
 <ZwsANQhOyYrEGTip@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZwsANQhOyYrEGTip@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Sun, Oct 13, 2024 at 01:03:17AM +0200, Phil Sutter wrote:
> On Sat, Oct 12, 2024 at 11:26:32PM +0200, Pablo Neira Ayuso wrote:
> > On Sat, Oct 12, 2024 at 09:54:04PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Sat, Oct 12, 2024 at 07:15:21PM +0200, Pablo Neira Ayuso wrote:
> > > > Make it option, after this update it is still possible to build the
> > > > documentation on demand via:
> > > > 
> > > >  cd doxygen
> > > >  make
> > > 
> > > This is rather unelegant in an autotools-project. You probably did
> > > consider setting 'with_doxygen=no' in configure.ac line 48, why did you
> > > choose this way?
> > 
> > --with-doxygen=no would do try trick, yes.
> 
> Not sure if it was clear, but I meant to change the default in
> configure.ac, so users will have to pass --with-doxygen=yes if they
> want to build these docs. I guess that's the most intuitive way for
> users.

Thanks, I will submit a patch to change default.
