Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE20204F93
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672980; cv=none; b=K2WDgtLphV5HWPOvix2kblCwwTr8BcvrEP7qIRicLDaqdwkf1PoKWfIjyJDmaYKh4euxkD39bcjDSKoDcPj3DvYsdiRDl93rEwe8ElfWg91z0zcxW9btkzvRat4J1Za1AhcI9u34YFtfEZ0RQPX279Zn6aqGjgtXsQA0QMrNfPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672980; c=relaxed/simple;
	bh=CjpvOsaxIrWImxpTSd1utTb/0msq6aVSyLIEVPX3YQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U4yGGUHaIXt2Hu0fORH3p5qp//zRU+VTTuQc7zTcO+/Y/2f5zAMVPY9i8X5iJ+ggaYdLCdLw3BZQS86XWi4H0h2fX/nEB399ldoKpapGzRJ9xOtB5lWbbNNQD68PDrl7HDAfSTfxOjFSXUs+L40qwqVCwNkD+OOsqacMS194ffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 714A96031F; Tue, 28 Oct 2025 18:36:16 +0100 (CET)
Date: Tue, 28 Oct 2025 18:36:16 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, ffmancera@suse.de,
	brady.1345@gmail.com
Subject: Re: [PATCH nf 1/2] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <aQD_EJJPB4WtHld3@strlen.de>
References: <20251027221722.183398-1-pablo@netfilter.org>
 <20251027221722.183398-2-pablo@netfilter.org>
 <aQC_3p8Xu9-p48nV@strlen.de>
 <aQD8vKn0O5iNuxif@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQD8vKn0O5iNuxif@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> iptables needs higher value, while nftables with vmaps could set a
> much lower value, because vmap counts as a single immediate jump.

Agreed.  nftables can use something like 100 :-)

> > I have existing / real-world iptables dumps that exceed 64k :-/
> 
> OK, so k8s can load this ruleset inside userns (because netns can
> still rise this value). But your concern is the default value, right?

Yes, exactly.  If you have a system that runs iptables-restore on
startup then after kernel update that might fail.

I see that init_net is exempted from any limits and thats a good choice.
I'm concerned about containers here.

> I can take look, you mean:
> 
> - IPv4 count => count jumps in all table except ipv6.
> - IPv6 count => count jumps in all table except ipv4.

Yes, exactly.  That should remove a bit of pressure to
use a super-large default value.

> Here, IIRC, I needed ~8 million jumps (_not_ net jump counts in the
> rule, I mean number of jumps according to nft_jump_count_check()) in
> the input chain to see softlockup with KASAN+KMEMLEAK.
> 
> 256k is still far from 8 million.

Agreed.

> > If even a random old iptables-dump exceeds the 64k limit I would expect
> > combined ip+ip6tables rulesets to be even more brittle.
> 
> Yes, the problem here to set this default value is iptables,
> nftables can set it very small, but iptables needs a large one.

Right.

> I guess native nftables users can safely shrink the default value we
> are going to set here.

Yes, absolutely.  nft --omptimize could eventually yell at users when
it sees too many jumps :)
