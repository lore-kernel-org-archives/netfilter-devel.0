Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841071946CD
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Nov 2024 12:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731067746; cv=none; b=nl4JqVc1y5NgoJ7ozBVz/CZHfwynBfMLZsjUGKMqU+dCLW/KUGAqVoMM1Jf9JZUV6x5JQFAUQbVvKHLcUUXyQkxH42/HjoTN7/PN2bmwh3jnfGjBA2VmDebE8U4dwTkBdGZYcxzSiXbMQ9UyZIaYYKSOAhWnCtjNSuh1YcWGQVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731067746; c=relaxed/simple;
	bh=fcMei138kHi4jtVzHJ3ksS5TU1K08ydWH36TpLnfzWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YUKKpqqu6qLgAKCWg1HcbMjK/dxK+faoQS5RWlqfu2NyxxPP2ix1pvhqTLSEbalzayAT0BvnvIISM0zIEpx6YDImtTN3EJ7qUKoGndQp8WO5m3N02UEhhVcrXIS/SNRBc3Ha7eiVr/2FvRuQQM0KPtDox9LjrhjApeAt3EfyH9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t9NnK-00069L-R4; Fri, 08 Nov 2024 13:08:54 +0100
Date: Fri, 8 Nov 2024 13:08:54 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: allow to map key to nfqueue number
Message-ID: <20241108120854.GA23569@breakpoint.cc>
References: <20241025074729.12412-1-fw@strlen.de>
 <Zytu_YJeGyF-RaxI@calendula>
 <20241106135244.GA11098@breakpoint.cc>
 <20241106143253.GA12653@breakpoint.cc>
 <ZyuTa9lmkXRAvSfn@calendula>
 <Zyv3tBgF9jW5D0v-@calendula>
 <Zyv9D385olTWUv1k@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zyv9D385olTWUv1k@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Nov 07, 2024 at 12:11:53AM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Nov 06, 2024 at 05:03:55PM +0100, Pablo Neira Ayuso wrote:
> > > I can take a look later today based on your patch, I think I can reuse
> > > 90% of it, it is just a subtle detail what I am referring to.
> > 
> > See attachment, not better than your proposal, just a different focus.
> 
> Actually, this attachment.

Just apply this.
