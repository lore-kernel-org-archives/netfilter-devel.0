Return-Path: <SRS0=gJ4i=6M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCDDC83006
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDBF206D7
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Apr 2020 12:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgD1MK3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Apr 2020 08:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726554AbgD1MK2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Apr 2020 08:10:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B61FC03C1A9
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Apr 2020 05:10:28 -0700 (PDT)
Received: from localhost ([::1]:38614 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jTP4F-00084C-FG; Tue, 28 Apr 2020 14:10:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 05/18] ebtables-restore: Table line to trigger implicit commit
Date:   Tue, 28 Apr 2020 14:10:00 +0200
Message-Id: <20200428121013.24507-6-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428121013.24507-1-phil@nwl.cc>
References: <20200428121013.24507-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Cache code is suited for holding multiple tables' data at once. The only
users of that are xtables-save and ebtables-restore with its support for
multiple tables and lack of explicit COMMIT lines.

Remove the second user by introducing implicit commits upon table line
parsing. This would allow to make cache single table only, but then
xtables-save would fetch cache multiple times (once for each table) and
therefore lose atomicity with regards to the acquired kernel ruleset
image.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop the custom table_new callback, committing from there is too late
  since table_flush happens before. Instead explicitly call commit()
  from parser.
---
 iptables/xtables-restore.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index fe7148c9fcb3f..53a0d3738eb74 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -126,6 +126,10 @@ static void xtables_restore_parse_line(struct nft_handle *h,
 		if (p->tablename && (strcmp(p->tablename, table) != 0))
 			return;
 
+		/* implicit commit if no explicit COMMIT supported */
+		if (!p->commit)
+			cb->commit(h);
+
 		if (h->noflush == 0) {
 			DEBUGP("Cleaning all chains of table '%s'\n", table);
 			if (cb->table_flush)
-- 
2.25.1

