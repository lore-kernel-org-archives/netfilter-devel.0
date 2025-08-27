Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC6F2586C7
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 23:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756336113; cv=none; b=Y516JTY/UDKiYQZrB+dfj70IMXg0T18H1oWUVsXQajR3o5GvuAsFbViQ6swQYCaZ7zSR4RYqRym7Zn2+cGLQLXwAIXT0d2pxyGszKhRa5bxvAqILonagdFdX1NHTY2VfeaOP0zTY4XoHXkXTTZb8kyMnW5lLt/O99yCjo12yUDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756336113; c=relaxed/simple;
	bh=hHzDB0vNk8YNZMVevmPnoV/65XubLHsoHIZRB1PSmVE=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZT9sZO4xnIpfNmyHMAUEDNJaFBuZeaPqDkUoAlgnNnCJz+CMYkXcHvJ4O/mlhAcGqz4bscqAi9xfQOOp+nxn5sfO36zggxCq/gukWULK8EW3WH2J94k/dCiUNPSq+IfkeHEXykdplApC4VP9T6BSbsWsmlohFjVIah83cQW8Its=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=b7zdiciX; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z1W+bzS+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="b7zdiciX";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z1W+bzS+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 848C76069E; Thu, 28 Aug 2025 01:08:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756336109;
	bh=I7UYfeRT4IVP+qA+Ocipk7Ipb/ETbQuSp0d56IpwJEM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=b7zdiciXD9EDX5zaqw8/BBVSzgYC1g8AyfIFoC1g+Ao54L/HrTpdYEBifv/8TfgkL
	 B7fNQOZFoA73JQKA/Y+TftVi1HqSuRysGPvLSC2pNhEN1TZ9haVeeZxMmSX9ZZCVFs
	 wZ/K3Vqb5bj0yucrG1b+GGqEDyHzlWZSVhGyG571QXlm24aTgc62Rs8H8btMciX8Ph
	 YCFiCe0sn7vCHyqj0n1//irOZTeAZx/N7U76Bv02mE7xT06tONsr3+T9sAXHOQmXfG
	 CTcUn0EfoXJqlfyWJ4ObWEHOFErReBXz4JM1oVcUzAvCLkHz7RHQvKT139bhsBvZxA
	 wVBxvyi66I33A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id ACA3560641;
	Thu, 28 Aug 2025 01:08:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756336108;
	bh=I7UYfeRT4IVP+qA+Ocipk7Ipb/ETbQuSp0d56IpwJEM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=Z1W+bzS+6p9FJ8okHAG5uL8RtQ8AeZLBEn+0+GpXOcPAs8hixQWvtup+KNHp7SFZd
	 p7E8V6CSdSxYBQXIETOi5dJ94mE5B2BtQHVKNkIpW0d9IPb/tDi/d4nm1opbJfsQeb
	 aYwSqwg6AYM3qES3/p91rmButT+i9Th1g8TbNnGP7Lj45dsTjhRKsEiXox03x9WsNG
	 n2b4Lj+pvByyMB/Gxsd0QlpT7azHIDwXF0PzvUZwLarcXuJ0557poqlj1Zq1Bt74zL
	 IiC4omBY1zNC61OlBVRxwvi9T7kdEzyB8a7T3yDvn3PGSg1m0knXJRSKuHOAg4jaYI
	 Ujmzk5Mt31dtQ==
Date: Thu, 28 Aug 2025 01:08:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aK-P6gvGB-sSKYj8@calendula>
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
 <aJOLPp-1TWYfGCQF@calendula>
 <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>
 <aJSYlVUF9NzKL4FD@calendula>
 <aJSkbu8fZsAqoBTf@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJSkbu8fZsAqoBTf@orbyte.nwl.cc>

On Thu, Aug 07, 2025 at 03:04:46PM +0200, Phil Sutter wrote:
> On Thu, Aug 07, 2025 at 02:14:13PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Aug 07, 2025 at 01:51:09PM +0200, Phil Sutter wrote:
> > > On Wed, Aug 06, 2025 at 07:05:02PM +0200, Pablo Neira Ayuso wrote:
> > > > On Fri, Aug 01, 2025 at 06:11:05PM +0200, Phil Sutter wrote:
> > > > > Add the various testsuite runners to TESTS variable and have make call
> > > > > them with RUN_FULL_TESTSUITE=1 env var.
> > > > > 
> > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > ---
> > > > >  Makefile.am | 6 ++++++
> > > > >  1 file changed, 6 insertions(+)
> > > > > 
> > > > > diff --git a/Makefile.am b/Makefile.am
> > > > > index ba09e7f0953d5..4fb75b85a5d59 100644
> > > > > --- a/Makefile.am
> > > > > +++ b/Makefile.am
> > > > > @@ -409,5 +409,11 @@ EXTRA_DIST += \
> > > > >  	tests \
> > > > >  	$(NULL)
> > > > >  
> > > > > +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
> > > > 
> > > > I use make distcheck to build the tarballs.
> > > > 
> > > > I would prefer not to run the tests at the time of the release
> > > > process, I always do this before release, but I prefer not to inline
> > > > this to the release process.
> > > 
> > > Oh, good to know. Running just 'make dist' is no option for you?
> > 
> > I can just modify the script to do so, no idea on the implications.
> 
> There is more to distcheck than just the 'make check' call, so it's
> definitely worth doing it. The best option might be to run 'make
> distcheck' before the release for a complete test run and only 'make
> dist' during the release process. Though this requires to run 'make
> distcheck' as root, not sure if that is a good idea.

Hm, I prefer not to run make distcheck as root.

> > Or wait for one more hour for the test run to finish during the
> > release process.
> 
> Does not seem feasible, especially for a redundant test run you're not
> interested in. It also implies that you're creating the distribution on
> a system which is able to pass (or skip) all tests, which may not be the
> case.

Yes.

> > > BTW: There is the same situation with iptables, though if called as
> > > unprivileged user there is only the xlate test suite which runs (and
> > > quickly finishes).
> > > 
> > > > Maybe we can make this work this way?
> > > > 
> > > >   export RUN_FULL_TESTSUITE=1; make check
> > > > 
> > > > so make check is no-op without this variable?
> > > > 
> > > > Does this make sense to you?
> > > 
> > > It seems odd to enable 'make check' only to disable it again, but
> > > there's still added value in it.
> > > 
> > > I'm currently looking into distcheck-hook and DISTCHECK_CONFIGURE_FLAGS
> > > in order to identify the caller to 'make check' call.
> > > 
> > > An alternative would be to drop fake root functionality from shell
> > > test suite, then it would skip just like all the other test suites if run
> > > as non-root (assuming you don't run 'make distcheck' as root).
> > 
> > Looking at the current release script I have, it all runs as non-root.
> > 
> > Maybe simply as a run-all.sh under nftables/tests/?
> 
> Also an option, yes. Or a custom 'make testrun' or so.

'make testrun' sounds nicer than my run-it-all shell script proposal,
it would be nice to have a short summary at the test run not to scroll
up to find each individual test result. And I think 'make testrun'
should continue on errors so it is also useful for testing patches
under development.

Thanks.
