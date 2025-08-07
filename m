Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5B6253351
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 12:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754568866; cv=none; b=nhmKe6wlxLVFFAY0IYa6kevKvKW0tm1faoqO3YafVwniFnEsK0yPRG3pwAWvkcje7kQvJyCe5mtXVByZzEZsOS81/KHSyCar1jNq4ZOzTE6BKfw2ULAYwGotLf1Sy3JyeH3ea6fXYKIYWqnLrr0ICE/oN+kueLUK/WWrDhSF36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754568866; c=relaxed/simple;
	bh=eprINQVrcpRJfW8Ssc3sqmls34FgNG6QHeXghtG8MwU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=al2LzeSYS1TToS7Y+loSZ87wRZOaJ+qD9+0jQWjQRxI8SXCvYTFAISIT+rfnrXecMRNM2YltaIUyliPe7wqLqCROkTDDcHuWGFUwamuXSY7uURsD3K0EAuk6bFJs/3F60xyIEp/0PP3sP5KnxfoarO1JbgJCDhJS6+CEt2hTDiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=peh5k0kU; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=fQFEY3+3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="peh5k0kU";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="fQFEY3+3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 44D9F60A69; Thu,  7 Aug 2025 14:14:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754568857;
	bh=A5A1mOSZZobsyBjGWVxo5w+Zv964rmqx5zyQ3UeXUBc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=peh5k0kUr9EntrTVustrhcwlyDxYGg+IAqtbLm4guI724jXCtF1X60urS4eMaAhoa
	 D7N/SnjIXduiMV5UC/P9RLlivpGQOkXodZ8Z4reG9X4jETyWS5/CIw8mAlKPvIq8HE
	 XKyxxa878G+w3t/t94Ynu9qB7nPZ2AO71t8+V5n+4eHY+bwthyS8X7gZN+7yKyMjUZ
	 jWwrulO+F+EBXJbN/G6h0xLHvozLnG56YFN9mwcE6CzVZP9PoYoStT8H8keWhY48S0
	 DGmiwF0upI6OJGUHxOjmt6472Bcz11mOtlVt4UGYu7d09UZqFZ2RtVFTDDiMDQ9Ipz
	 ME81cjYiG/z6g==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 64B1360A69;
	Thu,  7 Aug 2025 14:14:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754568856;
	bh=A5A1mOSZZobsyBjGWVxo5w+Zv964rmqx5zyQ3UeXUBc=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=fQFEY3+3vhxVAWG5tLuZWnIZPItKkIAHjFUfG8HMsGn+eBGguTWx4oGBq924CP2Mb
	 mxtVIXWRGMO4E7tVCpYQ+Mg0F5x+zaqilgt31EPF1w68y5MrXWCP7liYs28rZphnme
	 +OVpHeN6qbZTEso74tWlWid3mZ9xR0upM3KpmOgU1Pu6VMJRhp9wCRv9yhU5ni/sky
	 eWNXduk1yPQQ/LwCeOAO6zz4M6wXdv1LtXnCld9j1USw8I5qxSr7rYWJtSlCMYzwXi
	 4MMBtH9lBzM5CusrHnVLUp+5hG+SB/8gHV/o7L47heM0iwYdV/yIomUIaS75yQJmHg
	 XdqkOzYP8kg6w==
Date: Thu, 7 Aug 2025 14:14:13 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aJSYlVUF9NzKL4FD@calendula>
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
 <aJOLPp-1TWYfGCQF@calendula>
 <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>

On Thu, Aug 07, 2025 at 01:51:09PM +0200, Phil Sutter wrote:
> On Wed, Aug 06, 2025 at 07:05:02PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 01, 2025 at 06:11:05PM +0200, Phil Sutter wrote:
> > > Add the various testsuite runners to TESTS variable and have make call
> > > them with RUN_FULL_TESTSUITE=1 env var.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  Makefile.am | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/Makefile.am b/Makefile.am
> > > index ba09e7f0953d5..4fb75b85a5d59 100644
> > > --- a/Makefile.am
> > > +++ b/Makefile.am
> > > @@ -409,5 +409,11 @@ EXTRA_DIST += \
> > >  	tests \
> > >  	$(NULL)
> > >  
> > > +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
> > 
> > I use make distcheck to build the tarballs.
> > 
> > I would prefer not to run the tests at the time of the release
> > process, I always do this before release, but I prefer not to inline
> > this to the release process.
> 
> Oh, good to know. Running just 'make dist' is no option for you?

I can just modify the script to do so, no idea on the implications.

Or wait for one more hour for the test run to finish during the
release process.

> BTW: There is the same situation with iptables, though if called as
> unprivileged user there is only the xlate test suite which runs (and
> quickly finishes).
> 
> > Maybe we can make this work this way?
> > 
> >   export RUN_FULL_TESTSUITE=1; make check
> > 
> > so make check is no-op without this variable?
> > 
> > Does this make sense to you?
> 
> It seems odd to enable 'make check' only to disable it again, but
> there's still added value in it.
> 
> I'm currently looking into distcheck-hook and DISTCHECK_CONFIGURE_FLAGS
> in order to identify the caller to 'make check' call.
> 
> An alternative would be to drop fake root functionality from shell
> test suite, then it would skip just like all the other test suites if run
> as non-root (assuming you don't run 'make distcheck' as root).

Looking at the current release script I have, it all runs as non-root.

Maybe simply as a run-all.sh under nftables/tests/?

It is not so elegant as make check, but still allows for running _all_
tests with minimal changes.

tests/build is slow but very useful.

> Another side-quest extracted from this mail: There's an odd failure from
> shell test suite when run by 'make distcheck':
> 
> | E: cannot execute nft command: ../../tests/shell/../../src/nft
> | ERROR tests/shell/run-tests.sh (exit status: 99)
> 
> > > +TESTS = tests/json_echo/run-test.py \
> > > +	tests/monitor/run-tests.sh \
> > > +	tests/py/nft-test.py \
> > > +	tests/shell/run-tests.sh
> > 
> > BTW, there are also tests/build/ that are slow but useful, that helped
> > me find this:
> > 
> > https://git.netfilter.org/nftables/commit/?id=0584f1c1c2073ff082badc7b49ed667de41002d9
> 
> Ah, I just "discovered" that bug as well, it surfaces from the build
> performed by 'make distcheck', too.
> 
> Thanks, Phil
