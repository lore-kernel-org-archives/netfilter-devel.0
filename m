Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B241E5B72
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Apr 2025 09:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744364905; cv=none; b=PL/6CUKjmU7p3ZBvskBI6mh6Bv+dN9t+wPq6F/Ol7HGLWxerkwjhZu+W7UwTb/z/kr6ih4vjLlxHxxuH5pJmEdNEqzPhIkcct98+Vra46ZoSvg2J6LptisDlFa34s7T9herMAM42SGILZawl+Y3Og8LunUOiAQqAjP1mvitk57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744364905; c=relaxed/simple;
	bh=qsid6nVAdnjaDGaLfY9jibdVuBAKgKkCfMQAoayQVTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTuxLYEpnBQyHqQnnM3jVEnoJ9qT9B6ugZ7hnp6qDOS4q6AyQaSjRWrPMPq8zh8vSvta1ZXsfdKmRyi2bgPrVJ/9WkOt+7S7/x5hCaS5rA3xEfk8yDlauSNY9FwNlUI3THC1iP9Fs3dzLwYmrmzx6ndW7AsfbY7qyzhdmcnGb2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1u3Azk-0006su-L2; Fri, 11 Apr 2025 11:48:20 +0200
Date: Fri, 11 Apr 2025 11:48:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] evaluate: restrict allowed subtypes of
 concatenations
Message-ID: <20250411094820.GA26374@breakpoint.cc>
References: <20250402145045.4637-1-fw@strlen.de>
 <20250402145045.4637-2-fw@strlen.de>
 <Z_hLLgRswOjXUKMa@calendula>
 <20250411055201.GA17742@breakpoint.cc>
 <Z_jkfafmlGedPQ-H@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_jkfafmlGedPQ-H@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I am in the need for such a context for payload/meta statements.
> 
>         meta mark set ip dscp map ...
>                       ^^^^^^^
> 
> in this case, ip dscp needs to be evaluated as a key for lookups,
> shift can probably be removed for implicit maps.
> 
> While in this case:
> 
>         meta mark set ip dscp
>                       ^^^^^^^
> 
> in this case, ip dscp needs the shift.
> 
> Then, there is:
> 
>         ip dscp set meta mark
>         ^^^^^^^
> 
> (note: this is not yet supported)
> 
> where ip dscp needs to expand to 16-bit because of the kernel
> checksum routine requirements.
> 
> They are all payload expressions, but evaluation needs to be slightly
> different depending on how the expression is used.
> 
> This context should help disentangle evaluation, evaluation is making
> assumption based on subtle hints, I think there is a need for more
> explicit hints.

Agreed.

> We can revisit in a few weeks, otherwise take this.

OK, lets keep this back for now; technically I don't need
to know the recursion depth, I need to know the placement
(lhs / lookup key resp. rhs / element key) to figure out what
restrictions apply.
