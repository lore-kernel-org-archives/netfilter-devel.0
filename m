Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18092D0C92
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853110; cv=none; b=L2Q3bEookDgmNjW1ILbEqjKvjzuZYJfpkw2C1BD16oFXLVC0E+IZ1TclCpzkw8U7ulFBwAQBmencXBdEMLx1DfZSPVbdhy8PuU3bBYZjveQQmNVKwiI3C9GVrPYA5+nRTchsIDYgoKN1G9uirYWtv3a5mNyJC4qMRB2QcZh0RSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853110; c=relaxed/simple;
	bh=/fj5mrMt8o4cRgEuAiqRri4eAknIvy2beDE9cRSq8MY=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dxaNVe+25CC9VbHFNxXrLzNk57r+nFrE3mMJH2m/+ynb3inHuC3Zs9VRlH8gUsWmQrQ9ghPbW+aCtamkCdo1n7N3gfxwNZKi15YQGBI0SDruTxV8IZF1TV+SSzBqaYJrRL8E6FK9p5Jn92IcU2qCXxtv4Q+UCcRtc+GH8fGcgYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nojuJQ0A; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nojuJQ0A"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 7B4F16026F;
	Wed, 18 Mar 2026 17:58:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773853105;
	bh=zKLYfzse1yhfbrofCNki+Zfjujlsi2U2X5XjdEek4nQ=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=nojuJQ0AEoayEiGX3wBBbEeGycizXC4QFLoH7M7U8e++VGhAnFBdt3b19FonZayY/
	 mBzLLXGy70dbizXPDANOR9Bx1u0UQ62oUR2NWjCPvGLrjmvPVSxIgwkuVxgjfLbWDe
	 UvBY+8/FUFox7fUMP20q+cyJXzHY4d5s94s78MyAkC4V6918lnpTx9K3XL2aHI8uAg
	 S7kwqBVBRmfj3xy3dRlK+lyk5tiPKPG0MNth5JsEVLPu0L4w8rUiR0UMO4e3ZThg6L
	 vVghnjqLnrTOdYc85wBkxtyFRCrn4PGptH+zru/ICCaStb904ldTpxt7EK1Q6HAAQA
	 6AcW+WS5aM6eQ==
Date: Wed, 18 Mar 2026 17:58:22 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Eric Garver <eric@garver.life>
Subject: Re: [nft PATCH 0/5] Enhance cache filter for list commands
Message-ID: <abrZrnBsHXOwhdRS@chamomile>
References: <20260310231115.25638-1-phil@nwl.cc>
 <abrRdC2OXLyj6xnt@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <abrRdC2OXLyj6xnt@orbyte.nwl.cc>

On Wed, Mar 18, 2026 at 05:23:16PM +0100, Phil Sutter wrote:
> On Wed, Mar 11, 2026 at 12:11:10AM +0100, Phil Sutter wrote:
> > Reducing the amount of data fetched from kernel improves performance
> > with large rule sets but also reduces adverse side-effects if multiple
> > versions of nftables access the same kernel rule set. Being able to
> > ignore parts of the rule set one is not interested in allows for (more or
> > less) safe coexistence if each tool is operating on the data it created
> > itself only.
> > 
> > This series reduces caching for list commands which specify a family
> > and/or table. To help testing this, patch 1 extends netlink debug output
> > to include chains, flowtables and objects so a test case may check if
> > they are fetched or not.
> > 
> > The remaining patches actually increase filter use.
> > 
> > Phil Sutter (5):
> >   cache: Include chains, flowtables and objects in netlink debug output
> >   cache: Respect family in all list commands
> >   cache: Relax chain_cache_dump filter application
> >   cache: Filter for table when listing sets or maps
> >   cache: Filter for table when listing flowtables
> 
> Series applied after inserting suggested Fixes: tags.

Uoh.

I did not even get here to review.
