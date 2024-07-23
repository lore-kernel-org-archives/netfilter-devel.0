Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE3514AD17
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2024 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721737171; cv=none; b=Jh6LwqgVtsrcqkjzpV7BxZuToPdVX/JuQJWyg1kuOMCl37A5FyYXKThPIYbcJqni4z0tEBkRV01rWCA7SZvlrRSLSAtEVW8UTgBrRjbNLFOecpx/aIYTeW5hhbPNeXccXYgto+45GTHY5MFIG9bt1dmZ3MSqwp9ZUJw/yFUToUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721737171; c=relaxed/simple;
	bh=dY9lHSfAvUPJMuHCyn1MBCqwqE/dCPfGQaR+tg2XsbM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CGyGpEYsYV9QNcbWQvlWmKHka7fPgtW70+W03JJCWUWaM6qPC5kX9nfQQWEfpKNxbGEqWCgaZJFG+PklIqbrsYrdzO0PFqcs0m0jMs5f441fJgBW9qhPZ9z+GgYPV+aYJUBJySgr9NoExe0YAaswXFj0wWq60gWjQV10gcDwLcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [46.6.251.194] (port=5428 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sWEUD-000b8d-Vd; Tue, 23 Jul 2024 14:19:24 +0200
Date: Tue, 23 Jul 2024 14:19:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Eric Garver <eric@garver.life>,
	netfilter-devel@vger.kernel.org, nhofmeyr@sysmocom.de
Subject: Re: [PATCH nft 2/2,v2] cache: recycle existing cache with
 incremental updates
Message-ID: <Zp-fx35ewU1n8EE5@calendula>
References: <20240528152817.856211-1-pablo@netfilter.org>
 <20240528152817.856211-2-pablo@netfilter.org>
 <Zp7FqL_YK3p_dQ8B@egarver-mac>
 <Zp7QSXcMHt9a8Hm7@calendula>
 <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fm4ywPs9r6x1CwJU"
Content-Disposition: inline
In-Reply-To: <Zp-afhWpdM9R4hco@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)


--fm4ywPs9r6x1CwJU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Tue, Jul 23, 2024 at 01:56:46PM +0200, Phil Sutter wrote:
> Some digging and lots of printf's later:
> 
> On Mon, Jul 22, 2024 at 11:34:01PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > I can reproduce it:
> > 
> > # nft -i
> > nft> add table inet foo
> > nft> add chain inet foo bar { type filter hook input priority filter; }
> > nft> add rule inet foo bar accept
> 
> This bumps cache->flags from 0 to 0x1f (no cache -> NFT_CACHE_OBJECT).
> 
> > nft> insert rule inet foo bar index 0 accept
> 
> This adds NFT_CACHE_RULE_BIT and NFT_CACHE_UPDATE, cache is updated (to
> fetch rules).
> 
> > nft> add rule inet foo bar index 0 accept
> 
> No new flags for this one, so the code hits the 'genid == cache->genid +
> 1' case in nft_cache_is_updated() which bumps the local genid and skips
> a cache update. The new rule then references the cached copy of the
> previously commited one which still does not have a handle. Therefore
> link_rules() does it's thing for references to  uncommitted rules which
> later fails.
> 
> Pablo: Could you please explain the logic around this cache->genid
> increment? Commit e791dbe109b6d ("cache: recycle existing cache with
> incremental updates") is not clear to me in this regard. How can the
> local process know it doesn't need whatever has changed in the kernel?

The idea is to use the ruleset generation ID as a hint to infer if the
existing cache can be recycled, to speed up incremental updates. This
is not sufficient for the index cache, see below.

> > Error: Could not process rule: No such file or directory
> 
> BTW: There are surprisingly many spots which emit a "Could not process
> rule:" error. I'm sure it may be provoked for non-rule-related commands
> (e.g. the calls in nft_netlink()).
> 
> > add rule inet foo bar index 0 accept
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Cache woes. Maybe a bug in
> > 
> > commit e5382c0d08e3c6d8246afa95b7380f0d6b8c1826
> > Author: Phil Sutter <phil@nwl.cc>
> > Date:   Fri Jun 7 19:21:21 2019 +0200
> > 
> >     src: Support intra-transaction rule references
> > 
> > that uncover now that cache is not flushed and sync with kernel so often?
> 
> The commit by itself is fine, as long as the cache is up to date. The
> problem is we have this previously inserted rule in cache which does not
> have a handle although it was committed to kernel already. This is
> something I don't see covered by e791dbe109b6d at all.

Yes, your commit relies on the frequent flush and resync at that time,
which is correct.

See attached patch, it sets on NFT_CACHE_REFRESH so a fresh cache from
the kernel is fetched in each run, it fixes the issue for me.

A quick recap:

Step #1 add rule inet foo bar accept

No cache is updated, because no NFT_CACHE_UPDATE is ever set on in
this case. It is not possible to know that the that the next command
will use the index feature.

After this point, the cache is inconsistent for this index feature.

Generation ID is checked, if cache is current, the previous rule in
step #1 is not there in the cache.

It should be possible to improve this logic to indicate that the cache
supports updates via index, instead of forcing a cache dump from the
kernel on each new index command.

So NFT_CACHE_UPDATE is only useful for intra-batch updates as you
commit describes.

--fm4ywPs9r6x1CwJU
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/src/cache.c b/src/cache.c
index 4b797ec79ae5..1fda3f6939f5 100644
--- a/src/cache.c
+++ b/src/cache.c
@@ -68,7 +68,7 @@ static unsigned int evaluate_cache_add(struct cmd *cmd, unsigned int flags)
 
 		if (cmd->handle.index.id ||
 		    cmd->handle.position.id)
-			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE;
+			flags |= NFT_CACHE_RULE | NFT_CACHE_UPDATE | NFT_CACHE_REFRESH;
 		break;
 	default:
 		break;

--fm4ywPs9r6x1CwJU--
