Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB4B1DF25F
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Feb 2026 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769952025; cv=none; b=VR6+ZaQoN589sWClGwB3BaDT1qAI24G63oz4/wO5CKg6SoMStVeomwybQs0ddqeAmV+QQKc3ZP9tJAg4iZoocUDDiTXiB/4ZfEggXEJnsExcWNw5OZWWo+856OIlEGdtwD/Bl9809XWLcriUFjCfMHdKGXhi2zCwXm99Jld2Edk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769952025; c=relaxed/simple;
	bh=amlEMOyABJCzMI5ljZcthXGYhWLd35d//l9pxhwvPS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j1MF2iZY3549HafK7EOSgTpibAaQkDXh5Um8DhqV1tmV0Jnmq6pEXDK7uyRO82FiCLiTGeBq/99dHlXjMySCTRuGCxTe8p0B/upWieepc4DjlKp3Lxrf1F/F5wAUB9GFkkGDh/X9qumTsgoPVlMwiwgLBDPoD3IS1DDWP239e3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 24FA1605C3; Sun, 01 Feb 2026 14:20:21 +0100 (CET)
Date: Sun, 1 Feb 2026 14:20:20 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Subject: Re: [PATCH v2 nf-next] netfilter: nf_tables: use dedicated spinlock
 for reset operations
Message-ID: <aX9TFNlIzLU9J99z@strlen.de>
References: <20260201062517.263087-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201062517.263087-1-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> Replace commit_mutex with a dedicated reset_lock spinlock for reset
> operations. This fixes a circular locking dependency between
> commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER when nft
> reset, ipset list, and iptables-nft with set match run concurrently:
> 
>   CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
>   CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
>   CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset
> 
> Using a spinlock instead of a mutex means we stay in the RCU read-side
> critical section throughout, eliminating the try_module_get/module_put
> and rcu_read_unlock/rcu_read_lock dance that was needed to handle the
> sleeping mutex.
> 
> Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
> Fixes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448

'Fixes' tag should point at the commit adding the bug.

Fixes: bd662c4218f9 netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Fixes: 3d483faa6663 netfilter: nf_tables: Add locking for NFT_MSG_GETSETELEM_RESET requests
Fixes: 3cb03edb4de3 netfilter: nf_tables: Add locking for NFT_MSG_GETRULE_RESET requests

No need to resend, I can mangle this locally.

> -	mutex_lock(&nft_net->commit_mutex);
> +	spin_lock(&nft_net->reset_lock);
>  	ret = nf_tables_dump_rules(skb, cb);
> -	mutex_unlock(&nft_net->commit_mutex);
> +	spin_unlock(&nft_net->reset_lock);

I *think* its fine, because concurrent resets make no sense.

In case we get reports wrt. long spin time the lock/unlock
pairs will have to be pushed down, like in the previous version.
