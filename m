From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 079/123] netfilter: nf_conncount: remove wrong condition check routine
Date: Wed,  5 Dec 2018 04:35:11 -0500
Message-ID: <20181205093555.5386-79-sashal@kernel.org>
References: <20181205093555.5386-1-sashal@kernel.org>
Cc: Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181205093555.5386-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 53ca0f2fec39c80ccd19e6e3f30cc8daef174b70 ]

All lists that reach the tree_nodes_free() function have both zero
counter and true dead flag. The reason for this is that lists to be
release are selected by nf_conncount_gc_list() which already decrements
the list counter and sets on the dead flag. Therefore, this if statement
in tree_nodes_free() is unnecessary and wrong.

Fixes: 31568ec09ea0 ("netfilter: nf_conncount: fix list_del corruption in conn_free")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 8acae4a3e4c0..b6d0f6deea86 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -323,11 +323,8 @@ static void tree_nodes_free(struct rb_root *root,
 	while (gc_count) {
 		rbconn = gc_nodes[--gc_count];
 		spin_lock(&rbconn->list.list_lock);
-		if (rbconn->list.count == 0 && rbconn->list.dead == false) {
-			rbconn->list.dead = true;
-			rb_erase(&rbconn->node, root);
-			call_rcu(&rbconn->rcu_head, __tree_nodes_free);
-		}
+		rb_erase(&rbconn->node, root);
+		call_rcu(&rbconn->rcu_head, __tree_nodes_free);
 		spin_unlock(&rbconn->list.list_lock);
 	}
 }
-- 
2.17.1
