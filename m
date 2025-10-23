Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0656D824A3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 20:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761252457; cv=none; b=h1Xi1ftDV5/VRmtA8rfh5hth02G6WfPd62OQ0pbQ8FN/rUAzotxCAtakzLRj3gW3cf30hzVsP0USfvoVlDNgQmnOvHTWmEx3GTHl6h1hfSSB6cIDccof2i7f+iNN5CWwvODNXRynVr45aBp3At+snj7X8OdO+RwMlUYNWb/rSMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761252457; c=relaxed/simple;
	bh=Litu5xVtJ3idYX3iYPHymrX2JNCVKMg7rGZKco7Dk2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARb2UlP+8YzjPoOLEy6IzpLTF1xUwWvA+NHHs7SS4eq35HzlPvKIRCIsaU+hfU1M3FGcZInAh1UW7H5EDctkBYxwyFjJ4F9zFaCf2iQ8tM04KqOToFm7UD6uI1jg/MVej6dtKQE4R9kqZYgVx22Ct1gDMW3IiJs2MHNmpmAMwnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GWAp/Nt8; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GWAp/Nt8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Sm94pdjNKBzLZXB7jqfk4XCDhDijvUiepFCBUsihsXs=; b=GWAp/Nt8mhHBcs/GHgfJJfXENJ
	CqVE1BTZGI11Hv05g0/yLVr6/Hxn4P1HMNjeI/BTyPoivz6AXC0QrMbklBOLgcl9gXifsk02BtrnZ
	0B4c2gybsNkpItmFx/H6Truxn9se4mbuKcpdW5NPjNZRy/nJIPy6t4eT2mKYLhAp+qVUa8+XsnkWG
	nCIEG62wXoN233LDU4OknVeAdGI0x+vWR1dnsoHiEdOTIAegoNc/qBfpaH9yb2IcDy38ZdCBKM6Bt
	LpjTYZvGy+RqrN3iizup1aotluJI4so0CjCUjuFKjVYdGtJmC5UgpY8mMN7+PhhZWpwAGri7QJyZH
	aVRn5XFQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vC2Dc-000000003lV-38E6;
	Thu, 23 Oct 2025 22:47:32 +0200
Date: Thu, 23 Oct 2025 22:47:32 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 00/28] Fix netlink debug output on Big Endian
Message-ID: <aPqUZJMNryg1ldNf@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20251023161417.13228-1-phil@nwl.cc>
 <aPqT1mTgJv-Ni0cJ@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPqT1mTgJv-Ni0cJ@strlen.de>

On Thu, Oct 23, 2025 at 10:45:10PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Make use of recent changes to libnftnl and make tests/py testsuite pass
> > on Big Endian systems.
> > 
> > Patches 1-7 fix existing code, are valid without the remaining ones but
> > required for the target at hand.
> 
> Please push those out, thanks.
> 
> > Patches 8-12 are a mixture of fixes and preparation for the remaining
> > ones.
> 
> I think they are fine too, so just flush them out.
> 
> I'll go over the rest tomorrow.

Cool, thanks for the quick review!
