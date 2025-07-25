Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF7FF9E8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753403049; cv=none; b=IYkpHhf895CozrO3p0/0/yovikKEUFDnhWVusFnITaG+mhjgT4p6PFIACPu7cF4EI2vySlfIOZjbOR2HQrSX2ATskg4Ww0dc5vq21zMqoYRTm1kMHRSo0Vhd4bbHHrA84b9QWhOXIbBrI2AMILNS0Fs/Uwy19GHihzA9TZLGbEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753403049; c=relaxed/simple;
	bh=tTft6jyuVN83Riu4c3LpgFyc+eHhfPURFAGELRXIDB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfH1DMplxKQuZVBUc/3nsvswFTL0aC3gXCuxGD9fw7froMlfsXIKOLWwAMqNpgG6VPBKkRurnGO9oSfKxHfvJvrdBX/72r0J/lbS42NGr9BHGX6zzClwiLEOEeudtjp/sC+w98gEf7C6hA8Vc0rLR7aHGToXK8s6uJLAslsrQ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F30C0604EE; Fri, 25 Jul 2025 02:24:04 +0200 (CEST)
Date: Fri, 25 Jul 2025 02:24:04 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aILOpGOJhR5xQCrc@strlen.de>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIK_aSCR67ge5q7s@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jul 04, 2025 at 02:30:16PM +0200, Florian Westphal wrote:
> > Removal of many set elements, e.g. during set flush or ruleset
> > deletion, can sometimes fail due to memory pressure.
> > Reduce likelyhood of this happening and enable sleeping allocations
> > for this.
> 
> I am exploring to skip the allocation of the transaction objects for
> this case. This needs a closer look to deal with batches like:
> 
>  delelem + flush set + abort
>  flush set + del set + abort
> 
> Special care need to be taken to avoid restoring the state of the
> element twice on abort.

Its possible to defer the flush to until after we've reached the
point of no return.

But I was worried about delete/add from datapath, since it can
happen in parallel.

Also, I think for:
flush set x + delelem x y

You get an error, as the flush marks the element as invalid in
the new generation. Can we handle this with a flag
in nft_set, that disallows all del elem operations on
the set after a flush was seen?

And, is that safe from a backwards-compat point of view?
I tought the answer was: no.
Maybe we can turn delsetelem after flush into a no-op
in case the element existed.  Not sure.

Which then means that we either can't do it, or
need to make sure that the "del elem x" is always
handled before the flush-set.

For maps it becomes even more problematic as we
would elide the deactivate step on chains.

And given walk isn't stable for rhashtable at the
moment, I don't think we can rely on "two walks" scheme.

Right now its fine because even if elements get inserted
during or after the delset operation has done the walk+deactivate,
those elements are not on the transaction list so we don't run into
trouble on abort and always undo only what the walk placed on the
transaction log.

> This would allow to save the memory allocation entirely, as well as
> speeding up the transaction handling.

Sure, it sounds tempting to pursue this.

> From userspace, the idea would be to print this event:
> 
>         flush set inet x y
> 
> to skip a large burst of events when a set is flushed.

I think thats fine.

> Is this worth to be pursued?

Yes, but I am not sure it is doable without
breaking some existing behaviour.
