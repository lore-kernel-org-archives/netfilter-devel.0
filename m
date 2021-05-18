Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA433C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 12:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B1026108B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 12:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbhERMjm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 08:39:42 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42796 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239716AbhERMjl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 08:39:41 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AA3A36415E
        for <netfilter-devel@vger.kernel.org>; Tue, 18 May 2021 14:37:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables,v2] datatype: skip cgroupv2 rootfs in listing
Date:   Tue, 18 May 2021 14:38:17 +0200
Message-Id: <20210518123817.64715-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

cgroupv2 path is expressed from the /sys/fs/cgroup, update listing
to skip the rootfs.

 # nft add rule x y socket cgroupv2 level 1 "user.slice" counter
 # nft list ruleset
 table ip x {
        chain y {
                type filter hook input priority filter; policy accept;
                socket cgroupv2 level 1 "user.slice" counter
        }
 }

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: update commit description.

 src/datatype.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/datatype.c b/src/datatype.c
index 743505de44b6..7267d60895d8 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -1382,7 +1382,8 @@ static void cgroupv2_type_print(const struct expr *expr,
 
 	cgroup_path = cgroupv2_get_path(SYSFS_CGROUPSV2_PATH, id);
 	if (cgroup_path)
-		nft_print(octx, "\"%s\"", cgroup_path);
+		nft_print(octx, "\"%s\"",
+			  &cgroup_path[strlen(SYSFS_CGROUPSV2_PATH) + 1]);
 	else
 		nft_print(octx, "%" PRIu64, id);
 
-- 
2.30.2

