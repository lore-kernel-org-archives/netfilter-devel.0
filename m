From: Pablo Neira <pablo@eurodev.net>
Subject: [RFC][PATCH] kill the fake conntrack
Date: Sat, 25 Jun 2005 14:42:38 +0200
Message-ID: <42BD513E.6090306@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030509090805070006050405"
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------030509090805070006050405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Well, the subject looks like good action film but it isn't :)

The patch attached kills the fake conntrack and propose a new logic to 
explicitely set connection as untracked. We set nfct to NULL and use a 
new flag called IP_CT_UNTRACKED for nfctinfo. I've slightely tested it 
here and works fine.

Comments welcome.

--
Pablo

--------------030509090805070006050405
Content-Type: text/x-patch;
 name="new-untracked.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="new-untracked.patch"

Index: linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- linux-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-25 13:17:21.000000000 +0200
@@ -20,7 +20,10 @@
 	IP_CT_IS_REPLY,
 
 	/* Number of distinct IP_CT types (no NEW in reply dirn). */
-	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1
+	IP_CT_NUMBER = IP_CT_IS_REPLY * 2 - 1,
+
+	/* This packet belongs to a untracked connection */
+	IP_CT_UNTRACKED = ~0U
 };
 
 /* Bitset representing status of connection. */
Index: linux-2.6/net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ip_nat_core.c	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ip_nat_core.c	2005-06-25 13:24:25.000000000 +0200
@@ -525,8 +525,6 @@
 	IP_NF_ASSERT(ip_conntrack_destroyed == NULL);
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
 
-	/* Initialize fake conntrack so that NAT will skip it */
-	ip_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
 	return 0;
 }
 
Index: linux-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-25 13:23:53.000000000 +0200
@@ -986,7 +986,6 @@
 EXPORT_SYMBOL(ip_conntrack_htable_size);
 EXPORT_SYMBOL(ip_conntrack_lock);
 EXPORT_SYMBOL(ip_conntrack_hash);
-EXPORT_SYMBOL(ip_conntrack_untracked);
 EXPORT_SYMBOL_GPL(ip_conntrack_find_get);
 EXPORT_SYMBOL_GPL(ip_conntrack_put);
 #ifdef CONFIG_IP_NF_NAT_NEEDED
Index: linux-2.6/net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_conntrack.c	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ipt_conntrack.c	2005-06-25 13:23:28.000000000 +0200
@@ -35,7 +35,7 @@
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (ct == &ip_conntrack_untracked)
+	if (ctinfo == IP_CT_UNTRACKED)
 		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
  		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
Index: linux-2.6/net/ipv4/netfilter/ipt_state.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_state.c	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ipt_state.c	2005-06-25 13:22:58.000000000 +0200
@@ -30,7 +30,7 @@
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	if (skb->nfct == &ip_conntrack_untracked.ct_general)
+	if (skb->nfctinfo == IP_CT_UNTRACKED)
 		statebit = IPT_STATE_UNTRACKED;
 	else if (!ip_conntrack_get(skb, &ctinfo))
 		statebit = IPT_STATE_INVALID;
Index: linux-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-24 23:47:19.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-25 13:59:28.000000000 +0200
@@ -71,7 +71,6 @@
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
 static kmem_cache_t *ip_conntrack_expect_cachep;
-struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
@@ -613,7 +612,7 @@
 	int ret;
 
 	/* Previously seen (loopback or untracked)?  Ignore. */
-	if ((*pskb)->nfct) {
+	if ((*pskb)->nfct || (*pskb)->nfctinfo == IP_CT_UNTRACKED) {
 		CONNTRACK_STAT_INC(ignore);
 		return NF_ACCEPT;
 	}
@@ -1203,12 +1202,6 @@
 	/* For use by ipt_REJECT */
 	ip_ct_attach = ip_conntrack_attach;
 
-	/* Set up fake conntrack:
-	    - to never be deleted, not in any hashes */
-	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
-	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
-
 	return ret;
 
 err_free_conntrack_slab:
Index: linux-2.6/net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ip_nat_standalone.c	2005-06-25 14:04:47.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ip_nat_standalone.c	2005-06-25 14:25:41.000000000 +0200
@@ -81,6 +81,14 @@
 			return NF_DROP;
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
+	/* This is freak. The user is mixing non-tracked stuff together
+	 * with NAT, this is not possible since we lack of the necessary
+	 * information to perform any handling. Since we don't want to 
+	 * break stupid settings <SIGH>, just let this packet continue 
+	 * its travel through the network stack */
+	if (ctinfo == IP_CT_UNTRACKED)
+		return NF_ACCEPT;
+
 	/* Can't track?  It's not due to stress, or conntrack would
 	   have dropped it.  Hence it's the user's responsibilty to
 	   packet filter it out, or implement conntrack/NAT for that
Index: linux-2.6/net/ipv4/netfilter/ipt_NOTRACK.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_NOTRACK.c	2005-06-25 13:49:52.000000000 +0200
+++ linux-2.6/net/ipv4/netfilter/ipt_NOTRACK.c	2005-06-25 14:01:32.000000000 +0200
@@ -1,5 +1,8 @@
 /* This is a module which is used for setting up fake conntracks
  * on packets so that they are not seen by the conntrack/NAT code.
+ *
+ * 05/06/25: Added new untracked logic. 
+ * 	     Pablo Neira Ayuso <pablo at eurodev dot net>
  */
 #include <linux/module.h>
 #include <linux/skbuff.h>
@@ -16,16 +19,18 @@
        void *userinfo)
 {
 	/* Previously seen (loopback)? Ignore. */
-	if ((*pskb)->nfct != NULL)
+	if ((*pskb)->nfct != NULL || (*pskb)->nfctinfo == IP_CT_UNTRACKED)
 		return IPT_CONTINUE;
 
 	/* Attach fake conntrack entry. 
 	   If there is a real ct entry correspondig to this packet, 
 	   it'll hang aroun till timing out. We don't deal with it
 	   for performance reasons. JK */
-	(*pskb)->nfct = &ip_conntrack_untracked.ct_general;
-	(*pskb)->nfctinfo = IP_CT_NEW;
-	nf_conntrack_get((*pskb)->nfct);
+	   
+	/* This packet hasn't got any conntrack associated. To 
+	   explicitely mark it as untracked, set the nfctinfo flag. */
+	(*pskb)->nfct = NULL;
+	(*pskb)->nfctinfo = IP_CT_UNTRACKED;
 
 	return IPT_CONTINUE;
 }

--------------030509090805070006050405--
