Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A02EC31E5B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79E92084B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 16:51:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729785AbfFRQvG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 12:51:06 -0400
Received: from mail.us.es ([193.147.175.20]:55486 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbfFRQvG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 12:51:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 561EAED602
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:51:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 476DBDA703
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:51:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3D0DBDA702; Tue, 18 Jun 2019 18:51:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30272DA703
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:51:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 18 Jun 2019 18:51:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0ED3B4265A31
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 18:51:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: do not suggest anonymous sets on mispelling errors
Date:   Tue, 18 Jun 2019 18:50:58 +0200
Message-Id: <20190618165058.12249-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

 # nft list set x __set000
 Error: No such file or directory; did you mean set ‘__set0’ in table ip ‘x’?
 list set x __set000
            ^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/rule.c b/src/rule.c
index f60374abcfbc..048a7fb4c92c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -388,6 +388,8 @@ struct set *set_lookup_fuzzy(const char *set_name,
 
 	list_for_each_entry(table, &cache->list, list) {
 		list_for_each_entry(set, &table->sets, list) {
+			if (set->flags & NFT_SET_ANONYMOUS)
+				continue;
 			if (!strcmp(set->handle.set.name, set_name)) {
 				*t = table;
 				return set;
-- 
2.11.0

