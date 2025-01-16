Received: from mail.netfilter.org (unknown [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F06153808;
	Thu, 16 Jan 2025 17:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047963; cv=none; b=fCYTJMPptQwKWwBWwMg2wNgItBgJe+nJKJllQdQLEVBk6O3fh/hs+g8pyK1NHb7/KeG9Ul5ODX4qB34Av7MCPHEsmFYduj+zl2Fon3e8ohMlEOsrWvob0SGrTuBru/4aWxl4WILi7I+KGOf4rOJwbaCuGVZ6P2ooVRjlYaSETtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047963; c=relaxed/simple;
	bh=YCUIgTXnZXL17oryx4O46qWOfHe2x1XhubsaVrXO574=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XEqBqg7s4Sc7wacUOHueVCZzg9WoGiSKOmcUbH3uBqAbZqXaJ7YgN13n76IYMCSDBHaJ0e6rqnhSo4qtkKf9rMYHY4aGE7PmHLYRJ1G2dm2PFxWPQ0DgBmoKnZ6hzHpdtG0AUns9m6FrB7akZ7nJrbHC+cZzj64urPHcZxTrWqM=
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
Subject: [PATCH net-next 03/14] netfilter: nf_tables: Flowtable hook's pf value never varies
Date: Thu, 16 Jan 2025 18:18:51 +0100
Message-Id: <20250116171902.1783620-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250116171902.1783620-1-pablo@netfilter.org>
References: <20250116171902.1783620-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

When checking for duplicate hooks in nft_register_flowtable_net_hooks(),
comparing ops.pf value is pointless as it is always NFPROTO_NETDEV with
flowtable hooks.

Dropping the check leaves the search identical to the one in
nft_hook_list_find() so call that function instead of open coding.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index de9c4335ef47..e41c77e5eefd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8895,7 +8895,7 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 					    struct list_head *hook_list,
 					    struct nft_flowtable *flowtable)
 {
-	struct nft_hook *hook, *hook2, *next;
+	struct nft_hook *hook, *next;
 	struct nft_flowtable *ft;
 	int err, i = 0;
 
@@ -8904,12 +8904,9 @@ static int nft_register_flowtable_net_hooks(struct net *net,
 			if (!nft_is_active_next(net, ft))
 				continue;
 
-			list_for_each_entry(hook2, &ft->hook_list, list) {
-				if (hook->ops.dev == hook2->ops.dev &&
-				    hook->ops.pf == hook2->ops.pf) {
-					err = -EEXIST;
-					goto err_unregister_net_hooks;
-				}
+			if (nft_hook_list_find(&ft->hook_list, hook)) {
+				err = -EEXIST;
+				goto err_unregister_net_hooks;
 			}
 		}
 
-- 
2.30.2

