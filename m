Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE411AF4F3;
	Thu, 26 Sep 2024 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348858; cv=none; b=MyJBfqhy+igS76a/G/sXBrLYqF63189OJFMacjoY7SENyxsRjxZ3cxHNJJLf61PpwhxbydSeaD7Ax3L93fhd4xhZyh2gjyirmDjb5Enmoc8uTLnn8LI+qx8QYg2drLMoS+MFHiSq9kLbd4aPqZ00i16AuR2dv/uVHg/2wyzhtU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348858; c=relaxed/simple;
	bh=sCWwNCFKtnxwvMe4XKLynhsxhNZs7Z8kEBkeVQ9aFCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RBElKz7QVxS+tfYIK/XWI5exDqljS53eZzS3L9nCCtiWGa37DTLEI0Bfy4X1V2V9Cu0UeLymXTAZafKP7AZc0PEJO1iz2zrjN0iBYkZvTTj5DRxrgoKH4OyziX0f41/TPnRJ++Ydt9RF6vsmTGjjYWkg5o9TMjM0Vy6J0iG+yHo=
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
Subject: [PATCH net 07/14] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Thu, 26 Sep 2024 13:07:10 +0200
Message-Id: <20240926110717.102194-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240926110717.102194-1-pablo@netfilter.org>
References: <20240926110717.102194-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

Documentation of list_del_rcu() warns callers to not immediately free
the deleted list item. While it seems not necessary to use the
RCU-variant of list_del() here in the first place, doing so seems to
require calling kfree_rcu() on the deleted item as well.

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 57259b5f3ef5..042080aeb46c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9207,7 +9207,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
-		kfree(hook);
+		kfree_rcu(hook, rcu);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.30.2

