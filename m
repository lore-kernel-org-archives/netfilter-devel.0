Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C25E1772F
	for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2024 20:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713991319; cv=none; b=AI7jBSPrK18GlPOgwUl9PjvzHy50iH4ZvIJY21aK10elx9XT+a+d+5nSRrb/hiPutbl/rwnj1LEyy8gXmelyh0GBfnXIIQn35eWL9/ahnJMrMqygVVo4rynmRxdekyzf4wSI69pXXti7bdXq1SWA+CS3vlue6nO4i1s9jS9gIjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713991319; c=relaxed/simple;
	bh=YK/C5HMFMO+VjoYSX/QOHiGkNRb3lMHI5aN3BvFXSdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/HXvwqPAK0nXxjb4YJOefNISQr7hgn/EsX6e7OuF8Nng+jrAdOEOtezubkIgFoBnlaQbWYoKbCUYqf1kpcgPHsRWYxcGzAuEBJ2GUOkXuw6LL8o1qaagJNfFYz8spHgygaZ9Zi6gDM+L9PDMjH/YOZEuZZbkWNOa8mnhQ81UmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=SaMJSv+J; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="SaMJSv+J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=v8JumbhNbhkaylj1807TjacKXDZlOp4WLRFROGBng+k=; b=SaMJSv+JwXDBlASQgROT83CSL0
	A/YhGC7aPYTW2hxeIw6sJPWJM1bEJjO7z8xH0PchlmZFkNQhokpycxJre/heQVkVDuT853hrkGNZ/
	r7S1DWXV80K045y51Aa5vNIpQw2z+AVQe+iMgP+URlUj3niI91WZOMSE3Uu3zwvvOZf2DgwKlSGAo
	eraaCzjJJqqvJT/0BKlx88XzzjvI000K8ncn1osdH+55Zbb3Ch1Dxsp4L9+AVK4PB+va+mv75ppvQ
	QVMI3bt1XVYKy8/f5HmP4pwvjkbyASR5JqlMgUAzK/aC+7mKrAlDVDdO6entJXtE7tkzkivXO1pBa
	Ntlv2R0g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1rzjRB-000000002ya-3Y1L;
	Wed, 24 Apr 2024 22:41:53 +0200
Date: Wed, 24 Apr 2024 22:41:53 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/7] A bunch of JSON printer/parser fixes
Message-ID: <ZilukXKP3frjjHMF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20240309113527.8723-1-phil@nwl.cc>
 <ZilmMzQIAyvvuFqo@calendula>
 <ZilmoE1LAAMErFbU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZilmoE1LAAMErFbU@calendula>

On Wed, Apr 24, 2024 at 10:08:00PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Apr 24, 2024 at 10:06:14PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Sat, Mar 09, 2024 at 12:35:20PM +0100, Phil Sutter wrote:
> > > Fix the following flaws in JSON input/output code:
> > > 
> > > * Patch 3:
> > >   Wrong ordering of 'nft -j list ruleset' preventing a following restore
> > >   of the dump. Code assumed dumping objects before chains was fine in
> > >   all cases, when actually verdict maps may reference chains already.
> > >   Dump like nft_cmd_expand() does when expanding nested syntax for
> > >   kernel submission (chains first, objects second, finally rules).
> > > 
> > > * Patch 5:
> > >   Maps may contain concatenated "targets". Both printer and parser were
> > >   entirely ignorant of that fact.
> > > 
> > > * Patch 6:
> > >   Synproxy objects were "mostly" supported, some hooks missing to
> > >   cover for named ones.
> > > 
> > > Patch 4 applies the new ordering to all stored json-nft dumps. Patch 7
> > > adds new dumps which are now parseable given the fixes above.
> > > 
> > > Patches 1 and 2 are fallout fixes to initially make the whole shell
> > > testsuite pass on my testing system.
> > > 
> > > Bugs still present after this series:
> > > 
> > > * Nested chains remain entirely unsupported
> > > * Maps specifying interval "targets" (i.e., set->data->flags contains
> > >   EXPR_F_INTERVAL bit) will be printed like regular ones and the parser
> > >   then rejects them.
> > 
> > I am seeing memleaks when running tests after this series, please see
> > attachment for reference.
> 
> It could actually be related to:
> 
> 0ac39384fd9e json: Accept more than two operands in binary expressions
> 
> I did not bisect yet.

Good catch! I missed the fact that json_array_extend() does not decref
the emptied array. The fix is simple, will submit after the testsuite
has passed.

Thanks, Phil
