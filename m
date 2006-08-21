From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 18/18]: xt_tcpmss: minor cleanups
Date: Tue, 22 Aug 2006 00:52:43 +0200 (MEST)
Message-ID: <20060821225242.10288.3510.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: xt_tcpmss: minor cleanups

- remove unused define
- remove useless wrapper function
- use new line for expression after condition

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 3a498d6f9d66f93f9afbf00f552eaf817b404d78
tree d4cb9b42cc0a4faa611c301bab2e0c2f331d86ee
parent e60478517acbd24f288c0d579adaea625c3419fb
author Patrick McHardy <kaber@trash.net> Tue, 22 Aug 2006 00:36:46 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 22 Aug 2006 00:36:46 +0200

 net/netfilter/xt_tcpmss.c |   48 +++++++++++++++++----------------------------
 1 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 7baa9eb..a3682fe 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -18,21 +18,22 @@ #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
-#define TH_SYN 0x02
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables TCP MSS match module");
 MODULE_ALIAS("ipt_tcpmss");
 
-/* Returns 1 if the mss option is set and matched by the range, 0 otherwise */
-static inline int
-mssoption_match(u_int16_t min, u_int16_t max,
-		const struct sk_buff *skb,
-		unsigned int protoff,
-		int invert,
-		int *hotdrop)
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const struct xt_match *match,
+      const void *matchinfo,
+      int offset,
+      unsigned int protoff,
+      int *hotdrop)
 {
+	const struct xt_tcpmss_match_info *info = matchinfo;
 	struct tcphdr _tcph, *th;
 	/* tcp.doff is only 4 bits, ie. max 15 * 4 bytes */
 	u8 _opt[15 * 4 - sizeof(_tcph)], *op;
@@ -64,35 +65,22 @@ mssoption_match(u_int16_t min, u_int16_t
 
 			mssval = (op[i+2] << 8) | op[i+3];
 			
-			return (mssval >= min && mssval <= max) ^ invert;
+			return (mssval >= info->mss_min &&
+			        mssval <= info->mss_max) ^ info->invert;
 		}
-		if (op[i] < 2) i++;
-		else i += op[i+1]?:1;
+		if (op[i] < 2)
+			i++;
+		else
+			i += op[i+1] ? : 1;
 	}
 out:
-	return invert;
+	return info->invert;
 
- dropit:
+dropit:
 	*hotdrop = 1;
 	return 0;
 }
 
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const struct xt_match *match,
-      const void *matchinfo,
-      int offset,
-      unsigned int protoff,
-      int *hotdrop)
-{
-	const struct xt_tcpmss_match_info *info = matchinfo;
-
-	return mssoption_match(info->mss_min, info->mss_max, skb, protoff,
-			       info->invert, hotdrop);
-}
-
 static struct xt_match xt_tcpmss_match[] = {
 	{
 		.name		= "tcpmss",
