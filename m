Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746C11C8FD2
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2024 21:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730411814; cv=none; b=KmgEPp34Km1p+cRYOsmtM1Fq+N6DhD51TgY6t1UD1mJA7/ZIk5i9svyZxLxF7+YnZAwnf4nZ82LNPqBEnMODOZs2qHsXbG1RhvwA/pLy3WWgA46J5xdrXTo6OOyqULYPz4zcw/rDn+Pn5hpAjcWzkKwujUvBUuzYdc+I+qkpXJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730411814; c=relaxed/simple;
	bh=RIvCNgxdabWFhajpduj6S33AImOIonlQq5yDxhiHJk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ajP8oduRpeBAvHBIzrrEWS0JeQZnHj9p9o1nhVlwD5wBxfGDfXlQovO5P7mCqR2fZ8DtKWrka38fxxCRVsRSeblpTVsiEQB4ytxik5a6nxj9LPNldUik+qN05akv6TvpBSM7cc1pwb9DVbppKXZszguZsBaKXs7prAldjmNPpLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t6d9p-0001K5-JL; Thu, 31 Oct 2024 22:56:45 +0100
Date: Thu, 31 Oct 2024 22:56:45 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next 0/7] netfilter: nf_tables: avoid
 PROVE_RCU_LIST splats
Message-ID: <20241031215645.GB4460@breakpoint.cc>
References: <20241030094053.13118-1-fw@strlen.de>
 <ZyP7Q94DCbwBmobU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyP7Q94DCbwBmobU@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This targets nf-next because these are long-standing issues.
> 
> This series breaks inner matching, I can see tests/shell reports:
> 
> I: conf: NFT_TEST_HAVE_inner_matching=n

Uh, didn't i fix this in v2?  V1 had a bug in patch 6:

+       if (!type->inner_ops || type->owner) {
+               err = -EOPNOTSUPP;


V1 had !type->owner, which causes feature probe to fail and the test to
skip (it skips builtin instead of module...).

I re-tested, I get:
I: conf: NFT_TEST_HAVE_inner_matching=y
