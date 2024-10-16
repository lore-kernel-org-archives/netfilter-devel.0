Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB12187342
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2024 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729098447; cv=none; b=BT+osnbfy8BIE89pbGD/T+g4iWAIpr6uM3/QS60OzA+JjG5fKV4t7Y6y3GenJ7lUZn1JbFKihnMTuaxNxnkJ8MAtPee8PSfuY6ZjUQhvhuOM01bY2LAPNJFdYzjCdmR0B/7hKR/AM1ftGlylRfXvDb6OpT3RtN6z0ZuEk5tYe88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729098447; c=relaxed/simple;
	bh=KYHniJxYqOM2u2mg8P2sHzfe3ILrtivHpoXbPWId6Ic=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GuSXnHZBCkGiHX1UfTga5PnD/Rbivx8/oQCRkR+EE32oJ9l6mZJ2TlnhNEDf1PdWS8mMMnQCgy676HEeD/BvVCE543Dst3YuHN1RdBWg1xpT1AuDPSmfsDULvi86lRhrjaioOVVqgwLK8yu+cV9kPagqc/1nPCBUKkwW4kRSYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=R9+WCIjO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="R9+WCIjO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KYHniJxYqOM2u2mg8P2sHzfe3ILrtivHpoXbPWId6Ic=; b=R9+WCIjOBtCKhaf6BDIR27dKct
	xVC+X1lfRbSnKxCagfvQS2iz4uNX49ExFFS9Syo0xVOaa+wxy2Z6BfGYRDhbZAU/T6twRuAe3WVeL
	k3wZosrRJd5xjdK/jtlPFu+75VdEC2v2G83PmZvpUxJbhYyM6fOln3b2Hhs+IsxCQZelBtYSqgWhR
	P+XVEF0WnRLb4SjRCEsyg6AIay8cEgfWjhAeFX1MODBo/vGVl+3XL6zKLO891wM9lHZn3wpFJt6YK
	Ym1qRFsDSoxG6wiKWlz4e0V7mU0326IHZOIrgbxy69KFVYVhfLNChRagHHzS1Y+cn880Bq8A8Rvwy
	EmQDieBg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1t17Ua-000000006KP-1IJE;
	Wed, 16 Oct 2024 19:07:24 +0200
Date: Wed, 16 Oct 2024 19:07:24 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [RFC libnftnl/nft 0/5] nftables: indicate presence of
 unsupported netlink attributes
Message-ID: <Zw_yzLizGDGzhFRg@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20241007094943.7544-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241007094943.7544-1-fw@strlen.de>

On Mon, Oct 07, 2024 at 11:49:33AM +0200, Florian Westphal wrote:
[...]
> Extend libnftnl to also make an annotation when a known expression has
> an unknown attribute included in the dump, then extend nftables to also
> display this to the user.

We must be careful with this and LIBVERSION updates. I'm looking at
libnftnl-1.2.0 which gained support for NFTA_TABLE_OWNER,
NFTA_SOCKET_LEVEL, etc. but did not update LIBVERSION at all - OK,
that's probably a bug. But there is also libnftnl-1.1.9 with similar
additions (NFTA_{DYNSET,SET,SET_ELEM}_EXPRESSIONS) and a LIBVERSION
update in the compatible range (15:0:4 -> 16:0:5).

We may increase incomplete marker correctness by treating support for
any new attribute an incompatible update. Given that we often have
dependencies between libnftnl and nftables for other things, it may not
be too much of a downside though.

> Debug out out will include the [incomplete] tag for each affected
> expression.

Looking at the impact this series has for such situations, I want to
make the iptables-nft compat extension stuff depend on it for better
detection of incompatible rule content.

Thanks, Phil
