From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] connection tracking event per packet
Date: Wed, 17 Nov 2004 00:07:48 +0100
Message-ID: <419A8844.4010208@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010501020507060904080209"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	KOVACS Krisztian <hidden@balabit.hu>
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
--------------010501020507060904080209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've finished the first version of the conntrack event per packet patch, 
I've been testing it and I didn't find any problem at the moment.

It includes 11 events, still 3 bits free for further use. Four of them 
should provide enough info handle expectations replication.

IPCT_RELATED:  expectaction has arrived
IPCT_HELPER: new helper set to a master conntrack
IPCT_HELPINFO: update helper private info
IPCT_HELPINFO_VOLATILE: update helper private info, it could be picked 
up, so mostly ignored.

All the events for confirmed conntracks are delivered in 
__ip_conntrack_confirm.

Three functions to send events:

ip_conntrack_event: send an asynchronous event, for example, conntrack 
destruction.
ip_conntrack_event_cache: set event in the per packet cache.
ip_conntrack_deliver_cached_events: deliver events! :-)

Two functions exported:

ip_conntrack_register_notifier
ip_conntrack_unregister_notifier

See that I'm sending nat events in __ip_conntrack_confirm because 
alter_reply doesn't have a skb as parameter and I didn't want to trash 
ip_nat_setup_info/ip_conntrack_alter_reply with a new parameter (a 
pointer to a skb). Same thing for the helper event and all 
ip_ct_find_helper.

I've removed the pick up stuff for TCP which I've inserted in my 
previous patch since I think that at this moment it's enough leaving 
ip_ct_tcp_loose set to 3. If someone wants a stateful firewalls which 
doesn't pick up TCP connection by default, just during the take over, I 
can recover the pick up feature. Later.

Comments welcome.

--
Pablo

--------------010501020507060904080209
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== include/linux/netfilter.h 1.13 vs edited =====
--- 1.13/include/linux/netfilter.h	2004-10-26 00:47:56 +02:00
+++ edited/include/linux/netfilter.h	2004-11-16 00:29:14 +01:00
@@ -21,7 +21,7 @@
 #define NF_MAX_VERDICT NF_REPEAT
 
 /* Generic cache responses from hook functions.
-   <= 0x2000 is used for protocol-flags. */
+   <= 0x2000 is reserved for conntrack event cache. */
 #define NFC_UNKNOWN 0x4000
 #define NFC_ALTERED 0x8000
 
===== include/linux/netfilter_ipv4.h 1.7 vs edited =====
--- 1.7/include/linux/netfilter_ipv4.h	2004-03-30 06:24:38 +02:00
+++ edited/include/linux/netfilter_ipv4.h	2004-11-16 00:16:44 +01:00
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
===== include/linux/netfilter_ipv4/ip_conntrack.h 1.24 vs edited =====
--- 1.24/include/linux/netfilter_ipv4/ip_conntrack.h	2004-10-21 06:13:43 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	2004-11-16 01:16:04 +01:00
@@ -47,6 +47,58 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT = 3,
 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
+
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	IPS_DESTROYED_BIT = 4,
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
 
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
@@ -263,7 +315,7 @@
 /* Refresh conntrack for this many jiffies */
 extern void ip_ct_refresh_acct(struct ip_conntrack *ct,
 			       enum ip_conntrack_info ctinfo,
-			       const struct sk_buff *skb,
+			       struct sk_buff *skb,
 			       unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
@@ -294,6 +346,11 @@
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int ip_conntrack_htable_size;
  
 struct ip_conntrack_stat
@@ -316,6 +373,57 @@
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
 
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
===== include/linux/netfilter_ipv4/ip_conntrack_core.h 1.11 vs edited =====
--- 1.11/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-09-23 23:42:34 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_core.h	2004-11-16 01:15:20 +01:00
@@ -39,10 +39,14 @@
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int ip_conntrack_confirm(struct sk_buff *skb)
 {
+	int ret = NF_ACCEPT;
+	
 	if (skb->nfct
 	    && !is_confirmed((struct ip_conntrack *)skb->nfct))
-		return __ip_conntrack_confirm(skb);
-	return NF_ACCEPT;
+		ret = __ip_conntrack_confirm(skb);
+	ip_conntrack_deliver_cached_events(skb);
+
+	return ret;
 }
 
 extern struct list_head *ip_conntrack_hash;
===== include/linux/netfilter_ipv4/ip_conntrack_protocol.h 1.10 vs edited =====
--- 1.10/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-09-23 23:42:34 +02:00
+++ edited/include/linux/netfilter_ipv4/ip_conntrack_protocol.h	2004-11-15 00:06:01 +01:00
@@ -34,7 +34,7 @@
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo);
 
 	/* Called when a new connection for this protocol found;
===== net/ipv4/netfilter/Kconfig 1.32 vs edited =====
--- 1.32/net/ipv4/netfilter/Kconfig	2004-10-22 07:34:33 +02:00
+++ edited/net/ipv4/netfilter/Kconfig	2004-11-15 00:06:01 +01:00
@@ -732,5 +732,15 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
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
 
===== net/ipv4/netfilter/ip_conntrack_proto_icmp.c 1.14 vs edited =====
--- 1.14/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-09-26 23:20:28 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	2004-11-15 00:06:01 +01:00
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
 
===== net/ipv4/netfilter/ip_conntrack_proto_generic.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-09-13 02:00:29 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_generic.c	2004-11-15 00:06:01 +01:00
@@ -49,7 +49,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct ip_conntrack *conntrack,
-		  const struct sk_buff *skb,
+		  struct sk_buff *skb,
 		  enum ip_conntrack_info ctinfo)
 {
 	ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_generic_timeout);
===== net/ipv4/netfilter/ip_conntrack_proto_sctp.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-09-26 23:17:15 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2004-11-15 00:06:01 +01:00
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
 
===== net/ipv4/netfilter/ip_conntrack_core.c 1.73 vs edited =====
--- 1.73/net/ipv4/netfilter/ip_conntrack_core.c	2004-10-29 01:35:43 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	2004-11-15 00:27:25 +01:00
@@ -37,6 +37,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -75,6 +76,10 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+struct notifier_block *ip_conntrack_chain;
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 inline void 
@@ -287,6 +292,8 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
 
+	set_bit(IPS_DESTROYED_BIT, &ct->status);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to ip_conntrack_lock!!! -HW */
@@ -327,6 +334,7 @@
 {
 	struct ip_conntrack *ct = (void *)ul_conntrack;
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
@@ -436,6 +444,14 @@
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		CONNTRACK_STAT_INC(insert);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+		if (ct->helper)
+			ip_conntrack_event_cache(IPCT_HELPER, skb);
+#ifdef CONFIG_IP_NF_NAT_NEEDED
+		if (ct->nat.info.initialized)
+			ip_conntrack_event_cache(IPCT_NATINFO, skb);
+#endif
+		ip_conntrack_event_cache(master_ct(ct) ?
+					 IPCT_RELATED : IPCT_NEW, skb);
 		return NF_ACCEPT;
 	}
 
@@ -708,6 +724,8 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
+	ip_conntrack_event_cache_init(*pskb);
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -769,8 +787,10 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
+	if (set_reply && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		ip_conntrack_event_cache(IPCT_STATUS, *pskb);
+	}
 
 	return ret;
 }
@@ -1052,6 +1072,7 @@
 	if (i->ctrack->helper == me) {
 		/* Get rid of any expected. */
 		remove_expectations(i->ctrack, 0);
+		ip_conntrack_event(IPCT_HELPER, i->ctrack);
 		/* And *then* set helper to NULL */
 		i->ctrack->helper = NULL;
 	}
@@ -1092,7 +1113,7 @@
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void ip_ct_refresh_acct(struct ip_conntrack *ct, 
 		        enum ip_conntrack_info ctinfo,
-			const struct sk_buff *skb,
+			struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
 	IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);
@@ -1107,6 +1128,7 @@
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_event_cache(IPCT_REFRESH, skb);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.24 vs edited =====
--- 1.24/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-10-20 10:12:06 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	2004-11-15 23:51:26 +01:00
@@ -300,6 +300,7 @@
 			ct_ftp_info->seq_aft_nl[dir] = 
 						ntohl(th->seq) + datalen;
 			ct_ftp_info->seq_aft_nl_set[dir] = 1;
+			ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
 		}
 	}
 
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.53 vs edited =====
--- 1.53/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-10-21 06:13:43 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-11-15 00:06:01 +01:00
@@ -880,6 +880,11 @@
 {
 }
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL(ip_conntrack_chain);
+EXPORT_SYMBOL(ip_conntrack_register_notifier);
+EXPORT_SYMBOL(ip_conntrack_unregister_notifier);
+#endif
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(invert_tuplepr);
===== net/ipv4/netfilter/ip_conntrack_proto_tcp.c 1.24 vs edited =====
--- 1.24/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-10-20 08:10:29 +02:00
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2004-11-15 00:06:01 +01:00
@@ -824,7 +824,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	enum tcp_conntrack new_state, old_state;
@@ -942,6 +942,10 @@
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
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_udp.c	2004-11-15 00:06:01 +01:00
@@ -64,7 +64,7 @@
 
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct ip_conntrack *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      enum ip_conntrack_info ctinfo)
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
@@ -73,7 +73,10 @@
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			ip_conntrack_event_cache(IPCT_STATUS, skb);
+		}
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 

--------------010501020507060904080209--
