Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5806F38E8A4
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786039324; cv=none; b=E2qhRMMrNwv2ciHQyonVEhM52fqEi3UaaBfOPLwpNdcsgRWgYowP5wGzC1JtBERC0uNVJ1+UuAwuRW+DpPYH8K2a2g3TEeepVLoGckd898cBWnhCzka56MNmS+BEupkqjnMiCI41NfMgFdePQiujCDLZZAwyD91slvutJjS658E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786039324; c=relaxed/simple;
	bh=JXsmsRoVenK8GGbCUaSVjlVEh3HaZJp7IR4gyw/fMRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wd2SmWkDReZlSp4CBz1DpzISZwhJy2DyNqiQzbxeO0zn6p8QrNJZ6BHB/ntuoe9b7etbLJ72Up+fRqgqskNaAWhEDnR7oYXyN39oTBRNua5KemP7R7PkCOb6am1la2QqFtMl1K5CYWTzmq6uEd9Zo5wxUzQcJabenyKb///iHkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 82563602AB; Thu, 06 Aug 2026 20:01:58 +0200 (CEST)
Date: Thu, 6 Aug 2026 20:01:57 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit
 when building new ruleset
Message-ID: <anTMFbo6AB9IqejA@strlen.de>
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
 <anRrLtZvlPXtqJAA@strlen.de>
 <anSe0eK9dl1d2J7-@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anSe0eK9dl1d2J7-@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Why must the blob be rebuilt before stale node purge in rbtree case?
> 
> ... there is a gap between the ruleset blob is built and published and
> the set .commit interface is called to publish the new version of the
> rbtree/pipapo datastructure.
> 
> See:
> https://lore.kernel.org/netfilter-devel/589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com/

Ah. That makes sense. So the problem is not rbtree specific.  Problem is
that packets switch over to the *new base chain* (linked to nf machinery,
nft rule blob becomes reachable on base_seq swap:

1. commit phase starts.
2. seqcount gets bumped.
 A.  	Packet p1 enters machinery
3. elements get purged / chains / tables unlinked, netlink notificatons
   etc. etc.
 B.     Packet p1 is in nft_lookup, which gets updated base_seq,
        but no match because rbtree blob resp. pipapo live blob
	are empty in the 'flush ruleset; table t { ..' case.
4. nft_set_commit_update() is called.

If the above is right your patch makes much more sense now :-)

The logic with (set->ops->abort_skip_removal && early_commit)
however is hard to grasp.

Even with NFT_COMMIT_PHASE_EARLY or whatever its bad because
the set implementation details leak into the transaction phase.
But I understand that you'd like to at least solve it for rbtree
with a smaller change, so thats ok.

Is there a long-term plan?

Maybe your 'pre-commit' phase could iterate the transaction
log and relink transactions (add/del/update of set elements
) to the owning set?  Contradicting transactions (destroy set x,
then remove element from x) should have been caught earlier, so
this delete-from-transaction-log-and-link-to-per-set-struct should
not be a problem.  Perhaps we might see issues with changes in the
netlink reporting order... but thats hopefully easy to avoid.

the ->commit() callback could then access the pending transactions
for the set (element adds/deletes) and always get invoked early.

Pipapo could walk its specific elem deletions internally, then swap.

The only other issue I see is that we need a second
list_for_each_entry_safe(trans, next, &nft_net->commit_list, list)

... walk, because the step-1 walk is allowed to fail.
