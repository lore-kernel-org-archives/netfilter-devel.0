Return-Path: <SRS0=Lm+H=63=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F3CC433E2
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 15:15:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 568AF20671
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 May 2020 14:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389005AbgEMOiQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 May 2020 10:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEMOiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 May 2020 10:38:16 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616A1C061A0C
        for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2020 07:38:16 -0700 (PDT)
Received: from localhost ([::1]:47654 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jYsWT-0003iT-6R; Wed, 13 May 2020 16:38:13 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH] JSON: Improve performance of json_events_cb()
Date:   Wed, 13 May 2020 16:38:03 +0200
Message-Id: <20200513143803.25109-1-phil@nwl.cc>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The function tries to insert handles into JSON input for echo option.
Yet there may be nothing to do if the given netlink message doesn't
contain a handle, e.g. if it is an 'add element' command. Calling
seqnum_to_json() is pointless overhead in that case, and if input is
large this overhead is significant. Better wait with that call until
after checking if the message is relevant at all.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 4468407b0ecd0..3a84bd96af31f 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3847,12 +3847,15 @@ static uint64_t handle_from_nlmsg(const struct nlmsghdr *nlh)
 }
 int json_events_cb(const struct nlmsghdr *nlh, struct netlink_mon_handler *monh)
 {
-	json_t *tmp, *json = seqnum_to_json(nlh->nlmsg_seq);
 	uint64_t handle = handle_from_nlmsg(nlh);
+	json_t *tmp, *json;
 	void *iter;
 
-	/* might be anonymous set, ignore message */
-	if (!json || !handle)
+	if (!handle)
+		return MNL_CB_OK;
+
+	json = seqnum_to_json(nlh->nlmsg_seq);
+	if (!json)
 		return MNL_CB_OK;
 
 	tmp = json_object_get(json, "add");
-- 
2.26.2

