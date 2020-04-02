Return-Path: <SRS0=05X/=5S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 137A7C2BA15
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Apr 2020 21:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE1520CC7
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Apr 2020 21:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389328AbgDBVtu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 17:49:50 -0400
Received: from correo.us.es ([193.147.175.20]:35166 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731783AbgDBVtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 17:49:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11F9EE16E3
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2020 23:49:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 040F3100A45
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2020 23:49:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EDB3C100A42; Thu,  2 Apr 2020 23:49:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69822100A44;
        Thu,  2 Apr 2020 23:49:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 02 Apr 2020 23:49:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 4314F42EE38E;
        Thu,  2 Apr 2020 23:49:44 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH] segtree: bail out on concatenations
Date:   Thu,  2 Apr 2020 23:49:41 +0200
Message-Id: <20200402214941.60097-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a lazy check to validate that the first element is not a
concatenation. The segtree code does not support for concatenations,
bail out with EOPNOTSUPP.

 # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
 Error: Could not process rule: Operation not supported
 add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Otherwise, the segtree code barfs with:

 BUG: invalid range expression type concat

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/src/segtree.c b/src/segtree.c
index 8d79332d8578..85310f62c429 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -419,6 +419,17 @@ static int set_to_segtree(struct list_head *msgs, struct set *set,
 	unsigned int n;
 	int err;
 
+	/* Probe for the first element to check for concatenations, this code
+	 * does not support for intervals and concatenations.
+	 */
+	if (init) {
+		i = list_first_entry(&init->expressions, struct expr, list);
+		if (i->key->etype == EXPR_CONCAT) {
+			errno = EOPNOTSUPP;
+			return -1;
+		}
+	}
+
 	/* We are updating an existing set with new elements, check if the new
 	 * interval overlaps with any of the existing ones.
 	 */
-- 
2.11.0

