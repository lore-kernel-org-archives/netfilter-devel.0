Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB9490C0B;
	Mon, 19 Oct 2026 08:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792399336; cv=none; b=LGcdkBeIIwoXJX17rX3L0Vmhlugw35pDmCpPdv9tSYznmTzt+Si/eitKlDXbCrV9/ZLsab+mmG83bo5Foz9PoSt2/KKFvkc9lnImkkZJ3UAZAom1LI4iT7BjNsicRExUdlah/D3YdLCynP0A/l3drt1YEK7veGZ5RfrH7XZEmGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792399336; c=relaxed/simple;
	bh=l72QEcfR7AVY2CxgGwa+lj9tdxTb3qzMrD7bqOXXGD4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dkfYKvJivnNoVOxzixiavIkOAo8cJGzDXgy68Phu45EW1RIl0ubGAdiQ71/VkDiPnTJ3JI26zemYHtEAfazV6udK6VSZOYY6fMGvH4fLccQJZjuYeM8DzKGgcl3LfypIbfkWCTH6XnWTW4PjBM8XX7zzxtvjD5jySBfOl9nnYWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E797960515; Mon, 19 Oct 2026 10:42:11 +0200 (CEST)
Date: Mon, 19 Oct 2026 10:42:11 +0200
From: Florian Westphal <fw@strlen.de>
To: liuc63 <liuc63@xiaopeng.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Florent Fourcot <florent.fourcot@wifirst.fr>,
	Romain Bellan <romain.bellan@wifirst.fr>,
	Weibin Liu <liuwb@xiaopeng.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_netlink: fix inverted IPv6 tuple
 filter
Message-ID: <atXX4zhsKh_qRvgM@strlen.de>
References: <20261019075629.2091511-1-liuc63@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019075629.2091511-1-liuc63@xiaopeng.com>

liuc63 <liuc63@xiaopeng.com> wrote:
> From: Liu Chao <liuc63@xiaopeng.com>
> 
> ctnetlink_filter_match_tuple() returns 0 (no match) when the IPv6
> source or destination address differs from the filter, because the
> !ipv6_addr_cmp() test is inverted.  ipv6_addr_cmp() returns 0 when
> the addresses are equal, so the negation makes the branch trigger on
> a match instead of a mismatch, which is the opposite of the IPv4
> path above.
> 
> Drop the '!' so the IPv6 branch returns 0 only when the addresses
> differ, matching the IPv4 semantics and the caller's expectation.

Reviewed-by: Florian Westphal <fw@strlen.de>
