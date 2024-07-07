Received: from smtp134-31.sina.com.cn (smtp134-31.sina.com.cn [180.149.134.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C24FE54C
	for <netfilter-devel@vger.kernel.org>; Sun,  7 Jul 2024 07:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.149.134.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720339036; cv=none; b=EhywUDsG3HBqQb89ix8md8gR6FY4M2KTyOs0otdhPkcbXcJ+lYukgQENsq73xCfw69qAFlv2tpAiT5rK/le8/FiSTI2O4drBG7b4CODYAaKlqBPPtlQGG93zjd027YNIq5YVo7j0arkw4MpgRUfLcGefBVUZI1PTNbqcEame7DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720339036; c=relaxed/simple;
	bh=IAaStqRr7hyLLG8bbQzWfK4Jo2PvQI4E75hxcwWi3TQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=puqNILWwX1J6xsQuJTVT+FfHzof1jTndK0xNuBUz1DZeYsRV5iS/5PRz10aZbQqgs/jFdPpXrZgXTMk/kUG1EwSM+GrHbPD1g+t26aJHW3X+TRWpUWRx/4agd61/H/r2Us7gIOtI0+Fk55HuZUgWhTqmjYqv/N/LKrr1pdydDzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com; spf=pass smtp.mailfrom=sina.com; arc=none smtp.client-ip=180.149.134.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sina.com
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([116.24.8.88])
	by sina.com (10.185.250.21) with ESMTP
	id 668A4A4600003EF9; Sun, 7 Jul 2024 15:56:57 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
Authentication-Results: sina.com;
	 spf=none smtp.mailfrom=hdanton@sina.com;
	 dkim=none header.i=none;
	 dmarc=none action=none header.from=hdanton@sina.com
X-SMAIL-MID: 5756333408340
X-SMAIL-UIID: D2DAC477427848E99147B9746D864345-20240707-155657-1
From: Hillf Danton <hdanton@sina.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Sun,  7 Jul 2024 15:56:44 +0800
Message-Id: <20240707075644.752-1-hdanton@sina.com>
In-Reply-To: <20240705110218.GA1616@breakpoint.cc>
References: 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 5 Jul 2024 13:02:18 +0200 Florian Westphal <fw@strlen.de>
> Hillf Danton <hdanton@sina.com> wrote:
> > > 				lock trans mutex returns
> > >   				flush work
> > >   				free A
> > >   				unlock trans mutex
> > > 
> > If your patch is correct, it should survive a warning.
> > 
> > #syz test https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git  1c5fc27bc48a
> > 
> > --- x/net/netfilter/nf_tables_api.c
> > +++ y/net/netfilter/nf_tables_api.c
> > @@ -11552,9 +11552,10 @@ static int nft_rcv_nl_event(struct notif
> >  
> >  	gc_seq = nft_gc_seq_begin(nft_net);
> >  
> > -	if (!list_empty(&nf_tables_destroy_list))
> > -		nf_tables_trans_destroy_flush_work();
> > +	nf_tables_trans_destroy_flush_work();
> >  again:
> > +	WARN_ON(!list_empty(&nft_net->commit_list));
> > +
> 
> You could officially submit this patch to nf-next, this
> is a slow path and the transaction list must be empty here.
> 
> I think this change might be useful as it also documents
> this requirement.

Yes it is boy and the current reproducer triggered another warning [1,2].

[1] https://lore.kernel.org/lkml/20240706231332.3261-1-hdanton@sina.com/
[2] https://lore.kernel.org/lkml/000000000000a42289061c9d452e@google.com/

And feel free to take a look at fput() and sock_put() for instance of
freeing slab pieces asyncally.
