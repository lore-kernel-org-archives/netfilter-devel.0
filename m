Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8EB22126D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Feb 2026 17:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770139134; cv=none; b=cGYjv/67I0geBSrxYPkCqob9g6BeGhkp32ErIMY1M8NbkzSuayyeE3fXmV8eOETeQo9iScOiymaUZB02mU7lWMqD/5p4G8JVYt8M1Q8MWaj/OEP9Jd5VrxWCWzvdwWK9YuCrbQBtK07nAY+B6b6DIIuWlKWD5DKkzDTpZPpgwKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770139134; c=relaxed/simple;
	bh=5PPi+eJmcKEjAKBWrlT5N5cgCtnwHEbad+MhXJh7LmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WaYAvcALW93Umil1f+96w0xo4FFKNc7uegtbsVZp/a2Wsv8Szj4aIIJN1aAuNFoUgTnxHq0qjP3kFHdbpDhkbxjtxgOsVH6FhaV+/M7Zc/1l1Ebrlt3G0YXSYZARcsHX4KIw6xKpJwycwIBVDi7YTH2iUAS6OwThnCavvlVVvXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=J2yL/5pO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="J2yL/5pO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EVbpP9FVGMVt8AI76qtlMTVB0+bZqhn3N5fNmuG5b2U=; b=J2yL/5pOjV6O11WkBoB5zcwK/b
	/onvc2OXCyWnk2GgtxUTLw8kyYT/wfa0gT5mUQsQAfX3w2clX5yptqw2lCoYbK5yvWDPTC3TcSN0B
	TwWIO3tEq72BuukHeYvnQpnrXJzl5Cj6gPTU0VyX/ePT7lrHAjwQQzOLg41ghhZla90/Od8Ta6y3P
	luNFFpwG5FS/VA9F8rQDQVr8N8rbo2hZZaRvCTB1CcLxSCqAx3wEJ+o+cqktaISlasDtvqbeeXFv3
	pL98+ceWz3rahK3el2m6RcafNuE0sHfS613me05RPs4D1kzbAmlLGdgtt2KIi3DpMCX2jgKetkpQd
	KLuwuLwA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1vnK32-000000004FS-3Gh8;
	Tue, 03 Feb 2026 18:18:44 +0100
Date: Tue, 3 Feb 2026 18:18:44 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [libnftnl PATCH 1/2] Revert "udata: Store u32 udata values in
 Big Endian"
Message-ID: <aYIt9IC8cepwJsq7@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20260129140707.10025-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129140707.10025-1-phil@nwl.cc>

On Thu, Jan 29, 2026 at 03:07:06PM +0100, Phil Sutter wrote:
> This reverts commit f20dfa7824860a9ac14425a3f7ca970a6c981597.
> 
> This change to payload (interpretation) is problematic with package
> updates at run-time: The new version might trip over userdata in the
> running ruleset, avoid this.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Series applied.
