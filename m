Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 573EBC47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 14:44:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32C892063A
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 14:44:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgD3OoG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:44:06 -0400
Received: from correo.us.es ([193.147.175.20]:51444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726780AbgD3OoF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 10:44:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B878DEF43F
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 16:44:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A810BB8002
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 16:44:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7523B7FF1; Thu, 30 Apr 2020 16:44:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93461B7FF1;
        Thu, 30 Apr 2020 16:44:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 16:44:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7071C42EFB81;
        Thu, 30 Apr 2020 16:44:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] rule: fix element cache update in __do_add_setelems()
Date:   Thu, 30 Apr 2020 16:43:59 +0200
Message-Id: <20200430144359.1551-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The set->init and expr arguments might actually refer to the same list
of elements. Skip set element cache update introduced by dd44081d91ce
("segtree: Fix add and delete of element in same batch") otherwise
list_splice_tail_init() actually operates with the same list as
arguments. Valgrind reports this problem as a memleak since the result
of this operation was an empty set element list.

Fixes: dd44081d91ce ("segtree: Fix add and delete of element in same batch")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index 9e80c0251947..23b1cbfc8fb2 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1564,7 +1564,7 @@ static int __do_add_setelems(struct netlink_ctx *ctx, struct set *set,
 		return -1;
 
 	if (!set_is_anonymous(set->flags) &&
-	    set->init != NULL &&
+	    set->init != NULL && set->init != expr &&
 	    set->flags & NFT_SET_INTERVAL &&
 	    set->desc.field_count <= 1) {
 		interval_map_decompose(expr);
-- 
2.20.1

