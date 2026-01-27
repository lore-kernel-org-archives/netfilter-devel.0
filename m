Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF49E353EEF;
	Tue, 27 Jan 2026 12:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769517211; cv=none; b=HDs6pmmAYBJSIOe1HwORBdrU6WVcbnsUjOMFsD9JMr5e0GR0zgYwvQPGzyRVJCRjARSFREOqhqCOSHMU3xcdHLrdsSpW21FtcKKiJ5kThlAzHg6sT1884CXsjRr9huPD6WgxwcZaR56fbqG8cfzV5CDR7kqzdJg49Rk0X6Jz8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769517211; c=relaxed/simple;
	bh=C2oK24VrfERRyJItryAq5ft76WMrPtYdaF9gSXkPde8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jmly3JaVmG2veAJ+/zX4TT9q2Jg8AhRgMM0x7qIj2aazioDyeQQryqufFmgvmLPr5s3lW4YFszoJvQ8p3TzSRpx5hdDPJQwjQ3q3hGiD/LWEwb3VVJ1Lro2f9KWp2WHKDGzgKsWzMyGAakId6IUZqdofKDNt86mVKHK1wEFRySs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E3A836033F; Tue, 27 Jan 2026 13:33:21 +0100 (CET)
Date: Tue, 27 Jan 2026 13:33:21 +0100
From: Florian Westphal <fw@strlen.de>
To: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v6 5/6] doc/netlink: nftables: Add getcompat operation
Message-ID: <aXiwkXKg7uvIon4p@strlen.de>
References: <20260121184621.198537-1-one-d-wide@protonmail.com>
 <20260121184621.198537-6-one-d-wide@protonmail.com>
 <aXiiYOxuXVn5YhXG@strlen.de>
 <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2VtJPFWA2Kgxe16KslviULQU9LRZsdYFsoUD6VZ9CH-49a2P2fwiQ9B03i3Rmfq6tUczD-oiGpWCCs9aPGwwD2N-vVzy4cFIZT7F7-83Fc=@protonmail.com>

Remy D. Farley <one-d-wide@protonmail.com> wrote:
> > Whats the intent here? nft_compat isn't used by nftables, this
> > is iptables-nft compatibility glue.
> 
> I noticed getcompat operation used by `nft list ruleset` command, and it
> doesn't seem to be defined anywhere else. Should I re/move it?

Its used by compatibility mode, it requires an nft binary linked
to libxtables, native nftables doesn't need it.

I would prefer not to mention its existence.
