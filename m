Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049C5C4CECB
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D31A4208C2
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 08:13:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eMEX52tW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387413AbfIMIN0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 04:13:26 -0400
Received: from kadath.azazel.net ([81.187.231.250]:60584 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729222AbfIMINY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 04:13:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=km1ykrUvWFPXynlUz/HqU6Wa44g+ywwpZuWlz0Ec6eU=; b=eMEX52tWR3dMrhT65878Ms/ba+
        3Nl07eMDXb2YSSH8jtvwCLzlJA05EGI8LTkPY8LUEpf/hLP/4+TNnMdTC+dQTEh81h5Qo5/Jt48Vq
        GFe1p9OaWgDQVK97qbN51i5EX0k9J+W4lVuIzNZ56bu+QYtYgQR2lZAJa0LwVf1EqIHXRPO7bxnPz
        MRIo5WkX9wYZYsAgEt5cRHfxGudKRTHMxHCNxrjUB8L4rFVp5jg30fb+Hrh0RypTc/mKTiouVKEWV
        +nrgKOsTNYCNq3BwVE7G+aqW7oOiOLBkEg1FIbZ+lxVPQjBUC8ndf061ZeZlpCcL4vEkmNyXaDsJl
        tTWA/TXg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i8ghj-0005yL-DR; Fri, 13 Sep 2019 09:13:19 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v3 01/18] netfilter: fix include guards.
Date:   Fri, 13 Sep 2019 09:13:01 +0100
Message-Id: <20190913081318.16071-2-jeremy@azazel.net>
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

nf_conntrack_labels.h has no include guard.  Add it.

The comment following the #endif in the nf_flow_table.h include guard
referred to the wrong macro.  Fix it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/net/netfilter/nf_conntrack_labels.h | 11 ++++++++---
 include/net/netfilter/nf_flow_table.h       |  2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_labels.h b/include/net/netfilter/nf_conntrack_labels.h
index 4eacce6f3bcc..ba916411c4e1 100644
--- a/include/net/netfilter/nf_conntrack_labels.h
+++ b/include/net/netfilter/nf_conntrack_labels.h
@@ -1,11 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include <linux/types.h>
-#include <net/net_namespace.h>
+
+#ifndef _NF_CONNTRACK_LABELS_H
+#define _NF_CONNTRACK_LABELS_H
+
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/types.h>
+#include <net/net_namespace.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
-
 #include <uapi/linux/netfilter/xt_connlabel.h>
 
 #define NF_CT_LABELS_MAX_SIZE ((XT_CONNLABEL_MAXBIT + 1) / BITS_PER_BYTE)
@@ -51,3 +54,5 @@ static inline void nf_conntrack_labels_fini(void) {}
 static inline int nf_connlabels_get(struct net *net, unsigned int bit) { return 0; }
 static inline void nf_connlabels_put(struct net *net) {}
 #endif
+
+#endif /* _NF_CONNTRACK_LABELS_H */
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 609df33b1209..d875be62cdf0 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -127,4 +127,4 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
-#endif /* _FLOW_OFFLOAD_H */
+#endif /* _NF_FLOW_TABLE_H */
-- 
2.23.0

