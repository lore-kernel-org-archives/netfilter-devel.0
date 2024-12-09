Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D712D78C9C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2024 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733781851; cv=none; b=NKw4ylUdsqPsqA5/sHfbMmZR53AdHPfzE2FSFuLJcM8bWRaMh+XaRhYGjL66tAdVlmBZtJxB1vbf09bgcYmUJ1Xec37F2KJ+B5HMkOW3Q8/TSzpCFkMaEaKU+QICD9s+VIyqhSHjydqcR02ojVeGlarjp9qbChTzplcURJrAQjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733781851; c=relaxed/simple;
	bh=4B+9EhDlOmAx+FoLKiooxuI5D4gQqeYLFOe5M6Om/bk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMnSm1OH57RxvyTSdu1/wLZd4fzgtDFRggxxZzHRQSU8Rejcp2KYsYXeUMvB/QbsJYFh0CpRojFpDLJxSimqCJ3N/WjgmVDcFJQkpLBXQXpXlQiXn2Y22ZKdzOP36vYNkNU3uBPeSXsVzeKV0HXuQOxKvv2YEQCKbcxcRrRwzic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1tKlrF-0001G5-0k; Mon, 09 Dec 2024 23:04:01 +0100
Date: Mon, 9 Dec 2024 23:04:01 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	syzkaller-bugs@googlegroups.com,
	syzbot+b26935466701e56cfdc2@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: do not defer rule destruction
 via call_rcu
Message-ID: <20241209220401.GA4709@breakpoint.cc>
References: <67478d92.050a0220.253251.0062.GAE@google.com>
 <20241207111459.7191-1-fw@strlen.de>
 <Z1dgtm5IhoJW5vGL@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1dgtm5IhoJW5vGL@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > One way would be to allocate nft_trans_rule objects + one nft_trans_chain
> > object, deactivate the rules + the chain and then defer the freeing to the
> > nft destroy workqueue.  We'd still need to keep the synchronize_rcu path as
> > a fallback to handle -ENOMEM corner cases though.
> 
> I think it can be done _without_ nft_trans objects.
> 
> Since the commit mutex is held in this netdev event path: Remove this
> basechain, deactivate rules and add basechain to global list protected
> with spinlock, it invokes worker. Then, worker zaps this list
> basechains, it calls synchronize_rcu() and it destroys rules and then
> basechain. No memory allocations needed in this case?

I don't think its possible due to netlink dumps.

Its safe for normal commit path because list_del_rcu() gets called on
these objects (making them unreachable for new dumps), then,
synchronize_rcu is called (so all concurrent dumpers are done) and then
we free.

It would work if you add a new list_head to the basechain, then you
could just link the basechain object to some other list and then
call nf_tables_rule_release() AFTER a synchronize_rcu because rules
can't be picked up if the owning chain is no longer reachable.

However, I do wonder how complex it would be.

This is tricky to get right and I'm not sure this patch adds a
noticeable issue, see nft_rcv_nl_event() which has similar pattern,
i.e. synchronize_rcu() is called.

I'm not saying we should not consider async route, but maybe better
to followup in -next?
