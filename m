Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2ED49634
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 05:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721712591; cv=none; b=unpVh5gMfJedsqFSiZzc7jxgCbFt7YrbBtHAGlAqHYcAquDhRfJ/8xj0R7fbDzu1XTkyup5hxqGbZlQuamJSuGjn4xBhtftyQmsj3KB7kCyG/sfQfisMznlj2kleZ0Wk9dhzuMSzy66IrzgwtcLBwprLT8eCBJEUcYdOhz9IYZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721712591; c=relaxed/simple;
	bh=4QmbYa/DiUopS4MozeavkOrzbb8BhZBnz5sc+B2d8jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=caQ3WL5pgKGGbIEEV2TVE+dGW/hL59cfflDsZ49AXq1bkM5MMPsKQMS5dL4UGHaUb9Btx+nN5XOLgnwizDiCKBbSyChBeU2Zm/+rhRQhTzZpwgH9D59gvSy9Wa/U6ZBlWU11tJW07i0lPZ/9oUTyT7k8D+2ShCZBgzRbCCXJTAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=O4jOWAIH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="O4jOWAIH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oM4/GwQu7mz1WxxvKd6AgXHvxqHwjkckihkJa5/0hAY=; b=O4jOWAIHjsIt2bhVk4fzB26tUv
	OJ6+9OUAuazs0zEvciD+TogTs3ZrwWzdB3qM036WWTrMLNd9mOAKK3jpFK505KTMRDHlyJERPNYiz
	1mUl1+24LL5gUuLtUD0JP5FKm75tk0gmv5suFVbyhtXk1fdwJwQDPvG1dM7R+K+f/WaVJhK2cWi9B
	0w5wEool8gL37jelna+/m2fA2sOOLBIdaCJMsDmPFI0+y0qKoyf6scdK4RH7nKsIEq+gK3TmnanXM
	l8hB4qQ/h94Wy+z/YOPBZKpmo1FLHzLRqsU6H93Ts8Qws8RpLU7w3wPmPkCMxukQehdNVB+vjXLvu
	2dvYKGdw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sW85k-000000004UF-1I4o;
	Tue, 23 Jul 2024 07:29:40 +0200
Date: Tue, 23 Jul 2024 07:29:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp8_xIP0FUsOdEHF@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Garver <eric@garver.life>, netfilter-devel@vger.kernel.org,
	nhofmeyr@sysmocom.de
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zp7QSXcMHt9a8Hm7@calendula>

On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 22, 2024 at 04:48:40PM -0400, Eric Garver wrote:
> > On Tue, May 28, 2024 at 05:28:17PM +0200, Pablo Neira Ayuso wrote:
> > > Cache tracking has improved over time by incrementally adding/deleting
> > > objects when evaluating commands that are going to be sent to the kernel.
> > > 
> > > nft_cache_is_complete() already checks that the cache contains objects
> > > that are required to handle this batch of commands by comparing cache
> > > flags.
> > > 
> > > Infer from the current generation ID if no other transaction has
> > > invalidated the existing cache, this allows to skip unnecessary cache
> > > flush then refill situations which slow down incremental updates.
> > > 
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > v2: no changes
> > 
> > Hi Pablo,
> > 
> > This patch introduced a regression with the index keyword. It seems to
> > be triggered by adding a rule with "insert", then referencing the new
> > rule with by "add"-ing another rule using index.
> > 
> > https://github.com/firewalld/firewalld/issues/1366#issuecomment-2243772215
> 
> I can reproduce it:
> 
> # nft -i
> nft> add table inet foo
> nft> add chain inet foo bar { type filter hook input priority filter; }
> nft> add rule inet foo bar accept
> nft> insert rule inet foo bar index 0 accept
> nft> add rule inet foo bar index 0 accept
> Error: Could not process rule: No such file or directory
> add rule inet foo bar index 0 accept
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Thanks for providing instructions.

> Cache woes. Maybe a bug in
> 
> commit e5382c0d08e3c6d8246afa95b7380f0d6b8c1826
> Author: Phil Sutter <phil@nwl.cc>
> Date:   Fri Jun 7 19:21:21 2019 +0200

I'll have a look later today.

Cheers, Phil
