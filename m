Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60CABA36
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Aug 2025 11:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754567474; cv=none; b=X4xJRZaDh3HjQeRTeL+/ch+MvVyCdXX1mfq+YBqFyEckbpqgfjm+oSyhM3SLm2aiwzGsUuF9Q13alfnn0/B3x/saAQ4LPz5ava+aVvdpIbcbJqkCDbK2SKXLUFjunx6ypwc6L/+ZvxS60guV+NLmT6bbKi2AXut7fgC9MP/+eSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754567474; c=relaxed/simple;
	bh=Dh1+SGgyozp87jgQktZpx68LwlBUyuELdqM+levs9Uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR3vJDpJo7+tQTAeUJgqjpXKXKkXgLRTKN0mchOp0TcAf9kwrsn86OniU4AoTwjBxwDzBn1uYCpRR292FV/inVqLoIuxZn2OgDTBeZoxzcqtLxwjRM5DX3rJBdI2cpJaddjWCKZAPVxw0S8OK4xutfdbNlQ7cSmMkbo12qTiJS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Sz/s9akh; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Sz/s9akh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/W5hY4MlbCQ3n83KCJtAj+WiYPFTtKVb4MXUYpOYL8w=; b=Sz/s9akhAvGPghafxtSKbGWahU
	qIzO5hAZzYUC4JlPVRM9r/qin7SPU3wQUyfHXjDCBT330a3KVigUt4PShI69x2jJasXXPr2EekpvA
	T1vhepvlNYNvUzQeHSLZ5ekZa2e/FZEqV4hqXd83XCSK3NfXinZ8IOIfnEDnxmA4GeOEuB+llSVab
	bOImrMgGQqGbZytbZDzqjgQZX4AXxoGIHg8vCBevEzulgmZQZbPr0SzB9zn48MeTaunXEdV80MN3C
	e3XOid6c2LfvAjaJO4aiZbXGZgWEdAS5/oedHQuy96yMING0lvUNoh9jbzHYs8c+F77MhgJKzMnwn
	1KGOZKsA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ujz9J-000000000dw-2jLv;
	Thu, 07 Aug 2025 13:51:09 +0200
Date: Thu, 7 Aug 2025 13:51:09 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 6/6] Makefile: Enable support for 'make check'
Message-ID: <aJSTLfOz4v-DgQVz@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250801161105.24823-1-phil@nwl.cc>
 <20250801161105.24823-7-phil@nwl.cc>
 <aJOLPp-1TWYfGCQF@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJOLPp-1TWYfGCQF@calendula>

On Wed, Aug 06, 2025 at 07:05:02PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 01, 2025 at 06:11:05PM +0200, Phil Sutter wrote:
> > Add the various testsuite runners to TESTS variable and have make call
> > them with RUN_FULL_TESTSUITE=1 env var.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  Makefile.am | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/Makefile.am b/Makefile.am
> > index ba09e7f0953d5..4fb75b85a5d59 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -409,5 +409,11 @@ EXTRA_DIST += \
> >  	tests \
> >  	$(NULL)
> >  
> > +AM_TESTS_ENVIRONMENT = RUN_FULL_TESTSUITE=1; export RUN_FULL_TESTSUITE;
> 
> I use make distcheck to build the tarballs.
> 
> I would prefer not to run the tests at the time of the release
> process, I always do this before release, but I prefer not to inline
> this to the release process.

Oh, good to know. Running just 'make dist' is no option for you?

BTW: There is the same situation with iptables, though if called as
unprivileged user there is only the xlate test suite which runs (and
quickly finishes).

> Maybe we can make this work this way?
> 
>   export RUN_FULL_TESTSUITE=1; make check
> 
> so make check is no-op without this variable?
> 
> Does this make sense to you?

It seems odd to enable 'make check' only to disable it again, but
there's still added value in it.

I'm currently looking into distcheck-hook and DISTCHECK_CONFIGURE_FLAGS
in order to identify the caller to 'make check' call.

An alternative would be to drop fake root functionality from shell
test suite, then it would skip just like all the other test suites if run
as non-root (assuming you don't run 'make distcheck' as root).

Another side-quest extracted from this mail: There's an odd failure from
shell test suite when run by 'make distcheck':

| E: cannot execute nft command: ../../tests/shell/../../src/nft
| ERROR tests/shell/run-tests.sh (exit status: 99)

> > +TESTS = tests/json_echo/run-test.py \
> > +	tests/monitor/run-tests.sh \
> > +	tests/py/nft-test.py \
> > +	tests/shell/run-tests.sh
> 
> BTW, there are also tests/build/ that are slow but useful, that helped
> me find this:
> 
> https://git.netfilter.org/nftables/commit/?id=0584f1c1c2073ff082badc7b49ed667de41002d9

Ah, I just "discovered" that bug as well, it surfaces from the build
performed by 'make distcheck', too.

Thanks, Phil
