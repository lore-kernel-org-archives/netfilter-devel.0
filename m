Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE891E2848
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 10:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753785549; cv=none; b=VBzJeraxRdDi7ijkaTVV7ac2Lk97Toc/43Cn5qZKGyQQ/aBA4kkAOalo0C/0oDlfbfg39hfsF8lQ0l2VWDyp9dZOqoM8g+f3YLSvaK1d+qxh02UIy/x9IKb12SZYmn63JrCmaniZKzm3ulVXbSkOL9x1n5ObRDfUNp7ZFu7oYLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753785549; c=relaxed/simple;
	bh=wpkq7MpL8FalAwkEdw3HU7b7V92AYh6hJOB+LKX56h8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lj1axP9aMTkf7wviQZ9LgGHo9gIagzsjGfdYvaTXWmab5X30id6PoSvxobE6yvSi7IhifSa4aDs+rWsiu+Vb0Z3bAZG8O7ldpaQzRqu2PW+YcPJlpzrkkR93DF7GyJDiAE9AiiT8saX+JjZ8t2je6OPE9ivpT2oQH+cOzxq2O1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=AKKWUCWC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SIMA4QYf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="AKKWUCWC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SIMA4QYf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 3F3D76026F; Tue, 29 Jul 2025 12:39:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753785544;
	bh=1zx3NjVh42fM4usRmOqWMiEbewRhnQIAFdMMcNrZxbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AKKWUCWCea8BFOn1SG9t0IX2WtjDSbU4VBA1Dgz+yCDB3r2TsB5OCrEzTwF3v8fW8
	 slvRh9WKLrSKqQtaHMa/dM3+3WTugxz4BKVM7mGP/29HVh2yZEwKpB3fo/1slGPD3m
	 XFKCsINCpF/jb05YgfQza6gE5WO8wG49bg4tkvjaOlS5kmZ5vKzQ+UOzLYMhsO58Vn
	 bWXKVK15QdaZTuWSvCpgPbOciEc9nOOg0FTVu9GkAGPjPhVvkrkIDTVUd6/2OsKEFW
	 I55CkN0ION8Zqpvt3/eyiskOhJcrX68j/x/kG0X4ON5BwNDOEBTZwn74XXi3L9oNQM
	 T9KilxdJCB4/A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 31B986026F;
	Tue, 29 Jul 2025 12:39:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753785543;
	bh=1zx3NjVh42fM4usRmOqWMiEbewRhnQIAFdMMcNrZxbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIMA4QYfmPZmdkp7t23kcQC8bTdI/LRr+erlE8gDZumIpQbTPdY+JZ73VC1k5elj3
	 wlXVuiiFt2QFGg/YH4IdZEPZrYD7pXjk2vSMpDUESUzgYsKnbxhkn5PZ/2XqSR4ht0
	 DfXpMHKNSZYblmx5sBB0StTGfxv81VXY9BgbKfbeVoFDQE+Nag4JgGBg+oE8KKHbp9
	 /vpuU4BueipSRwpJQtDB6mvRqMnI6jxRlzp8iJy1JQqljSQE+sO8Vnvzgr1jEe/r/H
	 vqaX9kblok8fB/GBjQJVSuBb7B48xIlxP2tQJuo3SN0DLyitEh6fLR3HBzVeqv+gAO
	 mA2DbjFy8Vjlg==
Date: Tue, 29 Jul 2025 12:38:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nf-next 0/2] netfilter: nf_tables: make set flush more
 resistant to memory pressure
Message-ID: <aIikwxU686KFto35@calendula>
References: <20250704123024.59099-1-fw@strlen.de>
 <aIK_aSCR67ge5q7s@calendula>
 <aILOpGOJhR5xQCrc@strlen.de>
 <aINYGACMGoNL77Ct@calendula>
 <aINnTy_Ifu66N8dp@strlen.de>
 <aIOcq2sdP17aYgAE@calendula>
 <aIfrktUYzla8f9dw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aIfrktUYzla8f9dw@strlen.de>

On Mon, Jul 28, 2025 at 11:28:50PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Yes, u32 flush_id (or trans_id) needs to be added, then set
> > transaction id incrementally.
> 
> Not enough, unfortunately.
> 
> The key difference between flush (delete all elements) and delset
> (remove the set and all elements) is that the set itself gets detached
> from the dataplane.  Then, when elements get free'd, we can just iterate
> the set and free all elements, they are all unreachable from the
> dataplane.
> 
> But in case of a flush, thats not the case, releasing the elements will
> cause use-after-free.  Current DELSETELEM method unlinks the elements
> from the set, links them to the DELSETELEM transactional container.

DELSETELEM does not unlink elements from set in the preparation phase,
instead elements are marked as inactive in the next generation but
they still remain linked to the set. These elements are removed from
the set from either the commit/abort phase.

- flush should skip elements that are already inactive
- flush should not work on deleted sets.
- flush command (elements are marked as inactive) then delete set
  skips those elements that are inactive. So abort path can unwind
  accordingly using the transaction id marker what I am proposing.

I think the key is that no two different transaction release the same
object, hence the need for the transaction id for the flush command to
differentiate between delete set and flush set commands.

I can take a look next week to see if all this is practical,
otherwise...

> Then, on abort they get re-linked to the set, or, in case of commit,
> they can be free'd after the final synchronize_rcu().
> 
> That leaves two options:
> 1.  Use the first patchset, that makes delsetelem allocations sleepable.
> 2.  Add a pointer + and id to nft_set_ext.
> 
> The drawback of 2) is the added mem cost for every set eleemnt (first
> patch series only forces it for rhashtable).
> 
> The major upside however is that DELSETELEM transaction objects are
> simplified a lot, the to-be-deleted elements could be linked to it by
> the then-always-available nft_set_ext pointer, i.e., each DELSETELEM
> transaction object can take an arbitrary number of elements.
> 
> Unless you disagree, I will go for 2).
> This will also allow to remove the krealloc() compaction for DELSETELEM,
> so it should be a net code-removal patch.
> 
> Another option might be to replace a flush with delset+newset
> internally, but this will get tricky because the set/map still being
> referenced by other rules, we'd have to fixup the ruleset internally to
> use the new/empty set while still being able to roll back.
> 
> Proably too tricky / hard to get right, but I'll check it anyway.

... if I don't find a way or I'm too slow, we can take your series in
the next merge window as is.
