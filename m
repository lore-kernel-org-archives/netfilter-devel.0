Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5483D3AB289
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2026 18:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776709283; cv=none; b=rOvqkq9stqK5Ezvkn3PLZvefc5WizUbyPctspUSUvWhXuDzT/KuDVn3WD/xSvgy39GyUBbIs52tIzvdzYgMViY3irRvLZ6zV4q9mNxzA77aTvVm4q1SJJ03fGXBGctlwvihyqg4avWGnX17Wvpe3OCA0EZ3dnwelYK8Zg3D3Bi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776709283; c=relaxed/simple;
	bh=xMYV6wYqLCqVFmQwUw/HfDr23EZJpVF/nfd8qhEY9Tk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GbMQHPWpZSejwRexOLyFPiwtBNvBZYr7RXPy2HMPtNkWL/fUqmhsckw0FxVuFYPhjrFezueW0vVPDd3FUEYVqNXy0KnF6tgCAC4KUZ9Roi9Y49GAw5xPHP7cuiHhLKCzF+SPoHhwJL9V8JnqOzqD26ZW5PVBkQycUVUU/bVLEAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 39EB560490; Mon, 20 Apr 2026 20:21:19 +0200 (CEST)
Date: Mon, 20 Apr 2026 20:21:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_compat: run checkentry() from .validate
Message-ID: <aeZunt0QSt2EdFdF@strlen.de>
References: <20260420174227.13087-1-pablo@netfilter.org>
 <aeZoiqyPFP0NJkz9@strlen.de>
 <aeZpj9r368paudyZ@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeZpj9r368paudyZ@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Apr 20, 2026 at 07:55:22PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Several matches and one target check that the hook is correct from
> > > checkentry(), however, the basechain is only available from
> > > nft_table_validate().
> > > 
> > > This patch calls checkentry() for matches and targets from the
> > > nft_compat expression .validate path for the following matches/target:
> > 
> > I worry that this is fragile.  Not all ->checkentry callbacks are pure.
> > Some create /proc entries or bump reference counts.
> 
> xt_set does bump the reference count. This calls xt.destroy to restore it.
> I am only calling them for the list of expression you mentioned.

I worry this will lead to trouble later, e.g. info->priv = kmalloc( ...)
-> memory leak.

But OK, at least there is a test case in iptables.git for this.
