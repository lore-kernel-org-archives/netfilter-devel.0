Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C90DC4CEC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D65A20693
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 11:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbfIMLbY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 07:31:24 -0400
Received: from correo.us.es ([193.147.175.20]:42672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388117AbfIMLbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26CC64FFE01
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 112DCA7E62
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 06D1EA7EFD; Fri, 13 Sep 2019 13:31:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED211FF6E4;
        Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C008842EE393;
        Fri, 13 Sep 2019 13:31:16 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 10/27] netfilter: fix include guards.
Date:   Fri, 13 Sep 2019 13:30:45 +0200
Message-Id: <20190913113102.15776-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

nf_conntrack_labels.h has no include guard.  Add it.

The comment following the #endif in the nf_flow_table.h include guard
referred to the wrong macro.  Fix it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.11.0

