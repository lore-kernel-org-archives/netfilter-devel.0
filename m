From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/07: netns: use NFPROTO_NUMPROTO instead of NUMPROTO for tables array
Date: Mon, 20 Oct 2008 11:54:11 +0200 (MEST)
Message-ID: <20081020095411.25670.22073.sendpatchset@x2.localnet>
References: <20081020095408.25670.37455.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081020095408.25670.37455.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 40ebc9cf6a56fef77d064b901e896207d7110db3
Author: Patrick McHardy <kaber@trash.net>
Date:   Sat Oct 18 15:20:56 2008 +0200

    netfilter: netns: use NFPROTO_NUMPROTO instead of NUMPROTO for tables array
    
    The netfilter families have been decoupled from regular protocol families.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netns/x_tables.h b/include/net/netns/x_tables.h
index 0cb63ed..b809397 100644
--- a/include/net/netns/x_tables.h
+++ b/include/net/netns/x_tables.h
@@ -2,9 +2,9 @@
 #define __NETNS_X_TABLES_H
 
 #include <linux/list.h>
-#include <linux/net.h>
+#include <linux/netfilter.h>
 
 struct netns_xt {
-	struct list_head tables[NPROTO];
+	struct list_head tables[NFPROTO_NUMPROTO];
 };
 #endif
