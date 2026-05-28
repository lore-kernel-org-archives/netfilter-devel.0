Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27933329C7C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 11:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779968164; cv=none; b=ivPCdqQEEu63x3qhR5VaN8OWMJTqlKdZC23PUeUNpjsBh8LPEUgHM6LcBrcsQ3+7ooTSzsMA8x0IZMRtkHBT7JyQ84A3mPFXWwRioOA/kOfbsfyOSeHL+PDyNShY40rr2fXB1UOTK5Ev+l5A0AJO4azLSq0Sya/4efvxjA6+nP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779968164; c=relaxed/simple;
	bh=4CT3FDtGEZvw4ofdBhCsUV8puBjygw+dhtj5Pgh7mtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgTLKS/u90SFU6phD0UWLzK01gLNND81zKmC7ZomZBdwSFrfLHtAcaz563vnsw+474gkQ+DQpOYkHmKX7pXLeD5dOulhh1nHnKgieAd3JxVGhIumb5DoU8bd/gxfhNT8YzVWckw+/WWAWOwJBvJj/tlgBbVI2OUFxu/x1KkYn4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bG+BZ9VL; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bG+BZ9VL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=E/jgCjMZalj7ommXhn0ljHJje+EccMgf3UDpZNJPwm0=; b=bG+BZ9VL+ory+hURTc3m+rlAeI
	B0cezx3+jE3o0eO3A0bDTBU5As8D9eOBizopn050PQPaNYmhai6M58JfQR8upnDc6zK8z53328lJ7
	3DHTZxWToZnuHfGIrkTDvxw+Eipw9xdyW3lFHZ6cWH5qKIuqVfl0bcWmamybMqAc/M4Wh0qs/vn8/
	nTtUu4qMNa9CKmk3oRFC+h8H5hWMBtVYkuA3+YHiqhsMqQUujHMVdsHGdtMTbRAZTd32DKEKqTA+M
	nDTRTMc5yQM28my/SVsfmvoMg1cDndel1sLSDq/ZQN/pt2VvRHEsyG6tvZX0L6ZcNkh1rrOLxb32U
	wBDOwxrA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wSZ1r-000000005xt-1mA3;
	Thu, 28 May 2026 13:35:59 +0200
Date: Thu, 28 May 2026 13:35:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2] scanner: Accept all statements' first words in
 all scopes
Message-ID: <ahgon4vGF4t0p-1r@orbyte.nwl.cc>
References: <20260508111538.3783172-1-phil@nwl.cc>
 <ahfy6vvK8dhvBig-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahfy6vvK8dhvBig-@strlen.de>

On Thu, May 28, 2026 at 09:46:50AM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > To fix for token lookahead with exclusive start conditions, we must
> > accept all keywords which may immediately follow the exclusive scope in
> > that scope as well. This affects basically the first word of every
> > statement which may follow a limit statement.
> > 
> > Add a test case to make sure things stay that way. A few quirks exist
> > though:
> > - xt statement would need special testing since having it in a rule is
> >   supposed to fail the command
> > - The parser formally accepts nonsensical things like strings, numbers
> >   and variable references on LHS, but these seem to be needed for the
> >   data part in map elements only
> > 
> > Suggested-by: Florian Westphal <fw@strlen.de>
> > Fixes: 9d105581b5f1b ("scanner: Introduce SCANSTATE_RATE")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> Is there anything missing here or were you waiting for a formal ack?
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Oops, yes. Just pushed after making sure it doesn't break 'make check'.

Thanks, Phil
