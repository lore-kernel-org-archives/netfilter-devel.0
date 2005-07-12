From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/*] conntrack event API updates
Date: Tue, 12 Jul 2005 22:35:46 +0200
Message-ID: <42D429A2.2060001@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050800030807010103000208"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------050800030807010103000208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This includes three fixes:

a) nfcache bits are reset once the events has been delivered. Loopback 
connections events are notified twice.

b) Don't kill NFC_IP_*. Just more it into a #ifndef __KERNEL__ fence, 
that way we don't break iptables backward compilation.

c) IPCT_DESTROY is delivered from destroy_conntrack. Some users has 
reported out of logical order event notification. This fixes the problem.

--------------050800030807010103000208
Content-Type: text/x-patch;
 name="02ct-event-api.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02ct-event-api.patch"

conntrack event API


Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-07-12 20:39:45.000000000 +0200
@@ -963,6 +963,12 @@
 {
 }
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL(ip_conntrack_chain);
+EXPORT_SYMBOL(ip_conntrack_expect_chain);
+EXPORT_SYMBOL(ip_conntrack_register_notifier);
+EXPORT_SYMBOL(ip_conntrack_unregister_notifier);
+#endif
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(ip_ct_get_tuple);
Index: davem-2.6/include/linux/netfilter_ipv4.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4.h	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4.h	2005-06-30 19:14:03.000000000 +0200
@@ -8,6 +8,8 @@
 #include <linux/config.h>
 #include <linux/netfilter.h>
 
+/* Old iptables versions need this: backward compatibility compilation */
+#ifndef __KERNEL__
 /* IP Cache bits. */
 /* Src IP address. */
 #define NFC_IP_SRC		0x0001
@@ -35,6 +37,7 @@
 #define NFC_IP_DST_PT		0x0400
 /* Something else about the proto */
 #define NFC_IP_PROTO_UNKNOWN	0x2000
+#endif
 
 /* IP Hooks */
 /* After promisc drops, checksum checks. */
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_udp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2005-07-12 20:39:45.000000000 +0200
@@ -64,7 +64,7 @@
 
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -73,7 +73,8 @@
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
+			ip_conntrack_event_cache(IPCT_STATUS, skb);
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2005-07-12 20:39:45.000000000 +0200
@@ -843,7 +843,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	enum tcp_conntrack new_state, old_state;
@@ -974,6 +974,10 @@
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
+	ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
+	if (new_state != old_state)
+		ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
+
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack.h	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack.h	2005-07-12 20:39:45.000000000 +0200
@@ -65,6 +65,10 @@
 
 	/* Both together */
 	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
+
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	IPS_DESTROYED_BIT = 9,
+	IPS_DESTROYED = (1 << IPS_DESTROYED_BIT),
 };
 
 #ifdef __KERNEL__
@@ -247,7 +251,7 @@
 /* Refresh conntrack for this many jiffies */
 extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
-			       const struct sk_buff *skb,
+			       struct sk_buff *skb,
 			       unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
@@ -277,6 +281,11 @@
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int ip_conntrack_htable_size;
  
 struct ip_conntrack_stat
@@ -300,6 +309,8 @@
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
+#include <linux/netfilter_ipv4/ip_conntrack_events.h>
+
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
 				     enum ip_nat_manip_type manip)
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_events.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_events.h	2005-06-30 19:14:03.000000000 +0200
@@ -0,0 +1,138 @@
+#ifndef _IP_CONNTRACK_EVENTS_H
+#define _IP_CONNTRACK_EVENTS_H
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
+};
+
+enum ip_conntrack_expect_events {
+	IPEXP_NEW_BIT = 0,
+	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
+
+	IPEXP_TIMEOUT_BIT = 1,
+	IPEXP_TIMEOUT = (1 << IPEXP_TIMEOUT_BIT),
+};
+
+#ifdef __KERNEL__
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+
+extern struct notifier_block *ip_conntrack_chain;
+extern struct notifier_block *ip_conntrack_expect_chain;
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
+static inline int 
+ip_conntrack_expect_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_conntrack_expect_chain, nb);
+}
+
+static inline int
+ip_conntrack_expect_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_conntrack_expect_chain, nb);
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
+	if (ct && is_confirmed(ct) && !is_destroyed(ct) && skb->nfcache) {
+		notifier_call_chain(&ip_conntrack_chain, skb->nfcache, ct);
+		/* Reset nfcache once events got delivered */
+		ip_conntrack_event_cache_init(skb);
+	}
+}
+
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&ip_conntrack_chain, event, ct);
+}
+
+static inline void 
+ip_conntrack_expect_event(enum ip_conntrack_expect_events event,
+			  struct ip_conntrack_expect *exp)
+{
+	notifier_call_chain(&ip_conntrack_expect_chain, event, exp);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline void ip_conntrack_event_cache_init(struct sk_buff *skb) {}
+static inline void ip_conntrack_event_cache(enum ip_conntrack_events event, 
+					    struct sk_buff *skb) {}
+static inline void ip_conntrack_event(enum ip_conntrack_events event, 
+				      struct ip_conntrack *ct) {}
+static inline void ip_conntrack_deliver_cached_events(struct sk_buff *skb) {}
+static inline void 
+ip_conntrack_expect_event(enum ip_conntrack_expect_events event, 
+			  struct ip_conntrack_expect *exp) {}
+#endif /* __KERNEL__ */
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+#endif /* _IP_CONNTRACK_EVENTS_H */
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_ftp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-07-12 20:39:45.000000000 +0200
@@ -263,7 +263,8 @@
 }
 
 /* We don't update if it's older than what we have. */
-static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
+static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir,
+			  struct sk_buff *skb)
 {
 	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
 
@@ -277,10 +278,13 @@
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
@@ -440,7 +444,7 @@
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
 	if (ends_in_nl)
-		update_nl_seq(seq, ct_ftp_info,dir);
+		update_nl_seq(seq, ct_ftp_info,dir, *pskb);
  out:
 	UNLOCK_BH(&ip_ftp_lock);
 	return ret;
Index: davem-2.6/net/ipv4/netfilter/Kconfig
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/Kconfig	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/Kconfig	2005-07-12 20:40:38.000000000 +0200
@@ -692,5 +692,15 @@
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
 
Index: davem-2.6/include/linux/netfilter.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter.h	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/include/linux/netfilter.h	2005-06-30 19:14:03.000000000 +0200
@@ -22,7 +22,7 @@
 #define NF_MAX_VERDICT NF_STOP
 
 /* Generic cache responses from hook functions.
-   <= 0x2000 is used for protocol-flags. */
+   <= 0x2000 is reserved for conntrack event cache. */
 #define NFC_UNKNOWN 0x4000
 #define NFC_ALTERED 0x8000
 
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2005-07-12 20:39:45.000000000 +0200
@@ -89,7 +89,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int icmp_packet(struct ip_conntrack *ct,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       enum ip_conntrack_info ctinfo)
 {
 	/* Try to delete connection immediately after all replies:
@@ -102,6 +102,7 @@
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
 
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_generic.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2005-06-30 19:14:03.000000000 +0200
@@ -49,7 +49,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct ip_conntrack *conntrack,
-		  const struct sk_buff *skb,
+		  struct sk_buff *skb,
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_protocol.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2005-07-12 20:39:45.000000000 +0200
@@ -34,7 +34,7 @@
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo);
 
 	/* Called when a new connection for this protocol found;
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-07-12 20:39:45.000000000 +0200
@@ -310,7 +310,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int sctp_packet(struct ip_conntrack *conntrack,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       enum ip_conntrack_info ctinfo)
 {
 	enum sctp_conntrack newconntrack, oldsctpstate;
@@ -405,6 +405,8 @@
 		}
 
 		conntrack->proto.sctp.state = newconntrack;
+		if (oldsctpstate != newconntrack)
+			ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
 		WRITE_UNLOCK(&sctp_lock);
 	}
 
Index: davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_core.h
===================================================================
--- davem-2.6.orig/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-06-30 19:14:03.000000000 +0200
@@ -39,10 +39,14 @@
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
Index: davem-2.6/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- davem-2.6.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-30 19:14:02.000000000 +0200
+++ davem-2.6/net/ipv4/netfilter/ip_conntrack_core.c	2005-07-12 20:39:45.000000000 +0200
@@ -76,6 +76,11 @@
 static LIST_HEAD(unconfirmed);
 static int ip_conntrack_vmalloc;
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+struct notifier_block *ip_conntrack_chain;
+struct notifier_block *ip_conntrack_expect_chain;
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 void 
@@ -157,6 +162,7 @@
 {
 	struct ip_conntrack_expect *exp = (void *)ul_expect;
 
+	ip_conntrack_expect_event(IPEXP_TIMEOUT, exp);
 	WRITE_LOCK(&ip_conntrack_lock);
 	unlink_expect(exp);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -230,6 +236,9 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
+	set_bit(IPS_DESTROYED_BIT, &ct->status);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -381,6 +390,15 @@
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		CONNTRACK_STAT_INC(insert);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		if (ct->helper)
+			ip_conntrack_event_cache(IPCT_HELPER, *pskb);
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+		if (IPS_NAT_DONE_MASK & ct->status)
+			ip_conntrack_event_cache(IPCT_NATINFO, *pskb);
+#endif
+		ip_conntrack_event_cache(master_ct(ct) ?
+					 IPCT_RELATED : IPCT_NEW, *pskb);
+
 		return NF_ACCEPT;
 	}
 
@@ -630,6 +648,8 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
+	ip_conntrack_event_cache_init(*pskb);
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -681,8 +701,8 @@
 		return -ret;
 	}
 
-	if (set_reply)
-		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
+		ip_conntrack_event_cache(IPCT_STATUS, *pskb);
 
 	return ret;
 }
@@ -802,7 +822,7 @@
 int ip_conntrack_expect_related(struct ip_conntrack_expect *expect)
 {
 	struct ip_conntrack_expect *i;
-	int ret;
+	int ret, inserted = 0;
 
 	DEBUGP("ip_conntrack_expect_related %p\n", related_to);
 	DEBUGP("tuple: "); DUMP_TUPLE(&expect->tuple);
@@ -830,9 +850,12 @@
 		evict_oldest_expect(expect->master);
 
 	ip_conntrack_expect_insert(expect);
+	inserted = 1;
 	ret = 0;
 out:
 	WRITE_UNLOCK(&ip_conntrack_lock);
+	if (inserted)
+		ip_conntrack_expect_event(IPEXP_NEW, expect);
  	return ret;
 }
 
@@ -915,7 +938,7 @@
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void ip_ct_refresh_acct(struct ip_conntrack *ct, 
 		        enum ip_conntrack_info ctinfo,
-			const struct sk_buff *skb,
+			struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
@@ -930,6 +953,7 @@
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_event_cache(IPCT_REFRESH, skb);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);

--------------050800030807010103000208--
