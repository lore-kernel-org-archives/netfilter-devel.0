Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794534396;
	b=Q05IgzGePmVPQCGyMIAbjaeRMLFw+iBLq35Ai7mmaNpvrBkt3JbLWM4BNc4tzTgmcPSs
	 dTfO2PwjPkHkgDZXPXqtiecCFQ6NCRWzyoNEvjcC7TkE+4FGeoCPgCicU312sk8E5yf6G
	 IO+xso7m/dETw0Gm7qtogfwLeKsaPvskbLiwMrG8POD6XAm4ErY90JudWbq4+0mXJUvcN
	 0VFAhFnR3wdjoaovSS//d0e7vDOmfPgTomSKXZoOiZnrXexY8lYUMAalCsL5Ufcx2QUoJ
	 A0O7xrhJchogLmQ6sZAAcBACIkGs51jeT0H7YgDwyp4tlqZj2nC5ZyxhK3lAdasf8qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794534396;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8ugPyJZycM++/Po4nkE5U2kjFxqMbLlChnXj7srK6+U=;
	b=Yw1INE8W1x1lqNsAt481vHkSQiu04g8mSSXoSlBlJrCldKw82eOBOiK1Mf6EjE8ZsFLF
	 nHSuzWF1pe3ycBhxzknUbq4XqHuEFxsd+qWtKzan+Vv5c0/ZTkcYrx7H1+//jkKie1LyE
	 H5dZOJxB/CtKI5Lhey+G9eydTgv7UeFASufwarhhCSGl+slVEJFLbCg917t1HstEmkgfM
	 DI2MXx6sFIj2XbtxJEywjINeOAjlfw0fbtgDibFgJfDONhEBiZLi5TLr8IV4H/QjOS2I2
	 aoyuXjfDAnFVwggHbh1wfdgF1KLXDDs4d33+9YZJACfJ6WS/jaXsPUE7dg1aA2vCScQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A73606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2026 01:46:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08A73606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0F550602AB; Fri, 13 Nov 2026 02:46:27 +0100 (CET)
Date: Fri, 13 Nov 2026 02:46:26 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nf_conntrack: limit expectation master
 chain depth
Message-ID: <avZr8lPA-bN9Z9_t@strlen.de>
References: <20261110133443.21073-1-fw@strlen.de>
 <avZRah74LdH7P9LH@chamomile>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avZRah74LdH7P9LH@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Nov 10, 2026 at 02:34:43PM +0100, Florian Westphal wrote:
> > A conntrack can point to a master conntrack, which itself may point to
> > another master, and so on.  There is currently no bound on how deep this
> > chain can grow.
> > 
> > Force a max depth in nf_ct_expect_alloc(): walk the master chain and
> > reject allocation if it would exceed 8 levels of nesting.
> > 
> > Also add ctnetlink_find_get_master and use it so that ctnetlink create
> > paths return -EMLINK instead of falling through to nf_ct_expect_alloc()
> > and returning a misleading -ENOMEM.
> > 
> > This prevents unbounded ct->master->master->... chains.
> > 
> > This also restricts the number of call forward/redirects that h323 and sip
> > helpers will follow.
> 
> "Should ctnetlink_glue_attach_expect() or ctnetlink_alloc_expect() also
> check nf_ct_master_acceptable(ct) and return -EMLINK?"

I saw that but there are many patches in flight in this area, so I don't
want to meddle with those.

> It would be great to collapse this patch to v3 too:
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20261101225435.447072-1-pablo@netfilter.org/

?

Not following.

ct_expect_help() calls nf_ct_expect_alloc(), so I don't see how nft_ct
can create long chains after this patch.
