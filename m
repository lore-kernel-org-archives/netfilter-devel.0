Received: from mail115-95.sinamail.sina.com.cn (mail115-95.sinamail.sina.com.cn [218.30.115.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C0814658C
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Jul 2024 10:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=218.30.115.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720176526; cv=none; b=ioMI5tPrwMbk9x5FHeMElxGyR1LZvKSVo4ag018IwT/c43jyT/7O6LuHl1P8zOhSb9DxUF504Ac8CfsqqEhxxh24XgS6GqkBUL21InF6doLcTPm0alFNQoYVsXWBkvrgiwYsCwv3kjleKBOaBGhkUQM138BczBd1TkWnnUkInsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720176526; c=relaxed/simple;
	bh=DZkXGAZOqOS8UxKTgq8Ci4H6svemPL5M77w8Qgr0DAg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JaiI11qPm7hFfSfZImPidWsa9B6ehszGJDdF/psIpEidVK9t9fTkbvlhkphzVBFCNe7yM0E2lnT1mRt0sWbMSPqfrxD70HoZiq2uqH3Fx43GPaPGfuJDrN7vg+Vug9xbal/4U9Yzly3xjEEkU+MSNX2QDhRovmBaC5+AtLtK82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=218.30.115.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.118.71.197])
	by sina.com (10.185.250.23) with ESMTP
	id 6687CF7D00007C71; Fri, 5 Jul 2024 18:48:32 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 2348268913080
X-SMAIL-UIID: 81AAD2B8BC994A36B295E5AF557FEB82-20240705-184832-1
From: Hillf Danton <hdanton@sina.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Fri,  5 Jul 2024 18:48:21 +0800
Message-Id: <20240705104821.3202-1-hdanton@sina.com>
In-Reply-To: <20240704105418.GA31039@breakpoint.cc>
References: 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 4 Jul 2024 12:54:18 +0200 Florian Westphal <fw@strlen.de>
> Hillf Danton <hdanton@sina.com> wrote:
> > On Wed, 3 Jul 2024 15:01:07 +0200 Florian Westphal <fw@strlen.de>
> > > Hillf Danton <hdanton@sina.com> wrote:
> > > > On Wed, 3 Jul 2024 12:52:15 +0200 Florian Westphal <fw@strlen.de>
> > > > > Hillf Danton <hdanton@sina.com> wrote:
> > > > > > Given trans->table goes thru the lifespan of trans, your proposal is a bandaid
> > > > > > if trans outlives table.
> > > > > 
> > > > > trans must never outlive table.
> > > > > 
> > > > What is preventing trans from being freed after closing sock, given
> > > > trans is freed in workqueue?
> > > > 
> > > > 	close sock
> > > > 	queue work
> > > 
> > > The notifier acquires the transaction mutex, locking out all other
> > > transactions, so no further transactions requests referencing
> > > the table can be queued.
> > > 
> > As per the syzbot report, trans->table could be instantiated before
> > notifier acquires the transaction mutex. And in fact the lock helps
> > trans outlive table even with your patch.
> > 
> > 	cpu1			cpu2
> > 	---			---
> > 	transB->table = A
> > 				lock trans mutex
> > 				flush work
> > 				free A
> > 				unlock trans mutex
> > 
> > 	queue work to free transB
> 
> Can you show a crash reproducer or explain how this assign
> and queueing happens unordered wrt. cpu2?
> 
Not so difficult.

> This should look like this:
> 
>  	cpu1			cpu2
>  	---			---
> 	lock trans mutex
>   				lock trans mutex -> blocks
>  	transB->table = A
>   	queue work to free transB
> 	unlock trans mutex
> 				lock trans mutex returns
>   				flush work
>   				free A
>   				unlock trans mutex
> 
If your patch is correct, it should survive a warning.

#syz test https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git  1c5fc27bc48a

--- x/net/netfilter/nf_tables_api.c
+++ y/net/netfilter/nf_tables_api.c
@@ -11552,9 +11552,10 @@ static int nft_rcv_nl_event(struct notif
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nf_tables_destroy_list))
-		nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work();
 again:
+	WARN_ON(!list_empty(&nft_net->commit_list));
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
 		    n->portid == table->nlpid) {
--
