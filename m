Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CE31DFE1;
	Tue,  2 Jul 2024 14:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719930619; cv=none; b=LZyTtfcpnXy/9Ejyn0JH4oVIFRJuMFK535fDCz1TB7A5zqCM21PXPW6J91AwcY1EOVepydQPmCY96OqakiwRblFkIvhESM3lplkvKVbi/ck1AQXPu96QEaRd4UJxjHTo4fMeES2URSMoODc6Fv5j1F3xBqEgHdAYrDKHuxV1Yh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719930619; c=relaxed/simple;
	bh=T3DWqD+Ol1/VNz18zDmIpBFqHT4hlrXFgHlH4ruVB2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJd9eJaJ/F81l5Lr16+EHPWDNejPin5Adg0oElg/lSuxkoeDnOTdyrhhc9xB8/DQJv0fD/MFljj504dCBCdb7dtKH0BaOrrGT2jthl38q379/qb7lIV4tsnqSwAbnSyxGO/O56aYUYr08vgqHKagGNMO1i3RKpnVv7RZxOaQqwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sOeWN-0008BV-L4; Tue, 02 Jul 2024 16:30:15 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org,
	<netdev@vger.kernel.org>,
	syzkaller-bugs@googlegroups.com,
	Florian Westphal <fw@strlen.de>,
	syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Subject: [PATCH nf] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Tue,  2 Jul 2024 16:08:14 +0200
Message-ID: <20240702140841.3337-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
In-Reply-To: <000000000000aa1dbb061c354fe6@google.com>
References: <000000000000aa1dbb061c354fe6@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reports:

KASAN: slab-uaf in nft_ctx_update include/net/netfilter/nf_tables.h:1831
KASAN: slab-uaf in nft_commit_release net/netfilter/nf_tables_api.c:9530
KASAN: slab-uaf int nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45
[..]
Workqueue: events nf_tables_trans_destroy_work
Call Trace:
 nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
 nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
 nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597

Problem is that the notifier does a conditional flush, but its possible
that the table-to-be-removed is still referenced by transactions being
processed by the worker, so we need to flush unconditionally.

We could make the flush_work depend on whether we found a table to delete
in nf-next to avoid the flush for most cases.

AFAICS this problem is only exposed in nf-next, with
commit e169285f8c56 ("netfilter: nf_tables: do not store nft_ctx in transaction objects"),
with this commit applied there is an unconditional fetch of
table->family which is whats triggering the above splat.

Fixes: 2c9f0293280e ("netfilter: nf_tables: flush pending destroy work before netlink notifier")
Reported-and-tested-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4fd66a69358fc15ae2ad
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 02d75aefaa8e..683f6a4518ee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11552,8 +11552,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nf_tables_destroy_list))
-		nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.44.2

