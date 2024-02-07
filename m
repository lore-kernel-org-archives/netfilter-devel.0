Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740538565B
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 19:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707333895; cv=none; b=WzTURMLcSNSSWJE5GLzRe+yRuOjS7pIFQhwABaFj6J1K47phhPXZ1b2S7qGgOvlbAb0isGh5dji/w6KrRouorHKe/la8o2au3eXgJAshNRmYBAsSLuPxYDSEpj33x0VmrQgbk9V0goxR/1YYEDMLrspTOBLo9XO78K9YQxmnTxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707333895; c=relaxed/simple;
	bh=T0TsdXN+Z5Pnz1K534AY0xyD757hn1v8/RZRjE6Rl0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s30MMDcjH45shBgCZDZuRjIgM8aMqW4lYGewm5xtBvogX7mlF/D5cPhE6ccWqWmsH0rsTk5DVKt7wB7H8poTC1IENXosDZpE6N27NxOXNYIU1AmWBohBWcP4vcIb6eq62oFinc46GeVrPNT3DVa+Rk0NFKcXW2EZrLJ1uABn+JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rXnXN-0005AX-Of; Wed, 07 Feb 2024 20:24:49 +0100
Date: Wed, 7 Feb 2024 20:24:49 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 1/3] netfilter: nft_set_pipapo: store index in scratch
 maps
Message-ID: <20240207192449.GB14600@breakpoint.cc>
References: <20240206122531.21972-1-fw@strlen.de>
 <20240206122531.21972-2-fw@strlen.de>
 <20240207151514.790c6cf3@elisabeth>
 <20240207152328.GA11077@breakpoint.cc>
 <20240207182751.6ed0dd1d@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207182751.6ed0dd1d@elisabeth>
User-Agent: Mutt/1.10.1 (2018-07-13)

Stefano Brivio <sbrivio@redhat.com> wrote:
> > In new code, k+4 is the perfect "already-aligned" address where we would
> > 'no-op' the address on a ARCH_KMALLOC_MINALIGN == 4 system.
> 
> Isn't the already aligned-address k - 4, that is, k + 28? With k + 4,
> we would have &scratch->map[0] at k + 8. But anyway:

Yes, k-4 (k+28).

[..]

> > Maybe thats what you were saying.  I could try to add/expand the
> > comments here for the alignment calculations.
> 
> ...yes, the rest is exactly what I meant. I'm not really satisfied of
> the paragraph below but maybe something on the lines of:
> 
> 	/* Align &scratch->map (not the struct itself): the extra
> 	 * %NFT_PIPAPO_ALIGN_HEADROOM bytes passed to kzalloc_node() above
> 	 * guarantee we can waste up to those bytes in order to align the map
> 	 * field regardless of its offset within the struct.
> 	 */

Thanks, thats good, I'll use that.

I think I'll also add a BUILD_BUG_ON to assert map
offset <= NFT_PIPAPO_ALIGN_HEADROOM, just in case.
