Return-Path: <SRS0=0udB=D2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5404DC433E7
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 12:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE619223BF
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Oct 2020 12:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgJSMtW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Oct 2020 08:49:22 -0400
Received: from correo.us.es ([193.147.175.20]:34678 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726561AbgJSMtW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Oct 2020 08:49:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 32D11154E8D
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:49:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23E06DA78B
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:49:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 196A3DA73D; Mon, 19 Oct 2020 14:49:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE54BDA78C
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:49:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 19 Oct 2020 14:49:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 852E94301DE2
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Oct 2020 14:49:17 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: add nftnl_rule_del_expr()
Date:   Mon, 19 Oct 2020 14:49:13 +0200
Message-Id: <20201019124913.6938-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a function to remove expression from the rule list.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/rule.h | 1 +
 src/libnftnl.map        | 1 +
 src/rule.c              | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/include/libnftnl/rule.h b/include/libnftnl/rule.h
index e5d1ca0534b7..b6b93c62b840 100644
--- a/include/libnftnl/rule.h
+++ b/include/libnftnl/rule.h
@@ -51,6 +51,7 @@ uint32_t nftnl_rule_get_u32(const struct nftnl_rule *r, uint16_t attr);
 uint64_t nftnl_rule_get_u64(const struct nftnl_rule *r, uint16_t attr);
 
 void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr);
+void nftnl_rule_del_expr(struct nftnl_expr *expr);
 
 struct nlmsghdr;
 
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 7937e05b669d..2d35ace0355b 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -372,4 +372,5 @@ LIBNFTNL_14 {
 LIBNFTNL_15 {
   nftnl_obj_get_data;
   nftnl_expr_build_payload;
+  nftnl_rule_del_expr;
 } LIBNFTNL_14;
diff --git a/src/rule.c b/src/rule.c
index 8d7e0681cb42..480afc8ffc1b 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -330,6 +330,12 @@ void nftnl_rule_add_expr(struct nftnl_rule *r, struct nftnl_expr *expr)
 	list_add_tail(&expr->head, &r->expr_list);
 }
 
+EXPORT_SYMBOL(nftnl_rule_del_expr);
+void nftnl_rule_del_expr(struct nftnl_expr *expr)
+{
+	list_del(&expr->head);
+}
+
 static int nftnl_rule_parse_attr_cb(const struct nlattr *attr, void *data)
 {
 	const struct nlattr **tb = data;
-- 
2.20.1

