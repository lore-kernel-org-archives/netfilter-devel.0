Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F56CC47082
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F176461285
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Jun 2021 15:40:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhFHPmL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:42:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56676 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhFHPmK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Jun 2021 11:42:10 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2E40563E3D
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Jun 2021 17:39:04 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] netlink: quick sort array of devices
Date:   Tue,  8 Jun 2021 17:40:12 +0200
Message-Id: <20210608154012.707-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Provide an ordered list of devices for (netdev) chain and flowtable.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1525
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: fix qsort_device_cmp()

 src/netlink.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/src/netlink.c b/src/netlink.c
index 6b6fe27762d5..7541ffd4408e 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -517,6 +517,14 @@ static int chain_parse_udata_cb(const struct nftnl_udata *attr, void *data)
 	return 0;
 }
 
+static int qsort_device_cmp(const void *a, const void *b)
+{
+	const char **x = (const char **)a;
+	const char **y = (const char **)b;
+
+	return strcmp(*x, *y) < 0;
+}
+
 struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 					const struct nftnl_chain *nlc)
 {
@@ -580,6 +588,11 @@ struct chain *netlink_delinearize_chain(struct netlink_ctx *ctx,
 			chain->dev_array_len = len;
 		}
 		chain->flags        |= CHAIN_F_BASECHAIN;
+
+		if (chain->dev_array_len) {
+			qsort(chain->dev_array, chain->dev_array_len,
+			      sizeof(char *), qsort_device_cmp);
+		}
 	}
 
 	if (nftnl_chain_is_set(nlc, NFTNL_CHAIN_USERDATA)) {
@@ -1582,6 +1595,11 @@ netlink_delinearize_flowtable(struct netlink_ctx *ctx,
 
 	flowtable->dev_array_len = len;
 
+	if (flowtable->dev_array_len) {
+		qsort(flowtable->dev_array, flowtable->dev_array_len,
+		      sizeof(char *), qsort_device_cmp);
+	}
+
 	priority = nftnl_flowtable_get_u32(nlo, NFTNL_FLOWTABLE_PRIO);
 	flowtable->priority.expr =
 				constant_expr_alloc(&netlink_location,
-- 
2.20.1

