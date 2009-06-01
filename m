From: Jan Kasprzak <kas@fi.muni.cz>
Subject: [RFD,patch] ICMP echo conntrack timeout
Date: Mon, 1 Jun 2009 19:43:52 +0200
Message-ID: <20090601174352.GH31797@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:54961 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZFARw6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:52:58 -0400
Received: from anxur.fi.muni.cz (anxur.fi.muni.cz [147.251.48.3])
	by minas.ics.muni.cz (8.13.8/8.13.8/SuSE Linux 0.8) with ESMTP id n51HhqJq015309
	for <netfilter-devel@vger.kernel.org>; Mon, 1 Jun 2009 19:43:53 +0200
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

	Hello, netfilter developers!

I am trying to delploy a conntrackd-based HA router and (if possible) a
flow statistics collector. I have discovered that nf_conntrack treats each
ICMP echo request/reply pair as a separate connection (in
net/ipv4/netfilter/nf_conntrack_proto_icmp.c:icmp_packet() function).
This has several problems:

- excessive conntrackd traffic when the ping is running over the router
	(one new "connection" per echo request/reply pair).

- should there be a duplicated ICMP echo reply (such as when when pinging
	a cluster IP address), only the first echo reply is seen as
	ESTABLISHED, the rest is INVALID.

- no "per-flow" statistics available, as there is no notion of the "flow"		at all.

	I think it would be better to keep the default timeout of
nf_ct_icmp_timeout even after the echo reply is received. Feel free
to correct me why early deleting of ICMP conntrack entries is needed,
or consider applying the following patch.

	Thanks,

-Yenya

From: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Date: Mon, 1 Jun 2009 18:53:20 +0200
Subject: [PATCH] [nf_conntrack] Keep the ICMP ct entries longer

Current conntrack code kills the ICMP conntrack entry as soon as
the first reply is received. This is incorrect, as we then see only
the first ICMP echo reply out of several possible duplicates as
ESTABLISHED, while the rest will be INVALID. Also this unnecessarily
increases the conntrackd traffic on H-A firewalls.

Make all the ICMP conntrack entries (including the replied ones)
last for the default of nf_conntrack_icmp{,v6}_timeout seconds.

Signed-off-by: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
---
 include/net/netfilter/ipv4/nf_conntrack_icmp.h   |   11 -----------
 include/net/netfilter/ipv6/nf_conntrack_icmpv6.h |    7 -------
 include/net/netfilter/nf_conntrack.h             |    3 ---
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c     |   18 ++++++------------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c   |   18 ++++++------------
 5 files changed, 12 insertions(+), 45 deletions(-)
 delete mode 100644 include/net/netfilter/ipv4/nf_conntrack_icmp.h

diff --git a/include/net/netfilter/ipv4/nf_conntrack_icmp.h b/include/net/netfilter/ipv4/nf_conntrack_icmp.h
deleted file mode 100644
index 3dd22cf..0000000
--- a/include/net/netfilter/ipv4/nf_conntrack_icmp.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _NF_CONNTRACK_ICMP_H
-#define _NF_CONNTRACK_ICMP_H
-/* ICMP tracking. */
-#include <asm/atomic.h>
-
-struct ip_ct_icmp
-{
-	/* Optimization: when number in == number out, forget immediately. */
-	atomic_t count;
-};
-#endif /* _NF_CONNTRACK_ICMP_H */
diff --git a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h b/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
index 86591af..67edd50 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_icmpv6.h
@@ -9,7 +9,6 @@
 
 #ifndef _NF_CONNTRACK_ICMPV6_H
 #define _NF_CONNTRACK_ICMPV6_H
-#include <asm/atomic.h>
 
 #ifndef ICMPV6_NI_QUERY
 #define ICMPV6_NI_QUERY 139
@@ -18,10 +17,4 @@
 #define ICMPV6_NI_REPLY 140
 #endif
 
-struct nf_ct_icmpv6
-{
-	/* Optimization: when number in == number out, forget immediately. */
-	atomic_t count;
-};
-
 #endif /* _NF_CONNTRACK_ICMPV6_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 6c3f964..6d2ee38 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -23,7 +23,6 @@
 #include <linux/netfilter/nf_conntrack_dccp.h>
 #include <linux/netfilter/nf_conntrack_sctp.h>
 #include <linux/netfilter/nf_conntrack_proto_gre.h>
-#include <net/netfilter/ipv4/nf_conntrack_icmp.h>
 #include <net/netfilter/ipv6/nf_conntrack_icmpv6.h>
 
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -34,8 +33,6 @@ union nf_conntrack_proto {
 	struct nf_ct_dccp dccp;
 	struct ip_ct_sctp sctp;
 	struct ip_ct_tcp tcp;
-	struct ip_ct_icmp icmp;
-	struct nf_ct_icmpv6 icmpv6;
 	struct nf_ct_gre gre;
 };
 
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index 23b2c2e..41b6655 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -82,18 +82,13 @@ static int icmp_packet(struct nf_conn *ct,
 		       u_int8_t pf,
 		       unsigned int hooknum)
 {
-	/* Try to delete connection immediately after all replies:
-	   won't actually vanish as we still have skb, and del_timer
-	   means this will only run once even if count hits zero twice
-	   (theoretically possible with SMP) */
-	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill_acct(ct, ctinfo, skb);
-	} else {
-		atomic_inc(&ct->proto.icmp.count);
+	/* Do not immediately delete the connection after the first
+	   successful reply to avoid excessive conntrackd traffic
+	   and also to handle correctly ICMP echo reply duplicates. */
+	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_REPLY)
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
-	}
+
+	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
 
 	return NF_ACCEPT;
 }
@@ -117,7 +112,6 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		nf_ct_dump_tuple_ip(&ct->tuplehash[0].tuple);
 		return false;
 	}
-	atomic_set(&ct->proto.icmp.count, 0);
 	return true;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 9903227..4a91da9 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -95,18 +95,13 @@ static int icmpv6_packet(struct nf_conn *ct,
 		       u_int8_t pf,
 		       unsigned int hooknum)
 {
-	/* Try to delete connection immediately after all replies:
-	   won't actually vanish as we still have skb, and del_timer
-	   means this will only run once even if count hits zero twice
-	   (theoretically possible with SMP) */
-	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY) {
-		if (atomic_dec_and_test(&ct->proto.icmp.count))
-			nf_ct_kill_acct(ct, ctinfo, skb);
-	} else {
-		atomic_inc(&ct->proto.icmp.count);
+	/* Do not immediately delete the connection after the first
+	   successful reply to avoid excessive conntrackd traffic
+	   and also to handle correctly ICMP echo reply duplicates. */
+	if (CTINFO2DIR(ctinfo) != IP_CT_DIR_REPLY)
 		nf_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, ct);
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
-	}
+
+	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
 
 	return NF_ACCEPT;
 }
@@ -132,7 +127,6 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 				      type + 128);
 		return false;
 	}
-	atomic_set(&ct->proto.icmp.count, 0);
 	return true;
 }
 
-- 
1.6.0.6






-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>> If we wanted to trade simplicity and kewl design for usability I think <<
>> we all know the URL of the Apple Store.               --jmorris42 @LWN <<
