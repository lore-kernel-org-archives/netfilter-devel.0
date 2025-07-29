Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55972254841
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 11:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753789044; cv=none; b=rP0tP8Dt413C3bj31EwZac7J0D7QJ0K6WVqqDgmvR9lIeMZl3tFTuHEGKrMekQf6uq+7q3aftjLkcLuPaycle9LAFTOTqC8qzg5G252qDcTPYfPL8EM6ubMVGJNBjpeHZvv/j8rSC5W+6OFMzAdo5M8DoeJS+Oik3GRbONsoC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753789044; c=relaxed/simple;
	bh=nddSbrN0baJVIUZ2LnHRYUaZpZiawQExMlHXHBqYzho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tg10lJpDuYqCC9wX7jOhb0+1JTWJ4K31PtU1IZfSyarqZLDZLFMj6gC8Eo/BPw2OlldrePOuMwZic5JFgAqxTT8n8+NUixbF3amTrOlq78JICQh4o0A9CgvCo47VYZ0utxzbEU2uKEZS39dnWD3Ii+7KZICkhmOWxTC9KuZ9er4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 136BF604EE; Tue, 29 Jul 2025 13:37:20 +0200 (CEST)
Date: Tue, 29 Jul 2025 13:37:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIiyVnDlbDTMRqB-@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
 <aIikwxU686KFto35@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIikwxU686KFto35@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> DELSETELEM does not unlink elements from set in the preparation phase,
> instead elements are marked as inactive in the next generation but
> they still remain linked to the set. These elements are removed from
> the set from either the commit/abort phase.
> 
> - flush should skip elements that are already inactive
> - flush should not work on deleted sets.
> - flush command (elements are marked as inactive) then delete set
>   skips those elements that are inactive. So abort path can unwind
>   accordingly using the transaction id marker what I am proposing.

Yes, that part works, but we still need to kfree the elements after unlink.

When commit phase does the unlink, the element becomes unreachable from
the set.  At this time, the DELSETELEM object keeps a pointer to the
unlinked elements, and that allows us to kfree after synchronize_rcu
from the worker.  If we don't want DELSETELEM for flush, we need to
provide the address to free by other means, e.g. stick a pointer into
struct nft_set_ext.
