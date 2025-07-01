Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B4A26A0EB
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Jul 2025 21:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751406564; cv=none; b=IrHhy8xA11uU0OBLx/nyYjTxXCDnJ4ZWVtgQUVC/0cV5c1m8rizgcdDF8RY9PxdO98GadveGHl3uxG30cXMYVqxcj93sbQpkw6bJEBUvcpVepO8FNqqzVSQoNLJmgv1auewOTm02weonWoTORyw6aE9QhqSOAJnXI3YpfK/rPNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751406564; c=relaxed/simple;
	bh=0TLlkjo1vRUn+/7UgmjR1+3cj1pWZsDamrT+hmiIkIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpe54yFK4WlMxiHJhNW6EWWbB0hlbelP+p+TZyPh7FMUywtWkwCRVbN+9GJdtqVOZQ+jTiznLQYWsl7jdfL7X843mnlpsfXYG/r9XxZdBB50Rs0rfbwWh71j8TCOSPYts9wxW673FU4iI558+P35+5uSDZ5omGP3I4EKXvu90Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2AFED604A5; Tue,  1 Jul 2025 23:49:19 +0200 (CEST)
Date: Tue, 1 Jul 2025 23:49:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Sven Auhagen <Sven.Auhagen@belden.com>
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Cannot allocate memory delete table inet filter
Message-ID: <aGRX3xYlWBxFahbm@strlen.de>
References: <BY1PR18MB5874110CAFF1ED098D0BC4E7E07BA@BY1PR18MB5874.namprd18.prod.outlook.com>
 <aFwHuT7m7GHtmtSm@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFwHuT7m7GHtmtSm@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> 1). Leverage what nft_set_pipapo.c is doing and extend
>     this for all sets that could use the same solution.
>     The .walk callback for pipapo doesn't need/use rcu read locks,
>     and could use sleepable allocations.
>     all set types except rhashtable could follow this.

FWIW I'm exploring a change to nft_set_hash to avoid the rcu read lock
when calling ->iter() for rhashtable.

If it works, this would allow to just replace the GFP_ATOMIC with GFP_KERNEL.
