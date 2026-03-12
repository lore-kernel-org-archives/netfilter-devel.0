Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1108B317142
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2026 22:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773354018; cv=none; b=PxpRQdcyadoOTxpeFx7X/e0h0saWpHaFZs8CxTRZJU0Q+yIkf6nbv9EFSSXVRSd2P3Qslol8uPcvWGpUyzKV760jTjW1ls2/GM8yJCrSoDnGcxRvlZe3rBFzIhP/JNyyABKGNgBHJme+BzLhlI5UcKFt9XrspnntjrKNyAD8CQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773354018; c=relaxed/simple;
	bh=g40q5Izl8+xS5jdoObpieU7QAV/JFH2LF77e4Kyfgro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r1m4zkXtI73gpm3fh2sozsLso5G+psKsH6vBi79Brh4HJ9ESpoLfEO89p5smnDmb5Luz1qQltmDQBVymGJmMY5m/EaZtM1Ce4P42V/sBCqvBKXIaG9evI9cvvX3U6KrNyG4/QHmHXRxuqEo452BDqHNW7ujhrbiT5eqtho8Fn4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=IF3pLs+s; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="IF3pLs+s"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 81E98600B9;
	Thu, 12 Mar 2026 23:20:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773354013;
	bh=ZVf/Ml2/Ya59ZC3/3zBMUTy64w+r6ntzPh9a7vY7WiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IF3pLs+sxFFWLWyL8yMgqqrzSyQWFHdYBYFnW0TTIyUxIy+JfQJ0oQe8JiDeaBxme
	 slhJ1ClRK0QWm1T19vrpfWiDl6SpRO6BGQ0kt4PuA40dIOToqQ5l0zHREfl8QUgWwk
	 097nnLGBLd518PcvXyB+0pw8C1gK2a5WK7lsaPwX6KtNOGyu/pp3KQfPfIjQyjbIA6
	 2a9KqeTJrNP0H//UJsUezlVBnvxcoNJIu08zw6dwdUrN6GRM3yLsB9uH2y0jIPaUI2
	 ovY9AZFYslsN1X8YrunU956AU6QV3OKcwjIG8d30lIjzS5uqmdHgVCuo36VJq449KP
	 0EcnM7nE3pm3g==
Date: Thu, 12 Mar 2026 23:20:10 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <abM8Glu2VHmYQdaM@chamomile>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
 <20260306183553.GA5468@celephais.dreamlands>
 <abCki9aBa8wVBvQi@orbyte.nwl.cc>
 <abM6vF13kX78q2Rh@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abM6vF13kX78q2Rh@strlen.de>

On Thu, Mar 12, 2026 at 11:14:20PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > > which suggests it's time-zone related.  Didn't see anything about that
> > > in the doc's.  Will take a closer look.  Apologies.
> > 
> > Yes, it's odd. Neither unshare module nor 'unshare -n' behave like this,
> > even though os.unshare is described as doing the same as unshare command
> > does. It also doesn't mangle os.environ['TZ'] value, no idea why it
> > messes with this.
> 
> Is there anyone working on a fix?
> 
> This breaks my CI pipeline (i.e. I disabled meta.t tests).

I suggest to revert by now, as it seems os.unshare is not equivalent
to 'unshare -n'.
