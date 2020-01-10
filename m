Return-Path: <SRS0=mMMR=27=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4958BC33CA2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2516020721
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Jan 2020 11:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgAJLLU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Jan 2020 06:11:20 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:34980 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbgAJLLT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Jan 2020 06:11:19 -0500
Received: from localhost ([::1]:48070 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ipsCE-0002kG-52; Fri, 10 Jan 2020 12:11:18 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/3] monitor: Fix for use after free when printing map elements
Date:   Fri, 10 Jan 2020 12:11:13 +0100
Message-Id: <20200110111114.23952-3-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200110111114.23952-1-phil@nwl.cc>
References: <20200110111114.23952-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When populating the dummy set, 'data' field must be cloned just like
'key' field.

Fixes: 343a51702656a ("src: store expr, not dtype to track data in sets")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/monitor.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/monitor.c b/src/monitor.c
index 84505eb914bf6..53a8bcd4641d1 100644
--- a/src/monitor.c
+++ b/src/monitor.c
@@ -401,7 +401,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 	 */
 	dummyset = set_alloc(monh->loc);
 	dummyset->key = expr_clone(set->key);
-	dummyset->data = set->data;
+	if (set->data)
+		dummyset->data = expr_clone(set->data);
 	dummyset->flags = set->flags;
 	dummyset->init = set_expr_alloc(monh->loc, set);
 
-- 
2.24.1

