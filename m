Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8249C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 11:01:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BDD8B20675
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfCFLBA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 06:01:00 -0500
Received: from mail.us.es ([193.147.175.20]:38102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbfCFLBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 06:01:00 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A0BE19D8AE
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 12:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4ECA0DA864
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 12:00:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D43BDA84C; Wed,  6 Mar 2019 12:00:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 122E6DA8F6
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 12:00:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Mar 2019 12:00:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id E1B5B4265A4C
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 12:00:54 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: misleading error reporting
Date:   Wed,  6 Mar 2019 12:00:51 +0100
Message-Id: <20190306110051.22974-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When trying to list a map content, if set is used, error reporting reports:

 # nft list set filter group_7933
 Error: No such file or directory; did you mean set ‘group_7933’ in table ip ‘filter’?
 list set filter group_7933
                 ^^^^^^^^^^

Which is confusing in case user wants to list an existing map:

 # nft list map filter group_7933
 table ip filter {
        map group_7933 {
                type ipv4_addr : classid
                flags interval
                elements = { 10.4.22.0/24 : 1:c7cb }
        }
 }

Instead, give a hint to user that probably wants to list a map, not a set:

 # nft list set filter group_7933
 Error: No such file or directory; did you mean map ‘group_7933’ in table ip ‘filter’?
 list set filter group_7933
                 ^^^^^^^^^^

Fixes: 285bb67a11ad ("src: introduce simple hints on incorrect set")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 29c436cd3cff..54afc3340186 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -209,10 +209,12 @@ static int set_not_found(struct eval_ctx *ctx, const struct location *loc,
 		return cmd_error(ctx, loc, "%s", strerror(ENOENT));
 
 	return cmd_error(ctx, loc,
-			 "%s; did you mean set ‘%s’ in table %s ‘%s’?",
-			 strerror(ENOENT), set->handle.set.name,
-				 family2str(set->handle.family),
-				 table->handle.table.name);
+			 "%s; did you mean %s ‘%s’ in table %s ‘%s’?",
+			 strerror(ENOENT),
+			 set->flags & NFT_SET_MAP ? "map" : "set",
+			 set->handle.set.name,
+			 family2str(set->handle.family),
+			 table->handle.table.name);
 }
 
 /*
-- 
2.11.0

