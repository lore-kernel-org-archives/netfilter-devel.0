From: Jan Kasprzak <kas@fi.muni.cz>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Sun, 7 Jun 2009 03:03:53 +0200
Message-ID: <20090607010353.GR27616@fi.muni.cz>
References: <20090601174352.GH31797@fi.muni.cz> <4A28F784.7030200@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from minas.ics.muni.cz ([147.251.4.40]:43058 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZFGBDz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jun 2009 21:03:55 -0400
Content-Disposition: inline
In-Reply-To: <4A28F784.7030200@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Patrick McHardy wrote:
: Jan Kasprzak wrote:
: >From: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
: >Date: Mon, 1 Jun 2009 18:53:20 +0200
: >Subject: [PATCH] [nf_conntrack] Keep the ICMP ct entries longer
: 
: Your patch doesn't apply to the latest tree. Could you rediff against
: git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-next-2.6.git
: please?

	Yes, patch attached.

-Yenya

-- 
| Jan "Yenya" Kasprzak  <kas at {fi.muni.cz - work | yenya.net - private}> |
| GPG: ID 1024/D3498839      Fingerprint 0D99A7FB206605D7 8B35FCDE05B18A5E |
| http://www.fi.muni.cz/~kas/    Journal: http://www.fi.muni.cz/~kas/blog/ |
>> If we wanted to trade simplicity and kewl design for usability I think <<
>> we all know the URL of the Apple Store.               --jmorris42 @LWN <<

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001--nf_conntrack-Keep-the-ICMP-ct-entries-longer.patch"

>From 3413b225e0c0950ba6e76f7be863eb90e95a78e3 Mon Sep 17 00:00:00 2001
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
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c     |   16 ++++------------
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c   |   16 ++++------------
 5 files changed, 8 insertions(+), 45 deletions(-)
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
index 2ba36dd..2b87737 100644
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
index c6ab3d9..d71ba76 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -82,17 +82,10 @@ static int icmp_packet(struct nf_conn *ct,
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
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
-	}
+	/* Do not immediately delete the connection after the first
+	   successful reply to avoid excessive conntrackd traffic
+	   and also to handle correctly ICMP echo reply duplicates. */
+	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmp_timeout);
 
 	return NF_ACCEPT;
 }
@@ -116,7 +109,6 @@ static bool icmp_new(struct nf_conn *ct, const struct sk_buff *skb,
 		nf_ct_dump_tuple_ip(&ct->tuplehash[0].tuple);
 		return false;
 	}
-	atomic_set(&ct->proto.icmp.count, 0);
 	return true;
 }
 
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index a0acd96..642dcb1 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -95,17 +95,10 @@ static int icmpv6_packet(struct nf_conn *ct,
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
-		nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
-	}
+	/* Do not immediately delete the connection after the first
+	   successful reply to avoid excessive conntrackd traffic
+	   and also to handle correctly ICMP echo reply duplicates. */
+	nf_ct_refresh_acct(ct, ctinfo, skb, nf_ct_icmpv6_timeout);
 
 	return NF_ACCEPT;
 }
@@ -131,7 +124,6 @@ static bool icmpv6_new(struct nf_conn *ct, const struct sk_buff *skb,
 				      type + 128);
 		return false;
 	}
-	atomic_set(&ct->proto.icmp.count, 0);
 	return true;
 }
 
-- 
1.6.0.6


--qMm9M+Fa2AknHoGS--
