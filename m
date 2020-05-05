Return-Path: <SRS0=RRXz=6T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50DCC47247
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2E37206CC
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 May 2020 18:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgEESuy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 May 2020 14:50:54 -0400
Received: from correo.us.es ([193.147.175.20]:43588 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728627AbgEESuy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 May 2020 14:50:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 315301C438B
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:50:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 234D2115417
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:50:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18D06115416; Tue,  5 May 2020 20:50:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CC652004A
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:50:50 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 05 May 2020 20:50:50 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E4A1142EE38F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 May 2020 20:50:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: objref: add nftnl_expr_objref_free() to release object name
Date:   Tue,  5 May 2020 20:50:47 +0200
Message-Id: <20200505185047.12487-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==4876==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 9 byte(s) in 1 object(s) allocated from:
    #0 0x7f4e2c16b810 in strdup (/usr/lib/x86_64-linux-gnu/libasan.so.5+0x3a810)
    #1 0x7f4e2a39906f in nftnl_expr_objref_set expr/objref.c:45
    #2 0x7f4e2a39906f in nftnl_expr_objref_set expr/objref.c:35

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/expr/objref.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/expr/objref.c b/src/expr/objref.c
index 7388b18ac929..d3dd17ee788c 100644
--- a/src/expr/objref.c
+++ b/src/expr/objref.c
@@ -187,6 +187,13 @@ static int nftnl_expr_objref_snprintf_default(char *buf, size_t len,
 				objref->imm.type, objref->imm.name);
 }
 
+static void nftnl_expr_objref_free(const struct nftnl_expr *e)
+{
+	struct nftnl_expr_objref *objref = nftnl_expr_data(e);
+
+	xfree(objref->imm.name);
+}
+
 static int nftnl_expr_objref_snprintf(char *buf, size_t len, uint32_t type,
 				      uint32_t flags,
 				      const struct nftnl_expr *e)
@@ -206,6 +213,7 @@ struct expr_ops expr_ops_objref = {
 	.name		= "objref",
 	.alloc_len	= sizeof(struct nftnl_expr_objref),
 	.max_attr	= NFTA_OBJREF_MAX,
+	.free		= nftnl_expr_objref_free,
 	.set		= nftnl_expr_objref_set,
 	.get		= nftnl_expr_objref_get,
 	.parse		= nftnl_expr_objref_parse,
-- 
2.20.1

