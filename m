Return-Path: <SRS0=/pLU=RP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A5C5C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:24:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41B16206BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Mar 2019 11:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfCLLYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Mar 2019 07:24:37 -0400
Received: from mail.us.es ([193.147.175.20]:37020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725792AbfCLLYh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Mar 2019 07:24:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B150F2782
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:24:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78827DA87D
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Mar 2019 12:24:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77493DA87B; Tue, 12 Mar 2019 12:24:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DB6EDA796;
        Tue, 12 Mar 2019 12:24:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 12 Mar 2019 12:24:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 33D1C4265A2F;
        Tue, 12 Mar 2019 12:24:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz
Subject: [PATCH nf] netfilter: nft_set_rbtree: check for inactive element after flag mismatch
Date:   Tue, 12 Mar 2019 12:24:28 +0100
Message-Id: <20190312112428.25260-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Otherwise, we hit bogus ENOENT when removing elements.

Fixes: e701001e7cbe ("netfilter: nft_rbtree: allow adjacent intervals with dynamic updates")
Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_rbtree.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index fa61208371f8..321a0036fdf5 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -308,10 +308,6 @@ static void *nft_rbtree_deactivate(const struct net *net,
 		else if (d > 0)
 			parent = parent->rb_right;
 		else {
-			if (!nft_set_elem_active(&rbe->ext, genmask)) {
-				parent = parent->rb_left;
-				continue;
-			}
 			if (nft_rbtree_interval_end(rbe) &&
 			    !nft_rbtree_interval_end(this)) {
 				parent = parent->rb_left;
@@ -320,6 +316,9 @@ static void *nft_rbtree_deactivate(const struct net *net,
 				   nft_rbtree_interval_end(this)) {
 				parent = parent->rb_right;
 				continue;
+			} else if (!nft_set_elem_active(&rbe->ext, genmask)) {
+				parent = parent->rb_left;
+				continue;
 			}
 			nft_rbtree_flush(net, set, rbe);
 			return rbe;
-- 
2.11.0

