From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 14/23] netfilter: ipvs: Use %pS printk format for direct addresses
Date: Tue,  7 Nov 2017 01:52:04 +0100
Message-ID: <20171107005213.22618-15-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Helge Deller <deller@gmx.de>

The debug and error printk functions in ipvs uses wrongly the %pF instead of
the %pS printk format specifier for printing symbols for the address returned
by _builtin_return_address(0). Fix it for the ia64, ppc64 and parisc64
architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: netdev@vger.kernel.org
Cc: lvs-devel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 2 +-
 net/netfilter/ipvs/ip_vs_ctl.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 3d2ac71a83ec..f73561ca982d 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -185,7 +185,7 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 		hlist_add_head_rcu(&cp->c_list, &ip_vs_conn_tab[hash]);
 		ret = 1;
 	} else {
-		pr_err("%s(): request for already hashed, called from %pF\n",
+		pr_err("%s(): request for already hashed, called from %pS\n",
 		       __func__, __builtin_return_address(0));
 		ret = 0;
 	}
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 4f940d7eb2f7..b825835752e6 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -300,7 +300,7 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
 	unsigned int hash;
 
 	if (svc->flags & IP_VS_SVC_F_HASHED) {
-		pr_err("%s(): request for already hashed, called from %pF\n",
+		pr_err("%s(): request for already hashed, called from %pS\n",
 		       __func__, __builtin_return_address(0));
 		return 0;
 	}
@@ -334,7 +334,7 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
 static int ip_vs_svc_unhash(struct ip_vs_service *svc)
 {
 	if (!(svc->flags & IP_VS_SVC_F_HASHED)) {
-		pr_err("%s(): request for unhash flagged, called from %pF\n",
+		pr_err("%s(): request for unhash flagged, called from %pS\n",
 		       __func__, __builtin_return_address(0));
 		return 0;
 	}
-- 
2.11.0
