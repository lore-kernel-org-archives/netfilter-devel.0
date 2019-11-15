Return-Path: <SRS0=hXfx=ZH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC2DFC432C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9982A20729
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Nov 2019 21:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfKOVy3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Nov 2019 16:54:29 -0500
Received: from correo.us.es ([193.147.175.20]:33742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfKOVy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Nov 2019 16:54:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A8EEEBAC4
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:54:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CC0BDA4CA
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2019 22:54:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62837DA840; Fri, 15 Nov 2019 22:54:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6234DDA4CA;
        Fri, 15 Nov 2019 22:54:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 15 Nov 2019 22:54:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3F25C4251481;
        Fri, 15 Nov 2019 22:54:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     eric@garver.life
Subject: [PATCH libnftnl] flowtable: remove NFTA_FLOWTABLE_SIZE
Date:   Fri, 15 Nov 2019 22:54:21 +0100
Message-Id: <20191115215421.5023-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Never defined in upstream Linux kernel uAPI, remove it.

Reported-by: Eric Garver <eric@garver.life>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 2 --
 src/flowtable.c                     | 6 ------
 2 files changed, 8 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 81c27d3c9ffd..bb9b049310df 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1518,7 +1518,6 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
- * @NFTA_FLOWTABLE_SIZE: maximum size (NLA_U32)
  * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
@@ -1529,7 +1528,6 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
-	NFTA_FLOWTABLE_SIZE,
 	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
diff --git a/src/flowtable.c b/src/flowtable.c
index ec89b952e47d..324e80f7e6ad 100644
--- a/src/flowtable.c
+++ b/src/flowtable.c
@@ -324,8 +324,6 @@ void nftnl_flowtable_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_FLAGS, htonl(c->ft_flags));
 	if (c->flags & (1 << NFTNL_FLOWTABLE_USE))
 		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_USE, htonl(c->use));
-	if (c->flags & (1 << NFTNL_FLOWTABLE_SIZE))
-		mnl_attr_put_u32(nlh, NFTA_FLOWTABLE_SIZE, htonl(c->size));
 	if (c->flags & (1 << NFTNL_FLOWTABLE_HANDLE))
 		mnl_attr_put_u64(nlh, NFTA_FLOWTABLE_HANDLE, htobe64(c->handle));
 }
@@ -489,10 +487,6 @@ int nftnl_flowtable_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_flowtab
 		c->use = ntohl(mnl_attr_get_u32(tb[NFTA_FLOWTABLE_USE]));
 		c->flags |= (1 << NFTNL_FLOWTABLE_USE);
 	}
-	if (tb[NFTA_FLOWTABLE_SIZE]) {
-		c->size = ntohl(mnl_attr_get_u32(tb[NFTA_FLOWTABLE_SIZE]));
-		c->flags |= (1 << NFTNL_FLOWTABLE_SIZE);
-	}
 	if (tb[NFTA_FLOWTABLE_HANDLE]) {
 		c->handle = be64toh(mnl_attr_get_u64(tb[NFTA_FLOWTABLE_HANDLE]));
 		c->flags |= (1 << NFTNL_FLOWTABLE_HANDLE);
-- 
2.11.0

