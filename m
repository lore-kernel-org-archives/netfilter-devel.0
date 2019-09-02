Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD94C41514
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B402921883
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cihlTf8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfIBXG4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:06:56 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43570 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726937AbfIBXGz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:06:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3czRauoD+TIkuqhOduPprou/vcm010H+qSbsDap1AdE=; b=cihlTf8CLnyDmiKrc/uExBAVfI
        Pw5LmtVY0I4YrjqOoLfmbCjexl4zNzLLoOcYsHqi6+EGvjc6Ue/8rxLPIR4DQhIkPpRPy0kQQ+3lm
        hPS8xW3mE3uO/P04WzpaGjJiNbdFNXczCp4I6QWMEHvT4nTfVUvxejilW6T/CxGe0IipmBdKLsD98
        AlmNZiM3FrPCM8LYPxY5H7jK0OTmUfzJ3tO4zXt2DwKlutgsihDwHb2rvdKVXM4A/36lNM/vR91xf
        65f8MFNcnbeydA+vTnI7lMI1E4yzltcRAbBTE88GpIzrwEd4uSvJm1cMGWCWVgVK+LunkAPkQDU62
        u1JSj8QQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPP-0004la-8k; Tue, 03 Sep 2019 00:06:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 05/30] netfilter: remove trailing white-space.
Date:   Tue,  3 Sep 2019 00:06:25 +0100
Message-Id: <20190902230650.14621-6-jeremy@azazel.net>
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

Several header-files, Kconfig files and Makefiles have trailing
white-space.  Remove it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/x_tables.h          | 2 +-
 include/linux/netfilter_ipv6.h              | 2 +-
 include/net/netfilter/nf_conntrack_expect.h | 2 +-
 include/net/netfilter/nf_conntrack_tuple.h  | 2 +-
 net/ipv4/netfilter/Kconfig                  | 8 ++++----
 net/ipv4/netfilter/Makefile                 | 2 +-
 net/netfilter/Kconfig                       | 6 +++---
 net/netfilter/Makefile                      | 2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index ae62bf1c6824..b9bc25f57c8e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -340,7 +340,7 @@ void xt_free_table_info(struct xt_table_info *info);
 
 /**
  * xt_recseq - recursive seqcount for netfilter use
- * 
+ *
  * Packet processing changes the seqcount only if no recursion happened
  * get_counters() can use read_seqcount_begin()/read_seqcount_retry(),
  * because we use the normal seqcount convention :
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index c2f669581d88..9797685d1e11 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -2,7 +2,7 @@
 /* IPv6-specific defines for netfilter.
  * (C)1998 Rusty Russell -- This code is GPL.
  * (C)1999 David Jeffery
- *   this header was blatantly ripped from netfilter_ipv4.h 
+ *   this header was blatantly ripped from netfilter_ipv4.h
  *   it's amazing what adding a bunch of 6s can do =8^)
  */
 #ifndef __LINUX_IP6_NETFILTER_H
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 573429be4d59..0855b60fba17 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -126,7 +126,7 @@ void nf_ct_expect_init(struct nf_conntrack_expect *, unsigned int, u_int8_t,
 		       const union nf_inet_addr *,
 		       u_int8_t, const __be16 *, const __be16 *);
 void nf_ct_expect_put(struct nf_conntrack_expect *exp);
-int nf_ct_expect_related_report(struct nf_conntrack_expect *expect, 
+int nf_ct_expect_related_report(struct nf_conntrack_expect *expect,
 				u32 portid, int report, unsigned int flags);
 static inline int nf_ct_expect_related(struct nf_conntrack_expect *expect,
 				       unsigned int flags)
diff --git a/include/net/netfilter/nf_conntrack_tuple.h b/include/net/netfilter/nf_conntrack_tuple.h
index 480c87b44a96..68ea9b932736 100644
--- a/include/net/netfilter/nf_conntrack_tuple.h
+++ b/include/net/netfilter/nf_conntrack_tuple.h
@@ -124,7 +124,7 @@ struct nf_conntrack_tuple_hash {
 #if IS_ENABLED(CONFIG_NETFILTER)
 static inline bool __nf_ct_tuple_src_equal(const struct nf_conntrack_tuple *t1,
 					   const struct nf_conntrack_tuple *t2)
-{ 
+{
 	return (nf_inet_addr_cmp(&t1->src.u3, &t2->src.u3) &&
 		t1->src.u.all == t2->src.u.all &&
 		t1->src.l3num == t2->src.l3num);
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 69e76d677f9e..f17b402111ce 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -272,7 +272,7 @@ config IP_NF_TARGET_CLUSTERIP
 	  The CLUSTERIP target allows you to build load-balancing clusters of
 	  network servers without having a dedicated load-balancing
 	  router/server/switch.
-	
+
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_ECN
@@ -281,7 +281,7 @@ config IP_NF_TARGET_ECN
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a `ECN' target, which can be used in the iptables mangle
-	  table.  
+	  table.
 
 	  You can use this target to remove the ECN bits from the IPv4 header of
 	  an IP packet.  This is particularly useful, if you need to work around
@@ -306,7 +306,7 @@ config IP_NF_RAW
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
 	  and OUTPUT chains.
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.rst>.  If unsure, say `N'.
 
@@ -318,7 +318,7 @@ config IP_NF_SECURITY
 	help
 	  This option adds a `security' table to iptables, for use
 	  with Mandatory Access Control (MAC) policy.
-	 
+
 	  If unsure, say N.
 
 endif # IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index c50e0ec095d2..7c497c78105f 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
 # flow table support
 obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
 
-# generic IP tables 
+# generic IP tables
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
 
 # the three instances of ip_tables
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0d65f4d39494..6244bf3de4af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -34,7 +34,7 @@ config NETFILTER_NETLINK_QUEUE
 	help
 	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
-	  
+
 config NETFILTER_NETLINK_LOG
 	tristate "Netfilter LOG over NFNETLINK interface"
 	default m if NETFILTER_ADVANCED=n
@@ -1502,7 +1502,7 @@ config NETFILTER_XT_MATCH_REALM
 	  This option adds a `realm' match, which allows you to use the realm
 	  key from the routing subsystem inside iptables.
 
-	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option 
+	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option
 	  in tc world.
 
 	  If you want to compile it as a module, say M here and read
@@ -1523,7 +1523,7 @@ config NETFILTER_XT_MATCH_SCTP
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
-	  With this option enabled, you will be able to use the 
+	  With this option enabled, you will be able to use the
 	  `sctp' match in order to match on SCTP source/destination ports
 	  and SCTP chunk types.
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 9270a7fae484..4fc075b612fe 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -124,7 +124,7 @@ nf_flow_table-objs := nf_flow_table_core.o nf_flow_table_ip.o
 
 obj-$(CONFIG_NF_FLOW_TABLE_INET) += nf_flow_table_inet.o
 
-# generic X tables 
+# generic X tables
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
 
 # combos
-- 
2.23.0.rc1

