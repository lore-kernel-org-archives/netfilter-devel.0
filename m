Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083CF156C6;
	Fri, 22 Dec 2023 10:42:17 +0000 (UTC)
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
Subject: [PATCH net 2/2] netfilter: nf_tables: skip set commit for deleted/destroyed sets
Date: Fri, 22 Dec 2023 11:42:05 +0100
Message-Id: <20231222104205.354606-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231222104205.354606-1-pablo@netfilter.org>
References: <20231222104205.354606-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NFT_MSG_DELSET deactivates all elements in the set, skip
set->ops->commit() to avoid the unnecessary clone (for the pipapo case)
as well as the sync GC cycle, which could deactivate again expired
elements in such set.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5c17c6e80ed..be04af433988 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9887,7 +9887,7 @@ static void nft_set_commit_update(struct list_head *set_update_list)
 	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
 
-		if (!set->ops->commit)
+		if (!set->ops->commit || set->dead)
 			continue;
 
 		set->ops->commit(set);
-- 
2.30.2

