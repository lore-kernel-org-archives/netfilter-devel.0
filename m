From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] ct-event API port to 2.6.11
Date: Mon, 28 Mar 2005 01:55:01 +0200
Message-ID: <424747D5.8060500@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020700050407070306090502"
Cc: Patrick McHardy <kaber@trash.net>
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
--------------020700050407070306090502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I sent this patch to Krisztian Kovacs some time ago in private but 
forgot to post it in mailing list. It is currently used by ct_sync.

BTW, I also ported this to nf_conntrack some time ago:

https://lists.netfilter.org/pipermail/netfilter-devel/2005-January/018219.html

I guess that such patch doesn't apply anymore since Rusty's changes. If 
I ported it again, could it be merge to the nf_conntrack tree or better 
wait until it's pushed forward?

--
Pablo

--------------020700050407070306090502
Content-Type: text/x-patch;
 name="ctevent-API-2.6.11-rc5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctevent-API-2.6.11-rc5.patch"

===== include/linux/netfilter.h 1.15 vs edited =====
--- 1.15/include/linux/netfilter.h	2005-01-10 21:23:55 +01:00
+++ edited/include/linux/netfilter.h	2005-02-24 19:43:20 +01:00
@@ -21,7 +21,7 @@
 #define NF_MAX_VERDICT NF_REPEAT
 
 /* Generic cache responses from hook functions.
-   <= 0x2000 is used for protocol-flags. */
+   <= 0x2000 is reserved for conntrack event cache. */
 #define NFC_UNKNOWN 0x4000
 #define NFC_ALTERED 0x8000
 
===== include/linux/netfilter_ipv4.h 1.7 vs edited =====
--- 1.7/include/linux/netfilter_ipv4.h	2004-03-30 06:24:38 +02:00
+++ edited/include/linux/netfilter_ipv4.h	2005-02-24 19:43:20 +01:00
@@ -8,34 +8,6 @@
 #include <linux/config.h>
 #include <linux/netfilter.h>
 
-/* IP Cache bits. */
-/* Src IP address. */
-#define NFC_IP_SRC		0x0001
-/* Dest IP address. */
-#define NFC_IP_DST		0x0002
-/* Input device. */
-#define NFC_IP_IF_IN		0x0004
-/* Output device. */
-#define NFC_IP_IF_OUT		0x0008
-/* TOS. */
-#define NFC_IP_TOS		0x0010
-/* Protocol. */
-#define NFC_IP_PROTO		0x0020
-/* IP options. */
-#define NFC_IP_OPTIONS		0x0040
-/* Frag & flags. */
-#define NFC_IP_FRAG		0x0080
-
-/* Per-protocol information: only matters if proto match. */
-/* TCP flags. */
-#define NFC_IP_TCPFLAGS		0x0100
-/* Source port. */
-#define NFC_IP_SRC_PT		0x0200
-/* Dest port. */
-#define NFC_IP_DST_PT		0x0400
-/* Something else about the proto */
-#define NFC_IP_PROTO_UNKNOWN	0x2000
-
 /* IP Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_IP_PRE_ROUTING	0
===== include/linux/netfilter_ipv4/ip_conntrack.h 1.35 vs edited =====
--- 1.35/include/linux/netfilter_ipv4/ip_conntrack.h	2005-01-27 07:03:17 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	2005-02-26 20:19:28 +01:00
@@ -65,6 +65,58 @@ enum ip_conntrack_status {
 
 	/* Both together */
 	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	IPS_DESTROYED_BIT = 9,
+	IPS_DESTROYED = (1 << IPS_DESTROYED_BIT),
+};
+
+/* Connection tracking event bits */
+enum ip_conntrack_events
+{
+	/* New conntrack */
+	IPCT_NEW_BIT = 0,
+	IPCT_NEW = (1 << IPCT_NEW_BIT),
+
+	/* Expected connection */
+	IPCT_RELATED_BIT = 1,
+	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
+
+	/* Destroyed conntrack */
+	IPCT_DESTROY_BIT = 2,
+	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
+
+	/* Timer has been refreshed */
+	IPCT_REFRESH_BIT = 3,
+	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
+
+	/* Status has changed */
+	IPCT_STATUS_BIT = 4,
+	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
+
+	/* Update of protocol info */
+	IPCT_PROTOINFO_BIT = 5,
+	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
+
+	/* Volatile protocol info */
+	IPCT_PROTOINFO_VOLATILE_BIT = 6,
+	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
+
+	/* New helper for conntrack */
+	IPCT_HELPER_BIT = 7,
+	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
+
+	/* Update of helper info */
+	IPCT_HELPINFO_BIT = 8,
+	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
+
+	/* Volatile helper info */
+	IPCT_HELPINFO_VOLATILE_BIT = 9,
+	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
+
+	/* NAT info */
+	IPCT_NATINFO_BIT = 10,
+	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
 };
 
 #ifdef __KERNEL__
@@ -247,7 +299,7 @@ extern int invert_tuplepr(struct ip_conn
 /* Refresh conntrack for this many jiffies */
 extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
-			       const struct sk_buff *skb,
+			       struct sk_buff *skb,
 			       unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
@@ -277,6 +329,11 @@ static inline int is_confirmed(struct ip
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int ip_conntrack_htable_size;
  
 struct ip_conntrack_stat
@@ -299,6 +356,57 @@ struct ip_conntrack_stat
 };
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
+
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+ 
+extern struct notifier_block *ip_conntrack_chain;
+ 
+static inline int ip_conntrack_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_conntrack_chain, nb);
+}
+
+static inline int ip_conntrack_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_conntrack_chain, nb);
+}
+
+static inline void ip_conntrack_event_cache_init(struct sk_buff *skb)
+{
+	/* Set to zero first 14 bits, see netfilter.h */
+	skb->nfcache &= 0xc000;
+}
+
+static inline void 
+ip_conntrack_event_cache(enum ip_conntrack_events event, struct sk_buff *skb)
+{
+	skb->nfcache |= event;
+}
+
+static inline void 
+ip_conntrack_deliver_cached_events(struct sk_buff *skb)
+{
+	struct ip_conntrack *ct = (struct ip_conntrack *) skb->nfct;
+
+	if (ct != NULL && is_confirmed(ct) && !is_destroyed(ct) && skb->nfcache)
+		notifier_call_chain(&ip_conntrack_chain, skb->nfcache, ct);
+}
+
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&ip_conntrack_chain, event, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline void ip_conntrack_event_cache_init(struct sk_buff *skb) {}
+static inline void ip_conntrack_event_cache(enum ip_conntrack_events event,
+					    struct sk_buff *skb) {}
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct) {}
+static inline void ip_conntrack_deliver_cached_events(struct sk_buff *skb) {}
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
 
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
===== include/linux/netfilter_ipv4/ip_conntrack_core.h 1.13 vs edited =====
--- 1.13/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-01-17 22:55:17 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-02-26 19:38:51 +01:00
@@ -39,10 +39,14 @@ extern int __ip_conntrack_confirm(struct
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int ip_conntrack_confirm(struct sk_buff **pskb)
 {
+	int ret = NF_ACCEPT;
+
 	if ((*pskb)->nfct
 	    && !is_confirmed((struct ip_conntrack *)(*pskb)->nfct))
-		return __ip_conntrack_confirm(pskb);
-	return NF_ACCEPT;
+		ret = __ip_conntrack_confirm(pskb);
+	ip_conntrack_deliver_cached_events(*pskb);
+
+	return ret;
 }
 
 extern struct list_head *ip_conntrack_hash;
===== include/linux/netfilter_ipv4/ip_conntrack_protocol.h 1.11 vs edited =====
--- 1.11/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-01-17 22:45:00 +01:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-02-24 19:43:20 +01:00
@@ -34,7 +34,7 @@ struct ip_conntrack_protocol
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo);
 
 	/* Called when a new connection for this protocol found;
===== net/ipv4/netfilter/Kconfig 1.35 vs edited =====
--- 1.35/net/ipv4/netfilter/Kconfig	2005-01-15 23:31:06 +01:00
+++ edited/net/ipv4/netfilter/Kconfig	2005-02-24 19:43:20 +01:00
@@ -692,5 +692,15 @@ config IP_NF_ARP_MANGLE
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
+config IP_NF_CONNTRACK_EVENTS
+	bool "Connection tracking events"
+	depends on IP_NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  provide a notifier chain that can be used by other kernel code
+	  to get notified about changes in the connection tracking state.
+	  
+	  IF unsure, say `N'.
+
 endmenu
 
===== net/ipv4/netfilter/ip_conntrack_proto_icmp.c 1.15 vs edited =====
--- 1.15/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-01-17 23:02:05 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-02-24 19:43:20 +01:00
@@ -89,7 +89,7 @@ static int icmp_print_conntrack(struct s
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmp_packet(struct ip_conntrack *ct,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       enum ip_conntrack_info ctinfo)
 {
 	/* Try to delete connection immediately after all replies:
@@ -102,6 +102,7 @@ static int icmp_packet(struct ip_conntra
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
 
===== net/ipv4/netfilter/ip_conntrack_proto_generic.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-09-13 02:00:29 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-02-24 19:43:20 +01:00
@@ -49,7 +49,7 @@ static int generic_print_conntrack(struc
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct ip_conntrack *conntrack,
-		  const struct sk_buff *skb,
+		  struct sk_buff *skb,
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
===== net/ipv4/netfilter/ip_conntrack_proto_sctp.c 1.11 vs edited =====
--- 1.11/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-01-17 22:58:33 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-02-24 19:43:20 +01:00
@@ -310,7 +310,7 @@ static int new_state(enum ip_conntrack_d
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int sctp_packet(struct ip_conntrack *conntrack,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       enum ip_conntrack_info ctinfo)
 {
 	enum sctp_conntrack newconntrack, oldsctpstate;
@@ -405,6 +405,8 @@ static int sctp_packet(struct ip_conntra
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
+		if (oldsctpstate != newconntrack)
+			ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
 		WRITE_UNLOCK(&sctp_lock);
 	}
 
===== net/ipv4/netfilter/ip_conntrack_core.c 1.86 vs edited =====
--- 1.86/net/ipv4/netfilter/ip_conntrack_core.c	2005-01-27 07:03:17 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	2005-02-26 19:38:09 +01:00
@@ -37,6 +37,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -76,6 +77,10 @@ unsigned int ip_ct_log_invalid;
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+struct notifier_block *ip_conntrack_chain;
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 void 
@@ -230,6 +235,8 @@ destroy_conntrack(struct nf_conntrack *n
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	set_bit(IPS_DESTROYED_BIT, &ct->status);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -268,6 +275,7 @@ static void death_by_timeout(unsigned lo
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
@@ -381,6 +389,16 @@ __ip_conntrack_confirm(struct sk_buff **
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		CONNTRACK_STAT_INC(insert);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		if (ct->helper)
+			ip_conntrack_event_cache(IPCT_HELPER, *pskb);
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
+		    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
+			ip_conntrack_event_cache(IPCT_NATINFO, *pskb);
+#endif
+		ip_conntrack_event_cache(master_ct(ct) ?
+					 IPCT_RELATED : IPCT_NEW, *pskb);
+
 		return NF_ACCEPT;
 	}
 
@@ -630,6 +648,8 @@ unsigned int ip_conntrack_in(unsigned in
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
+	ip_conntrack_event_cache_init(*pskb);
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -681,8 +701,8 @@ unsigned int ip_conntrack_in(unsigned in
 		return -ret;
 	}
 
-	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
+		ip_conntrack_event_cache(IPCT_STATUS, *pskb);
 
 	return ret;
 }
@@ -867,8 +887,10 @@ int ip_conntrack_helper_register(struct 
 static inline int unhelp(struct ip_conntrack_tuple_hash *i,
 			 const struct ip_conntrack_helper *me)
 {
-	if (tuplehash_to_ctrack(i)->helper == me)
+	if (tuplehash_to_ctrack(i)->helper == me) {
+ 		ip_conntrack_event(IPCT_HELPER, tuplehash_to_ctrack(i));
 		tuplehash_to_ctrack(i)->helper = NULL;
+	}
 	return 0;
 }
 
@@ -915,7 +937,7 @@ static inline void ct_add_counters(struc
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void ip_ct_refresh_acct(struct ip_conntrack *ct, 
 		        enum ip_conntrack_info ctinfo,
-			const struct sk_buff *skb,
+			struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
@@ -930,6 +952,7 @@ void ip_ct_refresh_acct(struct ip_conntr
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_event_cache(IPCT_REFRESH, skb);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.31 vs edited =====
--- 1.31/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-02-01 14:24:15 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-02-24 22:06:05 +01:00
@@ -263,7 +263,8 @@ static int find_nl_seq(u16 seq, const st
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u16 nl_seq, struct ip_ct_ftp_master *info, int dir,
+			  struct sk_buff *skb)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -277,10 +278,13 @@ static void update_nl_seq(u16 nl_seq, st
 			oldest = i;
 	}
 
-	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER)
+	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-	else if (oldest != NUM_SEQ_TO_REMEMBER)
+		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
+		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
+	}
 }
 
 static int help(struct sk_buff **pskb,
@@ -440,7 +444,7 @@ out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info,dir, *pskb);
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.63 vs edited =====
--- 1.63/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-01-27 07:03:17 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-26 20:22:16 +01:00
@@ -890,6 +890,11 @@ void need_ip_conntrack(void)
 {
 }
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL(ip_conntrack_chain);
+EXPORT_SYMBOL(ip_conntrack_register_notifier);
+EXPORT_SYMBOL(ip_conntrack_unregister_notifier);
+#endif
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(ip_ct_get_tuple);
===== net/ipv4/netfilter/ip_conntrack_proto_tcp.c 1.28 vs edited =====
--- 1.28/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-02-01 14:14:08 +01:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-02-24 19:43:20 +01:00
@@ -826,7 +826,7 @@ static int tcp_error(struct sk_buff *skb
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	enum tcp_conntrack new_state, old_state;
@@ -948,6 +948,10 @@ static int tcp_packet(struct ip_conntrac
 		  && *tcp_timeouts[new_state] > ip_ct_tcp_timeout_max_retrans
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
+
+	ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
+	if (new_state != old_state)
+		ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
 
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
===== net/ipv4/netfilter/ip_conntrack_proto_udp.c 1.14 vs edited =====
--- 1.14/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-09-26 23:18:26 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-02-25 10:57:39 +01:00
@@ -64,7 +64,7 @@ static int udp_print_conntrack(struct se
 
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -73,7 +73,8 @@ static int udp_packet(struct ip_conntrac
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
+			ip_conntrack_event_cache(IPCT_STATUS, skb);
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 

--------------020700050407070306090502--
