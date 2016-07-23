From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 23/25] netfilter: h323: Use mod_timer instead of set_expect_timeout
Date: Sat, 23 Jul 2016 13:08:37 +0200
Message-ID: <1469272119-29942-24-git-send-email-pablo@netfilter.org>
References: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Gao Feng <fgao@ikuai8.com>

Simplify the code without any side effect. The set_expect_timeout is
used to modify the timer expired time.  It tries to delete timer, and
add it again.  So we could use mod_timer directly.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_h323_main.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 9511af0..bb77a97 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -1273,19 +1273,6 @@ static struct nf_conntrack_expect *find_expect(struct nf_conn *ct,
 }
 
 /****************************************************************************/
-static int set_expect_timeout(struct nf_conntrack_expect *exp,
-			      unsigned int timeout)
-{
-	if (!exp || !del_timer(&exp->timeout))
-		return 0;
-
-	exp->timeout.expires = jiffies + timeout * HZ;
-	add_timer(&exp->timeout);
-
-	return 1;
-}
-
-/****************************************************************************/
 static int expect_q931(struct sk_buff *skb, struct nf_conn *ct,
 		       enum ip_conntrack_info ctinfo,
 		       unsigned int protoff, unsigned char **data,
@@ -1486,7 +1473,7 @@ static int process_rcf(struct sk_buff *skb, struct nf_conn *ct,
 				 "timeout to %u seconds for",
 				 info->timeout);
 			nf_ct_dump_tuple(&exp->tuple);
-			set_expect_timeout(exp, info->timeout);
+			mod_timer(&exp->timeout, jiffies + info->timeout * HZ);
 		}
 		spin_unlock_bh(&nf_conntrack_expect_lock);
 	}
-- 
2.1.4
