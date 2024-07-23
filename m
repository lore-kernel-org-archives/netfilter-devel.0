Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4290313D898
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 20:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721768226; cv=none; b=EVOdA5Ghg4/NxfFzZxTS0UM9QCdGHoC/FLnxil2jnReZEX0dIM2PogvVPQcKTptPaFDpwkokC5tHFlZcGLgNIdK+5x+J6QiRBV5V20/wmenB7S+dvDDCSfPhcpsen+Ux97JCaGCiLR0jXB/+AA+zeN3N3EnRO238hMWsSMWTXX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721768226; c=relaxed/simple;
	bh=mukGju3JuXe6BRVibT/BP+3W2v9nDlMlNPn6A8+IzXg=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WKSR3wNDgF6qw6zn235VQGaiDNdXp6pBXlUEMm/LjzUqFz1OVMiYDaIGOQe/pQ3E0oCw4WLUZfTwmyx4ciB58r2UqXvDzFwAg6MZEGgUdwi0+7xeTNBmD36q4zpOE8osVDKT7p2FoBFIrMIzXAAg9M67IzsZPU3qR8eNwVQcIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=kVRU9glJ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="kVRU9glJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NXmO3kDEVsI9FaaHatEZwPEVNxUHZcRBUeDCrHeGQWE=; b=kVRU9glJQBLy1T4mdTK507YsXr
	okHaRpv10Q6JosnVA3mTqaM/2PAhuXyg40hH5ZHReTtDE7K3GoTIs37djjh7lx8lf7A11pQ8Zg6Yf
	4sTaGKOYNPLhd/260jpnz+hVcGOLE7FkYbYOf3tbU91LqktH8CaB0Re8FccxYah1kqhNz8XxkFNnP
	ioVzmJsteLFb9NNxsryG1GK7BTFEO+XBa+z5ebYJ7oiTkL+mqjzAowLB22H7Wsdzk7Cyz0QFPKdAT
	hR903GLDuhMvg3zz9YY/is9CMLPod1Uyv6YBsHMSZUfBa9BqrHw/eH/Go+2/JJNi3XTE2Bx4Hh7nf
	f6D4kvbw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sWMZ9-000000002ut-3iUR;
	Tue, 23 Jul 2024 22:56:59 +0200
Date: Tue, 23 Jul 2024 22:56:59 +0200
From: Phil Sutter <phil@nwl.cc>
To: Eric Garver <eric@garver.life>, Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <ZqAZG8hXZMPq1MB6@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
 <Zp-fx35ewU1n8EE5@calendula>
 <Zp-_adFRy9PbvYXU@orbyte.nwl.cc>
 <ZqAEv1grG6B8xzvt@egarver-mac>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqAEv1grG6B8xzvt@egarver-mac>

On Tue, Jul 23, 2024 at 03:30:07PM -0400, Eric Garver wrote:
> On Tue, Jul 23, 2024 at 04:34:17PM +0200, Phil Sutter wrote:
> > On Tue, Jul 23, 2024 at 02:19:19PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Jul 23, 2024 at 01:56:46PM +0200, Phil Sutter wrote:
> > > > Some digging and lots of printf's later:
> > > > 
> > > > On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
> > > > [...]
> > > > > I can reproduce it:
> > > > > 
> > > > > # nft -i
> > > > > nft> add table inet foo
> > > > > nft> add chain inet foo bar { type filter hook input priority filter; }
> > > > > nft> add rule inet foo bar accept
> > > > 
> > > > This bumps cache->flags from 0 to 0x1f (no cache -> NFT_CACHE_OBJECT).
> > > > 
> > > > > nft> insert rule inet foo bar index 0 accept
> > > > 
> > > > This adds NFT_CACHE_RULE_BIT and NFT_CACHE_UPDATE, cache is updated (to
> > > > fetch rules).
> > > > 
> > > > > nft> add rule inet foo bar index 0 accept
> > > > 
> > > > No new flags for this one, so the code hits the 'genid == cache->genid +
> > > > 1' case in nft_cache_is_updated() which bumps the local genid and skips
> > > > a cache update. The new rule then references the cached copy of the
> > > > previously commited one which still does not have a handle. Therefore
> > > > link_rules() does it's thing for references to  uncommitted rules which
> > > > later fails.
> > > > 
> > > > Pablo: Could you please explain the logic around this cache->genid
> > > > increment? Commit e791dbe109b6d ("cache: recycle existing cache with
> > > > incremental updates") is not clear to me in this regard. How can the
> > > > local process know it doesn't need whatever has changed in the kernel?
> > > 
> > > The idea is to use the ruleset generation ID as a hint to infer if the
> > > existing cache can be recycled, to speed up incremental updates. This
> > > is not sufficient for the index cache, see below.
> > 
> > So the assumption is that any changes to the ruleset in kernel were also
> > done to the cache, so we may just bump cache->genid instead of
> > refetching. In interactive nft, this requires for the last command to
> > have manually updated the cache as needed though. This is what confused
> > me. E.g., adding some chains:
> > 
> > - add chain t c2
> >   - no cache yet, fetch initially, store current genid
> >   - commit the new chain (kernel bumps genid)
> > 
> > - add cahin t c3
> >   - local genid == kernel's genid + 1, so skip cache update and bump
> >     local genid instead
> >   - commit the new chain (kernel bumps genid)
> > 
> > So I think if NFT_CACHE_RULE_BIT is set, NFT_CACHE_UPDATE must be set as
> > well to be sure that a previous command updated the rule cache if if was
> > a rule-related one. Therefore the local genid bump trick should be
> > allowed only if !NFT_CACHE_RULE_BIT || NFT_CACHE_UPDATE.
> > 
> > This still does not fix for the case at hand, because it doesn't cover
> > for the fact that cache had been updated but the contained items were
> > modified in-kernel.
> > 
> > I think 'delete rule' command needs a fix, too: cmd_evaluate_delete()
> > does not drop the rule from cache. I can't come up with something that
> > breaks due to that, though.
> > 
> > > > > Error: Could not process rule: No such file or directory
> > > > 
> > > > BTW: There are surprisingly many spots which emit a "Could not process
> > > > rule:" error. I'm sure it may be provoked for non-rule-related commands
> > > > (e.g. the calls in nft_netlink()).
> > > > 
> > > > > add rule inet foo bar index 0 accept
> > > > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > > 
> > > > > Cache woes. Maybe a bug in
> > > > > 
> > > > > commit e5382c0d08e3c6d8246afa95b7380f0d6b8c1826
> > > > > Author: Phil Sutter <phil@nwl.cc>
> > > > > Date:   Fri Jun 7 19:21:21 2019 +0200
> > > > > 
> > > > >     src: Support intra-transaction rule references
> > > > > 
> > > > > that uncover now that cache is not flushed and sync with kernel so often?
> > > > 
> > > > The commit by itself is fine, as long as the cache is up to date. The
> > > > problem is we have this previously inserted rule in cache which does not
> > > > have a handle although it was committed to kernel already. This is
> > > > something I don't see covered by e791dbe109b6d at all.
> > > 
> > > Yes, your commit relies on the frequent flush and resync at that time,
> > > which is correct.
> > > 
> > > See attached patch, it sets on NFT_CACHE_REFRESH so a fresh cache from
> > > the kernel is fetched in each run, it fixes the issue for me.
> > 
> > Yes, NFT_CACHE_REFRESH disables the conditional cache update skipping.
> > It is overly agressive though: If kernel's genid matches the cache, no
> > update should be needed.
> > 
> > > A quick recap:
> > > 
> > > Step #1 add rule inet foo bar accept
> > > 
> > > No cache is updated, because no NFT_CACHE_UPDATE is ever set on in
> > > this case. It is not possible to know that the that the next command
> > > will use the index feature.
> > > 
> > > After this point, the cache is inconsistent for this index feature.
> > 
> > This is expected: A simple 'add rule' command does not need a rule
> > cache, so even setting NFT_CACHE_UPDATE would not lead to a consistent
> > cache. This is fine, we should avoid fetching rules unless really
> > needed.
> > 
> > > Generation ID is checked, if cache is current, the previous rule in
> > > step #1 is not there in the cache.
> > 
> > Actually no rules at all, as NFT_CACHE_RULE_BIT remains unset.
> > 
> > > It should be possible to improve this logic to indicate that the cache
> > > supports updates via index, instead of forcing a cache dump from the
> > > kernel on each new index command.
> > 
> > Only if we start fetching rules for non index/handle 'rule add'/'rule
> > insert' commands, right? Also, new rules have to be replaced by their
> > kernel versions in cache to get the handles.
> > 
> > > So NFT_CACHE_UPDATE is only useful for intra-batch updates as you
> > > commit describes.
> > 
> > > diff --git a/src/cache.c b/src/cache.c
> > > index 4b797ec79ae5..1fda3f6939f5 100644
> > > --- a/src/cache.c
> > > +++ b/src/cache.c
> > > @@ -68,7 +68,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
> > >  
> > >  		if (cmd->handle.index.id ||
> > >  		    cmd->handle.position.id)
> > > -			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;
> > > +			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE | NFT_CACHE_REFRESH;
> > >  		break;
> > >  	default:
> > >  		break;
> > 
> > Acked-by: Phil Sutter <phil@nwl.cc>
> 
> This patch fixes the failures around the index keyword. I see one more
> issue around set entries.
> 
> Notably, if the set add and element add are on separate lines (and thus
> round trips to the kernel) then the issue is not seen. Perhaps there are
> more instances with other stateful objects.
> 
> --->8---
> 
> # cat /tmp/foo
> add table inet foo
> add set inet foo bar { type ipv4_addr; flags interval; }; add element inet foo bar { 10.1.1.1/32 }
> add element inet foo bar { 10.1.1.2/32 }
> 
> # nft -i < /tmp/foo
> internal:0:0-0: Error: Could not process rule: File exists

Netlink debug output indicates what's going on:

| nft> add set inet foo bar { type ipv4_addr; flags interval; }; add element inet foo bar { 10.1.1.1/32 }
| bar foo 4
| bar foo 0
| 	element 0101010a  : 0 [end]	element 0201010a  : 1 [end]
| nft> add element inet foo bar { 10.1.1.2/32 }
| bar foo 0
| 	element 00000000  : 1 [end]	element 01000000  : 1 [end]
| 	element 0201010a  : 1 [end]	element 0301010a  : 1 [end]
| 	element 0201010a  : 0 [end]	element 0301010a  : 1 [end]

In contrast, the same with separate 'add set' and 'add element'
commands:

| nft> add set inet foo bar { type ipv4_addr; flags interval; };
| bar foo 4
| nft> add element inet foo bar { 10.1.1.1/32 }
| bar foo 0
| 	element 00000000  : 1 [end]	element 0101010a  : 0 [end]
| 	element 0201010a  : 1 [end]
| nft> add element inet foo bar { 10.1.1.2/32 }
| bar foo 0
| 	element 00000000  : 1 [end]	element 0201010a  : 0 [end]
| 	element 0301010a  : 1 [end]

So I assume the code does not recognize the previously committed
elements as such and tries to commit them again.

Reverting commit e791dbe109b6d helps here as well.

BTW: It's funny how your second reproducer proves my suspicion that
nft_cmd_error() may print "Could not process rule:" errors for non-rule
commands.

Cheers, Phil
