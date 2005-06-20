From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK] compatible ipt_conntrack
Date: Mon, 20 Jun 2005 18:19:17 +0900 (JST)
Message-ID: <200506200919.j5K9JIhl022823@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Mon_Jun_20_18:19:17_2005_670)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
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

----Next_Part(Mon_Jun_20_18:19:17_2005_670)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, Patrick and all,

These make ipt_conntrack match compatible with ip_conntrack and nf_conntrack.
I wrote 2 patches with different approaches.

	1. [ipt_conntrack.patch]
	   Introducing glue functions and grouping the common member in
	   struct ip_conntrack/nf_conn. {ip,nf}_conntrack registers glue
	   functions like ip_ct_attach() and matches/targets use them.
	   This is the rough conclusion on discussion with Patrick on March.
	   This approach hides dependencies well, but the glue functions will
	   add some overheads.

	2. [ipt_conntrack-macro.patch]
	   Introducing glue macros. This approach is suggested by Pablo and
	   I re-wrote it based on his patch to reduce the changes to
	   ip_conntrack as possible. This approach will not add overhead
	   to ipt_conntrack, but will add a few complexities of #ifdef.

It's difficult for me to say which is better, but I think 1st approach has
flexibility than 2nd one and it's easier to keep compatibility when
people want to add some changes/new features to nf_conntrack.

Which do you prefer or other idea ?

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Mon_Jun_20_18:19:17_2005_670)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ipt_conntrack.patch"

Index: include/linux/netfilter.h
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/include/linux/netfilter.h  (mode:100644)
+++ uncommitted/include/linux/netfilter.h  (mode:100644)
@@ -184,7 +184,6 @@
 			struct nf_info *info,
 			unsigned int verdict);
 
-extern void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
 extern void nf_ct_attach(struct sk_buff *, struct sk_buff *);
 
 /* FIXME: Before cache is ever used, this must be implemented for real. */
Index: include/linux/netfilter/nf_conntrack.h
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/include/linux/netfilter/nf_conntrack.h  (mode:100644)
+++ uncommitted/include/linux/netfilter/nf_conntrack.h  (mode:100644)
@@ -77,11 +77,7 @@
 	/* These are my tuples; original and reply */
 	struct nf_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
 
-	/* Have we seen traffic both ways yet? (bitset) */
-	unsigned long status;
-
-	/* Timer function; drops refcnt when it goes off. */
-	struct timer_list timeout;
+	struct nf_conntrack_common common;
 
 #ifdef CONFIG_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
@@ -211,7 +207,7 @@
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int nf_ct_is_confirmed(struct nf_conn *ct)
 {
-	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
+	return test_bit(IPS_CONFIRMED_BIT, &ct->common.status);
 }
 
 extern unsigned int nf_conntrack_htable_size;
Index: include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/include/linux/netfilter/nf_conntrack_common.h  (mode:100644)
+++ uncommitted/include/linux/netfilter/nf_conntrack_common.h  (mode:100644)
@@ -1,5 +1,9 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
+
+#include <linux/skbuff.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
 /* Connection state tracking for netfilter.  This is separated from,
    but required by, the NAT layer; it can also be used by an iptables
    extension. */
@@ -93,6 +97,42 @@
 	unsigned int expect_delete;
 };
 
+/* common part in {ip,nf}_conntrack */
+struct nf_conntrack_common {
+	/* Have we seen traffic both ways yet? (bitset) */
+	unsigned long status;
+
+	/* Timer function; drops refcnt when it goes off. */
+	struct timer_list timeout;
+};
+
+struct nf_ct_glue {
+	void (*attach)(struct sk_buff *, struct sk_buff *);
+	int (*is_untracked)(struct nf_conntrack *ct);
+
+	/* get transport protocol number this conntrack has */
+	u_int16_t (*get_proto)(struct nf_conntrack *ct);
+
+	/* get IPv4 address this conntrack has */
+	u_int32_t (*get_addr)(struct nf_conntrack *ct,
+			      enum ip_conntrack_dir dir,
+			      int is_src);
+
+	/* get common part in {ip,nf}_conntrack */
+	struct nf_conntrack_common *(*get_common)(struct nf_conntrack *ct);
+};
+
+extern struct nf_ct_glue *nf_ct_glue;
+
+int nf_ct_register_glue(struct nf_ct_glue *glue);
+void nf_ct_unregister_glue(struct nf_ct_glue *glue);
+
+#ifndef CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT
+#define NEEDS_IP_CONNTRACK()	need_ip_conntrack()
+#else
+#define NEEDS_IP_CONNTRACK()	NEEDS_CONNTRACK(ipv4)
+#endif /* CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT */
+
 #endif /* __KERNEL__ */
 
 #endif /* _NF_CONNTRACK_COMMON_H */
Index: include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/include/linux/netfilter_ipv4/ip_conntrack.h  (mode:100644)
+++ uncommitted/include/linux/netfilter_ipv4/ip_conntrack.h  (mode:100644)
@@ -66,11 +66,7 @@
            plus 1 for any connection(s) we are `master' for */
 	struct nf_conntrack ct_general;
 
-	/* Have we seen traffic both ways yet? (bitset) */
-	unsigned long status;
-
-	/* Timer function; drops refcnt when it goes off. */
-	struct timer_list timeout;
+	struct nf_conntrack_common common;
 
 #ifdef CONFIG_IP_NF_CT_ACCT
 	/* Accounting Information (same cache line as other written members) */
@@ -204,7 +200,7 @@
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
-	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
+	return test_bit(IPS_CONFIRMED_BIT, &ct->common.status);
 }
 
 extern unsigned int ip_conntrack_htable_size;
@@ -216,8 +212,8 @@
 				     enum ip_nat_manip_type manip)
 {
 	if (manip == IP_NAT_MANIP_SRC)
-		return test_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
-	return test_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
+		return test_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->common.status);
+	return test_bit(IPS_DST_NAT_DONE_BIT, &conntrack->common.status);
 }
 #endif /* CONFIG_IP_NF_NAT_NEEDED */
 
Index: net/core/netfilter.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/core/netfilter.c  (mode:100644)
+++ uncommitted/net/core/netfilter.c  (mode:100644)
@@ -28,6 +28,7 @@
 #include <net/sock.h>
 #include <net/route.h>
 #include <linux/ip.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 
 /* In this code, we can be waiting indefinitely for userspace to
  * service a packet if a hook returns NF_QUEUE.  We could keep a count
@@ -746,18 +747,45 @@
 EXPORT_SYMBOL(nf_log_unregister);
 EXPORT_SYMBOL(nf_log_packet);
 
-/* This does not belong here, but locally generated errors need it if connection
-   tracking in use: without this, connection may not be in hash table, and hence
-   manufactured ICMP or RST packets will not be associated with it. */
-void (*ip_ct_attach)(struct sk_buff *, struct sk_buff *);
+struct nf_ct_glue *nf_ct_glue;
+static DEFINE_SPINLOCK(nf_ct_glue_lock);
+int nf_ct_register_glue(struct nf_ct_glue *glue)
+{
+	if (glue == NULL)
+		return -EINVAL;
+
+	spin_lock_bh(&nf_ct_glue_lock);
+	if (nf_ct_glue) {
+		spin_unlock_bh(&nf_ct_glue_lock);
+		return -EEXIST;
+	}
+	nf_ct_glue = glue;
+	spin_unlock_bh(&nf_ct_glue_lock);
+
+	synchronize_net();
 
+	return 0;
+}
+
+void nf_ct_unregister_glue(struct nf_ct_glue *glue)
+{
+	spin_lock_bh(&nf_ct_glue_lock);
+	nf_ct_glue = NULL;
+	spin_unlock_bh(&nf_ct_glue_lock);
+
+	synchronize_net();
+}
+
+/* Locally generated errors need it if connection tracking in use: without this,
+   connection may not be in hash table, and hence manufactured ICMP or RST
+   packets will not be associated with it. */
 void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb)
 {
-	void (*attach)(struct sk_buff *, struct sk_buff *);
+	struct nf_ct_glue *glue;
 
-	if (skb->nfct && (attach = ip_ct_attach) != NULL) {
+	if (skb->nfct && (glue = nf_ct_glue) != NULL && glue->attach != NULL) {
 		mb(); /* Just to be sure: must be read before executing this */
-		attach(new, skb);
+		glue->attach(new, skb);
 	}
 }
 
@@ -769,9 +797,13 @@
 		for (h = 0; h < NF_MAX_HOOKS; h++)
 			INIT_LIST_HEAD(&nf_hooks[i][h]);
 	}
+
+	synchronize_net();
 }
 
-EXPORT_SYMBOL(ip_ct_attach);
+EXPORT_SYMBOL(nf_ct_glue);
+EXPORT_SYMBOL(nf_ct_register_glue);
+EXPORT_SYMBOL(nf_ct_unregister_glue);
 EXPORT_SYMBOL(nf_ct_attach);
 EXPORT_SYMBOL(nf_getsockopt);
 EXPORT_SYMBOL(nf_hook_slow);
Index: net/ipv4/netfilter/Kconfig
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/Kconfig  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/Kconfig  (mode:100644)
@@ -706,5 +706,13 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_IPV4_AS_DEFAULT
+	bool "use nf_conntrack instead of ip_conntrack for matches/targets."
+	depends on NF_CONNTRACK_IPV4=m
+	depends on IP_NF_CONNTRACK=m && KMOD
+	---help---
+	  Some matches and targets require connection tracking features.
+	  If you say Y, they use nf_conntrack instead of ip_conntrack.
+	  If unsure, say N.
 endmenu
 
Index: net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_core.c  (mode:100644)
@@ -48,6 +48,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 
 #define IP_CONNTRACK_VERSION	"2.1"
 
@@ -375,10 +376,10 @@
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
-		ct->timeout.expires += jiffies;
-		add_timer(&ct->timeout);
+		ct->common.timeout.expires += jiffies;
+		add_timer(&ct->common.timeout);
 		atomic_inc(&ct->ct_general.use);
-		set_bit(IPS_CONFIRMED_BIT, &ct->status);
+		set_bit(IPS_CONFIRMED_BIT, &ct->common.status);
 		CONNTRACK_STAT_INC(insert);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		return NF_ACCEPT;
@@ -409,7 +410,7 @@
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
 {
-	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->status));
+	return !(test_bit(IPS_ASSURED_BIT, &tuplehash_to_ctrack(i)->common.status));
 }
 
 static int early_drop(struct list_head *chain)
@@ -430,7 +431,7 @@
 	if (!ct)
 		return dropped;
 
-	if (del_timer(&ct->timeout)) {
+	if (del_timer(&ct->common.timeout)) {
 		death_by_timeout((unsigned long)ct);
 		dropped = 1;
 		CONNTRACK_STAT_INC(early_drop);
@@ -504,9 +505,9 @@
 		return NULL;
 	}
 	/* Don't set timer yet: wait for confirmation */
-	init_timer(&conntrack->timeout);
-	conntrack->timeout.data = (unsigned long)conntrack;
-	conntrack->timeout.function = death_by_timeout;
+	init_timer(&conntrack->common.timeout);
+	conntrack->common.timeout.data = (unsigned long)conntrack;
+	conntrack->common.timeout.function = death_by_timeout;
 
 	WRITE_LOCK(&ip_conntrack_lock);
 	exp = find_expectation(tuple);
@@ -515,7 +516,7 @@
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+		__set_bit(IPS_EXPECTED_BIT, &conntrack->common.status);
 		conntrack->master = exp->master;
 #if CONFIG_IP_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
@@ -579,11 +580,11 @@
 		*set_reply = 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->common.status)) {
 			DEBUGP("ip_conntrack_in: normal packet for %p\n",
 			       ct);
 		        *ctinfo = IP_CT_ESTABLISHED;
-		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
+		} else if (test_bit(IPS_EXPECTED_BIT, &ct->common.status)) {
 			DEBUGP("ip_conntrack_in: related packet for %p\n",
 			       ct);
 			*ctinfo = IP_CT_RELATED;
@@ -682,7 +683,7 @@
 	}
 
 	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		set_bit(IPS_SEEN_REPLY_BIT, &ct->common.status);
 
 	return ret;
 }
@@ -922,14 +923,14 @@
 
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
-		ct->timeout.expires = extra_jiffies;
+		ct->common.timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
 		WRITE_LOCK(&ip_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
+		if (del_timer(&ct->common.timeout)) {
+			ct->common.timeout.expires = jiffies + extra_jiffies;
+			add_timer(&ct->common.timeout);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
@@ -1023,7 +1024,7 @@
 	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
 		struct ip_conntrack *ct = tuplehash_to_ctrack(h);
 		/* Time to push up daises... */
-		if (del_timer(&ct->timeout))
+		if (del_timer(&ct->common.timeout))
 			death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
@@ -1108,11 +1109,48 @@
 				     * ip_conntrack_htable_size));
 }
 
+static int is_untracked(struct nf_conntrack *ct)
+{
+	return ct == &ip_conntrack_untracked.ct_general;
+}
+
+static u_int16_t get_proto(struct nf_conntrack *ct)
+{
+	IP_NF_ASSERT(ct);
+
+	return ((struct ip_conntrack *)ct)->tuplehash[IP_CT_DIR_ORIGINAL]
+							.tuple.dst.protonum;
+}
+
+static u_int32_t get_addr(struct nf_conntrack *ct, enum ip_conntrack_dir dir,
+			  int is_src)
+{
+	struct ip_conntrack_tuple *t;
+
+	t = &((struct ip_conntrack *)ct)->tuplehash[dir].tuple;
+
+	return is_src ? t->src.ip : t->dst.ip;
+}
+
+static struct nf_conntrack_common *get_common(struct nf_conntrack *ct)
+{
+	return &((struct ip_conntrack *)ct)->common;
+}
+
+static struct nf_ct_glue glue_ops = {
+	.is_untracked	= is_untracked,
+	.attach		= ip_conntrack_attach,
+	.get_proto	= get_proto,
+	.get_addr	= get_addr,
+	.get_common	= get_common,
+};
+
 /* Mishearing the voices in his head, our hero wonders how he's
    supposed to kill the mall. */
 void ip_conntrack_cleanup(void)
 {
-	ip_ct_attach = NULL;
+	nf_ct_unregister_glue(&glue_ops);
+
 	/* This makes sure all current packets have passed through
            netfilter framework.  Roll on, two-stage module
            delete... */
@@ -1213,14 +1251,14 @@
 	for (i = 0; i < ip_conntrack_htable_size; i++)
 		INIT_LIST_HEAD(&ip_conntrack_hash[i]);
 
-	/* For use by ipt_REJECT */
-	ip_ct_attach = ip_conntrack_attach;
+	if (nf_ct_register_glue(&glue_ops) < 0)
+		goto err_free_conntrack_slab;
 
 	/* Set up fake conntrack:
 	    - to never be deleted, not in any hashes */
 	atomic_set(&ip_conntrack_untracked.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
+	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.common.status);
 
 	return ret;
 
Index: net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_proto_icmp.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_proto_icmp.c  (mode:100644)
@@ -98,8 +98,8 @@
            (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		    && del_timer(&ct->common.timeout))
+			ct->common.timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
Index: net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_proto_sctp.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_proto_sctp.c  (mode:100644)
@@ -414,7 +414,7 @@
 		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		DEBUGP("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	}
 
 	return NF_ACCEPT;
Index: net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_proto_tcp.c  (mode:100644)
@@ -883,8 +883,8 @@
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(PF_INET, 0, skb, NULL, NULL, 
 					  "ip_ct_tcp: killing out of sync session ");
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
+		    	if (del_timer(&conntrack->common.timeout))
+		    		conntrack->common.timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_DROP;
 		}
@@ -919,8 +919,8 @@
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
 		    	WRITE_UNLOCK(&tcp_lock);
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
+		    	if (del_timer(&conntrack->common.timeout))
+		    		conntrack->common.timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_REPEAT;
 		} else {
@@ -932,7 +932,7 @@
 		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
 			/* RST sent to invalid SYN we had let trough
@@ -974,25 +974,25 @@
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
+			if (del_timer(&conntrack->common.timeout))
+				conntrack->common.timeout.function((unsigned long)
 							    conntrack);
 			return NF_ACCEPT;
 		}
-	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->common.status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
 		/* Set ASSURED if we see see valid ack in ESTABLISHED 
 		   after SYN_RECV or a valid answer for a picked up 
 		   connection. */
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	}
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
Index: net/ipv4/netfilter/ip_conntrack_proto_udp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_proto_udp.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_proto_udp.c  (mode:100644)
@@ -69,11 +69,11 @@
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)) {
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 
Index: net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_conntrack_standalone.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_conntrack_standalone.c  (mode:100644)
@@ -36,6 +36,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter/nf_conntrack_common.h>
 
 #if 0
 #define DEBUGP printk
@@ -154,8 +155,8 @@
 	if (seq_printf(s, "%-8s %u %ld ",
 		      proto->name,
 		      conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
-		      timer_pending(&conntrack->timeout)
-		      ? (long)(conntrack->timeout.expires - jiffies)/HZ
+		      timer_pending(&conntrack->common.timeout)
+		      ? (long)(conntrack->common.timeout.expires - jiffies)/HZ
 		      : 0) != 0)
 		return -ENOSPC;
 
@@ -169,7 +170,7 @@
  	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
 		return -ENOSPC;
 
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)))
 		if (seq_printf(s, "[UNREPLIED] "))
 			return -ENOSPC;
 
@@ -180,7 +181,7 @@
  	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
 		return -ENOSPC;
 
-	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
+	if (test_bit(IPS_ASSURED_BIT, &conntrack->common.status))
 		if (seq_printf(s, "[ASSURED] "))
 			return -ENOSPC;
 
Index: net/ipv4/netfilter/ip_nat_core.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_nat_core.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_nat_core.c  (mode:100644)
@@ -62,7 +62,7 @@
 /* Noone using conntrack by the time this called. */
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
-	if (!(conn->status & IPS_NAT_DONE_MASK))
+	if (!(conn->common.status & IPS_NAT_DONE_MASK))
 		return;
 
 	WRITE_LOCK(&ip_nat_lock);
@@ -259,7 +259,7 @@
 {
 	struct ip_conntrack_tuple curr_tuple, new_tuple;
 	struct ip_nat_info *info = &conntrack->nat.info;
-	int have_to_hash = !(conntrack->status & IPS_NAT_DONE_MASK);
+	int have_to_hash = !(conntrack->common.status & IPS_NAT_DONE_MASK);
 	enum ip_nat_manip_type maniptype = HOOK2MANIP(hooknum);
 
 	IP_NF_ASSERT(hooknum == NF_IP_PRE_ROUTING
@@ -287,9 +287,9 @@
 
 		/* Non-atomic: we own this at the moment. */
 		if (maniptype == IP_NAT_MANIP_SRC)
-			conntrack->status |= IPS_SRC_NAT;
+			conntrack->common.status |= IPS_SRC_NAT;
 		else
-			conntrack->status |= IPS_DST_NAT;
+			conntrack->common.status |= IPS_DST_NAT;
 	}
 
 	/* Place in source hash if this is the first time. */
@@ -304,9 +304,9 @@
 
 	/* It's done. */
 	if (maniptype == IP_NAT_MANIP_DST)
-		set_bit(IPS_DST_NAT_DONE_BIT, &conntrack->status);
+		set_bit(IPS_DST_NAT_DONE_BIT, &conntrack->common.status);
 	else
-		set_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->status);
+		set_bit(IPS_SRC_NAT_DONE_BIT, &conntrack->common.status);
 
 	return NF_ACCEPT;
 }
@@ -366,7 +366,7 @@
 		statusbit ^= IPS_NAT_MASK;
 
 	/* Non-atomic: these bits don't change. */
-	if (ct->status & statusbit) {
+	if (ct->common.status & statusbit) {
 		struct ip_conntrack_tuple target;
 
 		/* We are aiming to look like inverse of other direction. */
@@ -414,10 +414,10 @@
            confused... --RR */
 	if (inside->icmp.type == ICMP_REDIRECT) {
 		/* If NAT isn't finished, assume it and drop. */
-		if ((ct->status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
+		if ((ct->common.status & IPS_NAT_DONE_MASK) != IPS_NAT_DONE_MASK)
 			return 0;
 
-		if (ct->status & IPS_NAT_MASK)
+		if (ct->common.status & IPS_NAT_MASK)
 			return 0;
 	}
 
@@ -526,7 +526,7 @@
 	ip_conntrack_destroyed = &ip_nat_cleanup_conntrack;
 
 	/* Initialize fake conntrack so that NAT will skip it */
-	ip_conntrack_untracked.status |= IPS_NAT_DONE_MASK;
+	ip_conntrack_untracked.common.status |= IPS_NAT_DONE_MASK;
 	return 0;
 }
 
@@ -534,7 +534,7 @@
 static int clean_nat(struct ip_conntrack *i, void *data)
 {
 	memset(&i->nat, 0, sizeof(i->nat));
-	i->status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
+	i->common.status &= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK | IPS_SEQ_ADJUST);
 	return 0;
 }
 
Index: net/ipv4/netfilter/ip_nat_helper.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_nat_helper.c  (mode:100644)
@@ -193,7 +193,7 @@
 				   csum_partial((char *)tcph, datalen, 0));
 
 	if (rep_len != match_len) {
-		set_bit(IPS_SEQ_ADJUST_BIT, &ct->status);
+		set_bit(IPS_SEQ_ADJUST_BIT, &ct->common.status);
 		adjust_tcp_sequence(ntohl(tcph->seq),
 				    (int)rep_len - (int)match_len,
 				    ct, ctinfo);
@@ -411,7 +411,7 @@
 	struct ip_nat_range range;
 
 	/* This must be a fresh one. */
-	BUG_ON(ct->status & IPS_NAT_DONE_MASK);
+	BUG_ON(ct->common.status & IPS_NAT_DONE_MASK);
 
 	/* Change src to where master sends to */
 	range.flags = IP_NAT_RANGE_MAP_IPS;
Index: net/ipv4/netfilter/ip_nat_snmp_basic.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_nat_snmp_basic.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_nat_snmp_basic.c  (mode:100644)
@@ -1258,7 +1258,7 @@
 		return NF_ACCEPT;
 
 	/* No NAT? */
-	if (!(ct->status & IPS_NAT_MASK))
+	if (!(ct->common.status & IPS_NAT_MASK))
 		return NF_ACCEPT;
 
 	/* 
Index: net/ipv4/netfilter/ip_nat_standalone.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ip_nat_standalone.c  (mode:100644)
@@ -241,7 +241,7 @@
 	enum ip_conntrack_info ctinfo;
 
 	ct = ip_conntrack_get(*pskb, &ctinfo);
-	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->status)) {
+	if (ct && test_bit(IPS_SEQ_ADJUST_BIT, &ct->common.status)) {
 	        DEBUGP("ip_nat_standalone: adjusting sequence number\n");
 	        if (!ip_nat_seq_adjust(pskb, ct, ctinfo))
 	                return NF_DROP;
Index: net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
@@ -13,6 +13,9 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_conntrack.h>
+#include <linux/netfilter/nf_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
@@ -27,29 +30,30 @@
       int *hotdrop)
 {
 	const struct ipt_conntrack_info *sinfo = matchinfo;
-	struct ip_conntrack *ct;
-	enum ip_conntrack_info ctinfo;
+	struct nf_conntrack *ct = skb->nfct;
+	struct nf_conntrack_common *ct_common = NULL;
 	unsigned int statebit;
 
-	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	if (ct)
+		ct_common = nf_ct_glue->get_common(ct);
 
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (ct == &ip_conntrack_untracked)
+	if (nf_ct_glue->is_untracked(ct))
 		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
- 		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
+ 		statebit = IPT_CONNTRACK_STATE_BIT(skb->nfctinfo);
  	else
  		statebit = IPT_CONNTRACK_STATE_INVALID;
  
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip)
+			if(nf_ct_glue->get_addr(ct, IP_CT_DIR_ORIGINAL, 1) !=
+			   nf_ct_glue->get_addr(ct, IP_CT_DIR_REPLY, 0))
 				statebit |= IPT_CONNTRACK_STATE_SNAT;
 
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip)
+			if(nf_ct_glue->get_addr(ct, IP_CT_DIR_ORIGINAL, 0) !=
+			   nf_ct_glue->get_addr(ct, IP_CT_DIR_REPLY, 1))
 				statebit |= IPT_CONNTRACK_STATE_DNAT;
 		}
 
@@ -58,33 +62,45 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_PROTO) {
-		if (!ct || FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, IPT_CONNTRACK_PROTO))
+		if (!ct|| FWINV((nf_ct_glue->get_proto(ct) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum), IPT_CONNTRACK_PROTO))
                 	return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
+		if (!ct || FWINV((nf_ct_glue->get_addr(ct, IP_CT_DIR_ORIGINAL,1)
+				  & sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr)
+				 != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
+				 IPT_CONNTRACK_ORIGSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
+		if (!ct || FWINV((nf_ct_glue->get_addr(ct, IP_CT_DIR_ORIGINAL,0)
+				  & sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr)
+				 != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
+				 IPT_CONNTRACK_ORIGDST))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
+		if (!ct || FWINV((nf_ct_glue->get_addr(ct, IP_CT_DIR_REPLY, 1)
+				  & sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr)
+				 != sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
+				 IPT_CONNTRACK_REPLSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
+		if (!ct || FWINV((nf_ct_glue->get_addr(ct, IP_CT_DIR_REPLY, 0)
+				  & sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr)
+				 != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
+				 IPT_CONNTRACK_REPLDST))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_STATUS) {
-		if (!ct || FWINV((ct->status & sinfo->statusmask) == 0 &&
-				 (ct->status | sinfo->statusmask) != 0,
+		if (!ct || FWINV((ct_common->status & sinfo->statusmask) == 0 &&
+				 (ct_common->status | sinfo->statusmask) != 0,
 				 IPT_CONNTRACK_STATUS))
 			return 0;
 	}
@@ -95,7 +111,7 @@
 		if(!ct)
 			return 0;
 
-		expires = timer_pending(&ct->timeout) ? (ct->timeout.expires - jiffies)/HZ : 0;
+		expires = timer_pending(&ct_common->timeout) ? (ct_common->timeout.expires - jiffies)/HZ : 0;
 
 		if (FWINV(!(expires >= sinfo->expires_min && expires <= sinfo->expires_max), IPT_CONNTRACK_EXPIRES))
 			return 0;
@@ -125,7 +141,8 @@
 
 static int __init init(void)
 {
-	need_ip_conntrack();
+	NEEDS_IP_CONNTRACK();
+
 	return ipt_register_match(&conntrack_match);
 }
 
Index: net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  (mode:100644)
@@ -418,6 +418,42 @@
 	.me		 = THIS_MODULE,
 };
 
+static int is_untracked(struct nf_conntrack *ct)
+{
+	return ct == &nf_conntrack_untracked.ct_general;
+}
+
+static u_int16_t get_proto(struct nf_conntrack *ct)
+{
+	NF_CT_ASSERT(ct);
+
+	return ((struct nf_conn *)ct)->tuplehash[IP_CT_DIR_ORIGINAL]
+							.tuple.dst.protonum;
+}
+
+static u_int32_t get_addr(struct nf_conntrack *ct, enum ip_conntrack_dir dir,
+			  int is_src)
+{
+	struct nf_conntrack_tuple *t; 
+
+	t = &((struct nf_conn *)ct)->tuplehash[dir].tuple;
+
+	return is_src ? t->src.u3.ip : t->dst.u3.ip;
+}
+
+static struct nf_conntrack_common *get_common(struct nf_conntrack *ct)
+{
+	return &((struct nf_conn *)ct)->common;
+}
+
+static struct nf_ct_glue glue_ops = {
+	.is_untracked	= is_untracked,
+	.attach		= __nf_conntrack_attach,
+	.get_proto	= get_proto,
+	.get_addr	= get_addr,
+	.get_common	= get_common,
+};
+
 extern struct nf_conntrack_protocol nf_conntrack_protocol_tcp4;
 extern struct nf_conntrack_protocol nf_conntrack_protocol_udp4;
 extern struct nf_conntrack_protocol nf_conntrack_protocol_icmp;
@@ -457,10 +493,17 @@
 		goto cleanup_icmp;
 	}
 
+	/* For use by REJECT target */
+	ret = nf_ct_register_glue(&glue_ops);
+	if (ret < 0) {
+		printk("nf_conntrack_ipv4: can't register glue functions.\n");
+		goto cleanup_ipv4;
+	}
+
 	ret = nf_register_hook(&ipv4_conntrack_defrag_ops);
 	if (ret < 0) {
 		printk("nf_conntrack_ipv4: can't register pre-routing defrag hook.\n");
-		goto cleanup_ipv4;
+		goto cleanup_glue;
 	}
 	ret = nf_register_hook(&ipv4_conntrack_defrag_local_out_ops);
 	if (ret < 0) {
@@ -513,13 +556,9 @@
 	}
 #endif
 
-	/* For use by REJECT target */
-	ip_ct_attach = __nf_conntrack_attach;
-
 	return ret;
 
  cleanup:
-	ip_ct_attach = NULL;
 #ifdef CONFIG_SYSCTL
  	unregister_sysctl_table(nf_ct_ipv4_sysctl_header);
  cleanup_localinops:
@@ -539,6 +578,8 @@
 	nf_unregister_hook(&ipv4_conntrack_defrag_local_out_ops);
  cleanup_defragops:
 	nf_unregister_hook(&ipv4_conntrack_defrag_ops);
+ cleanup_glue:
+	nf_ct_unregister_glue(&glue_ops);
  cleanup_ipv4:
 	nf_conntrack_l3proto_unregister(&nf_conntrack_l3proto_ipv4);
  cleanup_icmp:
Index: net/ipv4/netfilter/nf_conntrack_proto_icmp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/nf_conntrack_proto_icmp.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/nf_conntrack_proto_icmp.c  (mode:100644)
@@ -105,8 +105,8 @@
            (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		    && del_timer(&ct->common.timeout))
+			ct->common.timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
Index: net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c  (mode:100644)
+++ uncommitted/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c  (mode:100644)
@@ -109,8 +109,8 @@
            (theoretically possible with SMP) */
 	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
 		if (atomic_dec_and_test(&ct->proto.icmp.count)
-		    && del_timer(&ct->timeout))
-			ct->timeout.function((unsigned long)ct);
+		    && del_timer(&ct->common.timeout))
+			ct->common.timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
Index: net/netfilter/nf_conntrack_core.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/netfilter/nf_conntrack_core.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_core.c  (mode:100644)
@@ -455,7 +455,7 @@
 
 	DEBUGP("destroy_conntrack(%p)\n", ct);
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
-	NF_CT_ASSERT(!timer_pending(&ct->timeout));
+	NF_CT_ASSERT(!timer_pending(&ct->common.timeout));
 
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
@@ -607,10 +607,10 @@
 		/* Timer relative to confirmation time, not original
 		   setting time, otherwise we'd get timer wrap in
 		   weird delay cases. */
-		ct->timeout.expires += jiffies;
-		add_timer(&ct->timeout);
+		ct->common.timeout.expires += jiffies;
+		add_timer(&ct->common.timeout);
 		atomic_inc(&ct->ct_general.use);
-		set_bit(IPS_CONFIRMED_BIT, &ct->status);
+		set_bit(IPS_CONFIRMED_BIT, &ct->common.status);
 		NF_CT_STAT_INC(insert);
 		WRITE_UNLOCK(&nf_conntrack_lock);
 		return NF_ACCEPT;
@@ -641,7 +641,7 @@
 static inline int unreplied(const struct nf_conntrack_tuple_hash *i)
 {
 	return !(test_bit(IPS_ASSURED_BIT,
-			  &nf_ct_tuplehash_to_ctrack(i)->status));
+			  &nf_ct_tuplehash_to_ctrack(i)->common.status));
 }
 
 static int early_drop(struct list_head *chain)
@@ -662,7 +662,7 @@
 	if (!ct)
 		return dropped;
 
-	if (del_timer(&ct->timeout)) {
+	if (del_timer(&ct->common.timeout)) {
 		death_by_timeout((unsigned long)ct);
 		dropped = 1;
 		NF_CT_STAT_INC(early_drop);
@@ -750,9 +750,9 @@
 		return NULL;
 	}
 	/* Don't set timer yet: wait for confirmation */
-	init_timer(&conntrack->timeout);
-	conntrack->timeout.data = (unsigned long)conntrack;
-	conntrack->timeout.function = death_by_timeout;
+	init_timer(&conntrack->common.timeout);
+	conntrack->common.timeout.data = (unsigned long)conntrack;
+	conntrack->common.timeout.function = death_by_timeout;
 
 	WRITE_LOCK(&nf_conntrack_lock);
 	exp = find_expectation(tuple);
@@ -761,7 +761,7 @@
 		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
 			conntrack, exp);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+		__set_bit(IPS_EXPECTED_BIT, &conntrack->common.status);
 		conntrack->master = exp->master;
 #if CONFIG_NF_CONNTRACK_MARK
 		conntrack->mark = exp->master->mark;
@@ -829,10 +829,10 @@
 		*set_reply = 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &ct->common.status)) {
 			DEBUGP("nf_conntrack_in: normal packet for %p\n", ct);
 			*ctinfo = IP_CT_ESTABLISHED;
-		} else if (test_bit(IPS_EXPECTED_BIT, &ct->status)) {
+		} else if (test_bit(IPS_EXPECTED_BIT, &ct->common.status)) {
 			DEBUGP("nf_conntrack_in: related packet for %p\n", ct);
 			*ctinfo = IP_CT_RELATED;
 		} else {
@@ -910,7 +910,7 @@
 	}
 
 	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		set_bit(IPS_SEEN_REPLY_BIT, &ct->common.status);
 
 	return ret;
 }
@@ -1173,18 +1173,18 @@
 			const struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
-	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
+	NF_CT_ASSERT(ct->common.timeout.data == (unsigned long)ct);
 
 	/* If not in hash table, timer will not be active yet */
 	if (!nf_ct_is_confirmed(ct)) {
-		ct->timeout.expires = extra_jiffies;
+		ct->common.timeout.expires = extra_jiffies;
 		ct_add_counters(ct, ctinfo, skb);
 	} else {
 		WRITE_LOCK(&nf_conntrack_lock);
 		/* Need del_timer for race avoidance (may already be dying). */
-		if (del_timer(&ct->timeout)) {
-			ct->timeout.expires = jiffies + extra_jiffies;
-			add_timer(&ct->timeout);
+		if (del_timer(&ct->common.timeout)) {
+			ct->common.timeout.expires = jiffies + extra_jiffies;
+			add_timer(&ct->common.timeout);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&nf_conntrack_lock);
@@ -1251,7 +1251,7 @@
 	while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
 		struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
 		/* Time to push up daises... */
-		if (del_timer(&ct->timeout))
+		if (del_timer(&ct->common.timeout))
 			death_by_timeout((unsigned long)ct);
 		/* ... else the timer will get him soon. */
 
@@ -1378,7 +1378,7 @@
 	    - to never be deleted, not in any hashes */
 	atomic_set(&nf_conntrack_untracked.ct_general.use, 1);
 	/*  - and look it like as a confirmed connection */
-	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.status);
+	set_bit(IPS_CONFIRMED_BIT, &nf_conntrack_untracked.common.status);
 
 	return ret;
 
Index: net/netfilter/nf_conntrack_proto_sctp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/netfilter/nf_conntrack_proto_sctp.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_proto_sctp.c  (mode:100644)
@@ -422,7 +422,7 @@
 		&& CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		DEBUGP("Setting assured bit\n");
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	}
 
 	return NF_ACCEPT;
Index: net/netfilter/nf_conntrack_proto_tcp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/netfilter/nf_conntrack_proto_tcp.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_proto_tcp.c  (mode:100644)
@@ -929,8 +929,8 @@
 			if (LOG_INVALID(IPPROTO_TCP))
 				nf_log_packet(pf, 0, skb, NULL, NULL, 
 					  "nf_ct_tcp: killing out of sync session ");
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
+		    	if (del_timer(&conntrack->common.timeout))
+		    		conntrack->common.timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_DROP;
 		}
@@ -965,14 +965,14 @@
 		    	/* Attempt to reopen a closed connection.
 		    	* Delete this connection and look up again. */
 		    	WRITE_UNLOCK(&tcp_lock);
-		    	if (del_timer(&conntrack->timeout))
-		    		conntrack->timeout.function((unsigned long)
+		    	if (del_timer(&conntrack->common.timeout))
+		    		conntrack->common.timeout.function((unsigned long)
 		    					    conntrack);
 		    	return -NF_REPEAT;
 		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
 			/* RST sent to invalid SYN we had let trough
@@ -1014,25 +1014,25 @@
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
-	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
 		   problem case, so we can delete the conntrack
 		   immediately.  --RR */
 		if (th->rst) {
-			if (del_timer(&conntrack->timeout))
-				conntrack->timeout.function((unsigned long)
+			if (del_timer(&conntrack->common.timeout))
+				conntrack->common.timeout.function((unsigned long)
 							    conntrack);
 			return NF_ACCEPT;
 		}
-	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+	} else if (!test_bit(IPS_ASSURED_BIT, &conntrack->common.status)
 		   && (old_state == TCP_CONNTRACK_SYN_RECV
 		       || old_state == TCP_CONNTRACK_ESTABLISHED)
 		   && new_state == TCP_CONNTRACK_ESTABLISHED) {
 		/* Set ASSURED if we see see valid ack in ESTABLISHED 
 		   after SYN_RECV or a valid answer for a picked up 
 		   connection. */
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	}
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 
Index: net/netfilter/nf_conntrack_proto_udp.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/netfilter/nf_conntrack_proto_udp.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_proto_udp.c  (mode:100644)
@@ -79,11 +79,11 @@
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
+	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)) {
 		nf_ct_refresh_acct(conntrack, ctinfo, skb,
 				   nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->common.status);
 	} else
 		nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_udp_timeout);
 
Index: net/netfilter/nf_conntrack_standalone.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_standalone.c  (mode:100644)
@@ -176,8 +176,8 @@
 		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.l3num,
 		       proto->name,
 		       conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum,
-		       timer_pending(&conntrack->timeout)
-		       ? (long)(conntrack->timeout.expires - jiffies)/HZ : 0) != 0)
+		       timer_pending(&conntrack->common.timeout)
+		       ? (long)(conntrack->common.timeout.expires - jiffies)/HZ : 0) != 0)
 		return -ENOSPC;
 
 	if (l3proto->print_conntrack(s, conntrack))
@@ -193,7 +193,7 @@
 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_ORIGINAL]))
 		return -ENOSPC;
 
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->common.status)))
 		if (seq_printf(s, "[UNREPLIED] "))
 			return -ENOSPC;
 
@@ -204,7 +204,7 @@
 	if (seq_print_counters(s, &conntrack->counters[IP_CT_DIR_REPLY]))
 		return -ENOSPC;
 
-	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
+	if (test_bit(IPS_ASSURED_BIT, &conntrack->common.status))
 		if (seq_printf(s, "[ASSURED] "))
 			return -ENOSPC;
 

----Next_Part(Mon_Jun_20_18:19:17_2005_670)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="ipt_conntrack-macro.patch"

Index: include/linux/netfilter/ipv4/ip_conntrack_compat.h
===================================================================
--- /dev/null  (tree:ae9373bb09f00964c2d3ae8d04d21ce299995bf9)
+++ uncommitted/include/linux/netfilter/ipv4/ip_conntrack_compat.h  (mode:100644)
@@ -0,0 +1,81 @@
+/*
+ * Definitions and Declarations for compatibilities between ip_conntrack
+ * and nf_conntrack.
+ *
+ * 23 May 2005: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *
+ * Derived from include/linux/netfiter_ipv4/ip_conntrack_tuple.h
+ */
+
+#ifndef _NF_CONNTRACK_COMPAT_H
+#define _NF_CONNTRACK_COMPAT_H
+
+#include <linux/netfilter/nf_conntrack.h>
+
+#ifdef CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT
+
+#define IP_CONNTRACK_COMPAT_UNTRACKED	(&nf_conntrack_untracked.ct_general)
+#define NEEDS_IP_CONNTRACK()		NEEDS_CONNTRACK(ipv4)
+
+#else /* CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT */
+
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+
+#define IP_CONNTRACK_COMPAT_UNTRACKED	(&ip_conntrack_untracked.ct_general)
+#define NEEDS_IP_CONNTRACK()		need_ip_conntrack()
+
+/* The l3 protocol-specific manipulable parts of the tuple: always in
+   network order! */
+union ip_conntrack_compat_man_l3proto {
+	u_int32_t ip;
+};
+
+/* The manipulable part of the tuple. */
+struct ip_conntrack_compat_man
+{
+	union ip_conntrack_compat_man_l3proto u3;
+	union ip_conntrack_manip_proto u;
+	/* Layer 3 protocol */
+	u_int16_t l3num;
+};
+
+/* This contains the information to distinguish a connection. */
+struct ip_conntrack_compat_tuple
+{
+	struct ip_conntrack_compat_man src;
+
+	/* These are the parts of the tuple which are fixed. */
+	struct {
+		union {
+			u_int32_t ip;
+		} u3;
+		union {
+			/* Add other protocols here. */
+			u_int16_t all;
+
+			struct {
+				u_int16_t port;
+			} tcp;
+			struct {
+				u_int16_t port;
+			} udp;
+			struct {
+				u_int8_t type, code;
+			} icmp;
+			struct {
+				u_int16_t port;
+			} sctp;
+		} u;
+
+		/* The protocol. */
+		u_int8_t protonum;
+
+		/* The direction (for tuplehash) */
+		u_int8_t dir;
+	} dst;
+};
+
+#endif /* CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT */
+
+#endif /* _IP_CONNTRACK_COMPAT_H */
Index: include/linux/netfilter/nf_conntrack_common.h
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/include/linux/netfilter/nf_conntrack_common.h  (mode:100644)
+++ uncommitted/include/linux/netfilter/nf_conntrack_common.h  (mode:100644)
@@ -1,3 +1,12 @@
+/*
+ * Common Definitions and Declarations in ip_conntrack and nf_conntrack
+ *
+ * 23 May 2005: Yasuyuki Kozakai @USAGI <yasuyuki.kozakai@toshiba.co.jp>
+ *
+ * Derived from include/linux/netfiter_ipv4/ip_conntrack.h and
+ * include/linux/netfiter_ipv4/ip_conntrack_tuple.h
+ */
+
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 /* Connection state tracking for netfilter.  This is separated from,
Index: net/ipv4/netfilter/Kconfig
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/Kconfig  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/Kconfig  (mode:100644)
@@ -706,5 +706,13 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_IPV4_AS_DEFAULT
+	bool "use nf_conntrack instead of ip_conntrack for matches/targets."
+	depends on NF_CONNTRACK_IPV4=m
+	depends on IP_NF_CONNTRACK=m && KMOD
+	---help---
+	  Some matches and targets require connection tracking features.
+	  If you say Y, they use nf_conntrack instead of ip_conntrack.
+	  If unsure, say N.
 endmenu
 
Index: net/ipv4/netfilter/ipt_conntrack.c
===================================================================
--- ae9373bb09f00964c2d3ae8d04d21ce299995bf9/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
+++ uncommitted/net/ipv4/netfilter/ipt_conntrack.c  (mode:100644)
@@ -10,7 +10,15 @@
 
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/config.h>
+
+#ifndef CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT
 #include <linux/netfilter_ipv4/ip_conntrack.h>
+#else
+#include <linux/netfilter/nf_conntrack.h>
+#endif
+
+#include <linux/netfilter/ipv4/ip_conntrack_compat.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_conntrack.h>
 
@@ -27,15 +35,34 @@
       int *hotdrop)
 {
 	const struct ipt_conntrack_info *sinfo = matchinfo;
-	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
 	unsigned int statebit;
 
-	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
-
 #define FWINV(bool,invflg) ((bool) ^ !!(sinfo->invflags & invflg))
 
-	if (ct == &ip_conntrack_untracked)
+#ifndef CONFIG_NF_CONNTRACK_IPV4_AS_DEFAULT
+	struct ip_conntrack *ct;
+	struct ip_conntrack_compat_tuple *orig_tuple = NULL, *repl_tuple = NULL;
+
+	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	if (ct) {
+		orig_tuple = (struct ip_conntrack_compat_tuple *)
+				&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		repl_tuple = (struct ip_conntrack_compat_tuple *)
+				&ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	}
+#else
+	struct nf_conn *ct;
+	struct nf_conntrack_tuple *orig_tuple = NULL, *repl_tuple = NULL;
+
+	ct = nf_ct_get((struct sk_buff *)skb, &ctinfo);
+	if (ct) {
+		orig_tuple = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
+		repl_tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
+	}
+#endif
+
+	if (skb->nfct == IP_CONNTRACK_COMPAT_UNTRACKED)
 		statebit = IPT_CONNTRACK_STATE_UNTRACKED;
 	else if (ct)
  		statebit = IPT_CONNTRACK_STATE_BIT(ctinfo);
@@ -44,12 +71,10 @@
  
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		if (ct) {
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip)
+			if(orig_tuple->src.u3.ip != repl_tuple->dst.u3.ip)
 				statebit |= IPT_CONNTRACK_STATE_SNAT;
 
-			if(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip !=
-			    ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip)
+			if(orig_tuple->dst.u3.ip != repl_tuple->src.u3.ip)
 				statebit |= IPT_CONNTRACK_STATE_DNAT;
 		}
 
@@ -58,27 +83,27 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_PROTO) {
-		if (!ct || FWINV(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, IPT_CONNTRACK_PROTO))
+		if (!ct || FWINV(orig_tuple->dst.protonum != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum, IPT_CONNTRACK_PROTO))
                 	return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
+		if (!ct || FWINV((orig_tuple->src.u3.ip&sinfo->sipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip, IPT_CONNTRACK_ORIGSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_ORIGDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
+		if (!ct || FWINV((orig_tuple->dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_ORIGINAL].s_addr) != sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip, IPT_CONNTRACK_ORIGDST))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
+		if (!ct || FWINV((repl_tuple->src.u3.ip&sinfo->sipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].src.ip, IPT_CONNTRACK_REPLSRC))
 			return 0;
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
-		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
+		if (!ct || FWINV((repl_tuple->dst.u3.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
 			return 0;
 	}
 
@@ -125,7 +150,7 @@
 
 static int __init init(void)
 {
-	need_ip_conntrack();
+	NEEDS_IP_CONNTRACK();
 	return ipt_register_match(&conntrack_match);
 }
 

----Next_Part(Mon_Jun_20_18:19:17_2005_670)----
