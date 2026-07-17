Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0243EDAA8
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jul 2026 10:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784284661; cv=none; b=gWXWLQNHPNU6qUsvAp0lpqmAXhKiG5PFqBELqOuWrZqfbYjtlrg24adHt15DzNiAvsur/qfMd2CtXezIMaaACEqx7otDV1ywlOHhbIjRHWeJaGtem5+2v1nAP8wZtNoAieQql05h4SIk0g3p7ZNQbyxwCScDPrSDKReOBD7JE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784284661; c=relaxed/simple;
	bh=5SchmqFptRgTqkt8eK940GGNPSkk0Sp9Mt60aZynty0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UyGTSjFJEBOkh8dLKUCpFR8r3ALzwydJf8086K3zzDMnAePCQMc/PFBSgIMxmfR+6a1fsQC9SoJ82YnYqonyIszmHx7vYIqKg1NpdtXsHhaBbd6kQAFB5zhan99sctZmt5w/QU5mldsmfNk69H+J9rHqo5aXwEWTwl6S6zUGsUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D71A06055C; Fri, 17 Jul 2026 12:37:21 +0200 (CEST)
Date: Fri, 17 Jul 2026 12:37:21 +0200
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools] conntrack.8: Document --stats counters
Message-ID: <aloF4dOlN_XMWsFl@strlen.de>
References: <20260527173858.2546091-1-phil@nwl.cc>
 <ahfyv50suL44m7FX@strlen.de>
 <aln9W7xoIhKM7P4P@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aln9W7xoIhKM7P4P@orbyte.nwl.cc>

Phil Sutter <phil@nwl.cc> wrote:
> Thanks for your feedback so far. What I don't like is how we all seem to
> reverse engineer meaning into the counter values. Maybe this is an
> opportunity to clarify what these counters *should* represent and with
> that in mind treat any deviation in the code as a bug which needs
> fixing.

Agreed.

> Since nf_conntrack_hash_check_insert is called from
> net/netfilter/nf_conntrack_bpf.c, too I'll put this as "Number of
> entries manually inserted (via netlink or eBPF)."

Oh, did not realize this was also called via ebpf.

> > oversized hash buckets should not be mentioned here, they have their own
> > counter.  Should probably not increment both counters in kernel when it
> > happens.
> 
> I see it incremented in three places:
> 
> 1) nf_ct_resolve_clash
>    - Increments 'drop' at the same time
>    - This is the "clash resolution failure" case I mentioned
>    - Happens either if nf_conntrack_l4proto does not set 'allow_clash' or
>      both __nf_ct_resolve_clash and nf_ct_resolve_clash_harder fail
> 
> 2) First spot in __nf_conntrack_confirm
>    - Called "entry in dying state" by me above
>    - AIUI, happens when confirming a conntrack entry (SYN-ACK?) for which
>      nf_ct_is_dying() returns true

SYN, we only ever confirm the NEW / first packet of a flow.

> 3) Second spot in __nf_conntrack_confirm
>    - Increments 'chaintoolong' at the same time
>    - Happens if oversized hash bucket is encountered(?)

Yes.

> > Maybe: "Number of NEW connections dropped because of clashes with existing entry."?
> So this would be just #1 above. As a remedy, I would:
> 
> - Remove the 'drop' increment in #1, make it *the* insert_failed counter
>   case
> - Remove the 'insert_failed' increment from #3

No objections.

> But what about #2? Introduce a new counter? Increment 'drop' instead?

I'm not sure this can ever be true anymore (dying on unconfirmed).
I would leave it as-is.  In both nf_ct_resolve_clash and this case there
is nothing the user could do.  At least I can't think of anything.

> > Yes, I think we need to fix this in the kernel and not increment two
> > counters for the same reason.
> > 
> > Drop should mostly mean "incomplete packet / out of memory".
> 
> Hmm. Assuming we no longer increment it in nf_ct_resolve_clash, the
> following incrementers remain:
> 
> 1) nf_conntrack_in
>   - If resolve_normal_ct returns error, which happens only if
>     init_conntrack returns -ENOMEM
> 
> 2) nf_conntrack_in
>    - Also increments 'invalid' counter
>    - If nf_conntrack_handle_packet returned 0 (= NF_DROP), which seems
>      to be a special case with TCP (added in commit 6b69fe0c73c0
>      ("netfilter: nf_conntrack_tcp: fix endless loop"))
> 
> 3) nf_confirm_cthelper
>    - If TCP sequence number adjustment fails, which seems to happen only
>      on ENOMEM, missing seqadj CT extension or malformed TCP packet
>      (having a tcpopt header with invalid optlen)
> 
> Maybe one should split #3 to increment 'invalid' upon invalid TCP option
> header?

Good idea.

> What about #2? Should this increment 'invalid' at all? It does
> not seem to indicate an invalid packet, but rather some internal
> corner-case, right?

Yes, I think its best to remove the invalid increment here.

> > > +.B early_drop
> > > +Number of packets dropped up front due to full table
> > 
> > AFAICS its number of connections dropped because of a full table.
> 
> This is incremented by early_drop() only, called by __nf_conntrack_alloc
> if a netns's conntrack table exceeds nf_conntrack_max. Am I getting this
> right and early_drop() tries to drop existing entries to free up space
> for the new one? I don't see any particular preference in
> early_drop_list(), is this just "best effort"? (I guess the system is
> under pressure and the goal is to resolve the situation as quickly as
> possible?)

Yes, it will attempt to remove another competing entry (not confirmed,
meaning short-lived UDP or TCP that did not progress past 3whs yet).

> > > +.B search_restart
> > > +Number of times a table lookup had to be restarted due to table reorg
> > 
> > Not sure about this one.  This is an implementation detail (SLAB_TYPESAFE_BY_RCU).
> > This can happen at any time when entry is removed from table and
> > other CPU is re-instantiating a new conection using the just-unlinked
> > entry.
> 
> Ah, I see. Guess the comment in ____nf_conntrack_find misled me into
> believing this was about hash table reorgs.
> 
> Maybe describe like this (which avoids too many internal details):
> 
> "Number of table lookups which had to be restarted. Due to optimized
> storage reuse, a table lookup may occasionally find an already deleted
> entry. This is detected and remedied by restarting the search."

Maybe even more terse, e.g.

"Number of table lookups which had to be restarted.  In rare cases a
lookup may encounter an already deleted entry which causes a
search restart."

Up to you, this is hard to explain without the implementation details,
the question would be "what does that counter tell me" and "what should
I do about this".  And I have no answer.  I thought about removing this
counter, but then this would allow to detect programming bugs (chain end
tag corrupted) for example.

Thanks for working on this!
