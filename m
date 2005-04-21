From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix NAT sequence number adjustment
Date: Fri, 22 Apr 2005 00:55:48 +0200
Message-ID: <42682F74.9030203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020806050600040909000601"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------020806050600040909000601
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

another important fix which should go in 2.6.12 if possible.
NAT sequence number adjustment is broken since 2.6.11, quite
a few people have reported failing and corrupted FTP control
connections.


--------------020806050600040909000601
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/04/22 00:52:27+02:00 kaber@coreworks.de 
#   [NETFILTER]: Fix NAT sequence number adjustment
#   
#   The NAT changes in 2.6.11 changed the position where helpers
#   are called and perform packet mangling. Before 2.6.11, a NAT
#   helper was called before the packet was NATed and had its
#   sequence number adjusted. Since 2.6.11, the helpers get packets
#   with already adjusted sequence numbers.
#   
#   This breaks sequence number adjustment, adjust_tcp_sequence()
#   needs the original sequence number to determine whether
#   a packet was a retransmission and to store it for further
#   corrections. It can't be reconstructed without more information
#   than available, so this patch restores the old order by
#   calling helpers from a new conntrack hook two priorities
#   below ip_conntrack_confirm() and adjusting the sequence number
#   from a new NAT hook one priority below ip_conntrack_confirm().
#   
#   Tracked down by Phil Oester <kernel@linuxace.com>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_standalone.c
#   2005/04/22 00:52:19+02:00 kaber@coreworks.de +53 -1
#   [NETFILTER]: Fix NAT sequence number adjustment
#   
#   The NAT changes in 2.6.11 changed the position where helpers
#   are called and perform packet mangling. Before 2.6.11, a NAT
#   helper was called before the packet was NATed and had its
#   sequence number adjusted. Since 2.6.11, the helpers get packets
#   with already adjusted sequence numbers.
#   
#   This breaks sequence number adjustment, adjust_tcp_sequence()
#   needs the original sequence number to determine whether
#   a packet was a retransmission and to store it for further
#   corrections. It can't be reconstructed without more information
#   than available, so this patch restores the old order by
#   calling helpers from a new conntrack hook two priorities
#   below ip_conntrack_confirm() and adjusting the sequence number
#   from a new NAT hook one priority below ip_conntrack_confirm().
#   
#   Tracked down by Phil Oester <kernel@linuxace.com>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_nat_core.c
#   2005/04/22 00:52:19+02:00 kaber@coreworks.de +0 -9
#   [NETFILTER]: Fix NAT sequence number adjustment
#   
#   The NAT changes in 2.6.11 changed the position where helpers
#   are called and perform packet mangling. Before 2.6.11, a NAT
#   helper was called before the packet was NATed and had its
#   sequence number adjusted. Since 2.6.11, the helpers get packets
#   with already adjusted sequence numbers.
#   
#   This breaks sequence number adjustment, adjust_tcp_sequence()
#   needs the original sequence number to determine whether
#   a packet was a retransmission and to store it for further
#   corrections. It can't be reconstructed without more information
#   than available, so this patch restores the old order by
#   calling helpers from a new conntrack hook two priorities
#   below ip_conntrack_confirm() and adjusting the sequence number
#   from a new NAT hook one priority below ip_conntrack_confirm().
#   
#   Tracked down by Phil Oester <kernel@linuxace.com>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_standalone.c
#   2005/04/22 00:52:19+02:00 kaber@coreworks.de +45 -6
#   [NETFILTER]: Fix NAT sequence number adjustment
#   
#   The NAT changes in 2.6.11 changed the position where helpers
#   are called and perform packet mangling. Before 2.6.11, a NAT
#   helper was called before the packet was NATed and had its
#   sequence number adjusted. Since 2.6.11, the helpers get packets
#   with already adjusted sequence numbers.
#   
#   This breaks sequence number adjustment, adjust_tcp_sequence()
#   needs the original sequence number to determine whether
#   a packet was a retransmission and to store it for further
#   corrections. It can't be reconstructed without more information
#   than available, so this patch restores the old order by
#   calling helpers from a new conntrack hook two priorities
#   below ip_conntrack_confirm() and adjusting the sequence number
#   from a new NAT hook one priority below ip_conntrack_confirm().
#   
#   Tracked down by Phil Oester <kernel@linuxace.com>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# include/linux/netfilter_ipv4.h
#   2005/04/22 00:52:19+02:00 kaber@coreworks.de +3 -0
#   [NETFILTER]: Fix NAT sequence number adjustment
#   
#   The NAT changes in 2.6.11 changed the position where helpers
#   are called and perform packet mangling. Before 2.6.11, a NAT
#   helper was called before the packet was NATed and had its
#   sequence number adjusted. Since 2.6.11, the helpers get packets
#   with already adjusted sequence numbers.
#   
#   This breaks sequence number adjustment, adjust_tcp_sequence()
#   needs the original sequence number to determine whether
#   a packet was a retransmission and to store it for further
#   corrections. It can't be reconstructed without more information
#   than available, so this patch restores the old order by
#   calling helpers from a new conntrack hook two priorities
#   below ip_conntrack_confirm() and adjusting the sequence number
#   from a new NAT hook one priority below ip_conntrack_confirm().
#   
#   Tracked down by Phil Oester <kernel@linuxace.com>
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
--- a/include/linux/netfilter_ipv4.h	2005-04-22 00:52:48 +02:00
+++ b/include/linux/netfilter_ipv4.h	2005-04-22 00:52:48 +02:00
@@ -62,6 +62,9 @@
 	NF_IP_PRI_FILTER = 0,
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
+	NF_IP_PRI_CONNTRACK_HELPER = INT_MAX - 2,
+	NF_IP_PRI_NAT_SEQ_ADJUST = INT_MAX - 1,
+	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
 	NF_IP_PRI_LAST = INT_MAX,
 };
 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
--- a/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-22 00:52:48 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-04-22 00:52:48 +02:00
@@ -401,6 +401,16 @@
 			       const struct net_device *out,
 			       int (*okfn)(struct sk_buff *))
 {
+	/* We've seen it coming out the other side: confirm it */
+	return ip_conntrack_confirm(pskb);
+}
+
+static unsigned int ip_conntrack_help(unsigned int hooknum,
+				      struct sk_buff **pskb,
+				      const struct net_device *in,
+				      const struct net_device *out,
+				      int (*okfn)(struct sk_buff *))
+{
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 
@@ -412,9 +422,7 @@
 		if (ret != NF_ACCEPT)
 			return ret;
 	}
-
-	/* We've seen it coming out the other side: confirm it */
-	return ip_conntrack_confirm(pskb);
+	return NF_ACCEPT;
 }
 
 static unsigned int ip_conntrack_defrag(unsigned int hooknum,
@@ -516,13 +524,30 @@
 	.priority	= NF_IP_PRI_CONNTRACK,
 };
 
+/* helpers */
+static struct nf_hook_ops ip_conntrack_helper_out_ops = {
+	.hook		= ip_conntrack_help,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+};
+
+static struct nf_hook_ops ip_conntrack_helper_in_ops = {
+	.hook		= ip_conntrack_help,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_CONNTRACK_HELPER,
+};
+
 /* Refragmenter; last chance. */
 static struct nf_hook_ops ip_conntrack_out_ops = {
 	.hook		= ip_refrag,
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_POST_ROUTING,
-	.priority	= NF_IP_PRI_LAST,
+	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 };
 
 static struct nf_hook_ops ip_conntrack_local_in_ops = {
@@ -530,7 +555,7 @@
 	.owner		= THIS_MODULE,
 	.pf		= PF_INET,
 	.hooknum	= NF_IP_LOCAL_IN,
-	.priority	= NF_IP_PRI_LAST-1,
+	.priority	= NF_IP_PRI_CONNTRACK_CONFIRM,
 };
 
 /* Sysctl support */
@@ -831,10 +856,20 @@
 		printk("ip_conntrack: can't register local out hook.\n");
 		goto cleanup_inops;
 	}
+	ret = nf_register_hook(&ip_conntrack_helper_in_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register local in helper hook.\n");
+		goto cleanup_inandlocalops;
+	}
+	ret = nf_register_hook(&ip_conntrack_helper_out_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register postrouting helper hook.\n");
+		goto cleanup_helperinops;
+	}
 	ret = nf_register_hook(&ip_conntrack_out_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register post-routing hook.\n");
-		goto cleanup_inandlocalops;
+		goto cleanup_helperoutops;
 	}
 	ret = nf_register_hook(&ip_conntrack_local_in_ops);
 	if (ret < 0) {
@@ -860,6 +895,10 @@
 	nf_unregister_hook(&ip_conntrack_local_in_ops);
  cleanup_inoutandlocalops:
 	nf_unregister_hook(&ip_conntrack_out_ops);
+ cleanup_helperoutops:
+	nf_unregister_hook(&ip_conntrack_helper_out_ops);
+ cleanup_helperinops:
+	nf_unregister_hook(&ip_conntrack_helper_in_ops);
  cleanup_inandlocalops:
 	nf_unregister_hook(&ip_conntrack_local_out_ops);
  cleanup_inops:
diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
--- a/net/ipv4/netfilter/ip_nat_core.c	2005-04-22 00:52:48 +02:00
+++ b/net/ipv4/netfilter/ip_nat_core.c	2005-04-22 00:52:48 +02:00
@@ -356,15 +356,6 @@
 	unsigned long statusbit;
 	enum ip_nat_manip_type mtype = HOOK2MANIP(hooknum);
 
-	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)
-	    && (hooknum == NF_IP_POST_ROUTING || hooknum == NF_IP_LOCAL_IN)) {
-		DEBUGP("ip_nat_core: adjusting sequence number\n");
-		/* future: put this in a l4-proto specific function,
-		 * and call this function here. */
-		if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
-			return NF_DROP;
-	}
-
 	if (mtype == IP_NAT_MANIP_SRC)
 		statusbit = IPS_SRC_NAT;
 	else
diff -Nru a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
--- a/net/ipv4/netfilter/ip_nat_standalone.c	2005-04-22 00:52:48 +02:00
+++ b/net/ipv4/netfilter/ip_nat_standalone.c	2005-04-22 00:52:48 +02:00
@@ -230,6 +230,25 @@
 	return ret;
 }
 
+static unsigned int
+ip_nat_adjust(unsigned int hooknum,
+	      struct sk_buff **pskb,
+	      const struct net_device *in,
+	      const struct net_device *out,
+	      int (*okfn)(struct sk_buff *))
+{
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = ip_conntrack_get(*pskb, &ctinfo);
+	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
+	        DEBUGP("ip_nat_standalone: adjusting sequence number\n");
+	        if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
+	                return NF_DROP;
+	}
+	return NF_ACCEPT;
+}
+
 /* We must be after connection tracking and before packet filtering. */
 
 /* Before packet filtering, change destination */
@@ -250,6 +269,15 @@
 	.priority	= NF_IP_PRI_NAT_SRC,
 };
 
+/* After conntrack, adjust sequence number */
+static struct nf_hook_ops ip_nat_adjust_out_ops = {
+	.hook		= ip_nat_adjust,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_POST_ROUTING,
+	.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+};
+
 /* Before packet filtering, change destination */
 static struct nf_hook_ops ip_nat_local_out_ops = {
 	.hook		= ip_nat_local_fn,
@@ -268,6 +296,16 @@
 	.priority	= NF_IP_PRI_NAT_SRC,
 };
 
+/* After conntrack, adjust sequence number */
+static struct nf_hook_ops ip_nat_adjust_in_ops = {
+	.hook		= ip_nat_adjust,
+	.owner		= THIS_MODULE,
+	.pf		= PF_INET,
+	.hooknum	= NF_IP_LOCAL_IN,
+	.priority	= NF_IP_PRI_NAT_SEQ_ADJUST,
+};
+
+
 static int init_or_cleanup(int init)
 {
 	int ret = 0;
@@ -296,10 +334,20 @@
 		printk("ip_nat_init: can't register out hook.\n");
 		goto cleanup_inops;
 	}
+	ret = nf_register_hook(&ip_nat_adjust_in_ops);
+	if (ret < 0) {
+		printk("ip_nat_init: can't register adjust in hook.\n");
+		goto cleanup_outops;
+	}
+	ret = nf_register_hook(&ip_nat_adjust_out_ops);
+	if (ret < 0) {
+		printk("ip_nat_init: can't register adjust out hook.\n");
+		goto cleanup_adjustin_ops;
+	}
 	ret = nf_register_hook(&ip_nat_local_out_ops);
 	if (ret < 0) {
 		printk("ip_nat_init: can't register local out hook.\n");
-		goto cleanup_outops;
+		goto cleanup_adjustout_ops;;
 	}
 	ret = nf_register_hook(&ip_nat_local_in_ops);
 	if (ret < 0) {
@@ -312,6 +360,10 @@
 	nf_unregister_hook(&ip_nat_local_in_ops);
  cleanup_localoutops:
 	nf_unregister_hook(&ip_nat_local_out_ops);
+ cleanup_adjustout_ops:
+	nf_unregister_hook(&ip_nat_adjust_out_ops);
+ cleanup_adjustin_ops:
+	nf_unregister_hook(&ip_nat_adjust_in_ops);
  cleanup_outops:
 	nf_unregister_hook(&ip_nat_out_ops);
  cleanup_inops:

--------------020806050600040909000601--
