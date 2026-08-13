Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D70331207
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2026 14:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786629617; cv=none; b=MN3uWUB2RWHqPfdkcZnWdHIS6urIAXFlQS6wSStRnCCZKQJz7du0K4klkaBMmvgy8uu6UqjGR7bdjpTZ1R5/6r9IxeUJzU2xiG5qnZr4Cugkx4Fw4BRDCD/ezCCT9xAeL59ir4PJId90yyVI3cSxAxK2ghcmRY0EuSnJ5BcTgYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786629617; c=relaxed/simple;
	bh=YTeOMzs/zml+iLALoDEJIH9fBxAY5hGLIxGFKPrcP+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I3ptctmu38iB0ziQxTj2KI46ULyyyRPrc8QdIVnXDhUr83edJ4msN6NB6ESmWBUJaafWXuyHaHXkGYdke7GNtXzfdVcwxBkK3sNqBc/iSiwcx0z/ZwSHSFTEe84OLtPmu8a6ImBEpteyIRU854TcLwknCYMTN5ehzZz6bV4vTxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jmEt+9Ql; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jmEt+9Ql"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OCuxUj4n9Tqsz0ESezX8mbwuw86/u4Z8Rg7q72+Uexs=; b=jmEt+9QlXZlxwOisnWGbHjjmhA
	qywG8DPf11uyxrflkvgg8HUdpmtqlEA5a+R9yrvVMeImueDiQtjnBaoRpDLYdMXw9SGVZ7vtTa0QL
	+wzus+VFK0IkzCaRTmAgY/T9smqE1gU06UcMHRfjr43C5zbas0c1e6QNTviK5/V5JzklIViSVkpOT
	7ZAjvD3z6f6j5L1okbqzneLSWBUgSlV4b058lz1xN1V+FRf5IE9IBuWZlW7/BNu0eQ+7wgkjz5WIq
	dYcflOTlb0uKJPvozp1RUemJV1CRL+9Q3KXgS68CcFUCJsAPfJF6JcVTbMpjYMjbvj2dos66T/kHB
	zLjiU0cA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wuVye-0000000077Y-21FP;
	Thu, 13 Aug 2026 16:00:12 +0200
Date: Thu, 13 Aug 2026 16:00:12 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Avinash Duduskar <avinash.duduskar@gmail.com>
Subject: Re: [nft PATCH 0/2] tests: shell: Keep dumps with numeric protocol
 values
Message-ID: <an3N7B2ooRVHkS4N@orbyte.nwl.cc>
References: <20260813114556.2685869-1-phil@nwl.cc>
 <an24NqiVztbea8bH@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an24NqiVztbea8bH@strlen.de>

On Thu, Aug 13, 2026 at 02:27:34PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Adjust the test wrapper to create dumps with --numeric-protocol option
> > (patch 1) and update all dumps (patch 2).
> > 
> > One could also set --stateless, py test suite does that, too. Though
> > there are tests (in packetpath dir) which seem to rely upon counter or
> > other stateful data to be matched in dump files, so keep state for now.
> 
> Yes, there are tests that rely on dump validation to catch
> non-matching/matching rules; those would have to be switched over to
> test for the counter values manually.

I was looking into that at first but decided to drop the --stateless
flag for now instead. I'd rather implement a way for test cases to
specify they want the stateful output, similar to the feature
requirement.

Or we just leave things as-is, the stateful output is harmless anyway.

> Patch LGTM, thanks for working on this.

Thanks for the review, I'll push it out.

Cheers, Phil
