From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2.6] connection tracking events
Date: Sat, 16 Oct 2004 17:32:33 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41713F11.9020301@eurodev.net>
References: <20041015175406.GK17516@obroa-skai.de.gnumonks.org>
	<41712042.2000505@trash.net>
	<20041016150756.GL29413@sunbeam.de.gnumonks.org>
	<41713C3E.5020200@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000209000700090806020204"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <41713C3E.5020200@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000209000700090806020204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick, Hi Harald,

Patrick McHardy wrote:

> Harald Welte wrote:
>
>> Hi Patrick!
>>
>> On Sat, Oct 16, 2004 at 03:21:06PM +0200, Patrick McHardy wrote:
>>
>>
>>> I've already did this in Erlangen. Pablo is currently working with
>>> Krizstian on this patch.
>>>
>>
>> mh, did you post this to netfilter-devel?  I must have missed it...
>>
> No not yet, I wasn't completely done and Pablo took in on from there.
> He introduced some new events for tcp window tracking, I didn't have
> time to look at it in detail yet. Pablo, could you post your latest
> patch to netfilter-devel ?


Attached the lastest version, I'm having a look at Harald's now to see I 
think that I can take something.

Comments welcome.

regards,
Pablo

--------------000209000700090806020204
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

===== include/linux/netfilter_ipv4/ip_conntrack.h 1.27 vs edited =====
--- 1.27/include/linux/netfilter_ipv4/ip_conntrack.h	Sun Oct 10 21:44:23 2004
+++ edited/include/linux/netfilter_ipv4/ip_conntrack.h	Thu Oct 14 19:46:48 2004
@@ -47,6 +47,12 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT = 3,
 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
+
+	IPS_DESTROYED_BIT = 4,
+	IPS_DESTROYED = (1 << IPS_DESTROYED_BIT),
+
+	IPS_PICKUP_BIT = 5,
+	IPS_PICKUP = (1 << IPS_PICKUP_BIT),
 };
 
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
@@ -290,6 +296,11 @@
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
 extern unsigned int ip_conntrack_htable_size;
  
 struct ip_conntrack_stat
@@ -313,6 +324,68 @@
 
 #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
 
+enum ip_conntrack_events
+{
+	IPCT_NEW,
+	IPCT_RELATED,
+	IPCT_DESTROY,
+	IPCT_STATUS,
+	IPCT_REFRESH,
+ 	IPCT_PROTOINFO,
+	IPCT_PROTOINFO_SOFT,
+ 	IPCT_HELPINFO,
+	IPCT_NATINFO,
+};
+
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+ 
+extern struct notifier_block *ip_conntrack_chain;
+DECLARE_PER_CPU(unsigned long, ip_conntrack_event_cache);
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
+static inline void ip_conntrack_event_cache_init(void)
+{
+	__get_cpu_var(ip_conntrack_event_cache) = 0UL;
+}
+
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event)
+{ 
+	__get_cpu_var(ip_conntrack_event_cache) |= 1 << event;
+}
+
+static inline void ip_conntrack_deliver_cached_events(struct ip_conntrack *ct)
+{
+	unsigned long events = __get_cpu_var(ip_conntrack_event_cache);
+ 
+	if (is_confirmed(ct) && !is_destroyed(ct) && events)
+		notifier_call_chain(&ip_conntrack_chain, events, ct);
+}
+ 
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+                                      struct ip_conntrack *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&ip_conntrack_chain, 1 << event, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline int ip_conntrack_register_notifier(void *nb) { return 0; }
+static inline int ip_conntrack_unregister_notifier(void *nb) { return 0; }
+static inline void ip_conntrack_event_cache_init(void) {}
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event) {}
+static inline void ip_conntrack_deliver_cached_events(struct ip_conntrack *ct) {}
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+                                      struct ip_conntrack *ct) {}
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
         int needs_ip_conntrack_##name;                  \
===== net/ipv4/netfilter/ip_conntrack_proto_icmp.c 1.16 vs edited =====
--- 1.16/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	Sun Oct 10 21:44:20 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	Thu Oct 14 19:30:24 2004
@@ -102,6 +102,7 @@
 			ct->timeout.function((unsigned long)ct);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
+		ip_conntrack_cache_event(IPCT_PROTOINFO);
 		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
 	}
 
===== net/ipv4/netfilter/ip_conntrack_core.c 1.72 vs edited =====
--- 1.72/net/ipv4/netfilter/ip_conntrack_core.c	Sun Oct 10 21:44:21 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Thu Oct 14 19:44:54 2004
@@ -37,6 +37,7 @@
 #include <linux/err.h>
 #include <linux/percpu.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 
 /* This rwlock protects the main hash table, protocol/helper/expected
    registrations, conntrack timers*/
@@ -76,6 +77,11 @@
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+struct notifier_block *ip_conntrack_chain;
+DEFINE_PER_CPU(unsigned long, ip_conntrack_event_cache);
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
 
 inline void 
@@ -330,6 +336,7 @@
 
 	CONNTRACK_STAT_INC(delete_list);
 
+	ip_conntrack_event(IPCT_DESTROY, ct);
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -437,6 +444,7 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+ 		ip_conntrack_event(master_ct(ct)? IPCT_RELATED : IPCT_NEW, ct);
 		CONNTRACK_STAT_INC(insert);
 		return NF_ACCEPT;
 	}
@@ -706,6 +714,8 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |= NFC_UNKNOWN;
 
+	ip_conntrack_event_cache_init();
+
 /* Doesn't cover locally-generated broadcast, so not worth it. */
 #if 0
 	/* Ignore broadcast: no `connection'. */
@@ -767,8 +777,11 @@
 			return NF_ACCEPT;
 		}
 	}
-	if (set_reply)
+	if (set_reply && !test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
+		ip_conntrack_cache_event(IPCT_STATUS);
+	}
+	ip_conntrack_deliver_cached_events(ct);
 
 	return ret;
 }
@@ -1052,6 +1065,7 @@
 		remove_expectations(i->ctrack, 0);
 		/* And *then* set helper to NULL */
 		i->ctrack->helper = NULL;
+		ip_conntrack_event(IPCT_HELPINFO, i->ctrack);
 	}
 	return 0;
 }
@@ -1105,6 +1119,7 @@
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires = jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
+			ip_conntrack_cache_event(IPCT_REFRESH);
 		}
 		ct_add_counters(ct, ctinfo, skb);
 		WRITE_UNLOCK(&ip_conntrack_lock);
===== net/ipv4/netfilter/ip_conntrack_ftp.c 1.27 vs edited =====
--- 1.27/net/ipv4/netfilter/ip_conntrack_ftp.c	Sun Oct 10 21:44:22 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_ftp.c	Thu Oct 14 19:30:24 2004
@@ -300,6 +300,7 @@
 			ct_ftp_info->seq_aft_nl[dir] = 
 						ntohl(th->seq) + datalen;
 			ct_ftp_info->seq_aft_nl_set[dir] = 1;
+			ip_conntrack_cache_event(IPCT_HELPINFO);
 		}
 	}
 
===== net/ipv4/netfilter/ip_conntrack_standalone.c 1.51 vs edited =====
--- 1.51/net/ipv4/netfilter/ip_conntrack_standalone.c	Thu Oct  7 00:11:17 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_standalone.c	Thu Oct 14 19:30:24 2004
@@ -47,6 +47,9 @@
 
 extern atomic_t ip_conntrack_count;
 DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+DECLARE_PER_CPU(unsigned long, ip_conntrack_event_cache);
+#endif
 
 static int kill_proto(const struct ip_conntrack *i, void *data)
 {
@@ -875,6 +878,10 @@
 {
 }
 
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+EXPORT_PER_CPU_SYMBOL(ip_conntrack_event_cache);
+EXPORT_SYMBOL(ip_conntrack_chain);
+#endif
 EXPORT_SYMBOL(ip_conntrack_protocol_register);
 EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
 EXPORT_SYMBOL(invert_tuplepr);
===== net/ipv4/netfilter/ip_conntrack_proto_tcp.c 1.23 vs edited =====
--- 1.23/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Mon Sep 13 02:00:29 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Thu Oct 14 19:30:24 2004
@@ -823,6 +823,32 @@
 	return NF_ACCEPT;
 }
 
+static inline void
+pickup_connection(struct ip_conntrack *conntrack, struct iphdr *iph,
+		  struct tcphdr *th, const struct sk_buff *skb)
+{
+	/*
+	 * We are in the middle of a connection,
+	 * its history is lost for us.
+	 * Let's try to use the data from the packet.
+	 */
+	conntrack->proto.tcp.seen[0].td_end =
+		segment_seq_plus_len(ntohl(th->seq), skb->len, iph, th);
+	conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
+	if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
+		conntrack->proto.tcp.seen[0].td_maxwin = 1;
+	conntrack->proto.tcp.seen[0].td_maxend =
+		conntrack->proto.tcp.seen[0].td_end + 
+		conntrack->proto.tcp.seen[0].td_maxwin;
+	conntrack->proto.tcp.seen[0].td_scale = 0;
+
+	/* We assume SACK. Should we assume window scaling too? */
+	conntrack->proto.tcp.seen[0].flags =
+	conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
+	conntrack->proto.tcp.seen[0].loose = 
+	conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
+}
+
 /* Returns verdict for packet, or -1 for invalid. */
 static int tcp_packet(struct ip_conntrack *conntrack,
 		      const struct sk_buff *skb,
@@ -838,6 +864,11 @@
 	th = skb_header_pointer(skb, iph->ihl * 4,
 				sizeof(_tcph), &_tcph);
 	BUG_ON(th == NULL);
+
+	if (test_bit(IPS_PICKUP_BIT, &conntrack->status)) {
+		pickup_connection(conntrack, iph, th, skb);
+		__clear_bit(IPS_PICKUP_BIT, &conntrack->status);
+	}
 	
 	WRITE_LOCK(&tcp_lock);
 	old_state = conntrack->proto.tcp.state;
@@ -944,6 +975,10 @@
 		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
 	WRITE_UNLOCK(&tcp_lock);
 
+	ip_conntrack_cache_event(IPCT_PROTOINFO);
+	if (new_state != old_state)
+		ip_conntrack_cache_event(IPCT_PROTOINFO_SOFT);
+
 	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		/* If only reply is a RST, we can consider ourselves not to
 		   have an established connection: this is a fairly common
@@ -968,7 +1003,7 @@
 
 	return NF_ACCEPT;
 }
- 
+
   /* Called when a new connection for this protocol found. */
 static int tcp_new(struct ip_conntrack *conntrack,
 		   const struct sk_buff *skb)
@@ -1014,29 +1049,8 @@
 	} else if (ip_ct_tcp_loose == 0) {
 		/* Don't try to pick up connections. */
 		return 0;
-	} else {
-		/*
-		 * We are in the middle of a connection,
-		 * its history is lost for us.
-		 * Let's try to use the data from the packet.
-		 */
-		conntrack->proto.tcp.seen[0].td_end =
-			segment_seq_plus_len(ntohl(th->seq), skb->len,
-					     iph, th);
-		conntrack->proto.tcp.seen[0].td_maxwin = ntohs(th->window);
-		if (conntrack->proto.tcp.seen[0].td_maxwin == 0)
-			conntrack->proto.tcp.seen[0].td_maxwin = 1;
-		conntrack->proto.tcp.seen[0].td_maxend =
-			conntrack->proto.tcp.seen[0].td_end + 
-			conntrack->proto.tcp.seen[0].td_maxwin;
-		conntrack->proto.tcp.seen[0].td_scale = 0;
-
-		/* We assume SACK. Should we assume window scaling too? */
-		conntrack->proto.tcp.seen[0].flags =
-		conntrack->proto.tcp.seen[1].flags = IP_CT_TCP_FLAG_SACK_PERM;
-		conntrack->proto.tcp.seen[0].loose = 
-		conntrack->proto.tcp.seen[1].loose = ip_ct_tcp_loose;
-	}
+	} else 
+		pickup_connection(conntrack, iph, th, skb);
     
 	conntrack->proto.tcp.seen[1].td_end = 0;
 	conntrack->proto.tcp.seen[1].td_maxend = 0;
===== net/ipv4/netfilter/ip_conntrack_proto_udp.c 1.18 vs edited =====
--- 1.18/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Sun Oct 10 21:44:22 2004
+++ edited/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Thu Oct 14 19:30:24 2004
@@ -73,7 +73,10 @@
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
 				   ip_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
-		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		if (!test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
+			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+			ip_conntrack_cache_event(IPCT_STATUS);
+		}
 	} else
 		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
 
===== net/ipv4/netfilter/ip_nat_core.c 1.48 vs edited =====
--- 1.48/net/ipv4/netfilter/ip_nat_core.c	Sun Oct 10 21:44:22 2004
+++ edited/net/ipv4/netfilter/ip_nat_core.c	Thu Oct 14 19:30:24 2004
@@ -607,6 +607,7 @@
 			   IP_NAT_MANIP_SRC, inv_tuple.src });
 		IP_NF_ASSERT(info->num_manips <= IP_NAT_MAX_MANIPS);
 	}
+	ip_conntrack_event(IPCT_NATINFO, conntrack);
 
 	/* If there's a helper, assign it; based on new tuple. */
 	if (!conntrack->master)

--------------000209000700090806020204--
