Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A516CC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 13:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 810E42054F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 13:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbfITNuv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:50:51 -0400
Received: from correo.us.es ([193.147.175.20]:47650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727836AbfITNuv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 09:50:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6720C508CC6
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5885EDA4CA
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E228DA8E8; Fri, 20 Sep 2019 15:50:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27B03B7FF2
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 15:50:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [5.182.56.138])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D3CAD4265A5A
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 15:50:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools,v2 1/2] conntrackd: Fix "Address Accept" filter case
Date:   Fri, 20 Sep 2019 15:50:42 +0200
Message-Id: <20190920135043.12594-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Robin Geuze <robing@transip.nl>

This fixes a bug in the Address Accept filter case where if you only
specify either addresses or masks it would never match, eg.

Filter From Usespace {
    Address Accept {
        IPv4_address 127.0.0.1
    }
}

or

Filter From Usespace {
    Address Accept {
        IPv4_address 0.0.0.0/0
    }
}

If lpm filter fails, fall back to hashtable lookup for exact matching.
If lpm filter succeeds, then depending on the policy, skip hashtable
lookup (in case policy is accept) or return mismatch (in case policy is
ignore).

Signed-off-by: Robin Geuze <robing@transip.nl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: simply previous version.

 src/filter.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/src/filter.c b/src/filter.c
index 00a5e96ecc24..65771025308f 100644
--- a/src/filter.c
+++ b/src/filter.c
@@ -335,16 +335,22 @@ ct_filter_check(struct ct_filter *f, const struct nf_conntrack *ct)
 		switch(nfct_get_attr_u8(ct, ATTR_L3PROTO)) {
 		case AF_INET:
 			ret = vector_iterate(f->v, ct, __ct_filter_test_mask4);
-			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+			if (ret) {
+				if (f->logic[CT_FILTER_ADDRESS])
+					break;
 				return 0;
+			}
 			ret = __ct_filter_test_ipv4(f, ct);
 			if (ret ^ f->logic[CT_FILTER_ADDRESS])
 				return 0;
 			break;
 		case AF_INET6:
 			ret = vector_iterate(f->v6, ct, __ct_filter_test_mask6);
-			if (ret ^ f->logic[CT_FILTER_ADDRESS])
+			if (ret) {
+				if (f->logic[CT_FILTER_ADDRESS])
+					break;
 				return 0;
+			}
 			ret = __ct_filter_test_ipv6(f, ct);
 			if (ret ^ f->logic[CT_FILTER_ADDRESS])
 				return 0;
-- 
2.11.0

