Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CBA32ED4E
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Nov 2025 15:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764342453; cv=none; b=UktaKuSpo6NMgmt/9juvixwYQ9EyCMcjhI35EHWnZJbLdnVTTT328ogQ1FI7B8QOiI0xMKehFmOjoBy+Q5+K9Ji43l5zdGvr211Ks6gZFFjgNERKrr4nsyl3nPQatUOc9aFUuK3fN5vdmGK9PfyUlwYriTrI1yqyn45/M50ones=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764342453; c=relaxed/simple;
	bh=bS/wCHSaWe7YSiPavcTDTZJbarPo86z6jFX8WDrmzOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMBb4ROlz4+E/qcf04NWJ4C0Y9wPVrXpBnBL1TOMqaPvV3y2oN8srVa4eLEF7uOSSmnkdc/r4Ng27pfYjPDs0D9iwvx/A6M2fF0LqW8oRnqCaX8+8vRgBGrZ0OxDTFG0JHA3dl/608++Y3sO/VIKcld+Vi6Zwz+mwVxGFozE4oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 81E0B60308; Fri, 28 Nov 2025 16:07:28 +0100 (CET)
Date: Fri, 28 Nov 2025 16:07:29 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH RFC 2/6] parser_bison: Introduce tokens for chain
 types
Message-ID: <aSm6sRVaq8ciWL-2@strlen.de>
References: <20251126151346.1132-1-phil@nwl.cc>
 <20251126151346.1132-3-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126151346.1132-3-phil@nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Use the already existing SCANSTATE_TYPE for keyword scoping.
> This is a bit of back-n-forth from string to token and back to string
> but it eliminates the helper function and also takes care of error
> handling.

Did you run this with valgrind or CFLAGS+=-fsanitize=address ?

> +				$<chain>0->type.str = xstrdup($2);

This should probably be $<chain>0->type.str = $2;

No?
