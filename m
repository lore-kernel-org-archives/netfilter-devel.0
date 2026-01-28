Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0A125B2
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 00:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769558954; cv=none; b=HIFkdrZfSpP+MauaUqOqsT+roDnFlagsr6L/aEVQnlFGKfO8DCCG02lrsvuU2cnZHQr3AfwCL/Z4qY7gSoeUFNu8++J9uB28ajDsNzaVqmTWLlk6Ma+VbE0yYHi1bo5T+7vwJn6FJ84i0ZJedqC6HbdN9Ri55yBONBSIpWMajeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769558954; c=relaxed/simple;
	bh=XveIEhNb3pNWV8nWGPzWr8Q7j03HnmMppmZQBnPsOc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sWPLGRFlrO1SnBfkA0ou+ERfB6xLrnQUVOx9P/lIorFvvMEs3EgUBCt7WdoG3kqLFek6g8ogwo0sYVE2+32o5vXt8FfATKd5Ze3vbukEPTVnNxg59rjmSf3fDltUtI0ywrUHxMc7gW13qTtDNEQ8IO6hNu6NFF7KjSqfIlXSYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 87798602B6; Wed, 28 Jan 2026 01:09:09 +0100 (CET)
Date: Wed, 28 Jan 2026 01:09:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Brian Witte <brianwitte@mailfence.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for
 reset operations
Message-ID: <aXlTpuk0Z1CeoYwT@strlen.de>
References: <20260127030604.39982-1-brianwitte@mailfence.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127030604.39982-1-brianwitte@mailfence.com>

Brian Witte <brianwitte@mailfence.com> wrote:
> Add a dedicated reset_mutex to serialize reset operations instead of
> reusing the commit_mutex. This fixes a circular locking dependency
> between commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER
> that could lead to deadlock when nft reset, ipset list, and
> iptables-nft with set match run concurrently:
> 
>   CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
>   CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
>   CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset
> 
> The reset_mutex only serializes concurrent reset operations to prevent
> counter underruns, which is all that's needed. Breaking the commit_mutex
> dependency in the dump-reset path eliminates the circular lock chain.
> 
> Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
> Signed-off-by: Brian Witte <brianwitte@mailfence.com>

This needs more work:

-----------------------------
net/netfilter/nf_tables_api.c:1002 RCU-list traversed in non-reader section!!

other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/17539:
 #0: ffff888132018368 (&nft_net->reset_mutex){+.+.}-{4:4}, at: nf_tables_getobj_reset+0x19e/0x5a0 [nf_tables]

stack backtrace:
CPU: 4 UID: 0 PID: 17539 Comm: nft Not tainted 6.19.0-rc6+ #9 PREEMPT(full)
Call Trace:
 lockdep_rcu_suspicious.cold+0x4f/0xb1
 nft_table_lookup.part.0+0x1e7/0x220 [nf_tables]
 nf_tables_getobj_single+0x196/0x5a0 [nf_tables]
 nf_tables_getobj_reset+0x1b1/0x5a0 [nf_tables]
 nfnetlink_rcv_msg+0x49e/0xf00

Please run nftables.git tests/shell/run-tests.sh with

CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_LIST=y

This warning is not a false positive, the list traversal was
fine for reset case because we held the transaction mutex.

Now that we don't, we need to hold rcu_read_lock().

Maybe its worth investigating if we should instead protect
only the reset action itself, i.e. add private reset spinlocks
in nft_quota_do_dump() et al?
