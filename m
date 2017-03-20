From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH] netfilter: fix the warning on unused refcount variable
Date: Mon, 20 Mar 2017 11:43:28 +0200
Message-ID: <1490003008-17443-1-git-send-email-elena.reshetova@intel.com>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, Elena Reshetova <elena.reshetova@intel.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 net/netfilter/nfnetlink_acct.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index f44cbd3..c86da17 100644
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
2.7.4
