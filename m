Received: from smtp134-31.sina.com.cn (smtp134-31.sina.com.cn [180.149.134.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077DA1AB91A
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jul 2024 10:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720089374; cv=none; b=hHKJtcTvXcTndpq2TCElm9ADRhcwvNnSQVGxJzk9QYwS5RvHnN3vIEzF3VAYFM0UJPZ3yw5hnX98n2jYACbsovkjyES4BB7i/XCVHxvU1jBwRd5xsXy3ph3ILMlA+7+XofXoReMcDiPmAHNtGio3hehhKmPijnaFnm/8JFGYUYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720089374; c=relaxed/simple;
	bh=F0U+LFngqNZTjEjSJVQJ9Hzl5vylWxE0tv1FzcykhCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Cl2Fcyt4HIjTyp7u4WmhJ3anK33bqFOws3hbRAP1khHKqA0aCIgp6tLskBIo4qGoCbA07uq5vu93ml6YZtC21S2Xbr+QtGRcpJPfIHKv/ixl52ejIbpplpA/yOlZxbpbac2aMs1c4zbC63g1BcOKCb4/M5MqbjOfKfYk1cJD7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=180.149.134.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.118.65.201])
	by sina.com (10.185.250.21) with ESMTP
	id 66867AEB00007F26; Thu, 4 Jul 2024 18:35:25 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 6097673408358
X-SMAIL-UIID: BAA4D347F2CB48EBA17B1782EB4B3DA7-20240704-183525-1
From: Hillf Danton <hdanton@sina.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Thu,  4 Jul 2024 18:35:14 +0800
Message-Id: <20240704103514.3035-1-hdanton@sina.com>
In-Reply-To: <20240703130107.GB29258@breakpoint.cc>
References: 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 3 Jul 2024 15:01:07 +0200 Florian Westphal <fw@strlen.de>
> Hillf Danton <hdanton@sina.com> wrote:
> > On Wed, 3 Jul 2024 12:52:15 +0200 Florian Westphal <fw@strlen.de>
> > > Hillf Danton <hdanton@sina.com> wrote:
> > > > Given trans->table goes thru the lifespan of trans, your proposal is a bandaid
> > > > if trans outlives table.
> > > 
> > > trans must never outlive table.
> > > 
> > What is preventing trans from being freed after closing sock, given
> > trans is freed in workqueue?
> > 
> > 	close sock
> > 	queue work
> 
> The notifier acquires the transaction mutex, locking out all other
> transactions, so no further transactions requests referencing
> the table can be queued.
> 
As per the syzbot report, trans->table could be instantiated before
notifier acquires the transaction mutex. And in fact the lock helps
trans outlive table even with your patch.

	cpu1			cpu2
	---			---
	transB->table = A
				lock trans mutex
				flush work
				free A
				unlock trans mutex

	queue work to free transB

> The work queue is flushed before potentially ripping the table
> out.  After this, no transactions referencing the table can exist
> anymore; the only transactions than can still be queued are those
> coming from a different netns, and tables are scoped per netns.
> 
> Table is torn down.  Transaction mutex is released.
> 
> Next transaction from userspace can't find the table anymore (its gone),
> so no more transactions can be queued for this table.
> 
> As I wrote in the commit message, the flush is dumb, this should first
> walk to see if there is a matching table to be torn down, and then flush
> work queue once before tearing the table down.
> 
> But its better to clearly split bug fix and such a change.
