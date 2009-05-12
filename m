From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 13:52:22 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:57130 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbZELLwY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 07:52:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick and Pablo,

The patch adds support to control the in-kernel event generation.
In practice we face two problems: we should support a fine-grained
event generation in netfilter, in order to be able to catch and follow
the different state changes. At the same time, for example for conntrack
replication, a too fine-grained event generation can easily result in
a high, unnecessary system load. BFP and/or userspace event filtering
is not effective enough to avoid it: the resources are already burnt
on building up the netlink messages.

The patch solves the problem by adding the full power of iptables
to select which traffic should generate events and by adding new
options to the CONNMARK target to specify exactly which events should
be generated for the selected traffic.

The downsize is that extra 16 bit required in the nf_conn structure to
store the selected event flags.

The events were a little bit reorganized as well:

- IPCT_STATUS is split into IPCT_SEEN_REPLY and IPCT_ASSURED, to express
  exactly the state change in conntrack
- IPCT_PROTOINFO_VOLATILE renamed to IPCT_ICMP_PROTOINFO, mainly
  to get a shorter name ;-)
- IPCT_HELPINFO_VOLATILE, IPCT_NATINFO and IPCT_COUNTER_FILLING
  are dropped
- IPEXP_REFRESH and IPEXP_TIMEOUT are added to cover the expectation
  events.

The single unresolved issue is backward incompatibility: should a module
parameter or a sysctl flag be added to the patch to specify the old
behaviour (i.e. generate events unconditionally)?

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/nf_conntrack_common.h  |   63 ++++++++++-------
 include/linux/netfilter/xt_CONNMARK.h          |   10 +++-
 include/net/netfilter/nf_conntrack.h           |    4 +
 include/net/netfilter/nf_conntrack_ecache.h    |   14 +++-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/nf_conntrack_core.c              |    7 +--
 net/netfilter/nf_conntrack_expect.c            |    1 +
 net/netfilter/nf_conntrack_ftp.c               |    4 +-
 net/netfilter/nf_conntrack_netlink.c           |   12 +++-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c         |    3 +-
 net/netfilter/nf_conntrack_proto_udp.c         |    2 +-
 net/netfilter/nf_conntrack_proto_udplite.c     |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    1 +
 net/netfilter/xt_CONNMARK.c                    |   92 +++++++++++++++++++++++-
 17 files changed, 172 insertions(+), 51 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 885cbe2..41a74de 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -94,19 +94,25 @@ enum ip_conntrack_events
 	IPCT_REFRESH_BIT = 3,
 	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
 
-	/* Status has changed */
-	IPCT_STATUS_BIT = 4,
-	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
+	/* Assured bit is set */
+	IPCT_ASSURED_BIT = 4,
+	IPCT_ASSURED = (1 << IPCT_ASSURED_BIT),
 
-	/* Update of protocol info */
+	/* Backward compatibility */
+	IPCT_STATUS = IPCT_ASSURED,
+
+	/* Protocol state info */
 	IPCT_PROTOINFO_BIT = 5,
 	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
 
-	/* Volatile protocol info */
-	IPCT_PROTOINFO_VOLATILE_BIT = 6,
-	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
+	/* ICMP(v6) protocol info */
+	IPCT_ICMP_PROTOINFO_BIT = 6,
+	IPCT_ICMP_PROTOINFO = (1 << IPCT_ICMP_PROTOINFO_BIT),
+
+	/* Backward compatibility */
+	IPCT_PROTOINFO_VOLATILE = IPCT_ICMP_PROTOINFO,
 
-	/* New helper for conntrack */
+	/* Helper for conntrack added/removed */
 	IPCT_HELPER_BIT = 7,
 	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
 
@@ -114,34 +120,41 @@ enum ip_conntrack_events
 	IPCT_HELPINFO_BIT = 8,
 	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
 
-	/* Volatile helper info */
-	IPCT_HELPINFO_VOLATILE_BIT = 9,
-	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
-
-	/* NAT info */
-	IPCT_NATINFO_BIT = 10,
-	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
-
-	/* Counter highest bit has been set, unused */
-	IPCT_COUNTER_FILLING_BIT = 11,
-	IPCT_COUNTER_FILLING = (1 << IPCT_COUNTER_FILLING_BIT),
+	/* Seen reply packet */
+	IPCT_SEEN_REPLY_BIT = 9,
+	IPCT_SEEN_REPLY = (1 << IPCT_SEEN_REPLY_BIT),
 
 	/* Mark is set */
-	IPCT_MARK_BIT = 12,
+	IPCT_MARK_BIT = 10,
 	IPCT_MARK = (1 << IPCT_MARK_BIT),
 
 	/* NAT sequence adjustment */
-	IPCT_NATSEQADJ_BIT = 13,
+	IPCT_NATSEQADJ_BIT = 11,
 	IPCT_NATSEQADJ = (1 << IPCT_NATSEQADJ_BIT),
 
 	/* Secmark is set */
-	IPCT_SECMARK_BIT = 14,
+	IPCT_SECMARK_BIT = 12,
 	IPCT_SECMARK = (1 << IPCT_SECMARK_BIT),
-};
+	
+	/* All conntrack event bits */
+	IPCT_ALL_BIT = 13,
+	IPCT_ALL = ((1 << IPCT_ALL_BIT) - 1),
 
-enum ip_conntrack_expect_events {
-	IPEXP_NEW_BIT = 0,
+	/* New expectation created */
+	IPEXP_NEW_BIT = 13,
 	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
+
+	/* Timer has been refreshed */
+	IPEXP_REFRESH_BIT = 14,
+	IPEXP_REFRESH = (1 << IPEXP_REFRESH_BIT),
+
+	/* Expectation timed out */
+	IPEXP_TIMEOUT_BIT = 15,
+	IPEXP_TIMEOUT = (1 << IPEXP_TIMEOUT_BIT),
+
+	/* All expectation event bits */
+	IPEXP_ALL_BIT = 16,
+	IPEXP_ALL = (((1 << IPEXP_ALL_BIT) - 1) & ~IPCT_ALL)
 };
 
 #ifdef __KERNEL__
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 7635c8f..0ecbc85 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -15,7 +15,8 @@
 enum {
 	XT_CONNMARK_SET = 0,
 	XT_CONNMARK_SAVE,
-	XT_CONNMARK_RESTORE
+	XT_CONNMARK_RESTORE,
+	XT_CONNMARK_EVENT_ONLY
 };
 
 struct xt_connmark_target_info {
@@ -29,4 +30,11 @@ struct xt_connmark_tginfo1 {
 	__u8 mode;
 };
 
+struct xt_connmark_tginfo2 {
+	__u32 ctmark, ctmask, nfmask;
+	__u8 mode;
+	__u8 events;
+	__u16 eventmask;
+};
+
 #endif /*_XT_CONNMARK_H_target*/
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6c3f964..bf8b156 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -117,6 +117,10 @@ struct nf_conn {
 	u_int32_t secmark;
 #endif
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	u_int16_t eventmask;
+#endif
+
 	/* Storage reserved for other modules: */
 	union nf_conntrack_proto proto;
 
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0ff0dc6..15a1018 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -38,6 +38,9 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *ecache;
 
+	if (!(ct->eventmask & event & IPCT_ALL))
+		return;
+
 	local_bh_disable();
 	ecache = per_cpu_ptr(net->ct.ecache, raw_smp_processor_id());
 	if (ct != ecache->ct)
@@ -57,7 +60,9 @@ nf_conntrack_event_report(enum ip_conntrack_events event,
 		.pid	= pid,
 		.report = report
 	};
-	if (nf_ct_is_confirmed(ct) && !nf_ct_is_dying(ct))
+	if (nf_ct_is_confirmed(ct)
+	    && !nf_ct_is_dying(ct)
+	    && (ct->eventmask & event & IPCT_ALL))
 		atomic_notifier_call_chain(&nf_conntrack_chain, event, &item);
 }
 
@@ -78,7 +83,7 @@ extern int nf_ct_expect_register_notifier(struct notifier_block *nb);
 extern int nf_ct_expect_unregister_notifier(struct notifier_block *nb);
 
 static inline void
-nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
+nf_ct_expect_event_report(enum ip_conntrack_events event,
 			  struct nf_conntrack_expect *exp,
 			  u32 pid,
 			  int report)
@@ -88,11 +93,12 @@ nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 		.pid	= pid,
 		.report = report
 	};
-	atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
+	if (exp->master && (exp->master->exp_eventmask & event & IPEXP_ALL))
+		atomic_notifier_call_chain(&nf_ct_expect_chain, event, &item);
 }
 
 static inline void
-nf_ct_expect_event(enum ip_conntrack_expect_events event,
+nf_ct_expect_event(enum ip_conntrack_events event,
 		   struct nf_conntrack_expect *exp)
 {
 	nf_ct_expect_event_report(event, exp, 0, 0);
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 23b2c2e..fc6c56f 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -91,7 +91,7 @@ static int icmp_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
-		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
+		nf_conntrack_event_cache(IPCT_ICMP_PROTOINFO, ct);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
 	}
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 9903227..d359a0d 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -104,7 +104,7 @@ static int icmpv6_packet(struct nf_conn *ct,
 			nf_ct_kill_acct(ct, ctinfo, skb);
 	} else {
 		atomic_inc(&ct->proto.icmp.count);
-		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
+		nf_conntrack_event_cache(IPCT_ICMP_PROTOINFO, ct);
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
 	}
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 8020db6..1aec311 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -398,11 +398,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	help = nfct_help(ct);
 	if (help && help->helper)
 		nf_conntrack_event_cache(IPCT_HELPER, ct);
-#ifdef CONFIG_NF_NAT_NEEDED
-	if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
-	    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
-		nf_conntrack_event_cache(IPCT_NATINFO, ct);
-#endif
 	nf_conntrack_event_cache(master_ct(ct) ?
 				 IPCT_RELATED : IPCT_NEW, ct);
 	return NF_ACCEPT;
@@ -756,7 +751,7 @@ nf_conntrack_in(struct net *net, u_int8_t pf, unsigned int hooknum,
 	}
 
 	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
-		nf_conntrack_event_cache(IPCT_STATUS, ct);
+		nf_conntrack_event_cache(IPCT_SEEN_REPLY, ct);
 
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index afde8f9..0f0513b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -62,6 +62,7 @@ static void nf_ct_expectation_timed_out(unsigned long ul_expect)
 	struct nf_conntrack_expect *exp = (void *)ul_expect;
 
 	spin_lock_bh(&nf_conntrack_lock);
+	nf_ct_expect_event(IPEXP_TIMEOUT, exp);
 	nf_ct_unlink_expect(exp);
 	spin_unlock_bh(&nf_conntrack_lock);
 	nf_ct_expect_put(exp);
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 00fecc3..c4f12ad 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -338,11 +338,11 @@ static void update_nl_seq(struct nf_conn *ct, u32 nl_seq,
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
-		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
+		nf_conntrack_event_cache(IPCT_HELPINFO, ct);
 	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
 		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
-		nf_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, ct);
+		nf_conntrack_event_cache(IPCT_HELPINFO, ct);
 	}
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index fd77619..e52c36f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -494,6 +494,9 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 	if (ct == &nf_conntrack_untracked)
 		return NOTIFY_DONE;
 
+	/* ignore events explicitly not wanted */
+	events &= ct->eventmask;
+
 	if (events & IPCT_DESTROY) {
 		type = IPCTNL_MSG_CT_DELETE;
 		group = NFNLGRP_CONNTRACK_DESTROY;
@@ -501,7 +504,7 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		type = IPCTNL_MSG_CT_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
+	} else  if (events & (IPCT_ASSURED | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
@@ -1367,7 +1370,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 			else
 				events = IPCT_NEW;
 
-			nf_conntrack_event_report(IPCT_STATUS |
+			nf_conntrack_event_report(IPCT_ASSURED |
 						  IPCT_HELPER |
 						  IPCT_PROTOINFO |
 						  IPCT_NATSEQADJ |
@@ -1392,7 +1395,7 @@ ctnetlink_new_conntrack(struct sock *ctnl, struct sk_buff *skb,
 		if (err == 0) {
 			nf_conntrack_get(&ct->ct_general);
 			spin_unlock_bh(&nf_conntrack_lock);
-			nf_conntrack_event_report(IPCT_STATUS |
+			nf_conntrack_event_report(IPCT_ASSURED |
 						  IPCT_HELPER |
 						  IPCT_PROTOINFO |
 						  IPCT_NATSEQADJ |
@@ -1545,6 +1548,9 @@ static int ctnetlink_expect_event(struct notifier_block *this,
 	sk_buff_data_t b;
 	int flags = 0;
 
+	/* ignore events explicitly not wanted */
+	events &= exp->master->exp_eventmask;
+
 	if (events & IPEXP_NEW) {
 		type = IPCTNL_MSG_EXP_NEW;
 		flags = NLM_F_CREATE|NLM_F_EXCL;
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 117b801..e93d827 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -242,7 +242,7 @@ static int gre_packet(struct nf_conn *ct,
 				   ct->proto.gre.stream_timeout);
 		/* Also, more likely to be important, and not a probe. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_STATUS, ct);
+		nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   ct->proto.gre.timeout);
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 101b4ad..d5ef276 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -380,7 +380,7 @@ static int sctp_packet(struct nf_conn *ct,
 	    new_state == SCTP_CONNTRACK_ESTABLISHED) {
 		pr_debug("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_STATUS, ct);
+		nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	}
 
 	return NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b5ccf2b..96fddc7 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -974,7 +974,6 @@ static int tcp_packet(struct nf_conn *ct,
 		timeout = tcp_timeouts[new_state];
 	write_unlock_bh(&tcp_lock);
 
-	nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
 	if (new_state != old_state)
 		nf_conntrack_event_cache(IPCT_PROTOINFO, ct);
 
@@ -995,7 +994,7 @@ static int tcp_packet(struct nf_conn *ct,
 		   after SYN_RECV or a valid answer for a picked up
 		   connection. */
 		set_bit(IPS_ASSURED_BIT, &ct->status);
-		nf_conntrack_event_cache(IPCT_STATUS, ct);
+		nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	}
 	nf_ct_refresh_acct(ct, ctinfo, skb, timeout);
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 70809d1..d5499a5 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -77,7 +77,7 @@ static int udp_packet(struct nf_conn *ct,
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
-			nf_conntrack_event_cache(IPCT_STATUS, ct);
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udp_timeout);
 
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 0badedc..b277cea 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -75,7 +75,7 @@ static int udplite_packet(struct nf_conn *ct,
 				   nf_ct_udplite_timeout_stream);
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
-			nf_conntrack_event_cache(IPCT_STATUS, ct);
+			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else
 		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_udplite_timeout);
 
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4b57216..6014b01 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -701,6 +701,7 @@ static int refresh_signalling_expectation(struct nf_conn *ct,
 		exp->flags &= ~NF_CT_EXPECT_INACTIVE;
 		exp->timeout.expires = jiffies + expires * HZ;
 		add_timer(&exp->timeout);
+		nf_ct_expect_event(IPEXP_REFRESH, exp);
 		found = 1;
 		break;
 	}
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index d6e5ab4..86bc5ea 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -75,7 +75,7 @@ connmark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 }
 
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
+connmark_tg_v1(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct xt_connmark_tginfo1 *info = par->targinfo;
 	enum ip_conntrack_info ctinfo;
@@ -112,6 +112,48 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
+static unsigned int
+connmark_tg_v2(struct sk_buff *skb, const struct xt_target_param *par)
+{
+	const struct xt_connmark_tginfo2 *info = par->targinfo;
+	enum ip_conntrack_info ctinfo;
+	struct nf_conn *ct;
+	u_int32_t newmark;
+
+	ct = nf_ct_get(skb, &ctinfo);
+	if (ct == NULL)
+		return XT_CONTINUE;
+
+#ifdef NF_CONNTRACK_EVENTS
+	if (info->events)
+		ct->eventmask = info->eventmask;
+#endif
+	switch (info->mode) {
+	case XT_CONNMARK_SET:
+		newmark = (ct->mark & ~info->ctmask) ^ info->ctmark;
+		if (ct->mark != newmark) {
+			ct->mark = newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case XT_CONNMARK_SAVE:
+		newmark = (ct->mark & ~info->ctmask) ^
+		          (skb->mark & info->nfmask);
+		if (ct->mark != newmark) {
+			ct->mark = newmark;
+			nf_conntrack_event_cache(IPCT_MARK, ct);
+		}
+		break;
+	case XT_CONNMARK_RESTORE:
+		newmark = (skb->mark & ~info->nfmask) ^
+		          (ct->mark & info->ctmask);
+		skb->mark = newmark;
+		break;
+	}
+
+	return XT_CONTINUE;
+}
+
 static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
 {
 	const struct xt_connmark_target_info *matchinfo = par->targinfo;
@@ -180,6 +222,37 @@ static int connmark_tg_compat_to_user_v0(void __user *dst, void *src)
 	};
 	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
 }
+
+struct compat_xt_connmark_tginfo1 {
+	__u32 ctmark, ctmask, nfmask;
+	__u8 mode;
+	__u8 __pad1;
+	__u16 __pad2;
+};
+
+static void connmark_tg_compat_from_user_v1(void *dst, void *src)
+{
+	const struct compat_xt_connmark_tginfo1 *cm = src;
+	struct xt_connmark_tginfo1 m = {
+		.ctmark	= cm->ctmark,
+		.ctmask	= cm->ctmask,
+		.nfmask = cm->nfmask,
+		.mode	= cm->mode,
+	};
+	memcpy(dst, &m, sizeof(m));
+}
+
+static int connmark_tg_compat_to_user_v1(void __user *dst, void *src)
+{
+	const struct xt_connmark_tginfo1 *m = src;
+	struct compat_xt_connmark_tginfo1 cm = {
+		.ctmark	= m->ctmark,
+		.ctmask	= m->ctmask,
+		.nfmask = m->nfmask,
+		.mode	= m->mode,
+	};
+	return copy_to_user(dst, &cm, sizeof(cm)) ? -EFAULT : 0;
+}
 #endif /* CONFIG_COMPAT */
 
 static struct xt_target connmark_tg_reg[] __read_mostly = {
@@ -203,9 +276,24 @@ static struct xt_target connmark_tg_reg[] __read_mostly = {
 		.revision       = 1,
 		.family         = NFPROTO_UNSPEC,
 		.checkentry     = connmark_tg_check,
-		.target         = connmark_tg,
+		.target         = connmark_tg_v1,
 		.targetsize     = sizeof(struct xt_connmark_tginfo1),
 		.destroy        = connmark_tg_destroy,
+#ifdef CONFIG_COMPAT
+		.compatsize	= sizeof(struct compat_xt_connmark_tginfo1),
+		.compat_from_user = connmark_tg_compat_from_user_v1,
+		.compat_to_user	= connmark_tg_compat_to_user_v1,
+#endif
+		.me             = THIS_MODULE,
+	},
+	{
+		.name           = "CONNMARK",
+		.revision       = 2,
+		.family         = NFPROTO_UNSPEC,
+		.checkentry     = connmark_tg_check,
+		.target         = connmark_tg_v2,
+		.targetsize     = sizeof(struct xt_connmark_tginfo2),
+		.destroy        = connmark_tg_destroy,
 		.me             = THIS_MODULE,
 	},
 };
-- 
1.5.4.3


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
