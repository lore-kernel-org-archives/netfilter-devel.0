Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7322F12CDBE
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783435799; cv=none; b=o1pX+Z9JLzFwVGey7s4ueyE9EwhRz8OhsBHaYv15/uoaKClvyqHxhZ7/a99V6fQaXVXQPkDeF+674IM3FkUQ5FTVc16QAL/+M0i87GZKpjTPUbRi5WWtmbaUlEzrBQetM7jsCgmHLqLu9NdwvayvWtmStqUToD0mkrnHKOPJ6S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783435799; c=relaxed/simple;
	bh=MH3XDG3yMn509sxtRVGzWhUohZUIqI66PGbH6qvu6nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcEAHgUlZznIqY+u/AwZdCmyCDZEbTSWQkgRSzl8wcPie8v4/gxtDZXRJRH3o3z174qq4+TgRQAAL4YSEyfiRnFS8shKGieyR+7UllE8BU2M3JBK5twmooKV79S7h1k7Dl62Gbo1PiXX8zg/EnzC0FutSivNwiK6Hf6b9pY48oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=jlOHxXCx; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="jlOHxXCx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V8RONei49XuW+pG3nPA3nEQSp6UOlpl341CHGBHq87o=; b=jlOHxXCx8AZ0vbZ+8BOkBujfYx
	CSXEFE7ObyYXLilbHpf/e2ek5gXmhp76vKehSyDxRbJw52JmRQ9wRHGhSotz1YTzFhkJtS/NBVkJL
	8R2xUbv/GeQorPcvBAC725axKhXWUzmqGq+8MoVvZcYlcUBJ4gh/uWHwchF4acWqrFVtNxTaVQ257
	a8s99tZOpEkx2wau33spTHUgvjmo13SmxEQRVMEdIGcCb+45VmzP4ZGw2ebZHdDaK0TIzogrNjMbQ
	iqYPDP0gWx/3iykvadx33k39jKqXIkLC45RHQUV6sQF878hXW6XmC48rPZa+C34dyY0aF+2bDHxCe
	5BjqLGqA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wh77T-00000000488-2C0I;
	Tue, 07 Jul 2026 16:49:55 +0200
Date: Tue, 7 Jul 2026 16:49:55 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] tests: shell: expand get command test with open
 intervals
Message-ID: <ak0SE7hrYpUdxjVK@orbyte.nwl.cc>
References: <20260702123634.349861-1-pablo@netfilter.org>
 <20260702123634.349861-2-pablo@netfilter.org>
 <akz-fH24aKQbjaHm@orbyte.nwl.cc>
 <ak0KITUOuYAXYm5v@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak0KITUOuYAXYm5v@chamomile>

On Tue, Jul 07, 2026 at 04:16:01PM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Jul 07, 2026 at 03:26:20PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > On Thu, Jul 02, 2026 at 02:36:34PM +0200, Pablo Neira Ayuso wrote:
> > > Extend the existing test to cover get commands with open internals.
> > 
> > This test fails on a Big Endian testing machine running Fedora Rawhide
> > running 7.2.0-0.rc2.21.fc45. Does this perhaps test a recent kernel fix
> > or something?
> 
> Does this kernel contain this kernel fix?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git/commit/?id=d63611cbe8af99dd61b118ee6e5b5e3e518250b2

Ah, thanks for the pointer. Rawhide kernels are "best effort" by early
rebase vs. excessive backporting, so a fix in nf.git must be rather
critical to hit it before linus.git.

> as well as this userspace fix:
> 
> https://git.netfilter.org/nftables/commit/?id=4eafc1a2a9ef5a827b1b4e58cb3b2832d2eb1650

Yes, this is present. To give you a bit of context: I have a script
which builds current upstream HEAD of iptables, nftables and
dependencies on a fresh Rawhide for running the test suites. I reserve a
RH-internal Big Endian machine (s390x VM) for it. The goal is to detect
Big Endian breakers early.

Thanks for clarifying!

Cheers, Phil
