Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60228C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC23F208C2
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Z1RqKNjQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfIMINZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:13:25 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60606 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729271AbfIMINY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s9zRJtOaNMDipdXqs5CleGRtCtrw8Z7rgiv7zrwhLlY=; b=Z1RqKNjQGOEoopBKSzIkqttUN+
        t1xvmBaPxN5y9vCOSuTW2s7rz2Z9l2rOR3ksyTWSN3bWr9AN6FE4svglqg4pJ7qZDUKDy8/7gr5+S
        OU1MBcYbP6rPdyFkpACzQSWgsfgGlbk8EvjQkvFD9rwfRk+vvJSTDcOoRFGhaNWFisE+z2WuhNvSn
        +A5tYHArviKC/9C5eIv7iFtFJVg6rPZ+Q6OwFP7XSJAqwyFtbwzDTTM765WBo1YAJfl9Uk7gaK20o
        /HVKB+iex/+lZXpyeL3MOlul4r0Prt6p3ZJqXsePISDckGxyLnd5uqm9JBMY198bBZMNIKyto9x8F
        0/Qlg3KQ==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghl-0005yL-10; Fri, 13 Sep 2019 09:13:21 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 07/18] netfilter: move inline function to a more appropriate header.
Date:   Fri, 13 Sep 2019 09:13:07 +0100
Message-Id: <20190913081318.16071-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913081318.16071-1-jeremy@azazel.net>
References: <20190913081318.16071-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is an inline function in ip6_tables.h which is not specific to
ip6tables and is used elswhere in netfilter.  Move it into
netfilter_ipv6.h and update the callers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter_ipv6.h            | 12 ++++++++++++
 include/linux/netfilter_ipv6/ip6_tables.h | 12 ------------
 net/ipv6/netfilter/ip6t_ipv6header.c      |  4 ++--
 net/ipv6/netfilter/nf_log_ipv6.c          |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index a889e376d197..c1500209cfaf 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -10,6 +10,18 @@
 #include <uapi/linux/netfilter_ipv6.h>
 #include <net/tcp.h>
 
+/* Check for an extension */
+static inline int
+nf_ip6_ext_hdr(u8 nexthdr)
+{	return (nexthdr == IPPROTO_HOPOPTS) ||
+	       (nexthdr == IPPROTO_ROUTING) ||
+	       (nexthdr == IPPROTO_FRAGMENT) ||
+	       (nexthdr == IPPROTO_ESP) ||
+	       (nexthdr == IPPROTO_AH) ||
+	       (nexthdr == IPPROTO_NONE) ||
+	       (nexthdr == IPPROTO_DSTOPTS);
+}
+
 /* Extra routing may needed on local out, as the QUEUE target never returns
  * control to the table.
  */
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 666450c117bf..3a0a2bd054cc 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -36,18 +36,6 @@ extern unsigned int ip6t_do_table(struct sk_buff *skb,
 				  struct xt_table *table);
 #endif
 
-/* Check for an extension */
-static inline int
-ip6t_ext_hdr(u8 nexthdr)
-{	return (nexthdr == IPPROTO_HOPOPTS) ||
-	       (nexthdr == IPPROTO_ROUTING) ||
-	       (nexthdr == IPPROTO_FRAGMENT) ||
-	       (nexthdr == IPPROTO_ESP) ||
-	       (nexthdr == IPPROTO_AH) ||
-	       (nexthdr == IPPROTO_NONE) ||
-	       (nexthdr == IPPROTO_DSTOPTS);
-}
-
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index 0fc6326ef499..c52ff929c93b 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -16,7 +16,7 @@
 #include <net/ipv6.h>
 
 #include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
 MODULE_LICENSE("GPL");
@@ -42,7 +42,7 @@ ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	len = skb->len - ptr;
 	temp = 0;
 
-	while (ip6t_ext_hdr(nexthdr)) {
+	while (nf_ip6_ext_hdr(nexthdr)) {
 		const struct ipv6_opt_hdr *hp;
 		struct ipv6_opt_hdr _hdr;
 		int hdrlen;
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index f53bd8f01219..22b80db6d882 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -18,7 +18,7 @@
 #include <net/route.h>
 
 #include <linux/netfilter.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/xt_LOG.h>
 #include <net/netfilter/nf_log.h>
 
@@ -70,7 +70,7 @@ static void dump_ipv6_packet(struct net *net, struct nf_log_buf *m,
 	fragment = 0;
 	ptr = ip6hoff + sizeof(struct ipv6hdr);
 	currenthdr = ih->nexthdr;
-	while (currenthdr != NEXTHDR_NONE && ip6t_ext_hdr(currenthdr)) {
+	while (currenthdr != NEXTHDR_NONE && nf_ip6_ext_hdr(currenthdr)) {
 		struct ipv6_opt_hdr _hdr;
 		const struct ipv6_opt_hdr *hp;
 
-- 
2.23.0

