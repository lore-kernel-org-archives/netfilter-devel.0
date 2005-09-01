From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 10/10] add nf_conntrack support to conntrack
 match
Date: Thu, 01 Sep 2005 18:15:17 +0900 (JST)
Message-ID: <200509010915.j819FIBh006683@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_15_17_2005_084)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Sep__1_18_15_17_2005_084)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_15_17_2005_084)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="10-conntrack.patch"

[NETFILTER] add nf_conntrack support to conntrack match

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 2e7803033b677db0c08571d64ef5a0b526c64ecc
tree 20d360c55ab1d5b34d006c4f076ccf0be448b0a8
parent 753286b105158ef80e495f76201201834e62d843
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 04:09:24 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 04:09:24 +0900

 net/ipv4/netfilter/Kconfig         |    3 +
 net/ipv4/netfilter/ipt_conntrack.c |   96 ++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -294,7 +294,8 @@ config IP_NF_MATCH_STATE
 
 config IP_NF_MATCH_CONNTRACK
 	tristate "Connection tracking match support"
-	depends on IP_NF_CONNTRACK && IP_NF_IPTABLES
+	depends on IP_NF_IPTABLES
+	depends on IP_NF_CONNTRACK || NF_CONNTRACK_IPV4
 	help
 	  This is a general conntrack match module, a superset of the state match.
 
diff --git a/net/ipv4/netfilter/ipt_conntrack.c b/net/ipv4/netfilter/ipt_conntrack.c
--- a/net/ipv4/netfilter/ipt_conntrack.c
+++ b/net/ipv4/netfilter/ipt_conntrack.c
@@ -10,7 +10,14 @@
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
+
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#else
+#include <linux/netfilter/nf_conntrack.h>
+#endif
+
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_conntrack.h>
 
@@ -18,6 +25,8 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
 MODULE_DESCRIPTION("iptables connection tracking match module");
 
+#if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -102,6 +111,93 @@ match(const struct sk_buff *skb,
 	return 1;
 }
 
+#else /* CONFIG_IP_NF_CONNTRACK */
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      int *hotdrop)
+{
+	const struct ipt_conntrack_info *sinfo = matchinfo;
+	struct nf_conn *ct;
+	enum ip_conntrack_info ctinfo;
+	unsigned int statebit;
+
+	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+
+#define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
+
+	if (ct == &nf_conntrack_untracked)
+		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct)
+ 		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
+ 	else
+ 		statebit = IPT_CONNTRACK_STATE_INVALID;
+ 
+	if(sinfo->flags & IPT_CONNTRACK_STATE) {
+		if (ct) {
+			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip !=
+			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip)
+				statebit |= IPT_CONNTRACK_STATE_SNAT;
+
+			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip !=
+			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip)
+				statebit |= IPT_CONNTRACK_STATE_DNAT;
+		}
+
+		if (FWINV((statebit & sinfo->statemask) == 0, IPT_CONNTRACK_STATE))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_PROTO) {
+		if (!ct || FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, IPT_CONNTRACK_PROTO))
+                	return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_ORIGDST) {
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u3.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
+		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_STATUS) {
+		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0, IPT_CONNTRACK_STATUS))
+			return 0;
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_EXPIRES) {
+		unsigned long expires;
+
+		if(!ct)
+			return 0;
+
+		expires = timer_pending(&ct->timeout) ? (ct->timeout.expires - jiffies)/HZ : 0;
+
+		if (FWINV(!(expires >= sinfo->expires_min && expires <= sinfo->expires_max), IPT_CONNTRACK_EXPIRES))
+			return 0;
+	}
+
+	return 1;
+}
+
+#endif /* CONFIG_NF_IP_CONNTRACK */
+
 static int check(const char *tablename,
 		 const struct ipt_ip *ip,
 		 void *matchinfo,

----Next_Part(Thu_Sep__1_18_15_17_2005_084)----
