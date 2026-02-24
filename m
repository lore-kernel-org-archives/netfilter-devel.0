Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65A422652D;
	Tue, 24 Feb 2026 14:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771942554; cv=none; b=tGGkpqjMovHJnb4OmTCjTYwbc+3slJmckfkl9ZwriL1Q5kNg4BKTtQjubtyk+6mIyS4rxIgcTcHSVaBzoYcnaWj1V/7uqBe1lM76mqXSxZw8SAMhOFK8GAeEe5yQ/nnhPrmtije0nxjD2jwIehlWe17hxeZVE5+OCABgGWLi5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771942554; c=relaxed/simple;
	bh=dnNFZinG7Mxopd2kn2Svmxzz1R3aSgDkJ0uawihEBtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XcvsNYj/jX0M7+vUZEYOf+Fd3w68H2a6DdBnI3Z2UNs3+FZGRuqPrDCjEiiCU/f09SfSN/pLfiT1xEdRX16XLDsjwSRVf3qG8K0yqvqoptdTxBcwHshy/XEBHUAVZBOeD9Iib9W85gqwdGETFbDv1/TdbyXBQplVGtDk8sanmtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id CB90260516; Tue, 24 Feb 2026 15:15:50 +0100 (CET)
Date: Tue, 24 Feb 2026 15:15:50 +0100
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v19 nf-next 1/5] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
Message-ID: <aZ2ylpMdcYp5C7OQ@strlen.de>
References: <20260224065307.120768-1-ericwouds@gmail.com>
 <20260224065307.120768-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224065307.120768-2-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> Jakub Kicinski suggested following patch:
> 
> W=1 C=1 GCC build gives us:
> 
> net/bridge/netfilter/nf_conntrack_bridge.c: note: in included file (through
> ../include/linux/if_pppox.h, ../include/uapi/linux/netfilter_bridge.h,
> ../include/linux/netfilter_bridge.h): include/uapi/linux/if_pppox.h:
> 153:29: warning: array of flexible structures
> 
> It doesn't like that hdr has a zero-length array which overlaps proto.
> The kernel code doesn't currently need those arrays.
> 
> PPPoE connection is functional after applying this patch.

LGTM, can you send this one directly to netdev@vger.kernel.org?

Its not netfilter related so it feels wrong to apply it, even though I
agree with it :-)

No need to resend the rest of this series.
