Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F72E3E9F61
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2026 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773859998; cv=none; b=p/xStxhDDeXb2FXbMyMP9z+G7h6XVYb7HrKHwAfhC8DH6zVIuW1lcezGbDmvn3n6spIKragUgoWuNrIwkbQGtks19ByRLO2XsdAKomwB3WyeByqe0oiMAfLvTlPTPxeO+WH3AbTPCwjjSQ+WplwOkfCSkkiPruq24dTaREEgz7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773859998; c=relaxed/simple;
	bh=RJAJmfde+A/ocbCJq56P4Sdqo/rbGLLrQtzsAaA8ZTY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/m63WBZbWb/c5yP6rFR5F82h9dFqfBA8dBeuXOoUZVt2KEJCV5VhidvkXLObIP6lvaVp2WS/zGftIhEhEEgbp/Ndth3yFQq+n2hpMq9bJtPXCeLLd5LsTtdycyHHgZpWCVI3utewK0bn3/OkcMhZ5fFGHb8bTVym1uVwpCcYgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Btq19ZwX; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Btq19ZwX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FNPLFW2XNoqTU5c/0l4WpwwxgicOMKJDqzBL6PgnkIE=; b=Btq19ZwXhTvo61swn9YJQCgetx
	EAvZaTE+jNcQUiZl8p9RlaiBZoZ3QtbhxS8VUYuaFLd6jCAGiUet4dU5P3bwDci/R83IErp/uWIEg
	W/rc02pHXx8oXDbOoB2/7hUVWivq2Uwo0AFy2koKAywFe9Zb8NcyKXGjO2K+zESND0O2SvkYKZV1v
	+1TxHPtTwmjNBL3Em981m1YXEtXUGopGZ1HKkiCoCuP96Oq+iheHymUiwIHbDmI7DPIHtQ9uw04Fu
	MciXck1GZR0X+fESu19QnLSUyJXLW+FEp3G+sV0ymLkBwGoNiWjmMdswdEfv4CiNff/yhXQBgHaqM
	HluHZhBg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w2w14-000000005TZ-2FEQ;
	Wed, 18 Mar 2026 19:53:14 +0100
Date: Wed, 18 Mar 2026 19:53:14 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: chlorodose <chlorodose@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] src: Export nftnl_set_clone symbol
Message-ID: <abr0mqg2A0V0DiWb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	chlorodose <chlorodose@gmail.com>, netfilter-devel@vger.kernel.org
References: <20260318025651.151116-1-chlorodose@gmail.com>
 <abqCdqPLJyKmBQc-@orbyte.nwl.cc>
 <abra_o50miSi49Aw@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abra_o50miSi49Aw@chamomile>

On Wed, Mar 18, 2026 at 06:03:58PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 18, 2026 at 11:46:14AM +0100, Phil Sutter wrote:
> > Hi chlorodose,
> > 
> > On Wed, Mar 18, 2026 at 10:56:51AM +0800, chlorodose wrote:
> > > Seems that nftnl_set_clone is forgot to be exported, we add it back.
> > > 
> > > Signed-off-by: chlorodose <chlorodose@gmail.com>
> > > ---
> > >  src/set.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/src/set.c b/src/set.c
> > > index 54674bc..e5e51b6 100644
> > > --- a/src/set.c
> > > +++ b/src/set.c
> > > @@ -360,6 +360,7 @@ uint64_t nftnl_set_get_u64(const struct nftnl_set *s, uint16_t attr)
> > >  	return val ? *val : 0;
> > >  }
> > >  
> > > +EXPORT_SYMBOL(nftnl_set_clone);
> > >  struct nftnl_set *nftnl_set_clone(const struct nftnl_set *set)
> > >  {
> > >  	struct nftnl_set *newset;
> > 
> > Don't you also have to add it to src/libnftnl.map? How did you test this
> > patch?
> > 
> > Looking at the function itself, I fear the code is not correct anymore.
> > E.g., it does not clone expr_list or user.data. If I was to decide, I'd
> > rather drop it entirely instead of polishing it up. What's your
> > use-case?
> 
> Indeed, this function is internal and it is incomplete. it does not
> provide a full clone.

I don't see it called inside libnftnl, though. Ah, it seems to have been
used by the JSON API dropped in commit 80077787f8f21 ("src: remove json
support"). And since we did not export it yet, we're safe to drop it
unless chlorodose has a proper use-case for it.

Cheers, Phil
