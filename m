Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2807AE74
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2024 14:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254088; cv=none; b=UPnGrYGR9bZTtcr9+bVwBZGZFMPhMjQ8pPZkvgOD0/Z8ndFSXYo7vG4xeoJdmyrSOfDEnpLlH2x82RiZThVp53N2O69h2K01cbzxfhgZZQ/alZ8mOki5yEdd4ZcG2L2vLPup4pUr5zbuPvGJ9al6SZEpgL09xH89mY6INs2Sl3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254088; c=relaxed/simple;
	bh=Y8i4zyzsfaxIbEJDtvx1wz6CYr5mipuIgkrVB3uzhs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dziGyAyB9DamNR4EIoQmHXxx6vvtfLlQwoIpjhmfvVWaSNhgS1MRtXU1Pz/opHU65rsn5c8GjCD0+naIcMf2nckieBU5W0Jrl2IvOvhTC4xUonPoxUsOIRwrl3DQkZEfR1QobehmirVjbcHOXE5PLV4U4WssVYHobseAM4fImew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rk3DI-0001Ql-UT; Tue, 12 Mar 2024 15:34:44 +0100
Date: Tue, 12 Mar 2024 15:34:44 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Quan Tian <tianquan23@gmail.com>,
	netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Subject: Re: [PATCH v3 nf-next 1/2] netfilter: nf_tables: use struct nlattr *
 to store userdata for nft_table
Message-ID: <20240312143444.GG1529@breakpoint.cc>
References: <20240311141454.31537-1-tianquan23@gmail.com>
 <20240312140535.GC1529@breakpoint.cc>
 <ZfBkB3VcbfzZe0fw@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBkB3VcbfzZe0fw@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > +	struct nlattr			*udata;
> 
> May I suggest to use our own data structure, instead of using nlattr?
> It is just a bit misleading to the reader.
> 
> But maybe I need to get used to this and that's all, your call.

I have no preference.  I thought reusing nlattr was simpler
because you can just kmemdup the nlattr+header.

I'll leave it up to patch author, no strong opinion either.
