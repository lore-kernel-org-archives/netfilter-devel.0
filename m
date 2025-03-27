Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CF7155312
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Mar 2025 15:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743090555; cv=none; b=YCvwqyjs/OF/3o3BW6+DpJsQpeAqNXGIXfD174KPpel0YA0XYgC4IFfIea7RORLgfVlnlccNcEz94uMDvpm6rqmv+q7QbukrHvl1Z/yJvbsdKerBUtKrvkLcg5jVqAKW5xNerF8TIONteGZqFk0dMQsSZ+s5kIbr725LjhxLsz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743090555; c=relaxed/simple;
	bh=ZLtBoY+ItgmPfKLhk/cYEFIAy8aJ7hLs+SZaT5DBO3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p2FT0jSia4YqOKLgp0KIetXuAyV9CfB9ClvJJpAbB+64RnPLc7YKRKnod9PUORkKxr4Gg3PkSFaz7REE8eCSzzS4uloliudpCXyiRkza0YLixmUtiAyTwjyPb5RA0k/357AkgxDo5witezJeaUO/qQpIZijq78JZTVpjEnZ3Vgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1txpTi-0007lT-OP; Thu, 27 Mar 2025 16:49:10 +0100
Date: Thu, 27 Mar 2025 16:49:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: tolerate empty concatenation
Message-ID: <20250327154910.GB21843@breakpoint.cc>
References: <20250324115301.11579-1-fw@strlen.de>
 <Z-Vv1R-OmC2QukpS@calendula>
 <Z-VxdrgTRO1RTdBq@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-VxdrgTRO1RTdBq@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Mar 24, 2025 at 12:52:58PM +0100, Florian Westphal wrote:
> > > Don't rely on a successful evaluation of set->key.
> > > With this input, set->key fails validation but subsequent
> > > element evaluation asserts because the context points at
> > > the set key -- an empty concatenation.
> > > 
> > > Causes:
> > > nft: src/evaluate.c:1681: expr_evaluate_concat: Assertion `!list_empty(&ctx->ectx.key->expressions)' failed.
> > > 
> > > After patch:
> > > internal:0:0-0: Error: unqualified type  specified in set definition. Try "typeof expression" instead of "type datatype".
> > > internal:0:0-0: Error: Could not parse symbolic invalid expression
> > 
> > Maybe block this from the json parser itself?
> 
> Maybe this instead? This covers for empty concatenation in both set
> key and set data.

I don't like the idea of having to keep double-error-checks in
both json and bison frontends.

I would prefer a generic solution where possible, unless
there is some other advantage such as better error reporting.
