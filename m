Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEAB6C10F09
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 01:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6A0C20684
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 01:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfCFBJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 20:09:47 -0500
Received: from mail.us.es ([193.147.175.20]:54668 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727773AbfCFBJr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 20:09:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1CB55508CE8
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 02:09:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 073D5DA84C
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 02:09:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 05DC9DA797; Wed,  6 Mar 2019 02:09:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BE44DA84E;
        Wed,  6 Mar 2019 02:09:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Mar 2019 02:09:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D44B54265A2F;
        Wed,  6 Mar 2019 02:09:42 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, vaclav.zindulka@tlapnet.cz
Subject: [PATCH nft 2/2] segtree: add missing non-matching segment to set in flat representation
Date:   Wed,  6 Mar 2019 02:09:38 +0100
Message-Id: <20190306010938.23687-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190306010938.23687-1-pablo@netfilter.org>
References: <20190306010938.23687-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # cat test.nft
 add set x y { type ipv4_addr; }
 add element x y { 10.0.24.0/24 }
 # nft -f test.nft
 # nft delete element x y { 10.0.24.0/24 }

bogusly return -ENOENT. The closing segment (0.0.0.0 with end flag set
on ) is not added to the set in the example above.

This patch also adds a test to catch this case.

Fixes: 4935a0d561b5 ("segtree: special handling for the first non-matching segment")
Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c                                          |  9 ++++++---
 tests/shell/testcases/sets/0035add_set_elements_flat_0 | 10 ++++++++++
 2 files changed, 16 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/sets/0035add_set_elements_flat_0

diff --git a/src/segtree.c b/src/segtree.c
index ecf564e5fa07..8034525fb80b 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -430,16 +430,19 @@ static bool segtree_needs_first_segment(const struct set *set,
 					const struct expr *init, bool add)
 {
 	if (add) {
-		/* Add the first segment in three situations:
+		/* Add the first segment in four situations:
 		 *
 		 * 1) This is an anonymous set.
 		 * 2) This set exists and it is empty.
-		 * 3) This set is created with a number of initial elements.
+		 * 3) New empty set and, separately, new elements are added.
+		 * 4) This set is created with a number of initial elements.
 		 */
 		if ((set->flags & NFT_SET_ANONYMOUS) ||
 		    (set->init && set->init->size == 0) ||
-		    (set->init == init))
+		    (set->init == NULL && init) ||
+		    (set->init == init)) {
 			return true;
+		}
 	} else {
 		/* If the set is empty after the removal, we have to
 		 * remove the first non-matching segment too.
diff --git a/tests/shell/testcases/sets/0035add_set_elements_flat_0 b/tests/shell/testcases/sets/0035add_set_elements_flat_0
new file mode 100755
index 000000000000..d914ba9846ca
--- /dev/null
+++ b/tests/shell/testcases/sets/0035add_set_elements_flat_0
@@ -0,0 +1,10 @@
+#!/bin/bash
+
+RULESET="add table ip x
+add set x y {type ipv4_addr; flags interval;}
+add element x y { 10.0.24.0/24 }
+"
+
+set -e
+$NFT -f - <<< "$RULESET"
+$NFT delete element x y { 10.0.24.0/24 }
-- 
2.11.0

