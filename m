From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] conntrack event notifiers for nf_conntrack
Date: Mon, 24 Jan 2005 01:57:14 +0100
Message-ID: <41F447E9.6090309@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030905010703090307070704"
Cc: KOVACS Krisztian <hidden@balabit.hu>
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
--------------030905010703090307070704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I've ported the conntrack event notification API[1] to nf_conntrack. 
Anyway, I'll try to keep a updated version for ip_conntrack (which won't 
be ever merged into the mainline) since it's useful for Krisztian 
Kovacs' ct_sync works.

Expect more patches that port my lastest posted stuff to nf_conntrack soon.

References:
[1] 
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017453.html

--
Pablo

--------------030905010703090307070704
Content-Type: text/x-patch;
 name="notifiers-nf_conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="notifiers-nf_conntrack.patch"

--- nf_conntrack-orig/include/linux/netfilter.h	2005-01-24 01:31:46.000000000 +0100
+++ nf_conntrack/include/linux/netfilter.h	2005-01-24 01:32:32.000000000 +0100
@@ -21,7 +21,7 @@
 #define NF_MAX_VERDICT NF_REPEAT
 
 /* Generic cache responses from hook functions.
-   <= 0x2000 is used for protocol-flags. */
+   <= 0x2000 is reserved for conntrack event cache. */
 #define NFC_UNKNOWN 0x4000
 #define NFC_ALTERED 0x8000
 
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/include/linux/netfilter/nf_conntrack_core.h nf_conntrack/include/linux/netfilter/nf_conntrack_core.h
--- nf_conntrack-orig/include/linux/netfilter/nf_conntrack_core.h	2005-01-13 23:14:48.000000000 +0100
+++ nf_conntrack/include/linux/netfilter/nf_conntrack_core.h	2005-01-23 22:38:35.000000000 +0100
@@ -55,11 +55,13 @@
 /* Confirm a connection: returns NF_DROP if packet must be dropped. */
 static inline int nf_conntrack_confirm(struct sk_buff *skb)
 {
-	if (skb->nfct
-	    && !is_confirmed((struct nf_conn *)skb->nfct))
-		return __nf_conntrack_confirm(skb);
+	int ret = NF_ACCEPT;
 
-	return NF_ACCEPT;
+ 	if (skb->nfct && !is_confirmed((struct nf_conn *)skb->nfct))
+		ret = __nf_conntrack_confirm(skb);
+	nf_conntrack_deliver_cached_events(skb);
+
+	return ret;
 }
 
 extern void __nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb);
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/include/linux/netfilter/nf_conntrack.h nf_conntrack/include/linux/netfilter/nf_conntrack.h
--- nf_conntrack-orig/include/linux/netfilter/nf_conntrack.h	2005-01-13 23:14:48.000000000 +0100
+++ nf_conntrack/include/linux/netfilter/nf_conntrack.h	2005-01-23 15:47:10.000000000 +0100
@@ -54,6 +54,58 @@
 	/* Connection is confirmed: originating packet has left box */
 	NF_S_CONFIRMED_BIT = 3,
 	NF_S_CONFIRMED = (1 << NF_S_CONFIRMED_BIT),
+
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	NF_S_DESTROYED_BIT = 4,
+	NF_S_DESTROYED = (1 << NF_S_DESTROYED_BIT),
+};
+
+/* Connection tracking event bits */
+enum nf_conntrack_events
+{
+	/* New conntrack */
+	NFCT_NEW_BIT = 0,
+	NFCT_NEW = (1 << NFCT_NEW_BIT),
+
+	/* Expected connection */
+	NFCT_RELATED_BIT = 1,
+	NFCT_RELATED = (1 << NFCT_RELATED_BIT),
+
+	/* Destroyed conntrack */
+	NFCT_DESTROY_BIT = 2,
+	NFCT_DESTROY = (1 << NFCT_DESTROY_BIT),
+
+	/* Timer has been refreshed */
+	NFCT_REFRESH_BIT = 3,
+	NFCT_REFRESH = (1 << NFCT_REFRESH_BIT),
+
+	/* Status has changed */
+	NFCT_STATUS_BIT = 4,
+	NFCT_STATUS = (1 << NFCT_STATUS_BIT),
+
+	/* Update of protocol info */
+	NFCT_PROTOINFO_BIT = 5,
+	NFCT_PROTOINFO = (1 << NFCT_PROTOINFO_BIT),
+
+	/* Volatile protocol info */
+	NFCT_PROTOINFO_VOLATILE_BIT = 6,
+	NFCT_PROTOINFO_VOLATILE = (1 << NFCT_PROTOINFO_VOLATILE_BIT),
+
+	/* New helper for conntrack */
+	NFCT_HELPER_BIT = 7,
+	NFCT_HELPER = (1 << NFCT_HELPER_BIT),
+
+	/* Update of helper info */
+	NFCT_HELPINFO_BIT = 8,
+	NFCT_HELPINFO = (1 << NFCT_HELPINFO_BIT),
+
+	/* Volatile helper info */
+	NFCT_HELPINFO_VOLATILE_BIT = 9,
+	NFCT_HELPINFO_VOLATILE = (1 << NFCT_HELPINFO_VOLATILE_BIT),
+
+	/* NAT info */
+	NFCT_NATINFO_BIT = 10,
+	NFCT_NATINFO = (1 << NFCT_NATINFO_BIT),
 };
 
 #include <linux/netfilter/nf_conntrack_tcp.h>
@@ -260,7 +312,7 @@
 /* Refresh conntrack for this many jiffies */
 extern void nf_ct_refresh_acct(struct nf_conn *ct,
 			       enum nf_conntrack_info ctinfo,
-			       const struct sk_buff *skb,
+			       struct sk_buff *skb,
 			       unsigned long extra_jiffies);
 
 /* These are for NAT.  Icky. */
@@ -283,6 +335,11 @@
 	return test_bit(NF_S_CONFIRMED_BIT, &ct->status);
 }
 
+static inline int is_destroyed(struct nf_conn *ct)
+{
+	return test_bit(NF_S_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int nf_conntrack_htable_size;
 
 struct nf_conntrack_stat
@@ -306,6 +363,57 @@
 
 #define NF_CT_STAT_INC(count) (__get_cpu_var(nf_conntrack_stat).count++)
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+ 
+extern struct notifier_block *nf_conntrack_chain;
+ 
+static inline int nf_conntrack_register_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_register(&nf_conntrack_chain, nb);
+}
+
+static inline int nf_conntrack_unregister_notifier(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&nf_conntrack_chain, nb);
+}
+
+static inline void nf_conntrack_event_cache_init(struct sk_buff *skb)
+{
+	/* Set to zero first 14 bits, see netfilter.h */
+	skb->nfcache &= 0xc000;
+}
+
+static inline void 
+nf_conntrack_event_cache(enum nf_conntrack_events event, struct sk_buff *skb)
+{
+	skb->nfcache |= event;
+}
+
+static inline void 
+nf_conntrack_deliver_cached_events(struct sk_buff *skb)
+{
+	struct nf_conn *ct = (struct nf_conn *) skb->nfct;
+
+	if (ct != NULL && is_confirmed(ct) && !is_destroyed(ct) && skb->nfcache)
+		notifier_call_chain(&nf_conntrack_chain, skb->nfcache, ct);
+}
+
+static inline void nf_conntrack_event(enum nf_conntrack_events event,
+				      struct nf_conn *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&nf_conntrack_chain, event, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline void nf_conntrack_event_cache_init(struct sk_buff *skb) {}
+static inline void nf_conntrack_event_cache(enum nf_conntrack_events event,
+					    struct sk_buff *skb) {}
+static inline void nf_conntrack_event(enum nf_conntrack_events event,
+				      struct nf_conn *ct) {}
+static inline void nf_conntrack_deliver_cached_events(struct sk_buff *skb) {}
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
         int needs_nf_conntrack_##name;                  \
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/include/linux/netfilter/nf_conntrack_helper.h nf_conntrack/include/linux/netfilter/nf_conntrack_helper.h
--- nf_conntrack-orig/include/linux/netfilter/nf_conntrack_helper.h	2005-01-13 23:14:48.000000000 +0100
+++ nf_conntrack/include/linux/netfilter/nf_conntrack_helper.h	2005-01-23 15:18:43.000000000 +0100
@@ -33,7 +33,7 @@
 	
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
-	int (*help)(const struct sk_buff *skb,
+	int (*help)(struct sk_buff *skb,
 		    unsigned int dataoff,
 		    struct nf_conn *ct,
 		    enum nf_conntrack_info conntrackinfo);
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/include/linux/netfilter/nf_conntrack_protocol.h nf_conntrack/include/linux/netfilter/nf_conntrack_protocol.h
--- nf_conntrack-orig/include/linux/netfilter/nf_conntrack_protocol.h	2005-01-13 23:14:48.000000000 +0100
+++ nf_conntrack/include/linux/netfilter/nf_conntrack_protocol.h	2005-01-23 14:40:52.000000000 +0100
@@ -48,7 +48,7 @@
 
 	/* Returns verdict for packet, or -1 for invalid. */
 	int (*packet)(struct nf_conn *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum nf_conntrack_info ctinfo,
 		      int pf,
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c nf_conntrack/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
--- nf_conntrack-orig/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-01-23 15:32:59.000000000 +0100
+++ nf_conntrack/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c	2005-01-23 15:43:25.000000000 +0100
@@ -113,6 +113,7 @@
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
+		nf_conntrack_event_cache(NFCT_PROTOINFO_VOLATILE, skb);
 	}
 
 	return NF_ACCEPT;
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/Kconfig nf_conntrack/net/netfilter/Kconfig
--- nf_conntrack-orig/net/netfilter/Kconfig	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/Kconfig	2005-01-23 14:41:44.000000000 +0100
@@ -65,4 +65,26 @@
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NF_CONNTRACK_EVENTS
+	bool "Connection tracking events"
+	depends on NF_CONNTRACK
+	help
+	  If this option is enabled, the connection tracking code will
+	  provide a notifier chain that can be used by other kernel code
+	  to get notified about changes in the connection tracking state.
+	  
+	  IF unsure, say `N'.
+
 endmenu
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_core.c nf_conntrack/net/netfilter/nf_conntrack_core.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_core.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_core.c	2005-01-24 01:36:18.000000000 +0100
@@ -41,6 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
 #include <linux/socket.h>
+#include <linux/notifier.h>
 
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -80,6 +81,10 @@
 struct nf_conn nf_conntrack_untracked;
 unsigned int nf_ct_log_invalid;
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+struct notifier_block *nf_conntrack_chain;
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct nf_conntrack_stat, nf_conntrack_stat);
 EXPORT_PER_CPU_SYMBOL(nf_conntrack_stat);
 
@@ -505,6 +510,8 @@
 	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
 	NF_CT_ASSERT(!timer_pending(&ct->timeout));
 
+	set_bit(NF_S_DESTROYED_BIT, &ct->status);
+
 	/* To make sure we don't get any weird locking issues here:
 	 * destroy_conntrack() MUST NOT be called with a write lock
 	 * to nf_conntrack_lock!!! -HW */
@@ -550,7 +557,7 @@
 {
 	struct nf_conn *ct = (void *)ul_conntrack;
 
-
+	nf_conntrack_event(NFCT_DESTROY, ct);
 	WRITE_LOCK(&nf_conntrack_lock);
 	/* Inside lock so preempt is disabled on module removal path.
 	 * Otherwise we can get spurious warnings. */
@@ -664,6 +671,15 @@
 		set_bit(NF_S_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&nf_conntrack_lock);
 		NF_CT_STAT_INC(insert);
+		if (ct->helper)
+			nf_conntrack_event_cache(NFCT_HELPER, skb);
+#ifdef CONFIG_NF_NAT_NEEDED
+		/* I Know, NAT isn't implemented yet */
+		if (ct->nat.info.initialized)
+			nf_conntrack_event_cache(NFCT_NATINFO, skb);
+#endif
+		nf_conntrack_event_cache(master_ct(ct) ?
+					 NFCT_RELATED : NFCT_NEW, skb);
 		return NF_ACCEPT;
 	}
 
@@ -960,6 +976,8 @@
 		return ret;
 	}
 
+	nf_conntrack_event_cache_init(*pskb);
+	
 	proto = nf_ct_find_proto((u_int16_t)pf, protonum);
 	DEBUGP("protonum = %u\n", protonum);
 
@@ -1012,8 +1030,10 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
-		set_bit(NF_S_SEEN_REPLY_BIT, &ct->status);
+	if (set_reply && !test_bit(NF_S_SEEN_REPLY_BIT, &ct->status)) {
+ 		set_bit(NF_S_SEEN_REPLY_BIT, &ct->status);
+		nf_conntrack_event_cache(NFCT_STATUS, *pskb);
+	}
 
 	return ret;
 }
@@ -1321,6 +1341,7 @@
 	if (i->ctrack->helper == me) {
 		/* Get rid of any expected. */
 		remove_expectations(i->ctrack, 0);
+		nf_conntrack_event(NFCT_HELPER, i->ctrack);
 		/* And *then* set helper to NULL */
 		i->ctrack->helper = NULL;
 	}
@@ -1363,7 +1384,7 @@
 /* Refresh conntrack for this many jiffies and do accounting (if skb != NULL) */
 void nf_ct_refresh_acct(struct nf_conn *ct,
 			enum nf_conntrack_info ctinfo,
-			const struct sk_buff *skb,
+			struct sk_buff *skb,
 			unsigned long extra_jiffies)
 {
 	NF_CT_ASSERT(ct->timeout.data == (unsigned long)ct);
@@ -1378,6 +1399,7 @@
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			nf_conntrack_event_cache(NFCT_REFRESH, skb);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&nf_conntrack_lock);
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_ftp.c nf_conntrack/net/netfilter/nf_conntrack_ftp.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_ftp.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_ftp.c	2005-01-23 15:18:54.000000000 +0100
@@ -385,7 +385,7 @@
 	return 1;
 }
 
-static int help(const struct sk_buff *skb,
+static int help(struct sk_buff *skb,
 		unsigned int protoff,
 		struct nf_conn *ct,
 		enum nf_conntrack_info ctinfo)
@@ -441,6 +441,7 @@
 			ct_ftp_info->seq_aft_nl[dir] = 
 						ntohl(th->seq) + datalen;
 			ct_ftp_info->seq_aft_nl_set[dir] = 1;
+			nf_conntrack_event_cache(NFCT_HELPINFO_VOLATILE, skb);
 		}
 	}
 
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_proto_generic.c nf_conntrack/net/netfilter/nf_conntrack_proto_generic.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_proto_generic.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_proto_generic.c	2005-01-23 15:19:01.000000000 +0100
@@ -54,7 +54,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int packet(struct nf_conn *conntrack,
-		  const struct sk_buff *skb,
+		  struct sk_buff *skb,
 		  unsigned int dataoff,
 		  enum nf_conntrack_info ctinfo,
 		  int pf,
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_proto_sctp.c nf_conntrack/net/netfilter/nf_conntrack_proto_sctp.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_proto_sctp.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_proto_sctp.c	2005-01-23 15:06:20.000000000 +0100
@@ -316,7 +316,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int sctp_packet(struct nf_conn *conntrack,
-		       const struct sk_buff *skb,
+		       struct sk_buff *skb,
 		       unsigned int dataoff,
 		       enum nf_conntrack_info ctinfo,
 		       int pf,
@@ -412,6 +412,8 @@
 			conntrack->proto.sctp.vtag[NF_CT_DIR_ORIGINAL] = ih->init_tag;
 		}
 
+		if (oldsctpstate != newconntrack)
+			nf_conntrack_event_cache(NFCT_PROTOINFO, skb);
 		conntrack->proto.sctp.state = newconntrack;
 		WRITE_UNLOCK(&sctp_lock);
 	}
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_proto_tcp.c nf_conntrack/net/netfilter/nf_conntrack_proto_tcp.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_proto_tcp.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_proto_tcp.c	2005-01-23 15:15:18.000000000 +0100
@@ -875,7 +875,7 @@
 
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct nf_conn *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum nf_conntrack_info ctinfo,
 		      int pf,
@@ -995,6 +995,10 @@
 		  ? nf_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
+	nf_conntrack_event_cache(NFCT_PROTOINFO_VOLATILE, skb);
+	if (new_state != old_state)
+		nf_conntrack_event_cache(NFCT_PROTOINFO, skb);
+
 	if (!test_bit(NF_S_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_proto_udp.c nf_conntrack/net/netfilter/nf_conntrack_proto_udp.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_proto_udp.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_proto_udp.c	2005-01-23 15:09:06.000000000 +0100
@@ -71,7 +71,7 @@
 
 /* Returns verdict for packet, and may modify conntracktype */
 static int udp_packet(struct nf_conn *conntrack,
-		      const struct sk_buff *skb,
+		      struct sk_buff *skb,
 		      unsigned int dataoff,
 		      enum nf_conntrack_info ctinfo,
 		      int pf,
@@ -84,6 +84,10 @@
 				   nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		set_bit(NF_S_ASSURED_BIT, &conntrack->status);
+		if (!test_bit(NF_S_ASSURED_BIT, &conntrack->status)) {
+			set_bit(NF_S_ASSURED_BIT, &conntrack->status);
+			nf_conntrack_event_cache(NFCT_STATUS, skb);
+		}
 	} else
 		nf_ct_refresh_acct(conntrack, ctinfo, skb, nf_ct_udp_timeout);
 
diff -Nru --exclude='*cmd.c' --exclude='*.ko' --exclude='*.cmd' --exclude='*.o' --exclude=Makefile --exclude=SCCS --exclude='*.rej' --exclude='*.d' --exclude='*.mod.c' --exclude='*.orig' --exclude='nf_netlink*' nf_conntrack-orig/net/netfilter/nf_conntrack_standalone.c nf_conntrack/net/netfilter/nf_conntrack_standalone.c
--- nf_conntrack-orig/net/netfilter/nf_conntrack_standalone.c	2005-01-13 23:14:12.000000000 +0100
+++ nf_conntrack/net/netfilter/nf_conntrack_standalone.c	2005-01-23 15:08:05.000000000 +0100
@@ -787,6 +787,11 @@
 {
 }
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+EXPORT_SYMBOL(nf_conntrack_chain);
+EXPORT_SYMBOL(nf_conntrack_register_notifier);
+EXPORT_SYMBOL(nf_conntrack_unregister_notifier);
+#endif
 EXPORT_SYMBOL(nf_conntrack_l3proto_register);
 EXPORT_SYMBOL(nf_conntrack_l3proto_unregister);
 EXPORT_SYMBOL(nf_conntrack_protocol_register);

--------------030905010703090307070704--
