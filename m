From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 22/22] netfilter: fix the warning on unused refcount variable
Date: Mon, 20 Mar 2017 11:08:50 +0100
Message-ID: <1490004530-9128-23-git-send-email-pablo@netfilter.org>
References: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1490004530-9128-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Reshetova, Elena" <elena.reshetova@intel.com>

net/netfilter/nfnetlink_acct.c: In function 'nfnl_acct_try_del':
net/netfilter/nfnetlink_acct.c:329:15: warning: unused variable 'refcount' [-Wunused-variable]
unsigned int refcount;
             ^

Fixes: b54ab92b84b6 ("netfilter: refcounter conversions")
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_acct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index f44cbd35357f..c86da174a5fc 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -326,7 +326,6 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
-	unsigned int refcount;
 
 	/* We want to avoid races with nfnl_acct_put. So only when the current
 	 * refcnt is 1, we decrease it to 0.
-- 
2.1.4
