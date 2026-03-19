Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9B3EF0BE
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773939979; cv=none; b=aFKTKqs5eC0UPICU0cmM0AGU0iOYUwOWnMlxjfyxs3FYZjbZF682ivkmA4W9uTqQP8mhjRxWSHBLaAJ/FJABm2QOa7DW6qsHz50iviZCjWJyIxcOCd6TycUt0xoA763e4pPYSGVUG1f7BWq2NEe35apou4+4/08InZQ3bdophvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773939979; c=relaxed/simple;
	bh=Qnrol6MusTgtV93+UBTh4bbT0y1stTFnAdCK6AIHohk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQoZipcfi1h5B5pXfB1qgEIwtfvoE5OfNMpKMGJwjYzREnaZvZFn3GBqMp5nDpMrhMPtqmiqXcZEEWXFyA9Q845Wibk9lioEBweZl+rYKSEPmMXXsjWfCGnNJI0J8CunuPjbL0MoHvx+ON83nHW+6sKBp+q1ouV1+tmKtDEsJFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 4DB68606E1; Thu, 19 Mar 2026 18:06:15 +0100 (CET)
Date: Thu, 19 Mar 2026 18:06:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH] netfilter: nfnetlink_hook: Dump nat type chains
Message-ID: <abwtAkSF8-SmH684@strlen.de>
References: <20260313153220.19662-1-phil@nwl.cc>
 <abwegj2TijkaQVLz@strlen.de>
 <abwraHUuxizN4krg@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abwraHUuxizN4krg@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Ah, so the nat-type chain's priority value orders it inside the
> dispatcher's list.

Yes.

> Maybe I should print them below the dispatcher hook with extra
> indentation? Maybe extra braces could further clarify, e.g.:
> 
> | hook postrouting {
> |         +0000000100 nf_nat_ipv6_out [nf_nat] {
> |                 +0000200000 chain inet nat postrouting [nft_chain_nat]
> |         }
> |         +2147483647 nf_confirm [nf_conntrack]
> | }

Actually  one could override the hook value with the one of the
nat base hook.  The ordering inside the dispatcher is whats important,
the exact numerical value isn't important.

> > If we really want the ability to list the nat hooks, I think this
> > needs a new command to dump them.
> 
> We may change 'nft list hooks' output arbitrarily, right? Or should we
> fear braking some third-party parsers when doing too fancy stuff?

Ugh. No mercy for screenscrapers.  But maybe my suggestion above is
enough.
