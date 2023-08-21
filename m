Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB2EE4996
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 10:27:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbjHUK1s (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Aug 2023 06:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234690AbjHUK1s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2023 06:27:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3F767E7
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Aug 2023 03:27:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack] conntrack: skip ENOENT when -U/-D finds a stale conntrack entry
Date:   Mon, 21 Aug 2023 12:27:39 +0200
Message-Id: <20230821102739.4893-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

-U and -D commands iterate over the netlink dump and it might try to
update/delete an entry which is not in the kernel anymore. Skip ENOENT
errors.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 69a8fde6b5ee..20aeed52da0f 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -1989,10 +1989,14 @@ static int mnl_nfct_delete_cb(const struct nlmsghdr *nlh, void *data)
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK,
 			       nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO),
 			       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, ct, NULL);
-	if (res < 0)
+	if (res < 0) {
+		/* the entry has vanish in middle of the delete */
+		if (errno == ENOENT)
+			goto done;
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
 			   err2str(errno, CT_DELETE));
+	}
 
 	if (output_mask & _O_SAVE) {
 		ct_save_snprintf(buf, sizeof(buf), ct, labelmap, NFCT_T_DESTROY);
@@ -2188,8 +2192,12 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 			       nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO),
 			       IPCTNL_MSG_CT_NEW, NLM_F_ACK, NULL, tmp, NULL);
 	if (res < 0) {
-		fprintf(stderr, "Operation failed: %s\n",
-			err2str(errno, CT_UPDATE));
+		/* the entry has vanish in middle of the update */
+		if (errno == ENOENT)
+			goto destroy_ok;
+		exit_error(OTHER_PROBLEM,
+			   "Operation failed: %s",
+			   err2str(errno, CT_UPDATE));
 	}
 
 	res = nfct_mnl_request(modifier_sock, NFNL_SUBSYS_CTNETLINK,
-- 
2.30.2

