Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEED25E479
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Jun 2025 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749131051; cv=none; b=JgriesxNEbcAe/VmXh079l/T65r/v64KOER5f7XwSl+VtAnTY2nO3st1GIUNMWEjZ8sL4i8sNe7sDIvmjhZ0tDAf29vj+uG55+WLRWBMk/h7m088Z9RQaJJXt3oFl8Y8jCjm11A+JoIVns/9BF+TMSKoLy1M1k4LcicNa33GSAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749131051; c=relaxed/simple;
	bh=16gWMVgSPZewX6Y8xxerJNrU3cyE7wNJiWz1TpBb6EY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGUymS1SBHjZoZwgaP516FtB+tZ8CxtyGyXqX3PqvLXVGZ+Jdtdz4qhTYMqN/gPF3SgNzApbeTNEMMdUAPjaFtLspVNKw3Cd4Juzy1gLL8WFgZPeRBmruVs9EudoQPnNxwx1iNILk2yvEi296mtbm7FjrNnW0lNkx8NP5XyLK2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9589660A0A; Thu,  5 Jun 2025 15:43:59 +0200 (CEST)
Date: Thu, 5 Jun 2025 15:43:59 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: work around fuzzer-induced assert crashes
Message-ID: <aEGfHyfzrYV0Fs8B@strlen.de>
References: <20250602121254.3469-1-fw@strlen.de>
 <aD87gslgK0kk5qzT@orbyte.nwl.cc>
 <aEBpAUZBwuQn1Imn@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aEBpAUZBwuQn1Imn@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Hi,
> 
> On Tue, Jun 03, 2025 at 08:14:26PM +0200, Phil Sutter wrote:
> > On Mon, Jun 02, 2025 at 02:12:49PM +0200, Florian Westphal wrote:
> > > fuzzer can cause assert failures due to json_pack() returning a NULL
> > > value and therefore triggering the assert(out) in __json_pack macro.
> > > 
> > > All instances I saw are due to invalid UTF-8 strings, i.e., table/chain
> > > names with non-text characters in them.
> > 
> > So these odd strings are supported everywhere else and we only fail to
> > format them into JSON? According to the spec[1] this should even support
> > "\uXXXX"-style escapes. Not sure if it helps us, but to me this sounds
> > like a bug in libjansson. Or are these really binary sequences somehow
> > entered into nftables wich jansson's utf8_check_string() identifies as
> > invalid?
> > 
> > > Work around this for now, replace the assert with a plaintext error
> > > message and return NULL instead of abort().
> > 
> > The old code was active with DEBUG builds, only. If undefined, it would
> > just call json_pack() itself. Did you test a non-DEBUG build, too? I
> > wonder if json.c swallows the NULL return or we see at least an error
> > message.
> 
> So for testing purposes, I built a json_pack() wrapper which
> occasionally returns NULL (and does not assert()). This causes almost
> all py testsuite tests to fail, obviously due to JSON dump differences.
> 
> Piping the non-empty ruleset-after.json files into json_pp shows no
> errors, i.e. if we get any JSON output it is valid at least.
> 
> Looking at testout.log of those tests with rc-failed-dump status, I
> don't see error messages related to JSON output. So catching the NULL
> return is definitely necessary, also with non-DEBUG builds. Hence:
> 
> Acked-by: Phil Sutter <phil@nwl.cc>

Thanks.  Meanwhile running the fuzzer again without this change found
a reproducer, its indeed non utf-8, in this case in a comment.

I pushed this patch with the added bogon included.
