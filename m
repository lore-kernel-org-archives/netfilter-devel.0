Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C9BC3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADA0022CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Q1kG6rPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfIBXcR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:17 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43996 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbfIBXcR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BGKqQhdutIWyARnd3VXdiR2nGAHouGxrSrSYTdUypi4=; b=Q1kG6rPZIbBYFLJVRipF5Kz+WD
        kGH5JvmVboSRlWeTnk6xjOG0RjmAp5MQqwWcShwJSLHE+oG1jSd+UTJIvhcvQAhajlGltodm5yC+n
        MJb07v4h2ScvkRbv7MSqOkWCgimBl4/ysDo3gYgX9nqucF+Ybk/7vQvCr97Dr1jiZCvfvM0jwjRP/
        A1xRKR8X4dnWzZWH2BAHFzHv7/00uB3LEsAfcZ4JB4D/T7K1Tnwk8h4PpxNMHbNCl9Rwdt3b84mq/
        wbVN4W2MwbWc9v7g3EJvVvS8LlvOGEmkoh3/xU6vjU4inaZM4lXZgi3EA+z3UR8UqFukHcZh3+QBi
        RY7kE2vQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPQ-0004la-RU; Tue, 03 Sep 2019 00:06:52 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 15/30] netfilter: move inline function to a more appropriate header.
Date:   Tue,  3 Sep 2019 00:06:35 +0100
Message-Id: <20190902230650.14621-16-jeremy@azazel.net>
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
index 9797685d1e11..b8f872844ba3 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -11,6 +11,18 @@
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
2.23.0.rc1

