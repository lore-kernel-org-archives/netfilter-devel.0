From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/53] ipvs: remove unused variable
Date: Mon,  1 May 2017 12:46:30 +0200
Message-ID: <1493635640-24325-4-git-send-email-pablo@netfilter.org>
References: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1493635640-24325-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Arushi Singhal <arushisinghal19971997@gmail.com>

This patch uses the following coccinelle script to remove
a variable that was simply used to store the return
value of a function call before returning it:

@@
identifier len,f;
@@

-int len;
 ... when != len
     when strict
-len =
+return
        f(...);
-return len;

Signed-off-by: Arushi Singhal <arushisinghal19971997@gmail.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 2e2bf7428cd1..6caf4459e981 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -482,11 +482,8 @@ static struct pernet_operations ip_vs_ftp_ops = {
 
 static int __init ip_vs_ftp_init(void)
 {
-	int rv;
-
-	rv = register_pernet_subsys(&ip_vs_ftp_ops);
 	/* rcu_barrier() is called by netns on error */
-	return rv;
+	return register_pernet_subsys(&ip_vs_ftp_ops);
 }
 
 /*
-- 
2.1.4
