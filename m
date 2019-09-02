Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E18C0C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CAB922CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="MFYyH2wh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfIBXcK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:10 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43950 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C0FTo3y4qK6TVVUnD2sAOD20+iqhyqJUGkcKbF82RS8=; b=MFYyH2whWXpJS5ugBH7WIEQE3p
        hApB3PprfDSx/2Y4sbFVUsl7O67uKjKuxE4lFRUhXccKlHBuUZUC68Gdk8e5f1gBTv+cuyY3a7FGf
        9euCoW5p0IZj+0Z74jWdvwKqjWPsS3zWGKYVA3YvVGpk0DwNUlm6e3Z/x8dueBm7LHQclyi4quSGH
        t3xoYtQC1rL3hIyEEqv74HLKjdh9pPf+UjH+ZY8uMHoR/BKYUmZNhI89dnapPDLdBOyteyLgRNZ+x
        IDhhEKqMUEHpT/YAFLUwaMEYl5Vtr9jrA4qKCwKDYJM2BqX9/UAaSFLYp2C2cVVmm0QleFaryjLiO
        hiOjpgxQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPT-0004la-Di; Tue, 03 Sep 2019 00:06:55 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 30/30] netfilter: wrap headers in CONFIG checks.
Date:   Tue,  3 Sep 2019 00:06:50 +0100
Message-Id: <20190902230650.14621-31-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190902230650.14621-1-jeremy@azazel.net>
References: <20190902230650.14621-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These headers are only required if some config option is enabled.  Wrap
each one in a check for that option.

This allows us to remove existing CONFIG checks wrapping smaller
sections of code.

In cases where a header includes a related uapi header, we leave that
inclusion outside the conditional in order to avoid having to update
inclusions in other parts of the kernel.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/ipset/ip_set.h        |  7 ++++++-
 include/linux/netfilter/ipset/ip_set_bitmap.h |  4 ++++
 .../linux/netfilter/ipset/ip_set_getport.h    |  4 ++++
 include/linux/netfilter/ipset/ip_set_hash.h   |  3 +++
 include/linux/netfilter/ipset/ip_set_list.h   |  3 +++
 include/linux/netfilter/ipset/pfxlen.h        |  4 ++++
 include/linux/netfilter/nf_conntrack_amanda.h |  6 ++++++
 include/linux/netfilter/nf_conntrack_common.h |  4 ++++
 include/linux/netfilter/nf_conntrack_dccp.h   |  4 ++++
 include/linux/netfilter/nf_conntrack_ftp.h    |  8 +++++++-
 include/linux/netfilter/nf_conntrack_h323.h   |  4 ++++
 .../linux/netfilter/nf_conntrack_h323_asn1.h  |  4 ++++
 .../linux/netfilter/nf_conntrack_h323_types.h |  4 ++++
 include/linux/netfilter/nf_conntrack_irc.h    |  4 ++++
 include/linux/netfilter/nf_conntrack_pptp.h   |  4 ++++
 .../linux/netfilter/nf_conntrack_proto_gre.h  |  6 ++++++
 include/linux/netfilter/nf_conntrack_sane.h   |  5 +++++
 include/linux/netfilter/nf_conntrack_sctp.h   |  5 +++++
 include/linux/netfilter/nf_conntrack_sip.h    |  4 ++++
 include/linux/netfilter/nf_conntrack_snmp.h   |  4 ++++
 include/linux/netfilter/nf_conntrack_tcp.h    |  3 +++
 include/linux/netfilter/nf_conntrack_tftp.h   |  4 ++++
 .../netfilter/nf_conntrack_zones_common.h     |  4 ++++
 include/linux/netfilter/nfnetlink.h           |  7 ++++++-
 include/linux/netfilter/nfnetlink_acct.h      |  6 ++++++
 include/linux/netfilter/nfnetlink_osf.h       |  4 ++++
 include/linux/netfilter/x_tables.h            | 13 ++++++-------
 include/linux/netfilter_arp/arp_tables.h      |  8 +++++++-
 include/linux/netfilter_bridge/ebtables.h     | 10 +++++++---
 include/linux/netfilter_ipv4.h                |  4 ++++
 include/linux/netfilter_ipv4/ip_tables.h      | 15 ++++++++-------
 include/linux/netfilter_ipv6/ip6_tables.h     | 13 ++++++++-----
 include/net/netfilter/br_netfilter.h          | 14 ++++----------
 .../net/netfilter/ipv4/nf_conntrack_ipv4.h    |  4 ++++
 include/net/netfilter/ipv4/nf_defrag_ipv4.h   |  4 ++++
 include/net/netfilter/ipv4/nf_dup_ipv4.h      |  4 ++++
 include/net/netfilter/ipv4/nf_reject.h        |  4 ++++
 .../net/netfilter/ipv6/nf_conntrack_ipv6.h    |  4 ++++
 include/net/netfilter/ipv6/nf_defrag_ipv6.h   |  4 ++++
 include/net/netfilter/ipv6/nf_dup_ipv6.h      |  4 ++++
 include/net/netfilter/ipv6/nf_reject.h        |  4 ++++
 include/net/netfilter/nf_conntrack.h          | 14 ++++----------
 include/net/netfilter/nf_conntrack_acct.h     | 17 +++++------------
 include/net/netfilter/nf_conntrack_bridge.h   |  6 ++++--
 include/net/netfilter/nf_conntrack_core.h     | 19 ++++++++++++-------
 include/net/netfilter/nf_conntrack_count.h    |  4 ++++
 include/net/netfilter/nf_conntrack_ecache.h   | 10 +++++++---
 include/net/netfilter/nf_conntrack_expect.h   |  6 ++++--
 include/net/netfilter/nf_conntrack_extend.h   |  6 +++++-
 include/net/netfilter/nf_conntrack_helper.h   |  6 ++++++
 include/net/netfilter/nf_conntrack_l4proto.h  |  7 +++++--
 include/net/netfilter/nf_conntrack_labels.h   |  4 ++++
 include/net/netfilter/nf_conntrack_seqadj.h   |  4 ++++
 include/net/netfilter/nf_conntrack_synproxy.h |  4 ++++
 include/net/netfilter/nf_conntrack_timeout.h  |  4 ++++
 .../net/netfilter/nf_conntrack_timestamp.h    |  6 +++++-
 include/net/netfilter/nf_conntrack_tuple.h    |  6 ++++--
 include/net/netfilter/nf_dup_netdev.h         |  4 ++++
 include/net/netfilter/nf_flow_table.h         |  8 ++++----
 include/net/netfilter/nf_log.h                |  4 ++++
 include/net/netfilter/nf_nat.h                |  9 +++++----
 include/net/netfilter/nf_nat_helper.h         |  5 +++++
 include/net/netfilter/nf_nat_masquerade.h     |  4 ++++
 include/net/netfilter/nf_nat_redirect.h       |  4 ++++
 include/net/netfilter/nf_queue.h              |  8 ++++----
 include/net/netfilter/nf_reject.h             |  4 ++++
 include/net/netfilter/nf_socket.h             |  4 ++++
 include/net/netfilter/nf_synproxy.h           |  8 ++++----
 include/net/netfilter/nf_tables.h             | 17 +++++------------
 include/net/netfilter/nf_tables_core.h        |  5 +++++
 include/net/netfilter/nf_tables_ipv4.h        |  4 ++++
 include/net/netfilter/nf_tables_ipv6.h        | 10 +++++-----
 include/net/netfilter/nf_tables_offload.h     |  4 ++++
 include/net/netfilter/nf_tproxy.h             |  4 ++++
 include/net/netfilter/nft_fib.h               |  5 +++++
 include/net/netfilter/nft_meta.h              |  4 ++++
 include/net/netfilter/nft_reject.h            |  4 ++++
 include/net/netfilter/xt_rateest.h            |  4 ++++
 78 files changed, 363 insertions(+), 111 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 9bc255a8461b..2884511700a0 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -7,6 +7,10 @@
 #ifndef _IP_SET_H
 #define _IP_SET_H
 
+#include <uapi/linux/netfilter/ipset/ip_set.h>
+
+#if IS_ENABLED(CONFIG_IP_SET)
+
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/netlink.h>
@@ -15,7 +19,6 @@
 #include <linux/stringify.h>
 #include <linux/vmalloc.h>
 #include <net/netlink.h>
-#include <uapi/linux/netfilter/ipset/ip_set.h>
 
 #define _IP_SET_MODULE_DESC(a, b, c)		\
 	MODULE_DESCRIPTION(a " type of IP sets, revisions " b "-" c)
@@ -698,4 +701,6 @@ ip_set_init_skbinfo(struct ip_set_skbinfo *skbinfo,
 #define IPSET_CONCAT(a, b)		a##b
 #define IPSET_TOKEN(a, b)		IPSET_CONCAT(a, b)
 
+#endif /* IS_ENABLED(CONFIG_IP_SET) */
+
 #endif /*_IP_SET_H */
diff --git a/include/linux/netfilter/ipset/ip_set_bitmap.h b/include/linux/netfilter/ipset/ip_set_bitmap.h
index 2dddbc6dcac7..4a7d0dd68cd3 100644
--- a/include/linux/netfilter/ipset/ip_set_bitmap.h
+++ b/include/linux/netfilter/ipset/ip_set_bitmap.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/netfilter/ipset/ip_set_bitmap.h>
 
+#if IS_ENABLED(CONFIG_IP_SET_BITMAP)
+
 #define IPSET_BITMAP_MAX_RANGE	0x0000FFFF
 
 enum {
@@ -26,4 +28,6 @@ range_to_mask(u32 from, u32 to, u8 *bits)
 	return mask;
 }
 
+#endif /* IS_ENABLED(CONFIG_IP_SET_BITMAP) */
+
 #endif /* __IP_SET_BITMAP_H */
diff --git a/include/linux/netfilter/ipset/ip_set_getport.h b/include/linux/netfilter/ipset/ip_set_getport.h
index d74cd112b88a..d47b5a2104b3 100644
--- a/include/linux/netfilter/ipset/ip_set_getport.h
+++ b/include/linux/netfilter/ipset/ip_set_getport.h
@@ -2,6 +2,8 @@
 #ifndef _IP_SET_GETPORT_H
 #define _IP_SET_GETPORT_H
 
+#if IS_ENABLED(CONFIG_IP_SET)
+
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <uapi/linux/in.h>
@@ -35,4 +37,6 @@ static inline bool ip_set_proto_with_ports(u8 proto)
 	return false;
 }
 
+#endif /* IS_ENABLED(CONFIG_IP_SET) */
+
 #endif /*_IP_SET_GETPORT_H*/
diff --git a/include/linux/netfilter/ipset/ip_set_hash.h b/include/linux/netfilter/ipset/ip_set_hash.h
index 838abab672af..fa0cdf8ee8b8 100644
--- a/include/linux/netfilter/ipset/ip_set_hash.h
+++ b/include/linux/netfilter/ipset/ip_set_hash.h
@@ -4,6 +4,7 @@
 
 #include <uapi/linux/netfilter/ipset/ip_set_hash.h>
 
+#if IS_ENABLED(CONFIG_IP_SET_HASH)
 
 #define IPSET_DEFAULT_HASHSIZE		1024
 #define IPSET_MIMINAL_HASHSIZE		64
@@ -11,4 +12,6 @@
 #define IPSET_DEFAULT_PROBES		4
 #define IPSET_DEFAULT_RESIZE		100
 
+#endif /* IS_ENABLED(CONFIG_IP_SET_HASH) */
+
 #endif /* __IP_SET_HASH_H */
diff --git a/include/linux/netfilter/ipset/ip_set_list.h b/include/linux/netfilter/ipset/ip_set_list.h
index a61fe2a7e655..180b6549f811 100644
--- a/include/linux/netfilter/ipset/ip_set_list.h
+++ b/include/linux/netfilter/ipset/ip_set_list.h
@@ -4,9 +4,12 @@
 
 #include <uapi/linux/netfilter/ipset/ip_set_list.h>
 
+#if IS_ENABLED(CONFIG_IP_SET_LIST_SET)
 
 #define IP_SET_LIST_DEFAULT_SIZE	8
 #define IP_SET_LIST_MIN_SIZE		4
 #define IP_SET_LIST_MAX_SIZE		65536
 
+#endif /* IS_ENABLED(CONFIG_IP_SET_LIST_SET) */
+
 #endif /* __IP_SET_LIST_H */
diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
index f59094e6158b..7b9408e911e1 100644
--- a/include/linux/netfilter/ipset/pfxlen.h
+++ b/include/linux/netfilter/ipset/pfxlen.h
@@ -2,6 +2,8 @@
 #ifndef _PFXLEN_H
 #define _PFXLEN_H
 
+#if IS_ENABLED(CONFIG_IP_SET)
+
 #include <asm/byteorder.h>
 #include <linux/netfilter.h>
 #include <net/tcp.h>
@@ -51,4 +53,6 @@ ip6_netmask(union nf_inet_addr *ip, u8 prefix)
 	ip->ip6[3] &= ip_set_netmask6(prefix)[3];
 }
 
+#endif /* IS_ENABLED(CONFIG_IP_SET) */
+
 #endif /*_PFXLEN_H */
diff --git a/include/linux/netfilter/nf_conntrack_amanda.h b/include/linux/netfilter/nf_conntrack_amanda.h
index 6f0ac896fcc9..8a4ac5fe25d0 100644
--- a/include/linux/netfilter/nf_conntrack_amanda.h
+++ b/include/linux/netfilter/nf_conntrack_amanda.h
@@ -1,8 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_CONNTRACK_AMANDA_H
 #define _NF_CONNTRACK_AMANDA_H
+
 /* AMANDA tracking. */
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_AMANDA)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -13,4 +16,7 @@ extern unsigned int (*nf_nat_amanda_hook)(struct sk_buff *skb,
 					  unsigned int matchoff,
 					  unsigned int matchlen,
 					  struct nf_conntrack_expect *exp);
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_AMANDA) */
+
 #endif /* _NF_CONNTRACK_AMANDA_H */
diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index e142b2b5f1ea..31d10682abbe 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 struct ip_conntrack_stat {
 	unsigned int found;
 	unsigned int invalid;
@@ -19,4 +21,6 @@ struct ip_conntrack_stat {
 	unsigned int search_restart;
 };
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/linux/netfilter/nf_conntrack_dccp.h b/include/linux/netfilter/nf_conntrack_dccp.h
index c509ed76e714..80245ff88321 100644
--- a/include/linux/netfilter/nf_conntrack_dccp.h
+++ b/include/linux/netfilter/nf_conntrack_dccp.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_DCCP_H
 #define _NF_CONNTRACK_DCCP_H
 
+#ifdef CONFIG_NF_CT_PROTO_DCCP
+
 /* Exposed to userspace over nfnetlink */
 enum ct_dccp_states {
 	CT_DCCP_NONE,
@@ -35,4 +37,6 @@ struct nf_ct_dccp {
 	u_int64_t	handshake_seq;
 };
 
+#endif
+
 #endif /* _NF_CONNTRACK_DCCP_H */
diff --git a/include/linux/netfilter/nf_conntrack_ftp.h b/include/linux/netfilter/nf_conntrack_ftp.h
index 0e38302820b9..0d1bb4c15f48 100644
--- a/include/linux/netfilter/nf_conntrack_ftp.h
+++ b/include/linux/netfilter/nf_conntrack_ftp.h
@@ -2,11 +2,14 @@
 #ifndef _NF_CONNTRACK_FTP_H
 #define _NF_CONNTRACK_FTP_H
 
+#include <uapi/linux/netfilter/nf_conntrack_ftp.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_FTP)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <net/netfilter/nf_conntrack_expect.h>
-#include <uapi/linux/netfilter/nf_conntrack_ftp.h>
 #include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define FTP_PORT	21
@@ -33,4 +36,7 @@ extern unsigned int (*nf_nat_ftp_hook)(struct sk_buff *skb,
 				       unsigned int matchoff,
 				       unsigned int matchlen,
 				       struct nf_conntrack_expect *exp);
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_FTP) */
+
 #endif /* _NF_CONNTRACK_FTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 4561ec0fcea4..6435ee527637 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_H323_H
 #define _NF_CONNTRACK_H323_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_H323)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -94,4 +96,6 @@ extern int (*nat_q931_hook) (struct sk_buff *skb, struct nf_conn *ct,
 			     int idx, __be16 port,
 			     struct nf_conntrack_expect *exp);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_H323) */
+
 #endif
diff --git a/include/linux/netfilter/nf_conntrack_h323_asn1.h b/include/linux/netfilter/nf_conntrack_h323_asn1.h
index bd6797f823b2..37aa39e22e9d 100644
--- a/include/linux/netfilter/nf_conntrack_h323_asn1.h
+++ b/include/linux/netfilter/nf_conntrack_h323_asn1.h
@@ -34,6 +34,8 @@
 #ifndef _NF_CONNTRACK_HELPER_H323_ASN1_H_
 #define _NF_CONNTRACK_HELPER_H323_ASN1_H_
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_H323)
+
 /*****************************************************************************
  * H.323 Types
  ****************************************************************************/
@@ -94,4 +96,6 @@ int DecodeMultimediaSystemControlMessage(unsigned char *buf, size_t sz,
 					 MultimediaSystemControlMessage *
 					 mscm);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_H323) */
+
 #endif
diff --git a/include/linux/netfilter/nf_conntrack_h323_types.h b/include/linux/netfilter/nf_conntrack_h323_types.h
index 74c6f9241944..4027361eb1c4 100644
--- a/include/linux/netfilter/nf_conntrack_h323_types.h
+++ b/include/linux/netfilter/nf_conntrack_h323_types.h
@@ -7,6 +7,8 @@
 #ifndef _NF_CONNTRACK_H323_TYPES_H
 #define _NF_CONNTRACK_H323_TYPES_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_H323)
+
 typedef struct TransportAddress_ipAddress {	/* SEQUENCE */
 	int options;		/* No use */
 	unsigned int ip;
@@ -935,4 +937,6 @@ typedef struct RasMessage {	/* CHOICE */
 	};
 } RasMessage;
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_H323) */
+
 #endif /* _NF_CONNTRACK_H323_TYPES_H */
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index d02255f721e1..2ca66e71ccef 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_IRC_H
 #define _NF_CONNTRACK_IRC_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_IRC)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -15,4 +17,6 @@ extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				       unsigned int matchlen,
 				       struct nf_conntrack_expect *exp);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_IRC) */
+
 #endif /* _NF_CONNTRACK_IRC_H */
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index fcc409de31a4..c8e300be2b4c 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -3,6 +3,8 @@
 #ifndef _NF_CONNTRACK_PPTP_H
 #define _NF_CONNTRACK_PPTP_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_PPTP)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
@@ -322,4 +324,6 @@ extern void
 (*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
 			     struct nf_conntrack_expect *exp);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_PPTP) */
+
 #endif /* _NF_CONNTRACK_PPTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index f33aa6021364..0ee9fe25043c 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -1,6 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _CONNTRACK_PROTO_GRE_H
 #define _CONNTRACK_PROTO_GRE_H
+
+#ifdef CONFIG_NF_CT_PROTO_GRE
+
 #include <asm/byteorder.h>
 #include <net/gre.h>
 #include <net/pptp.h>
@@ -31,4 +34,7 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 
 bool gre_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 		      struct net *net, struct nf_conntrack_tuple *tuple);
+
+#endif /* CONFIG_NF_CT_PROTO_GRE */
+
 #endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
index 46c7acd1b4a7..d091f2ad567e 100644
--- a/include/linux/netfilter/nf_conntrack_sane.h
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -1,8 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_CONNTRACK_SANE_H
 #define _NF_CONNTRACK_SANE_H
+
 /* SANE tracking. */
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_SANE)
+
 #define SANE_PORT	6566
 
 enum sane_state {
@@ -15,4 +18,6 @@ struct nf_ct_sane_master {
 	enum sane_state state;
 };
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_SANE) */
+
 #endif /* _NF_CONNTRACK_SANE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 9a33f171aa82..4531a33e6182 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -1,14 +1,19 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_CONNTRACK_SCTP_H
 #define _NF_CONNTRACK_SCTP_H
+
 /* SCTP tracking. */
 
 #include <uapi/linux/netfilter/nf_conntrack_sctp.h>
 
+#ifdef CONFIG_NF_CT_PROTO_SCTP
+
 struct ip_ct_sctp {
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
 };
 
+#endif /* CONFIG_NF_CT_PROTO_SCTP */
+
 #endif /* _NF_CONNTRACK_SCTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index c620521c42bc..b4b4d9f6f168 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -2,6 +2,8 @@
 #ifndef __NF_CONNTRACK_SIP_H__
 #define __NF_CONNTRACK_SIP_H__
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_SIP)
+
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include <net/netfilter/nf_conntrack_expect.h>
@@ -195,4 +197,6 @@ int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
 			  enum sdp_header_types term,
 			  unsigned int *matchoff, unsigned int *matchlen);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_SIP) */
+
 #endif /* __NF_CONNTRACK_SIP_H__ */
diff --git a/include/linux/netfilter/nf_conntrack_snmp.h b/include/linux/netfilter/nf_conntrack_snmp.h
index 87e4f33eb55f..276328ed68f7 100644
--- a/include/linux/netfilter/nf_conntrack_snmp.h
+++ b/include/linux/netfilter/nf_conntrack_snmp.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_SNMP_H
 #define _NF_CONNTRACK_SNMP_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_SNMP)
+
 #include <linux/netfilter.h>
 #include <linux/skbuff.h>
 
@@ -10,4 +12,6 @@ extern int (*nf_nat_snmp_hook)(struct sk_buff *skb,
 				struct nf_conn *ct,
 				enum ip_conntrack_info ctinfo);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_SNMP) */
+
 #endif /* _NF_CONNTRACK_SNMP_H */
diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index f9e3a663037b..136cbd3999f8 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -4,6 +4,7 @@
 
 #include <uapi/linux/netfilter/nf_conntrack_tcp.h>
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 
 struct ip_ct_tcp_state {
 	u_int32_t	td_end;		/* max of seq + len */
@@ -30,4 +31,6 @@ struct ip_ct_tcp {
 	u_int8_t	last_flags;	/* Last flags set */
 };
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_TCP_H */
diff --git a/include/linux/netfilter/nf_conntrack_tftp.h b/include/linux/netfilter/nf_conntrack_tftp.h
index dc4c1b9beac0..6db39d3501bb 100644
--- a/include/linux/netfilter/nf_conntrack_tftp.h
+++ b/include/linux/netfilter/nf_conntrack_tftp.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_TFTP_H
 #define _NF_CONNTRACK_TFTP_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK_TFTP)
+
 #define TFTP_PORT 69
 
 #include <linux/netfilter.h>
@@ -23,4 +25,6 @@ extern unsigned int (*nf_nat_tftp_hook)(struct sk_buff *skb,
 				        enum ip_conntrack_info ctinfo,
 				        struct nf_conntrack_expect *exp);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK_TFTP) */
+
 #endif /* _NF_CONNTRACK_TFTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_zones_common.h b/include/linux/netfilter/nf_conntrack_zones_common.h
index 4596f9eb2e8f..d92b2c77ee82 100644
--- a/include/linux/netfilter/nf_conntrack_zones_common.h
+++ b/include/linux/netfilter/nf_conntrack_zones_common.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_ZONES_COMMON_H
 #define _NF_CONNTRACK_ZONES_COMMON_H
 
+#ifdef CONFIG_NETFILTER
+
 #include <uapi/linux/netfilter/nf_conntrack_tuple_common.h>
 
 #define NF_CT_DEFAULT_ZONE_ID	0
@@ -25,4 +27,6 @@ extern const struct nf_conntrack_zone nf_ct_zone_dflt;
 
 #endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /* _NF_CONNTRACK_ZONES_COMMON_H */
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index cf09ab37b45b..97fac10f8199 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -2,10 +2,13 @@
 #ifndef _NFNETLINK_H
 #define _NFNETLINK_H
 
+#include <uapi/linux/netfilter/nfnetlink.h>
+
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK)
+
 #include <linux/netlink.h>
 #include <linux/capability.h>
 #include <net/netlink.h>
-#include <uapi/linux/netfilter/nfnetlink.h>
 
 struct nfnl_callback {
 	int (*call)(struct net *net, struct sock *nl, struct sk_buff *skb,
@@ -65,4 +68,6 @@ static inline bool lockdep_nfnl_is_held(__u8 subsys_id)
 #define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
 	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
 
+#endif /* IS_ENABLED(CONFIG_NETFILTER_NETLINK) */
+
 #endif	/* _NFNETLINK_H */
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index beee8bffe49e..c4f11f056af4 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -3,6 +3,9 @@
 #define _NFNL_ACCT_H_
 
 #include <uapi/linux/netfilter/nfnetlink_acct.h>
+
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_ACCT)
+
 #include <net/net_namespace.h>
 
 enum {
@@ -17,4 +20,7 @@ struct nf_acct *nfnl_acct_find_get(struct net *net, const char *filter_name);
 void nfnl_acct_put(struct nf_acct *acct);
 void nfnl_acct_update(const struct sk_buff *skb, struct nf_acct *nfacct);
 int nfnl_acct_overquota(struct net *net, struct nf_acct *nfacct);
+
+#endif /* IS_ENABLED(CONFIG_NETFILTER_NETLINK_ACCT) */
+
 #endif /* _NFNL_ACCT_H */
diff --git a/include/linux/netfilter/nfnetlink_osf.h b/include/linux/netfilter/nfnetlink_osf.h
index 788613f36935..0e23e7ee4cd4 100644
--- a/include/linux/netfilter/nfnetlink_osf.h
+++ b/include/linux/netfilter/nfnetlink_osf.h
@@ -4,6 +4,8 @@
 
 #include <uapi/linux/netfilter/nfnetlink_osf.h>
 
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_OSF)
+
 enum osf_fmatch_states {
 	/* Packet does not match the fingerprint */
 	FMATCH_WRONG = 0,
@@ -35,4 +37,6 @@ bool nf_osf_find(const struct sk_buff *skb,
 		 const struct list_head *nf_osf_fingers,
 		 const int ttl_check, struct nf_osf_data *data);
 
+#endif /* IS_ENABLED(CONFIG_NETFILTER_NETLINK_OSF) */
+
 #endif /* _NFOSF_H */
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b9bc25f57c8e..65216379a398 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -2,11 +2,13 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
 
+#include <uapi/linux/netfilter/x_tables.h>
+
+#ifdef CONFIG_NETFILTER
 
 #include <linux/netdevice.h>
 #include <linux/static_key.h>
 #include <linux/netfilter.h>
-#include <uapi/linux/netfilter/x_tables.h>
 
 /* Test a struct->invflags and a boolean for inequality */
 #define NF_INVF(ptr, flag, boolean)					\
@@ -35,15 +37,12 @@ struct xt_action_param {
 	union {
 		const void *matchinfo, *targinfo;
 	};
-#if IS_ENABLED(CONFIG_NETFILTER)
 	const struct nf_hook_state *state;
-#endif
 	int fragoff;
 	unsigned int thoff;
 	bool hotdrop;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *xt_net(const struct xt_action_param *par)
 {
 	return par->state->net;
@@ -78,7 +77,6 @@ static inline u_int8_t xt_family(const struct xt_action_param *par)
 {
 	return par->state->pf;
 }
-#endif
 
 /**
  * struct xt_mtchk_param - parameters for match extensions'
@@ -450,9 +448,7 @@ xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
 	return cnt;
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 struct nf_hook_ops *xt_hook_ops_alloc(const struct xt_table *, nf_hookfn *);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
@@ -536,4 +532,7 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int next_offset);
 
 #endif /* CONFIG_COMPAT */
+
+#endif /* CONFIG_NETFILTER */
+
 #endif /* _X_TABLES_H */
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 1b7b35bb9c27..24e473120493 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -9,11 +9,14 @@
 #ifndef _ARPTABLES_H
 #define _ARPTABLES_H
 
+#include <uapi/linux/netfilter_arp/arp_tables.h>
+
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
+
 #include <linux/if.h>
 #include <linux/in.h>
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
-#include <uapi/linux/netfilter_arp/arp_tables.h>
 
 /* Standard entry. */
 struct arpt_standard {
@@ -79,4 +82,7 @@ compat_arpt_get_target(struct compat_arpt_entry *e)
 }
 
 #endif /* CONFIG_COMPAT */
+
+#endif /* CONFIG_NETFILTER_FAMILY_ARP */
+
 #endif /* _ARPTABLES_H */
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index b5b2d371f0ef..d12a175a7b9a 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -13,9 +13,12 @@
 #ifndef __LINUX_BRIDGE_EFF_H
 #define __LINUX_BRIDGE_EFF_H
 
+#include <uapi/linux/netfilter_bridge/ebtables.h>
+
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
+
 #include <linux/if.h>
 #include <linux/if_ether.h>
-#include <uapi/linux/netfilter_bridge/ebtables.h>
 
 struct ebt_match {
 	struct list_head list;
@@ -105,7 +108,7 @@ struct ebt_table {
 
 #define EBT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) & \
 		     ~(__alignof__(struct _xt_align)-1))
-#if IS_ENABLED(CONFIG_NETFILTER)
+
 extern int ebt_register_table(struct net *net,
 			      const struct ebt_table *table,
 			      const struct nf_hook_ops *ops,
@@ -115,7 +118,6 @@ extern void ebt_unregister_table(struct net *net, struct ebt_table *table,
 extern unsigned int ebt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct ebt_table *table);
-#endif
 
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
@@ -128,4 +130,6 @@ static inline bool ebt_invalid_target(int target)
 	return (target < -NUM_STANDARD_TARGETS || target >= 0);
 }
 
+#endif /* CONFIG_NETFILTER_FAMILY_BRIDGE */
+
 #endif
diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index cab891485752..ed8f17ae1fed 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -7,6 +7,8 @@
 
 #include <uapi/linux/netfilter_ipv4.h>
 
+#ifdef CONFIG_NETFILTER
+
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
  */
@@ -39,4 +41,6 @@ static inline int nf_ip_route(struct net *net, struct dst_entry **dst,
 }
 #endif /* CONFIG_INET */
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /*__LINUX_IP_NETFILTER_H*/
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 0b0d43ad9ed9..b9eb9165a7cb 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -15,21 +15,21 @@
 #ifndef _IPTABLES_H
 #define _IPTABLES_H
 
+#include <uapi/linux/netfilter_ipv4/ip_tables.h>
+
+#if IS_ENABLED(CONFIG_IP_NF_IPTABLES)
+
 #include <linux/if.h>
 #include <linux/in.h>
+#include <linux/init.h>
 #include <linux/ip.h>
 #include <linux/skbuff.h>
 
-#include <linux/init.h>
-#include <uapi/linux/netfilter_ipv4/ip_tables.h>
-
-#if IS_ENABLED(CONFIG_NETFILTER)
 int ipt_register_table(struct net *net, const struct xt_table *table,
 		       const struct ipt_replace *repl,
 		       const struct nf_hook_ops *ops, struct xt_table **res);
 void ipt_unregister_table(struct net *net, struct xt_table *table,
 			  const struct nf_hook_ops *ops);
-#endif
 
 /* Standard entry. */
 struct ipt_standard {
@@ -65,11 +65,9 @@ struct ipt_error {
 }
 
 extern void *ipt_alloc_initial_table(const struct xt_table *);
-#if IS_ENABLED(CONFIG_NETFILTER)
 extern unsigned int ipt_do_table(struct sk_buff *skb,
 				 const struct nf_hook_state *state,
 				 struct xt_table *table);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
@@ -92,4 +90,7 @@ compat_ipt_get_target(struct compat_ipt_entry *e)
 }
 
 #endif /* CONFIG_COMPAT */
+
+#endif /* IS_ENABLED(CONFIG_IP_NF_IPTABLES) */
+
 #endif /* _IPTABLES_H */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 3a0a2bd054cc..3fbff8334ef0 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -15,17 +15,18 @@
 #ifndef _IP6_TABLES_H
 #define _IP6_TABLES_H
 
+#include <uapi/linux/netfilter_ipv6/ip6_tables.h>
+
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+
 #include <linux/if.h>
 #include <linux/in6.h>
+#include <linux/init.h>
 #include <linux/ipv6.h>
 #include <linux/skbuff.h>
 
-#include <linux/init.h>
-#include <uapi/linux/netfilter_ipv6/ip6_tables.h>
-
 extern void *ip6t_alloc_initial_table(const struct xt_table *);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int ip6t_register_table(struct net *net, const struct xt_table *table,
 			const struct ip6t_replace *repl,
 			const struct nf_hook_ops *ops, struct xt_table **res);
@@ -34,7 +35,6 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table,
 extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  const struct nf_hook_state *state,
 				  struct xt_table *table);
-#endif
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
@@ -56,4 +56,7 @@ compat_ip6t_get_target(struct compat_ip6t_entry *e)
 }
 
 #endif /* CONFIG_COMPAT */
+
+#endif /* IS_ENABLED(CONFIG_IP6_NF_IPTABLES) */
+
 #endif /* _IP6_TABLES_H */
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 2a613c84d49f..e08126b3fa92 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -2,22 +2,20 @@
 #ifndef _BR_NETFILTER_H_
 #define _BR_NETFILTER_H_
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+
 #include <linux/netfilter.h>
 
 #include "../../../net/bridge/br_private.h"
 
 static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct nf_bridge_info *b = skb_ext_add(skb, SKB_EXT_BRIDGE_NF);
 
 	if (b)
 		memset(b, 0, sizeof(*b));
 
 	return b;
-#else
-	return NULL;
-#endif
 }
 
 void nf_bridge_update_protocol(struct sk_buff *skb);
@@ -42,20 +40,15 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
 
 static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 {
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	struct net_bridge_port *port;
 
 	port = br_port_get_rcu(dev);
 	return port ? &port->br->fake_rtable : NULL;
-#else
-	return NULL;
-#endif
 }
 
 struct net_device *setup_pre_routing(struct sk_buff *skb,
 				     const struct net *net);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 #if IS_ENABLED(CONFIG_IPV6)
 int br_validate_ipv6(struct net *net, struct sk_buff *skb);
 unsigned int br_nf_pre_routing_ipv6(void *priv,
@@ -74,6 +67,7 @@ br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 #endif
-#endif
+
+#endif /* IS_ENABLED(CONFIG_BRIDGE_NETFILTER) */
 
 #endif /* _BR_NETFILTER_H_ */
diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 2c8c2b023848..1841b1f8ffe1 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -10,6 +10,8 @@
 #ifndef _NF_CONNTRACK_IPV4_H
 #define _NF_CONNTRACK_IPV4_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udp;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
@@ -26,4 +28,6 @@ extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite;
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_gre;
 #endif
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /*_NF_CONNTRACK_IPV4_H*/
diff --git a/include/net/netfilter/ipv4/nf_defrag_ipv4.h b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
index bcbd724cc048..d052d75fb9a9 100644
--- a/include/net/netfilter/ipv4/nf_defrag_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_defrag_ipv4.h
@@ -2,7 +2,11 @@
 #ifndef _NF_DEFRAG_IPV4_H
 #define _NF_DEFRAG_IPV4_H
 
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV4)
+
 struct net;
 int nf_defrag_ipv4_enable(struct net *);
 
+#endif
+
 #endif /* _NF_DEFRAG_IPV4_H */
diff --git a/include/net/netfilter/ipv4/nf_dup_ipv4.h b/include/net/netfilter/ipv4/nf_dup_ipv4.h
index a2bc16cdbcd3..e3655d9f4650 100644
--- a/include/net/netfilter/ipv4/nf_dup_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_dup_ipv4.h
@@ -2,10 +2,14 @@
 #ifndef _NF_DUP_IPV4_H_
 #define _NF_DUP_IPV4_H_
 
+#if IS_ENABLED(CONFIG_NF_DUP_IPV4)
+
 #include <linux/skbuff.h>
 #include <uapi/linux/in.h>
 
 void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in_addr *gw, int oif);
 
+#endif /* IS_ENABLED(CONFIG_NF_DUP_IPV4) */
+
 #endif /* _NF_DUP_IPV4_H_ */
diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f46..7f0a76278c94 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h
@@ -2,6 +2,8 @@
 #ifndef _IPV4_NF_REJECT_H
 #define _IPV4_NF_REJECT_H
 
+#if IS_ENABLED(CONFIG_NF_REJECT_IPV4)
+
 #include <linux/skbuff.h>
 #include <net/ip.h>
 #include <net/icmp.h>
@@ -18,4 +20,6 @@ struct iphdr *nf_reject_iphdr_put(struct sk_buff *nskb,
 void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 			     const struct tcphdr *oth);
 
+#endif /* IS_ENABLED(CONFIG_NF_REJECT_IPV4) */
+
 #endif /* _IPV4_NF_REJECT_H */
diff --git a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
index 7b3c873f8839..73dfa7d42169 100644
--- a/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_conntrack_ipv6.h
@@ -2,9 +2,13 @@
 #ifndef _NF_CONNTRACK_IPV6_H
 #define _NF_CONNTRACK_IPV6_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 extern const struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6;
 
 #include <linux/sysctl.h>
 extern struct ctl_table nf_ct_ipv6_sysctl_table[];
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_IPV6_H*/
diff --git a/include/net/netfilter/ipv6/nf_defrag_ipv6.h b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
index 6d31cd041143..30250f213856 100644
--- a/include/net/netfilter/ipv6/nf_defrag_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_defrag_ipv6.h
@@ -2,6 +2,8 @@
 #ifndef _NF_DEFRAG_IPV6_H
 #define _NF_DEFRAG_IPV6_H
 
+#if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
+
 #include <linux/skbuff.h>
 #include <linux/types.h>
 
@@ -13,4 +15,6 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user);
 
 struct inet_frags_ctl;
 
+#endif /* IS_ENABLED(CONFIG_NF_DEFRAG_IPV6) */
+
 #endif /* _NF_DEFRAG_IPV6_H */
diff --git a/include/net/netfilter/ipv6/nf_dup_ipv6.h b/include/net/netfilter/ipv6/nf_dup_ipv6.h
index f6312bb04a13..81bb9096fe5a 100644
--- a/include/net/netfilter/ipv6/nf_dup_ipv6.h
+++ b/include/net/netfilter/ipv6/nf_dup_ipv6.h
@@ -2,9 +2,13 @@
 #ifndef _NF_DUP_IPV6_H_
 #define _NF_DUP_IPV6_H_
 
+#if IS_ENABLED(CONFIG_NF_DUP_IPV6)
+
 #include <linux/skbuff.h>
 
 void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		 const struct in6_addr *gw, int oif);
 
+#endif
+
 #endif /* _NF_DUP_IPV6_H_ */
diff --git a/include/net/netfilter/ipv6/nf_reject.h b/include/net/netfilter/ipv6/nf_reject.h
index 4a3ef9ebdf6f..6d5cc6537319 100644
--- a/include/net/netfilter/ipv6/nf_reject.h
+++ b/include/net/netfilter/ipv6/nf_reject.h
@@ -2,6 +2,8 @@
 #ifndef _IPV6_NF_REJECT_H
 #define _IPV6_NF_REJECT_H
 
+#if IS_ENABLED(CONFIG_NF_REJECT_IPV6)
+
 #include <linux/icmpv6.h>
 #include <net/netfilter/nf_reject.h>
 
@@ -20,4 +22,6 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 			      const struct sk_buff *oldskb,
 			      const struct tcphdr *oth, unsigned int otcplen);
 
+#endif /* IS_ENABLED(CONFIG_NF_REJECT_IPV6) */
+
 #endif /* _IPV6_NF_REJECT_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 0673cf685741..7dc5c913eb7f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -13,6 +13,8 @@
 #ifndef _NF_CONNTRACK_H
 #define _NF_CONNTRACK_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/nf_conntrack_common.h>
 
 #include <linux/bitops.h>
@@ -64,7 +66,6 @@ struct nf_conntrack_net {
 #include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 struct nf_conn {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Usage count in here is 1 for hash table, 1 per skb,
 	 * plus 1 for any connection(s) we are `master' for
 	 *
@@ -74,7 +75,6 @@ struct nf_conn {
 	 * beware nf_ct_get() is different and don't inc refcnt.
 	 */
 	struct nf_conntrack ct_general;
-#endif
 
 	spinlock_t	lock;
 	/* jiffies32 when this ct is considered dead */
@@ -155,8 +155,6 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
 int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 			     const struct nf_conn *ignored_conntrack);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 #define NFCT_INFOMASK	7UL
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
@@ -176,8 +174,6 @@ static inline void nf_ct_put(struct nf_conn *ct)
 	nf_conntrack_put(&ct->ct_general);
 }
 
-#endif
-
 /* Protocol module loading */
 int nf_ct_l3proto_try_module_get(unsigned short l3proto);
 void nf_ct_l3proto_module_put(unsigned short l3proto);
@@ -329,16 +325,12 @@ void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
 u32 nf_ct_get_id(const struct nf_conn *ct);
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
-
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 {
 	skb->_nfct = (unsigned long)ct | info;
 }
 
-#endif
-
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
@@ -346,4 +338,6 @@ nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 #define MODULE_ALIAS_NFCT_HELPER(helper) \
         MODULE_ALIAS("nfct-helper-" helper)
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nf_conntrack_acct.h b/include/net/netfilter/nf_conntrack_acct.h
index 5b5287bb49db..b8994e20136f 100644
--- a/include/net/netfilter/nf_conntrack_acct.h
+++ b/include/net/netfilter/nf_conntrack_acct.h
@@ -5,11 +5,14 @@
 
 #ifndef _NF_CONNTRACK_ACCT_H
 #define _NF_CONNTRACK_ACCT_H
-#include <net/net_namespace.h>
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
+#include <net/net_namespace.h>
 
 struct nf_conn_counter {
 	atomic64_t packets;
@@ -29,7 +32,6 @@ struct nf_conn_acct *nf_conn_acct_find(const struct nf_conn *ct)
 static inline
 struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct net *net = nf_ct_net(ct);
 	struct nf_conn_acct *acct;
 
@@ -42,34 +44,25 @@ struct nf_conn_acct *nf_ct_acct_ext_add(struct nf_conn *ct, gfp_t gfp)
 
 
 	return acct;
-#else
-	return NULL;
-#endif
 }
 
 /* Check if connection tracking accounting is enabled */
 static inline bool nf_ct_acct_enabled(struct net *net)
 {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	return net->ct.sysctl_acct != 0;
-#else
-	return false;
-#endif
 }
 
 /* Enable/disable connection tracking accounting */
 static inline void nf_ct_set_acct(struct net *net, bool enable)
 {
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	net->ct.sysctl_acct = enable;
-#endif
 }
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 void nf_conntrack_acct_pernet_init(struct net *net);
 
 int nf_conntrack_acct_init(void);
 void nf_conntrack_acct_fini(void);
+
 #endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 
 #endif /* _NF_CONNTRACK_ACCT_H */
diff --git a/include/net/netfilter/nf_conntrack_bridge.h b/include/net/netfilter/nf_conntrack_bridge.h
index 01b62fd5efa2..fb5fb167a20e 100644
--- a/include/net/netfilter/nf_conntrack_bridge.h
+++ b/include/net/netfilter/nf_conntrack_bridge.h
@@ -1,14 +1,14 @@
 #ifndef NF_CONNTRACK_BRIDGE_
 #define NF_CONNTRACK_BRIDGE_
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <uapi/linux/if_ether.h>
 
 struct nf_ct_bridge_info {
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops	*ops;
-#endif
 	unsigned int		ops_size;
 	struct module		*me;
 };
@@ -16,4 +16,6 @@ struct nf_ct_bridge_info {
 void nf_ct_bridge_register(struct nf_ct_bridge_info *info);
 void nf_ct_bridge_unregister(struct nf_ct_bridge_info *info);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif
diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index d340886e012d..8653ddd45c0b 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -13,18 +13,21 @@
 #ifndef _NF_CONNTRACK_CORE_H
 #define _NF_CONNTRACK_CORE_H
 
+/*
+ * This header is used to share core functionality between the standalone
+ * connection tracking module, and the compatibility layer's use of connection
+ * tracking.
+ */
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 
-/* This header is used to share core functionality between the
-   standalone connection tracking module, and the compatibility layer's use
-   of connection tracking. */
-
-#if IS_ENABLED(CONFIG_NETFILTER)
-unsigned int nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state);
-#endif
+unsigned int nf_conntrack_in(struct sk_buff *skb,
+			     const struct nf_hook_state *state);
 
 int nf_conntrack_init_net(struct net *net);
 void nf_conntrack_cleanup_net(struct net *net);
@@ -81,4 +84,6 @@ void nf_conntrack_lock(spinlock_t *lock);
 
 extern spinlock_t nf_conntrack_expect_lock;
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_CORE_H */
diff --git a/include/net/netfilter/nf_conntrack_count.h b/include/net/netfilter/nf_conntrack_count.h
index 9645b47fa7e4..a5b43b9259e0 100644
--- a/include/net/netfilter/nf_conntrack_count.h
+++ b/include/net/netfilter/nf_conntrack_count.h
@@ -1,6 +1,8 @@
 #ifndef _NF_CONNTRACK_COUNT_H
 #define _NF_CONNTRACK_COUNT_H
 
+#if IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT)
+
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
@@ -36,4 +38,6 @@ bool nf_conncount_gc_list(struct net *net,
 
 void nf_conncount_cache_free(struct nf_conncount_list *list);
 
+#endif /* IS_ENABLED(CONFIG_NETFILTER_CONNCOUNT) */
+
 #endif
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index eb81f9195e28..2d9dfcea9f2b 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -5,12 +5,14 @@
 
 #ifndef _NF_CONNTRACK_ECACHE_H
 #define _NF_CONNTRACK_ECACHE_H
-#include <net/netfilter/nf_conntrack.h>
 
-#include <net/net_namespace.h>
-#include <net/netfilter/nf_conntrack_expect.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/net_namespace.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
 enum nf_ct_ecache_state {
@@ -225,4 +227,6 @@ static inline void nf_conntrack_ecache_work(struct net *net)
 #endif
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /*_NF_CONNTRACK_ECACHE_H*/
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 0855b60fba17..7899ceb3c1be 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -6,8 +6,9 @@
 #ifndef _NF_CONNTRACK_EXPECT_H
 #define _NF_CONNTRACK_EXPECT_H
 
-#include <linux/refcount.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 
+#include <linux/refcount.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
@@ -134,5 +135,6 @@ static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 	return nf_ct_expect_related_report(expect, 0, 0, flags);
 }
 
-#endif /*_NF_CONNTRACK_EXPECT_H*/
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 
+#endif /*_NF_CONNTRACK_EXPECT_H*/
diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 112a6f40dfaf..2e43f8683434 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -2,8 +2,9 @@
 #ifndef _NF_CONNTRACK_EXTEND_H
 #define _NF_CONNTRACK_EXTEND_H
 
-#include <linux/slab.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 
+#include <linux/slab.h>
 #include <net/netfilter/nf_conntrack.h>
 
 enum nf_ct_ext_id {
@@ -97,4 +98,7 @@ struct nf_ct_ext_type {
 
 int nf_ct_extend_register(const struct nf_ct_ext_type *type);
 void nf_ct_extend_unregister(const struct nf_ct_ext_type *type);
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_EXTEND_H */
diff --git a/include/net/netfilter/nf_conntrack_helper.h b/include/net/netfilter/nf_conntrack_helper.h
index 44b5a00a9c64..c4a164eeab89 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -10,6 +10,9 @@
 
 #ifndef _NF_CONNTRACK_HELPER_H
 #define _NF_CONNTRACK_HELPER_H
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/refcount.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
@@ -177,4 +180,7 @@ void nf_nat_helper_unregister(struct nf_conntrack_nat_helper *nat);
 int nf_nat_helper_try_module_get(const char *name, u16 l3num,
 				 u8 protonum);
 void nf_nat_helper_put(struct nf_conntrack_helper *helper);
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /*_NF_CONNTRACK_HELPER_H*/
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index c200b95d27ae..6912367da3ec 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -10,6 +10,9 @@
 
 #ifndef _NF_CONNTRACK_L4PROTO_H
 #define _NF_CONNTRACK_L4PROTO_H
+
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netlink.h>
 #include <net/netlink.h>
 #include <net/netfilter/nf_conntrack.h>
@@ -178,7 +181,6 @@ void nf_ct_l4proto_log_invalid(const struct sk_buff *skb,
 			       const char *fmt, ...) { }
 #endif /* CONFIG_SYSCTL */
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static inline struct nf_generic_net *nf_generic_pernet(struct net *net)
 {
        return &net->ct.nf_ct_proto.generic;
@@ -203,7 +205,6 @@ static inline struct nf_icmp_net *nf_icmpv6_pernet(struct net *net)
 {
        return &net->ct.nf_ct_proto.icmpv6;
 }
-#endif
 
 #ifdef CONFIG_NF_CT_PROTO_DCCP
 static inline struct nf_dccp_net *nf_dccp_pernet(struct net *net)
@@ -226,4 +227,6 @@ static inline struct nf_gre_net *nf_gre_pernet(struct net *net)
 }
 #endif
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index ba916411c4e1..ffe08252a70d 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -3,6 +3,8 @@
 #ifndef _NF_CONNTRACK_LABELS_H
 #define _NF_CONNTRACK_LABELS_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/types.h>
@@ -55,4 +57,6 @@ static inline int nf_connlabels_get(struct net *net, unsigned int bit) { return
 static inline void nf_connlabels_put(struct net *net) {}
 #endif
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_LABELS_H */
diff --git a/include/net/netfilter/nf_conntrack_seqadj.h b/include/net/netfilter/nf_conntrack_seqadj.h
index 0a10b50537ae..d7b22f4e1a66 100644
--- a/include/net/netfilter/nf_conntrack_seqadj.h
+++ b/include/net/netfilter/nf_conntrack_seqadj.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_SEQADJ_H
 #define _NF_CONNTRACK_SEQADJ_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <net/netfilter/nf_conntrack_extend.h>
 
 /**
@@ -45,4 +47,6 @@ s32 nf_ct_seq_offset(const struct nf_conn *ct, enum ip_conntrack_dir, u32 seq);
 int nf_conntrack_seqadj_init(void);
 void nf_conntrack_seqadj_fini(void);
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_SEQADJ_H */
diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 6a3ab081e4bf..3c0395ada5b5 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_SYNPROXY_H
 #define _NF_CONNTRACK_SYNPROXY_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netns/generic.h>
 
@@ -45,4 +47,6 @@ static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 	return true;
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_SYNPROXY_H */
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 6dd72396f534..dfc37f4ea49c 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -2,6 +2,8 @@
 #ifndef _NF_CONNTRACK_TIMEOUT_H
 #define _NF_CONNTRACK_TIMEOUT_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <net/net_namespace.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
@@ -124,4 +126,6 @@ extern struct nf_ct_timeout *(*nf_ct_timeout_find_get_hook)(struct net *net, con
 extern void (*nf_ct_timeout_put_hook)(struct nf_ct_timeout *timeout);
 #endif
 
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif /* _NF_CONNTRACK_TIMEOUT_H */
diff --git a/include/net/netfilter/nf_conntrack_timestamp.h b/include/net/netfilter/nf_conntrack_timestamp.h
index 2b8aeba649aa..5ffa8b27cb77 100644
--- a/include/net/netfilter/nf_conntrack_timestamp.h
+++ b/include/net/netfilter/nf_conntrack_timestamp.h
@@ -2,9 +2,11 @@
 #ifndef _NF_CONNTRACK_TSTAMP_H
 #define _NF_CONNTRACK_TSTAMP_H
 
-#include <net/net_namespace.h>
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
@@ -73,4 +75,6 @@ static inline void nf_conntrack_tstamp_fini(void)
 }
 #endif /* CONFIG_NF_CONNTRACK_TIMESTAMP */
 
+#endif /* CONFIG_NF_CONNTRACK */
+
 #endif /* _NF_CONNTRACK_TSTAMP_H */
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 68ea9b932736..70af4b169eee 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -11,6 +11,8 @@
 #ifndef _NF_CONNTRACK_TUPLE_H
 #define _NF_CONNTRACK_TUPLE_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
 #include <linux/list_nulls.h>
@@ -121,7 +123,6 @@ struct nf_conntrack_tuple_hash {
 	struct nf_conntrack_tuple tuple;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
 {
@@ -184,6 +185,7 @@ nf_ct_tuple_mask_cmp(const struct nf_conntrack_tuple *t,
 	return nf_ct_tuple_src_mask_cmp(t, tuple, mask) &&
 	       __nf_ct_tuple_dst_equal(t, tuple);
 }
-#endif
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
 
 #endif /* _NF_CONNTRACK_TUPLE_H */
diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index 181672672160..e84227c68ea1 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -2,9 +2,13 @@
 #ifndef _NF_DUP_NETDEV_H_
 #define _NF_DUP_NETDEV_H_
 
+#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
+
 #include <net/netfilter/nf_tables.h>
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+#endif /* IS_ENABLED(CONFIG_NF_DUP_NETDEV) */
+
 #endif
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d875be62cdf0..afaf4b882f53 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -1,6 +1,8 @@
 #ifndef _NF_FLOW_TABLE_H
 #define _NF_FLOW_TABLE_H
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <linux/in.h>
 #include <linux/in6.h>
 #include <linux/netdevice.h>
@@ -17,9 +19,7 @@ struct nf_flowtable_type {
 	int				family;
 	int				(*init)(struct nf_flowtable *ft);
 	void				(*free)(struct nf_flowtable *ft);
-#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hook;
-#endif
 	struct module			*owner;
 };
 
@@ -117,14 +117,14 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 				     const struct nf_hook_state *state);
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
-#endif
 
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif /* _NF_FLOW_TABLE_H */
diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 0d3920896d50..0dd375db4eda 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -2,6 +2,8 @@
 #ifndef _NF_LOG_H
 #define _NF_LOG_H
 
+#ifdef CONFIG_NETFILTER
+
 #include <linux/netfilter.h>
 #include <linux/netfilter/nf_log.h>
 
@@ -122,4 +124,6 @@ void nf_log_l2packet(struct net *net, u_int8_t pf,
 		     const struct net_device *out,
 		     const struct nf_loginfo *loginfo, const char *prefix);
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /* _NF_LOG_H */
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 362ff94fa6b0..d9d4acdc0776 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -2,6 +2,8 @@
 #ifndef _NF_NAT_H
 #define _NF_NAT_H
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+
 #include <linux/list.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter/nf_conntrack_pptp.h>
@@ -68,12 +70,10 @@ static inline bool nf_nat_oif_changed(unsigned int hooknum,
 #endif
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		       const struct nf_hook_ops *nat_ops, unsigned int ops_count);
 void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 			  unsigned int ops_count);
-#endif
 
 unsigned int nf_nat_packet(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 			   unsigned int hooknum, struct sk_buff *skb);
@@ -93,7 +93,6 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb, struct nf_conn *ct,
 				    enum ip_conntrack_info ctinfo,
 				    unsigned int hooknum, unsigned int hdrlen);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_nat_ipv4_register_fn(struct net *net, const struct nf_hook_ops *ops);
 void nf_nat_ipv4_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 
@@ -106,7 +105,6 @@ void nf_nat_inet_unregister_fn(struct net *net, const struct nf_hook_ops *ops);
 unsigned int
 nf_nat_inet_fn(void *priv, struct sk_buff *skb,
 	       const struct nf_hook_state *state);
-#endif
 
 int nf_xfrm_me_harder(struct net *n, struct sk_buff *s, unsigned int family);
 
@@ -118,4 +116,7 @@ static inline int nf_nat_initialized(struct nf_conn *ct,
 	else
 		return ct->status & IPS_DST_NAT_DONE;
 }
+
+#endif /* IS_ENABLED(CONFIG_NF_CONNTRACK) */
+
 #endif
diff --git a/include/net/netfilter/nf_nat_helper.h b/include/net/netfilter/nf_nat_helper.h
index efae84646353..11692d9b6913 100644
--- a/include/net/netfilter/nf_nat_helper.h
+++ b/include/net/netfilter/nf_nat_helper.h
@@ -1,6 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _NF_NAT_HELPER_H
 #define _NF_NAT_HELPER_H
+
+#if IS_ENABLED(CONFIG_NF_NAT)
+
 /* NAT protocol helper routines. */
 
 #include <linux/skbuff.h>
@@ -38,4 +41,6 @@ bool nf_nat_mangle_udp_packet(struct sk_buff *skb, struct nf_conn *ct,
  * to port ct->master->saved_proto. */
 void nf_nat_follow_master(struct nf_conn *ct, struct nf_conntrack_expect *this);
 
+#endif /* IS_ENABLED(CONFIG_NF_NAT) */
+
 #endif
diff --git a/include/net/netfilter/nf_nat_masquerade.h b/include/net/netfilter/nf_nat_masquerade.h
index be7abc9d5f22..d6ef5e6f84dd 100644
--- a/include/net/netfilter/nf_nat_masquerade.h
+++ b/include/net/netfilter/nf_nat_masquerade.h
@@ -2,6 +2,8 @@
 #ifndef _NF_NAT_MASQUERADE_H_
 #define _NF_NAT_MASQUERADE_H_
 
+#ifdef CONFIG_NF_NAT_MASQUERADE
+
 #include <linux/skbuff.h>
 #include <net/netfilter/nf_nat.h>
 
@@ -17,4 +19,6 @@ unsigned int
 nf_nat_masquerade_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		       const struct net_device *out);
 
+#endif /* CONFIG_NF_NAT_MASQUERADE */
+
 #endif /*_NF_NAT_MASQUERADE_H_ */
diff --git a/include/net/netfilter/nf_nat_redirect.h b/include/net/netfilter/nf_nat_redirect.h
index 2418653a66db..2a2c818523eb 100644
--- a/include/net/netfilter/nf_nat_redirect.h
+++ b/include/net/netfilter/nf_nat_redirect.h
@@ -2,6 +2,8 @@
 #ifndef _NF_NAT_REDIRECT_H_
 #define _NF_NAT_REDIRECT_H_
 
+#ifdef CONFIG_NF_NAT_REDIRECT
+
 #include <linux/skbuff.h>
 #include <uapi/linux/netfilter/nf_nat.h>
 
@@ -13,4 +15,6 @@ unsigned int
 nf_nat_redirect_ipv6(struct sk_buff *skb, const struct nf_nat_range2 *range,
 		     unsigned int hooknum);
 
+#endif /* CONFIG_NF_NAT_REDIRECT */
+
 #endif /* _NF_NAT_REDIRECT_H_ */
diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 80edb46a1bbc..5f0986357ad8 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -2,6 +2,8 @@
 #ifndef _NF_QUEUE_H
 #define _NF_QUEUE_H
 
+#ifdef CONFIG_NETFILTER
+
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/jhash.h>
@@ -15,9 +17,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_state	state;
-#endif
 	u16			size; /* sizeof(entry) + saved route keys */
 
 	/* extra space to store route keys */
@@ -123,9 +123,9 @@ nfqueue_hash(const struct sk_buff *skb, u16 queue, u16 queues_total, u8 family,
 	return queue;
 }
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 int nf_queue(struct sk_buff *skb, struct nf_hook_state *state,
 	     unsigned int index, unsigned int verdict);
-#endif
+
+#endif /* CONFIG_NETFILTER */
 
 #endif /* _NF_QUEUE_H */
diff --git a/include/net/netfilter/nf_reject.h b/include/net/netfilter/nf_reject.h
index 9051c3a0c8e7..664db093d24a 100644
--- a/include/net/netfilter/nf_reject.h
+++ b/include/net/netfilter/nf_reject.h
@@ -2,6 +2,8 @@
 #ifndef _NF_REJECT_H
 #define _NF_REJECT_H
 
+#ifdef CONFIG_NETFILTER
+
 #include <linux/types.h>
 #include <uapi/linux/in.h>
 
@@ -27,4 +29,6 @@ static inline bool nf_reject_verify_csum(__u8 proto)
 	return true;
 }
 
+#endif /* CONFIG_NETFILTER */
+
 #endif /* _NF_REJECT_H */
diff --git a/include/net/netfilter/nf_socket.h b/include/net/netfilter/nf_socket.h
index f9d7bee9bd4e..642cb6640e23 100644
--- a/include/net/netfilter/nf_socket.h
+++ b/include/net/netfilter/nf_socket.h
@@ -2,6 +2,8 @@
 #ifndef _NF_SOCK_H_
 #define _NF_SOCK_H_
 
+#ifdef CONFIG_NETFILTER
+
 #include <net/sock.h>
 
 struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
@@ -10,4 +12,6 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 				  const struct net_device *indev);
 
+#endif /* CONFIG_NETFILTER */
+
 #endif
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index 19d1af7a0348..e1661141a0b8 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -2,6 +2,8 @@
 #ifndef _NF_SYNPROXY_SHARED_H
 #define _NF_SYNPROXY_SHARED_H
 
+#if IS_ENABLED(CONFIG_NETFILTER_SYNPROXY)
+
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <net/ip6_checksum.h>
@@ -58,10 +60,8 @@ bool synproxy_recv_client_ack(struct net *net,
 			      const struct tcphdr *th,
 			      struct synproxy_options *opts, u32 recv_seq);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int ipv4_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
-#endif
 int nf_synproxy_ipv4_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv4_fini(struct synproxy_net *snet, struct net *net);
 
@@ -75,10 +75,8 @@ bool synproxy_recv_client_ack_ipv6(struct net *net, const struct sk_buff *skb,
 				   const struct tcphdr *th,
 				   struct synproxy_options *opts, u32 recv_seq);
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 unsigned int ipv6_synproxy_hook(void *priv, struct sk_buff *skb,
 				const struct nf_hook_state *nhs);
-#endif
 int nf_synproxy_ipv6_init(struct synproxy_net *snet, struct net *net);
 void nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net);
 #else
@@ -88,4 +86,6 @@ static inline void
 nf_synproxy_ipv6_fini(struct synproxy_net *snet, struct net *net) {};
 #endif /* CONFIG_IPV6 */
 
+#endif /* IS_ENABLED(CONFIG_NETFILTER_SYNPROXY) */
+
 #endif /* _NF_SYNPROXY_SHARED_H */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 498665158ee0..a172f0923542 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,6 +2,8 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <asm/unaligned.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
@@ -26,7 +28,6 @@ struct nft_pktinfo {
 	struct xt_action_param		xt;
 };
 
-#if IS_ENABLED(CONFIG_NETFILTER)
 static inline struct net *nft_net(const struct nft_pktinfo *pkt)
 {
 	return pkt->xt.state->net;
@@ -59,7 +60,6 @@ static inline void nft_set_pktinfo(struct nft_pktinfo *pkt,
 	pkt->skb = skb;
 	pkt->xt.state = state;
 }
-#endif
 
 static inline void nft_set_pktinfo_unspec(struct nft_pktinfo *pkt,
 					  struct sk_buff *skb)
@@ -947,11 +947,9 @@ struct nft_chain_type {
 	int				family;
 	struct module			*owner;
 	unsigned int			hook_mask;
-#if IS_ENABLED(CONFIG_NETFILTER)
 	nf_hookfn			*hooks[NF_MAX_HOOKS];
 	int				(*ops_register)(struct net *net, const struct nf_hook_ops *ops);
 	void				(*ops_unregister)(struct net *net, const struct nf_hook_ops *ops);
-#endif
 };
 
 int nft_chain_validate_dependency(const struct nft_chain *chain,
@@ -977,9 +975,7 @@ struct nft_stats {
  *	@flow_block: flow block (for hardware offload)
  */
 struct nft_base_chain {
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		ops;
-#endif
 	const struct nft_chain_type	*type;
 	u8				policy;
 	u8				flags;
@@ -1176,9 +1172,7 @@ struct nft_flowtable {
 					use:30;
 	u64				handle;
 	/* runtime data below here */
-#if IS_ENABLED(CONFIG_NETFILTER)
 	struct nf_hook_ops		*ops ____cacheline_aligned;
-#endif
 	struct nf_flowtable		data;
 };
 
@@ -1233,8 +1227,6 @@ void nft_trace_notify(struct nft_traceinfo *info);
 #define MODULE_ALIAS_NFT_OBJ(type) \
 	MODULE_ALIAS("nft-obj-" __stringify(type))
 
-#if IS_ENABLED(CONFIG_NF_TABLES)
-
 /*
  * The gencursor defines two generations, the currently active and the
  * next one. Objects contain a bitmask of 2 bits specifying the generations
@@ -1308,8 +1300,6 @@ static inline void nft_set_elem_change_active(const struct net *net,
 	ext->genmask ^= nft_genmask_next(net);
 }
 
-#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
-
 /*
  * We use a free bit in the genmask field to indicate the element
  * is busy, meaning it is currently being processed either by
@@ -1446,4 +1436,7 @@ void nft_chain_filter_fini(void);
 
 void __init nft_chain_route_init(void);
 void nft_chain_route_fini(void);
+
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 7281895fa6d9..7fa23fb4383c 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -2,6 +2,8 @@
 #ifndef _NET_NF_TABLES_CORE_H
 #define _NET_NF_TABLES_CORE_H
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <net/netfilter/nf_tables.h>
 
 extern struct nft_expr_type nft_imm_type;
@@ -98,4 +100,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 void nft_rt_get_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
+
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index ed7b511f0a59..5156a6e4e7d6 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -2,6 +2,8 @@
 #ifndef _NF_TABLES_IPV4_H_
 #define _NF_TABLES_IPV4_H_
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <net/netfilter/nf_tables.h>
 #include <net/ip.h>
 
@@ -53,4 +55,6 @@ static inline void nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_unspec(pkt, skb);
 }
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index d0f1c537b017..46bf20eecf3a 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -2,6 +2,8 @@
 #ifndef _NF_TABLES_IPV6_H_
 #define _NF_TABLES_IPV6_H_
 
+#ifdef CONFIG_NF_TABLES_IPV6
+
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <net/ipv6.h>
 #include <net/netfilter/nf_tables.h>
@@ -28,7 +30,6 @@ static inline void nft_set_pktinfo_ipv6(struct nft_pktinfo *pkt,
 static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 						  struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_IPV6)
 	unsigned int flags = IP6_FH_F_AUTH;
 	struct ipv6hdr *ip6h, _ip6h;
 	unsigned int thoff = 0;
@@ -58,9 +59,6 @@ static inline int __nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 	pkt->xt.fragoff = frag_off;
 
 	return 0;
-#else
-	return -1;
-#endif
 }
 
 static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
@@ -70,4 +68,6 @@ static inline void nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_unspec(pkt, skb);
 }
 
-#endif
+#endif /* CONFIG_NF_TABLES_IPV6 */
+
+#endif /* _NF_TABLES_IPV6_H_ */
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index db104665a9e4..79a4a78f2f01 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -1,6 +1,8 @@
 #ifndef _NET_NF_TABLES_OFFLOAD_H
 #define _NET_NF_TABLES_OFFLOAD_H
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <net/flow_offload.h>
 #include <net/netfilter/nf_tables.h>
 
@@ -80,4 +82,6 @@ void nft_indr_block_get_and_ing_cmd(struct net_device *dev,
 
 int nft_chain_offload_priority(struct nft_base_chain *basechain);
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif
diff --git a/include/net/netfilter/nf_tproxy.h b/include/net/netfilter/nf_tproxy.h
index 82d0e41b76f2..0321ec632502 100644
--- a/include/net/netfilter/nf_tproxy.h
+++ b/include/net/netfilter/nf_tproxy.h
@@ -1,6 +1,8 @@
 #ifndef _NF_TPROXY_H_
 #define _NF_TPROXY_H_
 
+#if IS_ENABLED(CONFIG_NF_TPROXY)
+
 #include <net/tcp.h>
 
 enum nf_tproxy_lookup_t {
@@ -118,4 +120,6 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		      const struct net_device *in,
 		      const enum nf_tproxy_lookup_t lookup_type);
 
+#endif /* IS_ENABLED(CONFIG_NF_TPROXY) */
+
 #endif /* _NF_TPROXY_H_ */
diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 628b6fa579cd..b753729ce591 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -2,6 +2,8 @@
 #ifndef _NFT_FIB_H_
 #define _NFT_FIB_H_
 
+#if IS_ENABLED(CONFIG_NFT_FIB)
+
 #include <net/netfilter/nf_tables.h>
 
 struct nft_fib {
@@ -37,4 +39,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct net_device *dev);
+
+#endif /* IS_ENABLED(CONFIG_NFT_FIB) */
+
 #endif
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index 07e2fd507963..bbd18b64eaf8 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -2,6 +2,8 @@
 #ifndef _NFT_META_H_
 #define _NFT_META_H_
 
+#if IS_ENABLED(CONFIG_NF_TABLES)
+
 #include <net/netfilter/nf_tables.h>
 
 struct nft_meta {
@@ -43,4 +45,6 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 			  const struct nft_expr *expr,
 			  const struct nft_data **data);
 
+#endif /* IS_ENABLED(CONFIG_NF_TABLES) */
+
 #endif
diff --git a/include/net/netfilter/nft_reject.h b/include/net/netfilter/nft_reject.h
index 56b123a42220..502961721d30 100644
--- a/include/net/netfilter/nft_reject.h
+++ b/include/net/netfilter/nft_reject.h
@@ -2,6 +2,8 @@
 #ifndef _NFT_REJECT_H_
 #define _NFT_REJECT_H_
 
+#if IS_ENABLED(CONFIG_NFT_REJECT)
+
 #include <linux/types.h>
 #include <net/netlink.h>
 #include <net/netfilter/nf_tables.h>
@@ -27,4 +29,6 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr);
 int nft_reject_icmp_code(u8 code);
 int nft_reject_icmpv6_code(u8 code);
 
+#endif /* IS_ENABLED(CONFIG_NFT_REJECT) */
+
 #endif
diff --git a/include/net/netfilter/xt_rateest.h b/include/net/netfilter/xt_rateest.h
index 832ab69efda5..9fae3397d62c 100644
--- a/include/net/netfilter/xt_rateest.h
+++ b/include/net/netfilter/xt_rateest.h
@@ -2,6 +2,8 @@
 #ifndef _XT_RATEEST_H
 #define _XT_RATEEST_H
 
+#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_RATEEST)
+
 #include <net/gen_stats.h>
 
 struct xt_rateest {
@@ -24,4 +26,6 @@ struct xt_rateest {
 struct xt_rateest *xt_rateest_lookup(struct net *net, const char *name);
 void xt_rateest_put(struct net *net, struct xt_rateest *est);
 
+#endif /* IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_RATEEST) */
+
 #endif /* _XT_RATEEST_H */
-- 
2.23.0.rc1

