Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F301276025
	for <netfilter-devel@vger.kernel.org>; Wed, 14 May 2025 12:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747224945; cv=none; b=crrm7dDkeozsaFp1L1b0EzpSqaOBl4fpRBnmQ8NArifglaPhSddh91kGdfs1geq1J9HISG9JFaGKre8u5iXJ4EfBcI1GqFywrSyfJ02vnsNvysPgMVKvADqpliKMl9mRuuIIt/GbRH9EEZsNqdpkwzIuaaAMmI0Qp7WuOoUUJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747224945; c=relaxed/simple;
	bh=TvBGHlr/w4bb3weSyEPnv5vMcPa09RzykAuqxQ2vwP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAj+Tnq/pLjA8ieQxLx4jL5GL4afAJQdvfmp59Qha+Nj+VXyWsJUWTIS6b6W1YnD0C2SoSahjb8dUP44wMlrLCqQdrjDm08TBRB3OZyIw593+8lLD5yDUJ14eFtczkL1DszJtNYqYj63wD10uetcNaYJLoIniEu5Ll8v94w3qZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BC22E60033; Wed, 14 May 2025 14:15:40 +0200 (CEST)
Date: Wed, 14 May 2025 14:16:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Shaun Brady <brady.1345@gmail.com>, netfilter-devel@vger.kernel.org,
	ppwaskie@kernel.org
Subject: Re: [PATCH v3] netfilter: nf_tables: Implement jump limit for
 nft_table_validate
Message-ID: <aCSJiV5Hz-MTMFLd@strlen.de>
References: <20250513020856.2466270-1-brady.1345@gmail.com>
 <aCRPkxvH5LCtc7Bi@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCRPkxvH5LCtc7Bi@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, May 12, 2025 at 10:08:56PM -0400, Shaun Brady wrote:
> [...]
> > Add a new counter, total_jump_counter, to nft_ctx.  On every call to
> > nft_table_validate() (rule addition time, versus packet inspection time)
> > start the counter at the current sum of all jump counts in all other
> > tables with the same family, as well as netdev.
> 
> What about the bridge family? If bridged frames are passed up to the
> IP stack, then these hooks can have basechains with jumps too.

Good point, I forgot about this.

> Maybe it is better to have a global limit for all tables, regardless
> the family, in a non-init-netns?

Looks like it would be simpler.

The only cases where processing is disjunct is ipv4 vs. ipv6.

And arp. But large arp rulesets are unicorns so we should not bother
with that.
