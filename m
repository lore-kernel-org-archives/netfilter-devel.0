Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3ED2727E3
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 11:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756898256; cv=none; b=XgeOSlyOUQLxwirc8x4VTfA2kZGyQF08ct/96SojSJDAe9ojyHc6L2rtqsI889MB9lK+BxYh3YpsbK8MQuIbyyEOYZ4WaymxmHsm0W7W7AZNuVn/GDZLczplyJ6pLyzunn9mrpirAc/lOXEX5yRwl7I2IgUy/TtSGhbNaNmOrek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756898256; c=relaxed/simple;
	bh=Kqgg5ZRC/Md79VtS+y7rXM8Sl7c6oVpC6ZSKSCUR+sQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=md/WCUtyas8ToCpRDRoEUSNwYdh2aS/KIIuqtoZnh34+HX5JjNL2yNTOWV3wno5WiV3zTwy3V61aN8vBfJuWWKVLRsdMKIEMz9bAEtDOsoiiJ1sZSEKxUo+yTAqivSqQHhhF79Ph85vMHquFKmn+eBeDUM2+hVoA14SN5V4cLr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YMHloc+W; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YMHloc+W"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zQhH1b0J/0UfFkiHZsFcl69Y4ti2kMy7pk31bMlqVyw=; b=YMHloc+WV348ROuV1EyBaND29l
	exjKW8cyMq0xOZKl8HqVqAo7u7ddAMOwxxc1uJX+i6GFJy8tnIV0PotTxHAcDDg5h+OA/wMsW7BXx
	2NjfaCXtU33yMkL2afB+ciAOnvP5ei6MRblBxLIE469y3unCtFITPHAPwz2Cgzftk6mFwX4JQB+Br
	HC9j9DMatNL32a4qegt4l7V1mTBxVSHPZNUvZ4rGqQPw3ZkzTd5xxIr4MzqOTTq7AJX3t6r9YwWf5
	TwcshrpBuyRXmYhZwfLeIYuVI9Zc9XRaaE8uoF+7C/HQO08+Mdb5eO3zrTzMpYwJKn0uXMeZZQY+m
	HcO5dIIg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1utlUb-000000004OI-12iF;
	Wed, 03 Sep 2025 13:17:33 +0200
Date: Wed, 3 Sep 2025 13:17:33 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 7/7] Makefile: Enable support for 'make check'
Message-ID: <aLgjzTFgO32iuriA@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250829155203.29000-1-phil@nwl.cc>
 <20250829155203.29000-8-phil@nwl.cc>
 <aLcDF_OEWQ5KmkZr@calendula>
 <aLghQ7G-fkdvOKLc@orbyte.nwl.cc>
 <aLgiU3Pb2dLPxYK_@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLgiU3Pb2dLPxYK_@calendula>

On Wed, Sep 03, 2025 at 01:11:15PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 03, 2025 at 01:06:43PM +0200, Phil Sutter wrote:
> > On Tue, Sep 02, 2025 at 04:45:43PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Aug 29, 2025 at 05:52:03PM +0200, Phil Sutter wrote:
> > > > Add the various testsuite runners to TESTS variable and have make call
> > > > them with RUN_FULL_TESTSUITE=1 env var.
> > > 
> > > Given you add a env var for every test, would you instead use
> > > distcheck-hook: in Makefile.am to short circuit the test run and
> > > display SKIPPED?
> > 
> > I don't follow, sorry. The RUN_FULL_TESTSUITE variable is merely used to
> > enable "run all variants"-mode in test suites.
> 
> For make check, I think tests should be updated to run all variants by
> default. Then provide options to run independent variants.
> 
> > Test suites are skipped only if they require root and caller is not
> > - one may still run 'make check' as root or not, irrespective of the
> > hack to leave 'make distcheck' alone.
> 
> Right, I call diskcheck as non-root.
> 
> Maybe we can just skip tests for non-root when make check is called.

I had considered this, but dropping the fakeroot functionality from
shell test suite just for that feels wrong (and is pretty tedious as
well). Keeping it, letting 'make check' run as much as possible and
making sure 'make distcheck' remains unaffected is a cleaner solution
IMO.

> If the tests are updated to run all variants by default, then
> RUN_FULL_TESTSUITE is not needed.

ACK, I'll work on that. It will also improve live for non-"make check"
users.

Thanks, Phil
