Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F048D225417
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 13:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754571891; cv=none; b=j4FlmPTCBS5onxGtXPKsmnAv8rHq96tYhk34Dkk02hhBisa45TOMvT6zDcCJOkTfr6ROg3hjOFbRStbZyMUHDHEbUfzb/nMPwMFaI4bSoJUivJEzw7OYvLRCtXlE6B8kO5DrEfCvDYhKZmndV93vQBtSu0tkvLZgNNUIgoJhupg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754571891; c=relaxed/simple;
	bh=hifMagx+eB6vMlJHzBM10VmloddsWOG/xCc9dZ3IJqQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rZfbM+GbB+5VqSKLP7DygeyLEIY5v1KPmnY0sM3sagBNDqyxIiDHniJxm0v1fUv/WGGusiHBQ6jSPToclMgfrtmqBoLE8QGz4s5Iqzi5dw1YxM3zjUb0dhprQOFc+JmfanbYZ3xD2mPh/ytMHfIlCdWUGkfVLKl8/dOxFNiQTtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bqKfwzXr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bqKfwzXr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=eV//HUG3lfm0396hjCEq4POf2ueDJvtz5SaSrW/NBxU=; b=bqKfwzXrjcLjw75jBGxmYiB1Mk
	msNy+HF9p5YwdMWSgJEGiydW/qyuD+NkrAy0gpcrtBmxIx073xHx1E/zEquV/YJYYaxwyktfwjFGu
	GKktV2//Y1y1gbURuGL9SZF9QQPJnakWMJFf6jGRxzVEU9ey33VdWk/zLIj/8zsA8FwoOJWoeEpGZ
	WDMB/cNlYMo0ZtWzUnAy57nGAiUEhoKfdWOhY3AFHGVpb4Zezul3jzFlyw04QDknl6H021nbNlGTu
	aUHSn/KZY9gOE7lSPS8CKGqYjJ4UC4MrNoSEwo6UksSQ1m66dbujlN2dUhf5MsgOluzylh6FFt3g6
	WwGTXKtA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uk0IY-000000006kG-3iAQ;
	Thu, 07 Aug 2025 15:04:46 +0200
Date: Thu, 7 Aug 2025 15:04:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aJSkbu8fZsAqoBTf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
 <aJOLPp-1TWYfGCQF@calendula>
 <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>
 <aJSYlVUF9NzKL4FD@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJSYlVUF9NzKL4FD@calendula>

On Thu, Aug 07, 2025 at 02:14:13PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 07, 2025 at 01:51:09PM +0200, Phil Sutter wrote:
> > On Wed, Aug 06, 2025 at 07:05:02PM +0200, Pablo Neira Ayuso wrote:
> > > On Fri, Aug 01, 2025 at 06:11:05PM +0200, Phil Sutter wrote:
> > > > Add the various testsuite runners to TESTS variable and have make call
> > > > them with RUN_FULL_TESTSUITE=1 env var.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  Makefile.am | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/Makefile.am b/Makefile.am
> > > > index ba09e7f0953d5..4fb75b85a5d59 100644
> > > > --- a/Makefile.am
> > > > +++ b/Makefile.am
> > > > @@ -409,5 +409,11 @@ EXTRA_DIST += \
> > > >  	tests \
> > > >  	$(NULL)
> > > >  
> > > > +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
> > > 
> > > I use make distcheck to build the tarballs.
> > > 
> > > I would prefer not to run the tests at the time of the release
> > > process, I always do this before release, but I prefer not to inline
> > > this to the release process.
> > 
> > Oh, good to know. Running just 'make dist' is no option for you?
> 
> I can just modify the script to do so, no idea on the implications.

There is more to distcheck than just the 'make check' call, so it's
definitely worth doing it. The best option might be to run 'make
distcheck' before the release for a complete test run and only 'make
dist' during the release process. Though this requires to run 'make
distcheck' as root, not sure if that is a good idea.

> Or wait for one more hour for the test run to finish during the
> release process.

Does not seem feasible, especially for a redundant test run you're not
interested in. It also implies that you're creating the distribution on
a system which is able to pass (or skip) all tests, which may not be the
case.

> > BTW: There is the same situation with iptables, though if called as
> > unprivileged user there is only the xlate test suite which runs (and
> > quickly finishes).
> > 
> > > Maybe we can make this work this way?
> > > 
> > >   export RUN_FULL_TESTSUITE=1; make check
> > > 
> > > so make check is no-op without this variable?
> > > 
> > > Does this make sense to you?
> > 
> > It seems odd to enable 'make check' only to disable it again, but
> > there's still added value in it.
> > 
> > I'm currently looking into distcheck-hook and DISTCHECK_CONFIGURE_FLAGS
> > in order to identify the caller to 'make check' call.
> > 
> > An alternative would be to drop fake root functionality from shell
> > test suite, then it would skip just like all the other test suites if run
> > as non-root (assuming you don't run 'make distcheck' as root).
> 
> Looking at the current release script I have, it all runs as non-root.
> 
> Maybe simply as a run-all.sh under nftables/tests/?

Also an option, yes. Or a custom 'make testrun' or so.

> It is not so elegant as make check, but still allows for running _all_
> tests with minimal changes.

A cool feature of automake is to run tests in parallel. I have a local
branch which implements that for iptables. Makefile.am has to list every
test case though, which adds overhead (and room for errors) when writing
new tests.

> tests/build is slow but very useful.

Yes, I don't see a way to instruct 'make distcheck' to perform multiple
builds with different configure options.

tests/build is funny: It runs 'make distcheck' itself, so adding
tests/build/run-tests.sh to TESTS variable in Makefile.am should lead to
an infinite distcheck loop. :D

> > Another side-quest extracted from this mail: There's an odd failure from
> > shell test suite when run by 'make distcheck':
> > 
> > | E: cannot execute nft command: ../../tests/shell/../../src/nft
> > | ERROR tests/shell/run-tests.sh (exit status: 99)

This happens due to the separate source and build directories, the
compiled 'nft' tool (actually: wrapper) is not in the same tree as the
test runner.

Cheers, Phil
