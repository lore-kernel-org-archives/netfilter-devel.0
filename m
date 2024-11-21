Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2290055C29
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732209603; cv=none; b=aRKPNJn+IlkgM3l71Crp6aqfGPD/2HzULaLqYIYWOn8dA1h21FK+QXHa91BwWD8LjXlmtjo79lrER+kC5eAsa0AosuIpmtSlP2q6EQtv887isBsHHdP2ULq1IBg0CdC3uNhHNdiTa0Cxe9ebeXjFt9SuEIxf+1as9A3A4+yR7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732209603; c=relaxed/simple;
	bh=+5o2JlhrX3o9LYdesYQBBQwB1SE9m6LAxA0+vFSvve0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqUzcy7X6f2sHBhp3MqdtyIHt1hxGQHscvbWRJrMvAfVaKbYUid6A0ksyszJeWCsDxyn4xDF/Xaj4fz2fIt8Q5Uv8/nT69tlCoEXtLCXGkahYvYJp3UL3DR5SEeWM9b4DvFSI/7mgJn5Z9ReBM1a9TcO+AmXX3BX+JruzySSz9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tEAqT-0006h6-V2; Thu, 21 Nov 2024 18:19:57 +0100
Date: Thu, 21 Nov 2024 18:19:57 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <20241121171957.GA25690@breakpoint.cc>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
 <Zz9N4CmuiLxQpaAH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zz9N4CmuiLxQpaAH@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > AFAICS we only need to update < 10 dump files,
> > so churn is not too bad.
> >
> > Alternative is to always store postprocessed
> > dumps and then always run sed before diff, but I think
> > its better to do the extra mile.
> 
> rbtree going leaks a raw count of independent interval values which is
> going to be awkward to the user.

Sure, wasn't that the reason why you iniitially wanted to restrict this to
--netlink=debug?  What made you change your mind?

Maybe apply the simpler, existing v1 patches only, i.e. no exposure?

I can just send a v2 with the new attribute names and no getter for
libnftnl.
