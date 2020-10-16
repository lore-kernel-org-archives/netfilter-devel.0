Return-Path: <SRS0=ZKiM=DX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67ECCC43467
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 16:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2228720848
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Oct 2020 16:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410934AbgJPQ4e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Oct 2020 12:56:34 -0400
Received: from correo.us.es ([193.147.175.20]:60202 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410921AbgJPQ4e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Oct 2020 12:56:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4ED7ADCE0
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 18:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5BECDA730
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 18:56:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB5E2DA78B; Fri, 16 Oct 2020 18:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A2C8DA730
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 18:56:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 16 Oct 2020 18:56:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 3560142EE395
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2020 18:56:30 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnfnl] expr: expose nftnl_expr_build_payload()
Date:   Fri, 16 Oct 2020 18:56:26 +0200
Message-Id: <20201016165626.25387-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function allows you to build the netlink attributes for
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/libnftnl/expr.h | 2 ++
 src/expr.c              | 1 +
 src/libnftnl.map        | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index dcbcf5c5c575..c2b2d8644bcd 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -36,6 +36,8 @@ uint32_t nftnl_expr_get_u32(const struct nftnl_expr *expr, uint16_t type);
 uint64_t nftnl_expr_get_u64(const struct nftnl_expr *expr, uint16_t type);
 const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type);
 
+void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr);
+
 int nftnl_expr_snprintf(char *buf, size_t buflen, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 int nftnl_expr_fprintf(FILE *fp, const struct nftnl_expr *expr, uint32_t type, uint32_t flags);
 
diff --git a/src/expr.c b/src/expr.c
index 80c4c36a9bd7..ed2f60e1429f 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -203,6 +203,7 @@ const char *nftnl_expr_get_str(const struct nftnl_expr *expr, uint16_t type)
 	return (const char *)nftnl_expr_get(expr, type, &data_len);
 }
 
+EXPORT_SYMBOL(nftnl_expr_build_payload);
 void nftnl_expr_build_payload(struct nlmsghdr *nlh, struct nftnl_expr *expr)
 {
 	struct nlattr *nest;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index ceafa3f6b117..7937e05b669d 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -371,4 +371,5 @@ LIBNFTNL_14 {
 
 LIBNFTNL_15 {
   nftnl_obj_get_data;
+  nftnl_expr_build_payload;
 } LIBNFTNL_14;
-- 
2.20.1

