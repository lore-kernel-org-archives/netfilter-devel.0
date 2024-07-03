Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EEAC191F80;
	Wed,  3 Jul 2024 22:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720046003; cv=none; b=TOZ0BoHMiCxO4l46URmFU96/1OIJBexnO6D7xvJzw59lzP3hUB7f5Mk2xMdL0+C+7lFHrVJ/qLhR/oH7sKLc/BEkYU6kPb3gGER04lEh8mGwb1dmC3EysZQdoVjYmcoEsHAtIj4YifkFCaCbLJktRwelZTla+K0IoQKg2gtACzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720046003; c=relaxed/simple;
	bh=n4g3BYjzp2KjDlb6miScUM14X5byqZbF5D/nbWh7wLs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qwrS7mmt/xZ7syOn7H9KAgB7DbqYxPl5QQlk7jVu3EzqRDzNkLyTHrNJPA+4LUEJBIgQsHkOrRffaedqqAGRs2qMI0YLZG9GOHCycswk/mKDA5UVoVXNGzEJNW46TtxAZJoMAZqquDsCgomMFSdaNnxYNmp5WaAHP/Hs+mSX910=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 1/1] netfilter: nf_tables: unconditionally flush pending work before notifier
Date: Thu,  4 Jul 2024 00:33:04 +0200
Message-Id: <20240703223304.1455-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240703223304.1455-1-pablo@netfilter.org>
References: <20240703223304.1455-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e8dcf41d360d..081c08536d0f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11483,8 +11483,7 @@ static int nft_rcv_nl_event(struct notifier_block *this, unsigned long event,
 
 	gc_seq = nft_gc_seq_begin(nft_net);
 
-	if (!list_empty(&nf_tables_destroy_list))
-		nf_tables_trans_destroy_flush_work();
+	nf_tables_trans_destroy_flush_work();
 again:
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (nft_table_has_owner(table) &&
-- 
2.30.2

