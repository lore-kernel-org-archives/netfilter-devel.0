From: Roberto Nibali <ratz@tac.ch>
Subject: [PATCH] update raw patch in POM
Date: Tue, 07 Jun 2005 13:06:44 +0200
Message-ID: <42A57FC4.7010508@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020507000700010308010503"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
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
--------------020507000700010308010503
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello,

This is the updated (rediffed) patch against 2.4.31 for the raw table feature.
So far this has not been compile tested. Chunk #1 and #3 of the
ip_conntrack_core.c part failed.

Also I have already applied the nf-log and tcp-window-tracking patch before
this, so I don't know how much of use this patch is really. I wonder if people
adding code to POM could maybe use something like diff -Nur -C 10 to have more
context lines? It would make the diffs slightely larger but maintenance between
new kernel releases is reduced (hopefully).

Could someone tell me if any of the tcp window tracking fixes or other TCP state
transition fixes need to be backported from the 2.6.x to the 2.4.x kernel? I've
been offline for quite a while now and therefore not tracked netfilter-dev
exhaustively.

Thanks and best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------

--------------020507000700010308010503
Content-Type: text/plain;
 name="linux-2.4.31-raw-1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.31-raw-1.diff"

diff -Nur -X dontdiff linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_conntrack.h linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_conntrack.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_conntrack.h	2002-11-29 00:53:15 +0100
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_conntrack.h	2005-06-07 12:51:09 +0200
@@ -10,6 +10,7 @@
 
 #define IPT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
 #define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
+#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
 
 /* flags, invflags: */
 #define IPT_CONNTRACK_STATE	0x01
diff -Nur -X dontdiff linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_state.h linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_state.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4/ipt_state.h	2000-04-14 18:37:20 +0200
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4/ipt_state.h	2005-06-07 12:51:09 +0200
@@ -4,6 +4,8 @@
 #define IPT_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
 #define IPT_STATE_INVALID (1 << 0)
 
+#define IPT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
+
 struct ipt_state_info
 {
 	unsigned int statemask;
diff -Nur -X dontdiff linux-2.4.31-orig/include/linux/netfilter_ipv4.h linux-2.4.31-pab2/include/linux/netfilter_ipv4.h
--- linux-2.4.31-orig/include/linux/netfilter_ipv4.h	2002-02-25 20:38:13 +0100
+++ linux-2.4.31-pab2/include/linux/netfilter_ipv4.h	2005-06-07 12:51:09 +0200
@@ -51,6 +51,8 @@
 
 enum nf_ip_hook_priorities {
 	NF_IP_PRI_FIRST = INT_MIN,
+	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
+	NF_IP_PRI_RAW = -300,
 	NF_IP_PRI_CONNTRACK = -200,
 	NF_IP_PRI_MANGLE = -150,
 	NF_IP_PRI_NAT_DST = -100,
diff -Nur -X dontdiff linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-07 12:40:25 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-07 12:54:11 +0200
@@ -64,6 +64,7 @@
 static atomic_t ip_conntrack_count = ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
+struct ip_conntrack ip_conntrack_untracked;
 static LIST_HEAD(unconfirmed);
 
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
@@ -823,6 +824,15 @@
 	int set_reply;
 	int ret;
 
+	/* Never happen */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
+		if (net_ratelimit()) {
+		printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=%u)\n",
+		       (*pskb)->nh.iph->protocol, hooknum);
+		}
+		return NF_DROP;
+	}
+
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
@@ -841,21 +851,10 @@
 	}
 #endif
 
-	/* Previously seen (loopback)?  Ignore.  Do this before
-           fragment check. */
+	/* Previously seen (loopback or untracked)?  Ignore. */
 	if ((*pskb)->nfct)
 		return NF_ACCEPT;
 
-	/* Gather fragments. */
-	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
-		*pskb = ip_ct_gather_frags(*pskb,
-		                           hooknum == NF_IP_PRE_ROUTING ?
-		                           IP_DEFRAG_CONNTRACK_IN :
-		                           IP_DEFRAG_CONNTRACK_OUT);
-		if (!*pskb)
-			return NF_STOLEN;
-	}
-
 	proto = ip_ct_find_proto((*pskb)->nh.iph->protocol);
 
 	/* It may be an icmp error... */
@@ -1460,6 +1459,18 @@
 
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
+
+	/* Set up fake conntrack:
+	    - to never be deleted, not in any hashes */
+	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
+	/*  - and look it like as a confirmed connection */
+	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
+	/*  - and prepare the ctinfo field for REJECT/NAT. */
+	ip_conntrack_untracked.infos[IP_CT_NEW].master = 
+	ip_conntrack_untracked.infos[IP_CT_RELATED].master = 
+	ip_conntrack_untracked.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master = 
+		&ip_conntrack_untracked.ct_general;
+
 	return ret;
 
 err_free_hash:
diff -Nur -X dontdiff linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_standalone.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-07 12:40:25 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-07 12:51:09 +0200
@@ -189,6 +189,26 @@
 	return ip_conntrack_confirm(*pskb);
 }
 
+static unsigned int ip_conntrack_defrag(unsigned int hooknum,
+				        struct sk_buff **pskb,
+				        const struct net_device *in,
+				        const struct net_device *out,
+				        int (*okfn)(struct sk_buff *))
+{
+	/* Previously seen (loopback)?  Ignore.  Do this before
+           fragment check. */
+	if ((*pskb)->nfct)
+		return NF_ACCEPT;
+
+	/* Gather fragments. */
+	if ((*pskb)->nh.iph->frag_off & htons(IP_MF|IP_OFFSET)) {
+		*pskb = ip_ct_gather_frags(*pskb);
+		if (!*pskb)
+			return NF_STOLEN;
+	}
+	return NF_ACCEPT;
+}
+
 static unsigned int ip_refrag(unsigned int hooknum,
 			      struct sk_buff **pskb,
 			      const struct net_device *in,
@@ -230,9 +250,15 @@
 
 /* Connection tracking may drop packets, but never alters them, so
    make it the first hook. */
+static struct nf_hook_ops ip_conntrack_defrag_ops
+= { { NULL, NULL }, ip_conntrack_defrag, PF_INET, NF_IP_PRE_ROUTING,
+	NF_IP_PRI_CONNTRACK_DEFRAG };
 static struct nf_hook_ops ip_conntrack_in_ops
 = { { NULL, NULL }, ip_conntrack_in, PF_INET, NF_IP_PRE_ROUTING,
 	NF_IP_PRI_CONNTRACK };
+static struct nf_hook_ops ip_conntrack_defrag_local_out_ops
+= { { NULL, NULL }, ip_conntrack_defrag, PF_INET, NF_IP_LOCAL_OUT,
+	NF_IP_PRI_CONNTRACK_DEFRAG };
 static struct nf_hook_ops ip_conntrack_local_out_ops
 = { { NULL, NULL }, ip_conntrack_local, PF_INET, NF_IP_LOCAL_OUT,
 	NF_IP_PRI_CONNTRACK };
@@ -373,10 +399,20 @@
 	if (!proc) goto cleanup_init;
 	proc->owner = THIS_MODULE;
 
+	ret = nf_register_hook(&ip_conntrack_defrag_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
+		goto cleanup_proc;
+	}
+	ret = nf_register_hook(&ip_conntrack_defrag_local_out_ops);
+	if (ret < 0) {
+		printk("ip_conntrack: can't register local_out defrag hook.\n");
+		goto cleanup_defragops;
+	}
 	ret = nf_register_hook(&ip_conntrack_in_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing hook.\n");
-		goto cleanup_proc;
+		goto cleanup_defraglocalops;
 	}
 	ret = nf_register_hook(&ip_conntrack_local_out_ops);
 	if (ret < 0) {
@@ -414,6 +450,10 @@
 	nf_unregister_hook(&ip_conntrack_local_out_ops);
  cleanup_inops:
 	nf_unregister_hook(&ip_conntrack_in_ops);
+ cleanup_defraglocalops:
+	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
+ cleanup_defragops:
+	nf_unregister_hook(&ip_conntrack_defrag_ops);
  cleanup_proc:
 	proc_net_remove("ip_conntrack");
  cleanup_init:
@@ -503,5 +543,6 @@
 EXPORT_SYMBOL(ip_conntrack_expect_list);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
+EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
diff -Nur -X dontdiff linux-2.4.31-orig/net/ipv4/netfilter/ip_nat_core.c linux-2.4.31-pab2/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ip_nat_core.c	2005-04-04 03:42:20 +0200
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ip_nat_core.c	2005-06-07 12:51:09 +0200
@@ -1023,6 +1023,10 @@
 	/* FIXME: Man, this is a hack.  <SIGH> */
 	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
+	
+	/* Initialize fake conntrack so that NAT will skip it */
+	ip_conntrack_untracked.nat.info.initialized |= 
+		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
 
 	return 0;
 }
diff -Nur -X dontdiff linux-2.4.31-orig/net/ipv4/netfilter/ipt_conntrack.c linux-2.4.31-pab2/net/ipv4/netfilter/ipt_conntrack.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ipt_conntrack.c	2004-02-18 14:36:32 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ipt_conntrack.c	2005-06-07 12:51:09 +0200
@@ -27,11 +27,13 @@
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (ct)
-		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
-	else
-		statebit = IPT_CONNTRACK_STATE_INVALID;
-
+	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
+	else if (ct)
+ 		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
+ 	else
+ 		statebit = IPT_CONNTRACK_STATE_INVALID;
+ 
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
 			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=
diff -Nur -X dontdiff linux-2.4.31-orig/net/ipv4/netfilter/ipt_state.c linux-2.4.31-pab2/net/ipv4/netfilter/ipt_state.c
--- linux-2.4.31-orig/net/ipv4/netfilter/ipt_state.c	2004-02-18 14:36:32 +0100
+++ linux-2.4.31-pab2/net/ipv4/netfilter/ipt_state.c	2005-06-07 12:51:09 +0200
@@ -21,7 +21,9 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
+	if (skb->nfct == &ip_conntrack_untracked.infos[IP_CT_NEW])
+		statebit = IPT_STATE_UNTRACKED;
+	else if (!ip_conntrack_get((struct sk_buff *)skb, &ctinfo))
 		statebit = IPT_STATE_INVALID;
 	else
 		statebit = IPT_STATE_BIT(ctinfo);

--------------020507000700010308010503--
