Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C158F186284
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Feb 2026 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769955631; cv=none; b=tE+cajHH6pho+7aVYXiuFDTrSiSGAgQ/uimFAQ3YxnyE+YO6LstOBymlo88mCPjG8q+JQ+na0M2VSdk4r2PeNvNuOxh48aOGQ1DFQJo0q1As74ycOew1uYht74BgJyYGlwx+F5zRUgEVo1j6C4Zk7DTjN5qujHjFdsXEZg7fq0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769955631; c=relaxed/simple;
	bh=FMSpQoW/7EkeagX0qssllK/HplUFhhTkt/5gES1wUFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RRVGBgvCLwes8d1O8tkPBnKI5/ohr9w909QOlh9ijgt9mlkjIGMjctal44MfsxjmDVL9InOgVamWrT8ygRUwM9B/fVZlA/vi0pAsLhrJgVsdhrK3yED2x5TGFoZTk2SPPU6XlV6+E34R/8+rA28x/+zsRfl2JFqDN4Fgd0DX8Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 63DF0605C3; Sun, 01 Feb 2026 15:20:27 +0100 (CET)
Date: Sun, 1 Feb 2026 15:20:22 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 nf-next] netfilter: nf_tables: use dedicated spinlock
 for reset operations
Message-ID: <aX9hJsMroAcTng6m@strlen.de>
References: <20260201062517.263087-1-brianwitte@mailfence.com>
 <aX9TFNlIzLU9J99z@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aX9TFNlIzLU9J99z@strlen.de>

Florian Westphal <fw@strlen.de> wrote:
> Brian Witte <brianwitte@mailfence.com> wrote:
> > Replace commit_mutex with a dedicated reset_lock spinlock for reset
> > operations. This fixes a circular locking dependency between
> > commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER when nft
> > reset, ipset list, and iptables-nft with set match run concurrently:
> > 
> >   CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
> >   CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
> >   CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset
> > 
> > Using a spinlock instead of a mutex means we stay in the RCU read-side
> > critical section throughout, eliminating the try_module_get/module_put
> > and rcu_read_unlock/rcu_read_lock dance that was needed to handle the
> > sleeping mutex.
> > 
> > Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
> > Fixes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
> 
> 'Fixes' tag should point at the commit adding the bug.
> 
> Fixes: bd662c4218f9 netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
> Fixes: 3d483faa6663 netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
> Fixes: 3cb03edb4de3 netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests
> 
> No need to resend, I can mangle this locally.
> 
> > -	mutex_lock(&nft_net->commit_mutex);
> > +	spin_lock(&nft_net->reset_lock);
> >  	ret = nf_tables_dump_rules(skb, cb);
> > -	mutex_unlock(&nft_net->commit_mutex);
> > +	spin_unlock(&nft_net->reset_lock);
> 
> I *think* its fine, because concurrent resets make no sense.
> 
> In case we get reports wrt. long spin time the lock/unlock
> pairs will have to be pushed down, like in the previous version.

Actually, Brian, could you please try and see if the following isn't
yielding a saner result?

First, issue 'git revert' for bd662c4218f9, 3d483faa6663, 3cb03edb4de3

(3d483faa6663 has minor conflict, easy to resolve, keep nft_base_seq()
 but move to conditional).

Then, use the previous version of your patch but do use the nft_pernet
spinlock added in this change here.

I think this will give us a 4-part series that is more obvious wrt.
what is going on.

The spinlock fix would then be limited to adding locked sections where
needed, rather than mixing new lock with partial reverts of a few chunks
from the previous attempt.

The 3 reverts could optionally be squased into one commit, clearly saying
that it reverts those 3 changes (and why).

Thanks.
