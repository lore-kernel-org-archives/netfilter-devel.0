Return-Path: <SRS0=M/8g=ZS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7475C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A49922071E
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Nov 2019 10:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfKZKec (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Nov 2019 05:34:32 -0500
Received: from correo.us.es ([193.147.175.20]:40774 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbfKZKec (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Nov 2019 05:34:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9C32508CCF
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 11:34:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9CBDA7EFC
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Nov 2019 11:34:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CEEDBA7EE6; Tue, 26 Nov 2019 11:34:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 757F9B8014;
        Tue, 26 Nov 2019 11:34:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 26 Nov 2019 11:34:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (barqueta.lsi.us.es [150.214.188.150])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 64C74426CCBA;
        Tue, 26 Nov 2019 11:34:25 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2] segtree: restore automerge
Date:   Tue, 26 Nov 2019 11:34:22 +0100
Message-Id: <20191126103422.29501-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191126103422.29501-1-pablo@netfilter.org>
References: <20191126103422.29501-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Always close interval in non-anonymous sets unless the auto-merge
feature is set on.

Fixes: a4ec05381261 ("segtree: always close interval in non-anonymous sets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Hi Phil,

this patch also supersedes https://patchwork.ozlabs.org/patch/1198896/.

Thanks.

 src/segtree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index 50e34050c167..b3c61fb088a5 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -497,7 +497,7 @@ static void segtree_linearize(struct list_head *list, const struct set *set,
 			 */
 			mpz_add_ui(p, prev->right, 1);
 			if (mpz_cmp(p, ei->left) < 0 ||
-			    !(set->flags & NFT_SET_ANONYMOUS)) {
+			    (!(set->flags & NFT_SET_ANONYMOUS) && !merge)) {
 				mpz_sub_ui(q, ei->left, 1);
 				nei = ei_alloc(p, q, NULL, EI_F_INTERVAL_END);
 				list_add_tail(&nei->list, list);
-- 
2.11.0

