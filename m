Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A25FFCDB474
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Oct 2023 20:48:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344079AbjJLUsL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Oct 2023 16:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347407AbjJLUsK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2023 16:48:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9AD9CC
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Oct 2023 13:48:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH conntrack,v6] conntrack: ct label update requires proper ruleset
Date:   Thu, 12 Oct 2023 22:48:05 +0200
Message-Id: <20231012204805.593869-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

As of kernel 6.6-rc, your ruleset must use either the 'connlabel' match
in iptables or the 'ct label' statement in nftables to attach labels to
conntrack entries. Update documentation to describe this behaviour.

This patch addresses a corner case scenario: conntrack already contains
entries but ruleset that specifies connlabel did not get loaded yet.
In such case, skip ENOSPC errors for conntracks that have ct label
extension.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1622
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v6: fix patch subject, it was still referring to misconception.

 conntrack.8     | 4 ++++
 src/conntrack.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/conntrack.8 b/conntrack.8
index 031eaa4e9fef..3b6a15b5152d 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -193,6 +193,10 @@ Use multiple \-l options to specify multiple labels that need to be set.
 Specify the conntrack label to add to the selected conntracks.
 This option is only available in conjunction with "\-I, \-\-create",
 "\-A, \-\-add" or "\-U, \-\-update".
+As a rule of thumb, you must use either the 'connlabel' match in your iptables
+ruleset or the 'ct label' statement in your nftables ruleset, this turns on the
+ct label support in the kernel and it allows you to update labels via
+"\-U, \-\-update", otherwise label updates are ignored.
 .TP
 .BI "--label-del " "[LABEL]"
 Specify the conntrack label to delete from the selected conntracks.
diff --git a/src/conntrack.c b/src/conntrack.c
index f9758d78d39b..c1551cadbdb3 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2195,6 +2195,11 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 		/* the entry has vanish in middle of the update */
 		if (errno == ENOENT)
 			goto destroy_ok;
+		else if (cmd->options & (CT_OPT_ADD_LABEL | CT_OPT_DEL_LABEL) &&
+			 !nfct_attr_is_set(ct, ATTR_CONNLABELS) &&
+			 errno == ENOSPC)
+			goto destroy_ok;
+
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
 			   err2str(errno, CT_UPDATE));
-- 
2.30.2

