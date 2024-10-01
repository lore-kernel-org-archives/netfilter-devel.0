Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17E9BE6F
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2024 14:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727791541; cv=none; b=MOtzWOMsVNKZCOifsEQSYB17EME27vBz9NI7jrbMWZ0mOI2TzOFsrRit5XMe4tWYbRHJYf6kDoCcK8HZP9pcq5Vvt0R85HiLFgoHYSmcCNDu9qBwURr/mL4LC+VzBOCOYuJ+NZRda6ACBruwZQbeloE8TOeIM3aZB4S9raSCGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727791541; c=relaxed/simple;
	bh=bEC9N8Camk7wy62faOgOidhi7F9sd9RGey+DgZyO8Zs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nkRyfI4SMCHMpUbOQn1V/Y/6/IGQmw2yg+0yvWCFcZ/IEYaJV+8EA8WeZVEZesBK/wV9wsPRMzGVH6O1+xj+6AQEHSeTEoJMVvkbkazB4X87AWLe1TVXkY26zMVXcc8nGduyy4BJw2zE8jrAZHY7pdeOLiA3kzj4Ff/jrLAqALc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hpId2Ml+; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hpId2Ml+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PCmKEoctzqgitlsb28/pUyFa4BEaJCFtVWGEeFFhedA=; b=hpId2Ml+92bNMxjmMcS4b1jeRO
	Kr1m7iD8uB5E3LlPwVSgwN8oIvpzOcE48HZIqbD2d3/iNuCAYs8Z9sCjW3uDV8G+7WPx4R2g0jh3c
	hflYNW8l9DVDPxNXLgOW+NpOWw+Qy36JR4unhSA67I43ZshcfrxbEYPvbHXwtuXhwFli4urcZLvLL
	PPaRPyrcA/LVvyeQZO9K54/eP9t55mCr5Fc+SpqElnNKub60khJKYIoHnLB1XCQFv3veBBtvhmwkA
	mbRmhbfR/YiE9/YOjwp6ip5PrSU9x+slfHnNzbU9U4+f1IRtrFX2F6eoEw/Ytpq4V+KxhcBOVRx2V
	qT17BKew==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1svdVP-000000008BQ-1nyt;
	Tue, 01 Oct 2024 16:05:35 +0200
Date: Tue, 1 Oct 2024 16:05:35 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] Partially revert "rule, set_elem: remove
 trailing \n in userdata snprintf"
Message-ID: <ZvwBr9kQ9EeuDP4C@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20241001112054.16616-1-phil@nwl.cc>
 <ZvvbzkNjJeEY25Fv@calendula>
 <ZvvtmN2QKwOfTNp5@orbyte.nwl.cc>
 <ZvvvRQm8N-qKBD4G@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvvvRQm8N-qKBD4G@calendula>

On Tue, Oct 01, 2024 at 02:47:01PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 01, 2024 at 02:39:52PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Oct 01, 2024 at 01:23:58PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Oct 01, 2024 at 01:20:54PM +0200, Phil Sutter wrote:
> > > > This reverts the rule-facing part of commit
> > > > c759027a526ac09ce413dc88c308a4ed98b33416.
> > > > 
> > > > It can't be right: Rules without userdata are printed with a trailing
> > > > newline, so this commit made behaviour inconsistent.
> > > 
> > > Did you run tests/py with this? It is the primary user for this.
> > 
> > It doesn't cover this because there's no test containing a rule with a
> > comment. I just added a respective test, but only to notice it does not
> > matter because nft-test.py compares rules' payload individually per-rule
> > and thus does not care whether output has a trailing newline or not.
> > 
> > I noticed it when testing the iptables compat ext stuff. You can easily
> > reproduce it like so:
> > 
> > | # nft --check --debug=netlink 'table t { chain c { accept comment mycomment; accept; accept;};}'
> > | ip (null) (null) use 0
> > | ip t c
> > |   [ immediate reg 0 accept ]
> > |   userdata = { \x00\x0amycomment\x00 }
> > | ip t c
> > |   [ immediate reg 0 accept ]
> > | 
> > | ip t c
> > |   [ immediate reg 0 accept ]
> > 
> > Note the missing empty line after the first rule.
> 
> None of the existing libnftnl _snprintf functions terminate string
> with line break, right?. I mean, for consistency with other existing
> _snprintf functions. Maybe fix nft instead?

Correct, though others don't emit newlines at all. I'll change rule
debug output to never append a newline and see what breaks.

Thanks, Phil
