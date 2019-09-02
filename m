Return-Path: <SRS0=j12K=W5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8DD5C3A59E
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEA4022CF7
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Sep 2019 23:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ZtaGz7Ip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfIBXcG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Sep 2019 19:32:06 -0400
Received: from kadath.azazel.net ([81.187.231.250]:43926 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfIBXcG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Sep 2019 19:32:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Mxk7uUvRaoeBsf2+td3t3pWmsNV1pBQSxgK+PWUlbk=; b=ZtaGz7IpBz65DsLJmHtvH0miiD
        EQwTioLSeY+Ay2ZZkfw9euslViWsXP2b4P0DBogHwP4ALnjCdqWyUCVi5HHz9bo1+Z+CX1Y0vVbQ/
        rbXlTGZTfcLv0lhFPn8s7f2qjVmWG6mqoUGSyuL/H6JTjV/tosuW2WBhZot6oe2aK6adYYqsoKqzg
        Q/VXCcsJt5wzLbOBKcrRz+Mcutk58t7lcwLHG2DWuiOZ7tas/iVGHEvpbLl6TT/4ONRjqF/WbOskG
        2HsR0fgOnL/L5nwV/J0851z8w6jnZAXMxtJgLTS3pdqQrQoyILwD2VyI2hSVAPZ1iZcKviodxXbTj
        LbLxzdSg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4vPQ-0004la-VU; Tue, 03 Sep 2019 00:06:53 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 16/30] netfilter: move code between synproxy headers.
Date:   Tue,  3 Sep 2019 00:06:36 +0100
Message-Id: <20190902230650.14621-17-jeremy@azazel.net>
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

There is some non-conntrack code in the nf_conntrack_synproxy.h header.
Move it to the nf_synproxy.h header.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_synproxy.h | 39 -------------------
 include/net/netfilter/nf_synproxy.h           | 38 ++++++++++++++++++
 2 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index 2f0171d24997..c22f0c11cc82 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -43,43 +43,4 @@ static inline bool nf_ct_add_synproxy(struct nf_conn *ct,
 	return true;
 }
 
-struct synproxy_stats {
-	unsigned int			syn_received;
-	unsigned int			cookie_invalid;
-	unsigned int			cookie_valid;
-	unsigned int			cookie_retrans;
-	unsigned int			conn_reopened;
-};
-
-struct synproxy_net {
-	struct nf_conn			*tmpl;
-	struct synproxy_stats __percpu	*stats;
-	unsigned int			hook_ref4;
-	unsigned int			hook_ref6;
-};
-
-extern unsigned int synproxy_net_id;
-static inline struct synproxy_net *synproxy_pernet(struct net *net)
-{
-	return net_generic(net, synproxy_net_id);
-}
-
-struct synproxy_options {
-	u8				options;
-	u8				wscale;
-	u16				mss_option;
-	u16				mss_encode;
-	u32				tsval;
-	u32				tsecr;
-};
-
-struct tcphdr;
-struct nf_synproxy_info;
-bool synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
-			    const struct tcphdr *th,
-			    struct synproxy_options *opts);
-
-void synproxy_init_timestamp_cookie(const struct nf_synproxy_info *info,
-				    struct synproxy_options *opts);
-
 #endif /* _NF_CONNTRACK_SYNPROXY_H */
diff --git a/include/net/netfilter/nf_synproxy.h b/include/net/netfilter/nf_synproxy.h
index dc420b47e3aa..19d1af7a0348 100644
--- a/include/net/netfilter/nf_synproxy.h
+++ b/include/net/netfilter/nf_synproxy.h
@@ -11,6 +11,44 @@
 #include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netfilter/nf_conntrack_synproxy.h>
 
+struct synproxy_stats {
+	unsigned int			syn_received;
+	unsigned int			cookie_invalid;
+	unsigned int			cookie_valid;
+	unsigned int			cookie_retrans;
+	unsigned int			conn_reopened;
+};
+
+struct synproxy_net {
+	struct nf_conn			*tmpl;
+	struct synproxy_stats __percpu	*stats;
+	unsigned int			hook_ref4;
+	unsigned int			hook_ref6;
+};
+
+extern unsigned int synproxy_net_id;
+static inline struct synproxy_net *synproxy_pernet(struct net *net)
+{
+	return net_generic(net, synproxy_net_id);
+}
+
+struct synproxy_options {
+	u8				options;
+	u8				wscale;
+	u16				mss_option;
+	u16				mss_encode;
+	u32				tsval;
+	u32				tsecr;
+};
+
+struct nf_synproxy_info;
+bool synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
+			    const struct tcphdr *th,
+			    struct synproxy_options *opts);
+
+void synproxy_init_timestamp_cookie(const struct nf_synproxy_info *info,
+				    struct synproxy_options *opts);
+
 void synproxy_send_client_synack(struct net *net, const struct sk_buff *skb,
 				 const struct tcphdr *th,
 				 const struct synproxy_options *opts);
-- 
2.23.0.rc1

