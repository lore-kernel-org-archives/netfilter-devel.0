Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DB62D4B57
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753438241; cv=none; b=dXD567s+kPZzPRy31/j3Mdg2eBSL9713qTMDN+LHKeJ5L51F31wVHJNuUzgTBdnugQxBaR6d6zv2sGjfS5Fm8NsmBuJO/VPhsXq9c3U3KFgszFYiilDRCmFdxqfatCmZ1AjXBpUb/HuE1bS2E1FHMYMYfluvGLunEbCIzfdqcow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753438241; c=relaxed/simple;
	bh=G/1qQZycT6AxaZ96hrRYL4kToUX9nFjmEpASXb+MUmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HV9zdsJ76hIZNfe4Ca254UNapvE46q/iw1EPFd5Gggeet2PRT2FAsHS31a2DjVF3/+HUI50uR0b8xGNsXWoV2OtOWk9hXVIXEAWdOYVgOFeeEmT8oHiStJy1UVX2qnX4Y6Abvywxy3VlWSCRy4P3bfYg5CYhIv928jX1o096JAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=eqMGCBEV; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QBifAgj7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="eqMGCBEV";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QBifAgj7"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9AA7960278; Fri, 25 Jul 2025 12:10:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753438237;
	bh=oX1BnX+hKCIN5FJgj0CBqg8bCZHFgYqcZN2Us9IqxjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eqMGCBEVyyV2vpON4UgGp+0FvleYk/V/YrWgqQFB5MfsMe6taJiZajuvIj28J5QZ5
	 2xCBicaU5fg0PeXFgAO2PlzzdrUkMmOqQydP1EKnyp8+2Hf0fkQhDiptnZPIH4HdC8
	 GouLCeoK10EqZzFGjk/FXFkaAVdqz9RZiA8/knQ1pb6iVwANTMvjrX3YJPDISCliCT
	 ZtPDwd8bbwZ97uhs00RICAX+87Y35i4t8IBLUtez0K9+mQK4t5kcuL1CQnYuX10io6
	 uLyUO6VaIBJL4D2x/bUWTwHilhqkEJyRTkWIXdisAyOIeSlCr1Aa4+m7nSzD71Cfjk
	 SnrfSqVXmvsuw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A4DA960278;
	Fri, 25 Jul 2025 12:10:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753438236;
	bh=oX1BnX+hKCIN5FJgj0CBqg8bCZHFgYqcZN2Us9IqxjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QBifAgj7iDG+G1bHGDB/yevX6xl5xC6hvsr9a4M4ZxmnSL8hlUqMXhWLL+sJ7WTvj
	 3dviS997z0g8tjiLnOpnHgjHqaRJqH7Ii7FRrDdJKcdNJtXNQNLIAIJCKBoDE3cG1g
	 3qd2oV9onILzO2uqejFSzHKYj1yKYhruX4VQpUTOVOUrzEdtzstHcbc/3XdAPTggxw
	 R1TSeRf9BQ+cYm8bCfB/VSmRCFmSKk9ktx/ZSdYBENzIneP54C3XoekmdPggKecxPi
	 yeSqYTrTAdrpDhPJUHQUESi09lsdstuCmlFZ9JJmSp47XiTBMIv3/Ke9VQ29g/Vkb4
	 289TH3icSV46A==
Date: Fri, 25 Jul 2025 12:10:32 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aINYGACMGoNL77Ct@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aILOpGOJhR5xQCrc@strlen.de>

On Fri, Jul 25, 2025 at 02:24:04AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Jul 04, 2025 at 02:30:16PM +0200, Florian Westphal wrote:
> > > Removal of many set elements, e.g. during set flush or ruleset
> > > deletion, can sometimes fail due to memory pressure.
> > > Reduce likelyhood of this happening and enable sleeping allocations
> > > for this.
> > 
> > I am exploring to skip the allocation of the transaction objects for
> > this case. This needs a closer look to deal with batches like:
> > 
> >  delelem + flush set + abort
> >  flush set + del set + abort
> > 
> > Special care need to be taken to avoid restoring the state of the
> > element twice on abort.
> 
> Its possible to defer the flush to until after we've reached the
> point of no return.
>
> But I was worried about delete/add from datapath, since it can
> happen in parallel.
> 
> Also, I think for:
> flush set x + delelem x y
>
> You get an error, as the flush marks the element as invalid in
> the new generation. Can we handle this with a flag
> in nft_set, that disallows all del elem operations on
> the set after a flush was seen?
>
> And, is that safe from a backwards-compat point of view?
> I tought the answer was: no.
> Maybe we can turn delsetelem after flush into a no-op
> in case the element existed.  Not sure.
>
> Which then means that we either can't do it, or
> need to make sure that the "del elem x" is always
> handled before the flush-set.
> 
> For maps it becomes even more problematic as we
> would elide the deactivate step on chains.
> 
> And given walk isn't stable for rhashtable at the
> moment, I don't think we can rely on "two walks" scheme.
> 
> Right now its fine because even if elements get inserted
> during or after the delset operation has done the walk+deactivate,
> those elements are not on the transaction list so we don't run into
> trouble on abort and always undo only what the walk placed on the
> transaction log.

I think the key is to be able to identify what elements have been
flushed by what flush command, so abort path can just restore/undo the
state for the given elements.

Because this also is possible:

       flush set x + [...] + flush set x

And [...] includes possible new/delete elements in x.

It should be possible to store an flush command id in the set element
(this increases the memory consumption of the set element, which your
series already does it) to identify what flush command has deleted it.
This is needed because the transaction object won't be in place but I
think it is a fair tradeoff. The flush command id can be incremental
in the batch (the netlink sequence number cannot be used for this
purpose).

> > This would allow to save the memory allocation entirely, as well as
> > speeding up the transaction handling.
> 
> Sure, it sounds tempting to pursue this.
>
> > From userspace, the idea would be to print this event:
> > 
> >         flush set inet x y
> > 
> > to skip a large burst of events when a set is flushed.
> 
> I think thats fine.
> 
> > Is this worth to be pursued?
> 
> Yes, but I am not sure it is doable without
> breaking some existing behaviour.

Of course, this needs careful look, but if the set element can be used
to annotate the information that allows us to restore to previous
state before flush (given the transaction object is not used anymore),
then it should work. Your series is extending the set element size for
a different purpose, so I think the extra memory should not be an
issue.
