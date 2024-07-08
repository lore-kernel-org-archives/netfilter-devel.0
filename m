Received: from mail115-24.sinamail.sina.com.cn (mail115-24.sinamail.sina.com.cn [218.30.115.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB133C08A
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2024 12:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720441103; cv=none; b=tOTDsoJNLzui9/LcUIDooGYdTcYjKELsYKXV0a+iza5qG1rOpPfdwjyV88+8LA1ZSXXSkOB5Ka2YiDHdtejeeFuv/s23U8sjhbFBOphcar+x8WX92d4oIADr9DBaGS/14+YgZb1/KewyTvbKm4GCBj//tR+UoK/oqU6taFSh/p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720441103; c=relaxed/simple;
	bh=HpMd3P3IOD032HtJ6pH/C4gUFEi1zNfDNXJE4kUTS6s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NRmkZS4vJXR+bIGCIMtnmWHs300/QR9PNEfT3nfQf+WnfbNs8yFjZwnsMegx7cSlS62xmJLg9UPRRkKEJmkA5fZQ7ib4neiosS2Q2ODCK3f0r10FZo8St2gHKIlBe0prnEOr6cDe5KqaAOQZDU4z+BPkQxShZoas0kHp0kivQjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=218.30.115.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.118.64.123])
	by sina.com (10.185.250.22) with ESMTP
	id 668BD8DF00007E41; Mon, 8 Jul 2024 20:17:37 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 7461817602745
X-SMAIL-UIID: AB8EE09ED60443DA828A7ED8D376D69A-20240708-201737-1
From: Hillf Danton <hdanton@sina.com>
To: Florian Westphal <fw@strlen.de>
Cc: Tejun Heo <tj@kernel.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Mon,  8 Jul 2024 20:17:27 +0800
Message-Id: <20240708121727.944-1-hdanton@sina.com>
In-Reply-To: <20240708115831.GA1289@breakpoint.cc>
References: 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 8 Jul 2024 13:58:31 +0200 Florian Westphal <fw@strlen.de>
> Hillf Danton <hdanton@sina.com> wrote:
> > On Sun, 7 Jul 2024 10:08:24 +0200 Florian Westphal <fw@strlen.de>
> > > Hillf Danton <hdanton@sina.com> wrote:
> > > > > I think this change might be useful as it also documents
> > > > > this requirement.
> > > > 
> > > > Yes it is boy and the current reproducer triggered another warning [1,2].
> > > > 
> > > > [1] https://lore.kernel.org/lkml/20240706231332.3261-1-hdanton@sina.com/
> > > 
> > > The WARN is incorrect.  The destroy list can be non-empty; i already
> > > tried to explain why.
> > >
> > That warning as-is could be false positive but it could be triggered with a
> > single netns.
> 
> How?
> 
You saw the below cpu diagram, no?

> > 	cpu1		cpu2		cpu3
> > 	---		---		---
> > 					nf_tables_trans_destroy_work()
> > 					spin_lock(&nf_tables_destroy_list_lock);
> > 
> > 					// 1) clear the destroy list
> > 					list_splice_init(&nf_tables_destroy_list, &head);
> > 					spin_unlock(&nf_tables_destroy_list_lock);
> > 
> > 			nf_tables_commit_release()
> > 			spin_lock(&nf_tables_destroy_list_lock);
> > 
> > 			// 2) refill the destroy list
> > 			list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
> > 			spin_unlock(&nf_tables_destroy_list_lock);
> > 			schedule_work(&trans_destroy_work);
> > 			mutex_unlock(&nft_net->commit_mutex);
> 
> So you're saying work can be IDLE after schedule_work()?
> 
I got your point but difficult to explain you. In simple words,
like runqueue, workqueue has latency.

> I'm not following at all.

This does not matter but is why I added tj to the cc list.
