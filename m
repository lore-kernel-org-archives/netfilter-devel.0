Received: from smtp134-25.sina.com.cn (smtp134-25.sina.com.cn [180.149.134.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E227770ED
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2024 10:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720436221; cv=none; b=fUa6cLayjUkLy3BisnNYNs470ptv4I8d6Q7zek2LFHUH6bEd9VsuL1mAiUuAfKtx4upX5kBOYxhSWjRr+XkxvhkVUOfXJkcXuerfD4aewIaBoxotbTViM7WalO9IryfBxfgETkaAnDTd3lafCnRQ6ls9PS+VeheRkGov5Izz4H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720436221; c=relaxed/simple;
	bh=vnzHPyqhh9uqjyMMGYHiAx4MW+nRasQ0HWpUhG1eEsc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CqlnrbmFNl1ramg+Hy2z6lbwzblZj9mSA34A+j3AbEywTWiq7Ne+my1ARq6eV+KImgG66Gn6hlgJ5/5xeQFB9mt7Ki680cQ60MA7t5yPAxpKFroRqnvjb8F7YM/TaIsaBeFa1D3ZWmt94ki5AN88i4aEaLQD2YH9qgX6X/0rWRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=180.149.134.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([113.118.64.123])
	by sina.com (10.185.250.21) with ESMTP
	id 668BC5E70000702C; Mon, 8 Jul 2024 18:56:41 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 6985133408355
X-SMAIL-UIID: 2A7656D9FD7C49829FA8CEF8239B8943-20240708-185641-1
From: Hillf Danton <hdanton@sina.com>
To: Florian Westphal <fw@strlen.de>
Cc: Tejun Heo <tj@kernel.org>,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Mon,  8 Jul 2024 18:56:31 +0800
Message-Id: <20240708105631.841-1-hdanton@sina.com>
In-Reply-To: <20240707080824.GA29318@breakpoint.cc>
References: 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 7 Jul 2024 10:08:24 +0200 Florian Westphal <fw@strlen.de>
> Hillf Danton <hdanton@sina.com> wrote:
> > > I think this change might be useful as it also documents
> > > this requirement.
> > 
> > Yes it is boy and the current reproducer triggered another warning [1,2].
> > 
> > [1] https://lore.kernel.org/lkml/20240706231332.3261-1-hdanton@sina.com/
> 
> The WARN is incorrect.  The destroy list can be non-empty; i already
> tried to explain why.
>
That warning as-is could be false positive but it could be triggered with a
single netns.

	cpu1		cpu2		cpu3
	---		---		---
					nf_tables_trans_destroy_work()
					spin_lock(&nf_tables_destroy_list_lock);

					// 1) clear the destroy list
					list_splice_init(&nf_tables_destroy_list, &head);
					spin_unlock(&nf_tables_destroy_list_lock);

			nf_tables_commit_release()
			spin_lock(&nf_tables_destroy_list_lock);

			// 2) refill the destroy list
			list_splice_tail_init(&nft_net->commit_list, &nf_tables_destroy_list);
			spin_unlock(&nf_tables_destroy_list_lock);
			schedule_work(&trans_destroy_work);
			mutex_unlock(&nft_net->commit_mutex);

	nft_rcv_nl_event()
	mutex_lock(&nft_net->commit_mutex);
	flush_work(&trans_destroy_work);
	  start_flush_work()
	    insert_wq_barrier()
	    /*
	     * If @target is currently being executed, schedule the
	     * barrier to the worker; otherwise, put it after @target.
	     */

	// 3) flush work ends with the refilled destroy list left intact
	tear tables down

