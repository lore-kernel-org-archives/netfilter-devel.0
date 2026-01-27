Received: from mail-24431.protonmail.ch (mail-24431.protonmail.ch [109.224.244.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95389347BA5;
	Tue, 27 Jan 2026 12:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769517902; cv=none; b=otRaAs8URHZnibek8ppABWY39+YHOqMR/cplWYOHekXW2eJCmIAK/HWAGbnKifZtoZG9hT/+RrR1eVQdI4tGuVXqtCCwdD1ej59NZsgw+wLPFlVIfrkf8vV+p/jP+9zkRVIbmamr+CgSOxibHCreNo9uvMjbto0pSFf2uUcNW1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769517902; c=relaxed/simple;
	bh=/qI1KkfdbGxLYvSpOLUvzWtHz4bF7FNuyslfm+1wUw8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oYhcJzn7DMN3Qj8F1apPyZ7qv4XqMUsOCzus/d0ggi/1diOYsJ+380pOkkyOA+LQ3VETw0EC4AYrgon2Vjq1J8CR+7YTW+MYk5ztJjGmeewY3XOnTJfZsSHWeSKDfB45szO9Ih+Dsu0N/6XstEqC7tdS0F7SA9nNEOiDBbFFzvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=kQZ0HYQa; arc=none smtp.client-ip=109.224.244.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="kQZ0HYQa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1769517891; x=1769777091;
	bh=/qI1KkfdbGxLYvSpOLUvzWtHz4bF7FNuyslfm+1wUw8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kQZ0HYQaRCb6JR1WzkMfHeOoPPvv0kQyQoj7KEeDcRQkViO/jRFKBCvCHQ2I5cqCP
	 +n8gJwWy1FydaBcVucRp1rqQ+P9lbo+wt2xmWGrk4d6XQvn0SEZitLTLk8e3I8MB0C
	 tFcz1W2lL6C4QRfsyAgPQbZcn+i5gpdqpZZeJq6oKinXkeHgb+CKz0nW1itilcFZTz
	 9YT6Z5nU6mc5b8QYwPKafmPRUM35zqMXNw6HGErRuiuORhHjz3RPHqf64onbBa4sYB
	 9pEPlTgezSAKYQfdaq74WJcv2C0eda9q97aOFfTjtYX/CU7XYAfPbC0T8uu/BA0p7i
	 2ZXciyGdwOpVQ==
Date: Tue, 27 Jan 2026 12:44:45 +0000
To: Florian Westphal <fw@strlen.de>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <2mi8BfZGa57pxicf4pXNT_oDJ3bvV7pByJOBhG8e7u_3eBbjubS3YJ88xHp4oDiMi3iY20zcG6FgF8_m5nsJJ_3CYHNftjAL_4EAqN5zeU0=@protonmail.com>
In-Reply-To: <aXiwkXKg7uvIon4p@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com> <20260121184621.198537-6-one-d-wide@protonmail.com> <aXiiYOxuXVn5YhXG@strlen.de> <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com> <aXiwkXKg7uvIon4p@strlen.de>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: a6367344ac5633e3026c1e814b4a9a4949616229
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, January 27th, 2026 at 12:33, Florian Westphal <fw@strlen.de> wr=
ote:

> Remy D. Farley one-d-wide@protonmail.com wrote:
>=20
> > > Whats the intent here? nft_compat isn't used by nftables, this
> > > is iptables-nft compatibility glue.
> >=20
> > I noticed getcompat operation used by `nft list ruleset` command, and i=
t
> > doesn't seem to be defined anywhere else. Should I re/move it?
>=20
>=20
> Its used by compatibility mode, it requires an nft binary linked
> to libxtables, native nftables doesn't need it.
>=20
> I would prefer not to mention its existence.

Ah, I see. Netlink-bindings have a tool to decode netlink communication, so
it's a bit awkward to show a bunch of unkown-operations on a common command=
.
I'm fine keeping it downstream.
