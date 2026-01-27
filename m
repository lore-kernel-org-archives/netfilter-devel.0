Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097E01A267;
	Tue, 27 Jan 2026 13:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769518830; cv=none; b=nP7aStKlY6c22XsKd47zcHS47SDRg6fiw1ZfKwJ9NHIV2qUGlBlU5ZDSthSV7/yINKMGAgq9usSRXqklCE31V2rCfjMTrZGc5grLBQp+UxuEu1RrvzVJR8hc0wAN9ErufwAnyVpbwmueS+EqVUjrJZRMXcKN6Qis1nTAfU2vZzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769518830; c=relaxed/simple;
	bh=oLR+gZMbDd/CCv9Wa5C4E2lll9KuLUj11Zia3brqlHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V+Q0zC7TjSXjIBxY8ZCHq9KiJOt/23b6Z8RIyQTwJ5bT/UWCXoNwz2JAbfUbcLtYHALNBuXKY1obgbl8y+pmdrrmjk4TBRpS2QWJu/4nlGk5HkAKYvi/j6lSiejDPVaSuIB894FQcR3qe8OQO9s15SrRBRRjmJjdrtp1s0WlHR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 23DA96033F; Tue, 27 Jan 2026 14:00:27 +0100 (CET)
Date: Tue, 27 Jan 2026 14:00:27 +0100
From: Florian Westphal <fw@strlen.de>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <aXi26_vIXqQPhopG@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
 <20260121184621.198537-6-one-d-wide@protonmail.com>
 <aXiiYOxuXVn5YhXG@strlen.de>
 <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com>
 <aXiwkXKg7uvIon4p@strlen.de>
 <2mi8BfZGa57pxicf4pXNT_oDJ3bvV7pByJOBhG8e7u_3eBbjubS3YJ88xHp4oDiMi3iY20zcG6FgF8_m5nsJJ_3CYHNftjAL_4EAqN5zeU0=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2mi8BfZGa57pxicf4pXNT_oDJ3bvV7pByJOBhG8e7u_3eBbjubS3YJ88xHp4oDiMi3iY20zcG6FgF8_m5nsJJ_3CYHNftjAL_4EAqN5zeU0=@protonmail.com>

Remy D. Farley <one-d-wide@protonmail.com> wrote:
> > Its used by compatibility mode, it requires an nft binary linked
> > to libxtables, native nftables doesn't need it.
> > 
> > I would prefer not to mention its existence.
> 
> Ah, I see. Netlink-bindings have a tool to decode netlink communication, so
> it's a bit awkward to show a bunch of unkown-operations on a common command.
> I'm fine keeping it downstream.

No, showing unknown-operations is even worse.
Maybe just document in commit message that this is to avoid
clutter and present something more readable.

And perhaps mention that this is only for iptables-nft in the yaml file too.
(nft uses it on 'nft list' only if it encounters a rule added by iptables-nft).
