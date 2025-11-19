Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9B53587A9
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Nov 2025 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763556734; cv=none; b=ImYV6jMxZ+uVZP5P4VQMiQiVZ8uRzaltSswE7WT3i/xpvFcCy/bsK+wckxBoeLyWC/M8zmQkZ+JfsW2+JkGOWqk6CG2//CaZ9RqZJXmlpivYvBVn0+O6cox/Rxl+YsJ4MybqPJxTQ4pO50ShJiE9BBc5H/jP0ls6kAyG/9njPUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763556734; c=relaxed/simple;
	bh=cGvyGonjs+L+bGn4tVPzZEbsax0SKJAzXOUb155EdTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVctND338JyMy+0VKzNgc9JgWfGqBApaqjBxKv7i9aCHXw5FdnwYinA8Ovuyu4qgK6j8epqUf0HJH+b/WV5xibGRq9XJsmdFvmZa2UPB55VofMZ2oly9zCiDCLfXNVIEGTzf3D6yScOLCu7Wzjzj8zhLqmvaARxb4Mp/Jt6c6Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pv7N2Tg4; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pv7N2Tg4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lYCL0Mkbp8rt3/PVwGYXyspvOCQeESlMiDxE5256ZxQ=; b=pv7N2Tg4IMzE/7oyWIpuJGzwlq
	I/JZYvoZkx15XJwXpSzhLgpszqKRffvDa97Hbcl5wiMpCttpt5koQ6UX/c8b3QtGS7nefblpMg7RO
	X9OgCI20/HPMELbFKSK99yxzov3IvZojhWpzYHnBQjvB+818S00DZiJgv2bxJWT+2N0fYpCZnZ+ru
	j9Covq/ro0FZhbJT5M/kwHvramUISp8UArv1JCMjqykYxffFDLzuiU58omBzmmbIudvLe3+7Wr1wW
	JsRIV9Z58ES+sq/pyAJmr08HxzHc5LPkpti7PYYIaeedKXXO7zJO50KB9IhgANpwU9qXdLMw0GMWJ
	OLgHu6ow==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vLhfJ-000000004fY-30S6;
	Wed, 19 Nov 2025 13:52:05 +0100
Date: Wed, 19 Nov 2025 13:52:05 +0100
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/3] netfilter: nft_set_rbtree: use cloned tree
 for insertions and removal
Message-ID: <aR29ddgmrjWcayAV@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20251118111657.12003-1-fw@strlen.de>
 <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4e63da-6d36-4365-8c08-547961c9bfa7@suse.de>

Hi,

On Tue, Nov 18, 2025 at 05:07:56PM +0100, Fernando Fernandez Mancera wrote:
> On 11/18/25 12:16 PM, Florian Westphal wrote:
> > This series fixes false negative lookup bug in rbtree set backend that
> > can occur during transaction.
> > 
> > First two patches prepare for actual fix, which is coming in last patch.
> > 
> > All inserts/removals will now occur in a cloned copy, so packetpath can
> > no longer observe the problematic mixed-bag of old, current and new
> > elements.
> > 
> > The live tree will only have reachable elements that are active in the
> > current generation or were active in the previous generation (but are still
> > valid while packetpath holds rcu read lock).  The latter case is only
> > temporary, as new lookups already observe the updated tree).
> > 
> 
> I have been taking a look to the series and testing it with different 
> set sizes. The implementation looks good to me but I noticed that due 
> the new "clone" mechanism there is an impact on performance when 
> modifying an existing rbtree set (inserts or deletions). According to my 
> number the impact would be around 40~%. Usually that isn't problematic 
> but if big sets are used.. then it is a bit more. e.g
> 
> 200K elements ~ avg. time insertion before 510ms after 744ms
> 500K elements ~ avg. time insertion before 5460ms after 7730ms

I wonder if nft_rbtree_maybe_clone() could run a simpler copying
algorithm than properly inserting every element from the old tree into
the new one since the old tree is already correctly organized -
basically leveraging the existing knowledge of every element's correct
position.

Or is there a need to traverse the new tree with each element instead of
copying the whole thing as-is?

Cheers, Phil
