Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3180D84A4E;
	Mon,  8 Jul 2024 12:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720442624; cv=none; b=MN/Dmu2cYNQY0X5njvD1dgZMztiI3iMSQxxm3V4Tr3xXXMX2HLDfoKR4/KPy0/G2IgovHHpEpsvF9UwovU+tz7omtkuNDnEZeGx9Sfbaw4l/Zx0iSbWUcyAO9s1M8D0USfJ1K5Wp56refmGGscET/yEQf9tOVTMw1Kb6oTJc0wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720442624; c=relaxed/simple;
	bh=gDa1dHlAzEEcgrgD0zGK62WUiLry4su1EZRLvoZm7fw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dngGiBarltVrXC9UHUKepGq6HvswmNYUIAfF7wnKtTgytwHYH30JpoPVGTidDV92HpxIwM0ivPFjpEopaM7+kMLCebj94mssAJsw+GCfAuplwluCX5ZPUrd0iIzN8/G5Q1vtUYIA/I2UjKxzT8GjMWG7AFira8C22CpILDJlpsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sQniK-0000rn-SW; Mon, 08 Jul 2024 14:43:28 +0200
Date: Mon, 8 Jul 2024 14:43:28 +0200
From: Florian Westphal <fw@strlen.de>
To: Hillf Danton <hdanton@sina.com>
Cc: Florian Westphal <fw@strlen.de>, Tejun Heo <tj@kernel.org>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending
 work before notifier
Message-ID: <20240708124328.GA2748@breakpoint.cc>
References: <20240708115831.GA1289@breakpoint.cc>
 <20240708121727.944-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708121727.944-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hillf Danton <hdanton@sina.com> wrote:
> On Mon, 8 Jul 2024 13:58:31 +0200 Florian Westphal <fw@strlen.de>
> > Hillf Danton <hdanton@sina.com> wrote:
> > > On Sun, 7 Jul 2024 10:08:24 +0200 Florian Westphal <fw@strlen.de>
> > > > Hillf Danton <hdanton@sina.com> wrote:
> > > > > > I think this change might be useful as it also documents
> > > > > > this requirement.
> > > > > 
> > > > > Yes it is boy and the current reproducer triggered another warning [1,2].
> > > > > 
> > > > > [1] https://lore.kernel.org/lkml/20240706231332.3261-1-hdanton@sina.com/
> > > > 
> > > > The WARN is incorrect.  The destroy list can be non-empty; i already
> > > > tried to explain why.
> > > >
> > > That warning as-is could be false positive but it could be triggered with a
> > > single netns.
> > 
> > How?
> > 
> You saw the below cpu diagram, no?

It did not explain the problem in a way I understand.

>	cpu1		cpu2		cpu3
>	---		---		---
>					nf_tables_trans_destroy_work()
>					spin_lock(&nf_tables_destroy_list_lock);
>
>					// 1) clear the destroy list
>					list_splice_init(&nf_tables_destroy_list, &head);
>					spin_unlock(&nf_tables_destroy_list_lock);

This means @work is running on cpu3 and made a snapshot of the list.
I don't even understand how thats relevant, but OK.

>			nf_tables_commit_release()
>			spin_lock(&nf_tables_destroy_list_lock);
>			// 2) refill the destroy list
>			list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
>			spin_unlock(&nf_tables_destroy_list_lock);
>			schedule_work(&trans_destroy_work);
>			mutex_unlock(&nft_net->commit_mutex);

Means CPU2 has added transaction structures that could
reference @table to list.

It also called schedule_work BEFORE releasing the mutex and
after placing entries on destroy list.

> nft_rcv_nl_event()
> mutex_lock(&nft_net->commit_mutex);
> flush_work(&trans_destroy_work);

Means cpu1 serializes vs. cpu2, @work
was scheduled.

flush_work() must only return if @work is idle, without
any other pending execution.

If it gets scheduled again right after flush_work
returns that is NOT a problem, as I tried to explain several times.

We hold the transaction mutex, only a different netns can queue more
work, and such foreign netns can only see struct nft_table structures
that are private to their namespaces.

> // 3) flush work ends with the refilled destroy list left intact
> tear tables down

Again, I do not understand how its possible.

The postcondition after flush_work returns is:

1. nf_tables_destroy_list must be empty, UNLESS its from unrelated
   net namespaces, they cannot see the tables we're tearing down in 3),
   so they cannot reference them.

2. nf_tables_trans_destroy_work() is NOT running, unless its
   processing entries queued by other netns, after flush work
   returned.


cpu2 does:
   -> add trans->table to @nf_tables_destroy_list
   -> unlock list spinlock
   -> schedule_work
   -> unlock mutex

cpu1 does:
 -> lock mutex
 -> flush work

You say its not enough and that trans->table queued by cpu2 can still
be on @nf_tables_destroy_list.

I say flush_work after taking the mutex guarantees strans->table has been
processed by @work in all cases.
