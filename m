Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B322B242D66
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2025 22:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757974614; cv=none; b=n1Eswniz7smdXOsPxSLrSyN5raW+shrgyFDXr/nFwnItn10CHu22VwPDEIaMb1wknP0XOx+ActexjSxWNk6UhA3pPSc6TN/9WJuHwtmytw2ujtk5ZIaCCIES1tO8nTomOni4kPakDmlg381jWIItS8/AExnXt9ATW/JgpucPzFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757974614; c=relaxed/simple;
	bh=YDjbzXGuEr8rmy9CcdcbyULJpGIlWW+Ro+CdC+iIy/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ebj14bORDRdrBJapQbSmVdl+3Ytil65eyJLVKEu9fhgd2w2EMwLoY8pUo1pngCxyq6mobV7KcEEbWL6setKSNbnronXYjo94W+orHCHAHr4NMohqLUWXG5/5W0BbSPeB8YU6XZQQmWPgopX7q6ZsbBuLQ5Pbm2NcyBcUEz5OuB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=fuhuLGyk; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="fuhuLGyk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uwvBGQud2x3QqoITRnOeH7tEJWuFFxBfsVfueePM9mc=; b=fuhuLGykyC/qWMID0cu+vtqSyP
	fauWSEpSq4BwHZihlOw6U03pGIKAOThXFXWbhMSLln227ZJwEUObSmNI/4gCiPjWl+ZWyX+EArmsR
	lZcGRXlfV2tgUdKWmoIxoowTBHb0TvR2ELyTXEU5sLJeXuU07yO9qY6gi0IKs1s4duuCa7iOkilWl
	cOYywf7R+D/3N4E7XoJLwLfw1t0MFuge6g50numpZeqVv4OLHQPV3rKBnwhXeRhEEvO10WR5RACDg
	ZXQYg7oYvZfIzNodH/M0Rt3nkvSrmSGJLM4NQKqlQmSYQpJ0QMSNnO5euwAffOOHSbHIbrD28nbCJ
	e0UW06DQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uyHV4-000000001q1-0tWx;
	Tue, 16 Sep 2025 00:16:42 +0200
Date: Tue, 16 Sep 2025 00:16:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC] data_reg: Improve data reg value printing
Message-ID: <aMiQSi-ASbcAE5CL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250911141503.17828-1-phil@nwl.cc>
 <aMiC3xCrX_8T8rxe@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMiC3xCrX_8T8rxe@calendula>

Hi Pablo,

On Mon, Sep 15, 2025 at 11:19:27PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 11, 2025 at 04:11:45PM +0200, Phil Sutter wrote:
> > The old code printing each field with data as u32 value is problematic
> > in two ways:
> > 
> > A) Field values are printed in host byte order which may not be correct
> >    and output for identical data will divert between machines of
> >    different Endianness.
> > 
> > B) The actual data length is not clearly readable from given output.
> > 
> > This patch won't entirely fix for (A) given that data may be in host
> > byte order but it solves for the common case of matching against packet
> > data.
> > 
> > Fixing for (B) is crucial to see what's happening beneath the bonnet.
> > The new output will show exactly what is used e.g. by a cmp expression.
> 
> Could you fix this from libnftables? ie. add print functions that have
> access to the byteorder, so print can do accordingly.

You mean replacing nftnl_expr_fprintf() and all per-expr callbacks
entirely? I guess this exposes lots of libnftnl internals to
libnftables.

IIRC, the last approach from 2020 was to communicate LHS byteorder to
RHS in libnftnl internally and in addition to that annotate sets with
element byteorder info (which is not entirely trivial due to
concatenations of data with varying byteorder.

I don't get the code in my old branches anymore, though. Maybe if I read
up on our past mails. Or maybe we just retry from scratch with a fresh
mind. :)

Cheers, Phil
