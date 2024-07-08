Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77D97E782;
	Mon,  8 Jul 2024 11:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720439929; cv=none; b=iYzzaRtap4igvfGWau2lwbWSYh3ykSPkFR9O4YzS9ujbaeGuD53zF9Rk9YzSd0gVmBOxuQlHlxS3jJ6Xa2bdkc7lKDH0fxAQOYUqJuaHCALQ48A4Q4r6+adtZ+TvjYhFUmimLy73oteabY+omuy4JkWHd1tMMREPkJOJuhmiufo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720439929; c=relaxed/simple;
	bh=1E3I1ZiHzIVudZmbIetq96mRUH/6Y96+47Ui1GlIlUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=elKiuv3WQpmkVyqll3GVlULP0bTNi+EkJTw8nv2U7hf4IihbKJygfG6Wt7WqM2aWnlmxwdAP+2VynozjKSlBdyTsj348/SxydwK7FBTlUEuR02AQbYejGncKUt//k3ncBWVcTT1iYVd2XddUEMIoanLZMBTY7Jq6sxboo/nYjxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sQn0p-0000Q8-6r; Mon, 08 Jul 2024 13:58:31 +0200
Date: Mon, 8 Jul 2024 13:58:31 +0200
From: Florian Westphal <fw@strlen.de>
To: Hillf Danton <hdanton@sina.com>
Cc: Florian Westphal <fw@strlen.de>, Tejun Heo <tj@kernel.org>,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending
 work before notifier
Message-ID: <20240708115831.GA1289@breakpoint.cc>
References: <20240707080824.GA29318@breakpoint.cc>
 <20240708105631.841-1-hdanton@sina.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240708105631.841-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hillf Danton <hdanton@sina.com> wrote:
> On Sun, 7 Jul 2024 10:08:24 +0200 Florian Westphal <fw@strlen.de>
> > Hillf Danton <hdanton@sina.com> wrote:
> > > > I think this change might be useful as it also documents
> > > > this requirement.
> > > 
> > > Yes it is boy and the current reproducer triggered another warning [1,2].
> > > 
> > > [1] https://lore.kernel.org/lkml/20240706231332.3261-1-hdanton@sina.com/
> > 
> > The WARN is incorrect.  The destroy list can be non-empty; i already
> > tried to explain why.
> >
> That warning as-is could be false positive but it could be triggered with a
> single netns.

How?

> 	cpu1		cpu2		cpu3
> 	---		---		---
> 					nf_tables_trans_destroy_work()
> 					spin_lock(&nf_tables_destroy_list_lock);
> 
> 					// 1) clear the destroy list
> 					list_splice_init(&nf_tables_destroy_list, &head);
> 					spin_unlock(&nf_tables_destroy_list_lock);
> 
> 			nf_tables_commit_release()
> 			spin_lock(&nf_tables_destroy_list_lock);
> 
> 			// 2) refill the destroy list
> 			list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
> 			spin_unlock(&nf_tables_destroy_list_lock);
> 			schedule_work(&trans_destroy_work);
> 			mutex_unlock(&nft_net->commit_mutex);

So you're saying work can be IDLE after schedule_work()?

I'm not following at all.
