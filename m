From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 7/9]: Fix NAT sequence number adjustment
Date: Mon, 23 May 2005 15:20:24 +0900 (JST)
Message-ID: <200505230620.j4N6KOHq000985@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_May_23_15:20:24_2005_272)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

----Next_Part(Mon_May_23_15:20:24_2005_272)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This patch follows the recent changes to ip_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

===========

    [NETFILTER]: Fix NAT sequence number adjustment

    The NAT changes in 2.6.11 changed the position where helpers
    are called and perform packet mangling. Before 2.6.11, a NAT
    helper was called before the packet was NATed and had its
    sequence number adjusted. Since 2.6.11, the helpers get packets
    with already adjusted sequence numbers.

    This breaks sequence number adjustment, adjust_tcp_sequence()
    needs the original sequence number to determine whether
    a packet was a retransmission and to store it for further
    corrections. It can't be reconstructed without more information
    than available, so this patch restores the old order by
    calling helpers from a new conntrack hook two priorities
    below ip_conntrack_confirm() and adjusting the sequence number
    from a new NAT hook one priority below ip_conntrack_confirm().

    Tracked down by Phil Oester <kernel@linuxace.com>

    Signed-off-by: Patrick McHardy <kaber@trash.net>
    Signed-off-by: David S. Miller <davem@davemloft.net>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Mon_May_23_15:20:24_2005_272)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="07-nat-seq.patch"

diff -Nur linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c linux-2.6.12-rc4-nfct-7-nat-seq/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- linux-2.6.12-rc4-nfct-6-drop-ref6/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-19 20:46:33.000000000 +0900
+++ linux-2.6.12-rc4-nfct-7-nat-seq/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-05-20 03:17:51.000000000 +0900
@@ -154,6 +154,16 @@
 				 const struct net_device *out,
 				 int (*okfn)(struct sk_buff *))
 {
+	/* We've seen it coming out the other side: confirm it */
+	return nf_conntrack_confirm(pskb);
+}
+
+static unsigned int ipv4_conntrack_help(unsigned int hooknum,
+				      struct sk_buff **pskb,
+				      const struct net_device *in,
+				      const struct net_device *out,
+				      int (*okfn)(struct sk_buff *))
+{
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 
@@ -168,10 +178,7 @@
 		if (ret != NF_ACCEPT)
 			return ret;
 	}
-
-	/* We've seen it coming out the other side: confirm it */
-
-	return nf_conntrack_confirm(pskb);
+	return NF_ACCEPT;
 }
 
 static unsigned int ipv4_conntrack_defrag(unsigned int hooknum,
@@ -275,13 +282,31 @@
 	.priority	= NF_IP_PRI_CONNTRACK,
 };
 
+/* helpers */
+static struct nf_hook_ops ipv4_conntrack_helper_out_ops = {
+	.hook		= ipv4_conntrack_help,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+};
+
+static struct nf_hook_ops ipv4_conntrack_helper_in_ops = {
+	.hook		= ipv4_conntrack_help,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+};
+
+
 /* Refragmenter; last chance. */
 static struct nf_hook_ops ipv4_conntrack_out_ops = {
 	.hook		= ipv4_refrag,
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_LAST,
+	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 };
 
 static struct nf_hook_ops ipv4_conntrack_local_in_ops = {
@@ -289,7 +314,7 @@
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_LAST-1,
+	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 };
 
 #ifdef CONFIG_SYSCTL
@@ -467,10 +492,22 @@
 		goto cleanup_inops;
 	}
 
+	ret = nf_register_hook(&ipv4_conntrack_helper_in_ops);
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't register local helper hook.\n");
+		goto cleanup_inandlocalops;
+	}
+
+	ret = nf_register_hook(&ipv4_conntrack_helper_out_ops);
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't register postrouting helper hook.\n");
+		goto cleanup_helperinops;
+	}
+
 	ret = nf_register_hook(&ipv4_conntrack_out_ops);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register post-routing hook.\n");
-		goto cleanup_inandlocalops;
+		goto cleanup_helperoutops;
 	}
 
 	ret = nf_register_hook(&ipv4_conntrack_local_in_ops);
@@ -502,6 +539,10 @@
 	nf_unregister_hook(&ipv4_conntrack_local_in_ops);
  cleanup_inoutandlocalops:
 	nf_unregister_hook(&ipv4_conntrack_out_ops);
+ cleanup_helperoutops:
+	nf_unregister_hook(&ipv4_conntrack_helper_out_ops);
+ cleanup_helperinops:
+	nf_unregister_hook(&ipv4_conntrack_helper_in_ops);
  cleanup_inandlocalops:
 	nf_unregister_hook(&ipv4_conntrack_local_out_ops);
  cleanup_inops:

----Next_Part(Mon_May_23_15:20:24_2005_272)----
