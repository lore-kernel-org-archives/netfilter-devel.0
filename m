Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66FAECE588
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA13020650
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 14:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfJOORS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 10:17:18 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:36888 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbfJOORS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 10:17:18 -0400
Received: from localhost ([::1]:49978 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iKNdV-00037j-Bi; Tue, 15 Oct 2019 16:17:17 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 1/6] obj: ct_timeout: Check return code of mnl_attr_parse_nested()
Date:   Tue, 15 Oct 2019 16:16:53 +0200
Message-Id: <20191015141658.11325-2-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015141658.11325-1-phil@nwl.cc>
References: <20191015141658.11325-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Don't ignore nested attribute parsing errors, this may hide bugs in
users' code.

Fixes: 0adceeab1597a ("src: add ct timeout support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/obj/ct_timeout.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index e2e99917de7ae..a439432deee18 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -116,7 +116,7 @@ parse_timeout_attr_policy_cb(const struct nlattr *attr, void *data)
 	return MNL_CB_OK;
 }
 
-static void
+static int
 timeout_parse_attr_data(struct nftnl_obj *e,
 			const struct nlattr *nest)
 {
@@ -131,7 +131,8 @@ timeout_parse_attr_data(struct nftnl_obj *e,
 
 	memset(tb, 0, sizeof(struct nlattr *) * attr_max);
 
-	mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt);
+	if (mnl_attr_parse_nested(nest, parse_timeout_attr_policy_cb, &cnt) < 0)
+		return -1;
 
 	for (i = 1; i <= attr_max; i++) {
 		if (tb[i]) {
@@ -139,6 +140,7 @@ timeout_parse_attr_data(struct nftnl_obj *e,
 				ntohl(mnl_attr_get_u32(tb[i])));
 		}
 	}
+	return 0;
 }
 
 static int nftnl_obj_ct_timeout_set(struct nftnl_obj *e, uint16_t type,
@@ -248,7 +250,8 @@ nftnl_obj_ct_timeout_parse(struct nftnl_obj *e, struct nlattr *attr)
 		e->flags |= (1 << NFTNL_OBJ_CT_TIMEOUT_L4PROTO);
 	}
 	if (tb[NFTA_CT_TIMEOUT_DATA]) {
-		timeout_parse_attr_data(e, tb[NFTA_CT_TIMEOUT_DATA]);
+		if (timeout_parse_attr_data(e, tb[NFTA_CT_TIMEOUT_DATA]) < 0)
+			return -1;
 		e->flags |= (1 << NFTNL_OBJ_CT_TIMEOUT_ARRAY);
 	}
 	return 0;
-- 
2.23.0

