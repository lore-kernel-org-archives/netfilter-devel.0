Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E241FCD6E56
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 09:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjJKJzJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 05:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjJKJzI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 05:55:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6213F94
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 02:55:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH conntrack] conntrack: label update requires a previous label in place
Date:   Wed, 11 Oct 2023 11:55:03 +0200
Message-Id: <20231011095503.131168-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

You have to set an initial label if you plan to update it later on.  If
conntrack comes with no initial label, then it is not possible to attach
it later because conntrack extensions are created by the time the new
entry is created.

Skip entries with no label to skip ENOSPC error for conntracks that have
no initial label (this is assuming a scenario with conntracks with and
_without_ labels is possible, and the conntrack command line tool is used
to update all entries regardless they have or not an initial label, e.g.
conntrack -U --label-add "testlabel".

 # conntrack -U --label-add testlabel --dst 9.9.9.9
 icmp     1 13 src=192.168.2.130 dst=9.9.9.9 type=8 code=0 id=50997 src=9.9.9.9 dst=192.168.2.130 type=0 code=0 id=50997 mark=0 use=2 labels=default,testlabel
conntrack v1.4.8 (conntrack-tools): 1 flow entries have been updated.
 # conntrack -C
 8

Note the remaining 7 conntracks have no label, hence, they could not be
updated.

Update manpage to document this behaviour.

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1622
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 conntrack.8     | 2 ++
 src/conntrack.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/conntrack.8 b/conntrack.8
index 031eaa4e9fef..97c60079889f 100644
--- a/conntrack.8
+++ b/conntrack.8
@@ -193,6 +193,8 @@ Use multiple \-l options to specify multiple labels that need to be set.
 Specify the conntrack label to add to the selected conntracks.
 This option is only available in conjunction with "\-I, \-\-create",
 "\-A, \-\-add" or "\-U, \-\-update".
+You must set a default label for conntracks initially if you plan to update it
+later. "\-U, \-\-update" on conntracks with no initial entry will be ignored.
 .TP
 .BI "--label-del " "[LABEL]"
 Specify the conntrack label to delete from the selected conntracks.
diff --git a/src/conntrack.c b/src/conntrack.c
index f9758d78d39b..06c2fee7ac4b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2195,6 +2195,10 @@ static int mnl_nfct_update_cb(const struct nlmsghdr *nlh, void *data)
 		/* the entry has vanish in middle of the update */
 		if (errno == ENOENT)
 			goto destroy_ok;
+		else if (!(cmd->options & (CT_OPT_ADD_LABEL | CT_OPT_DEL_LABEL)) &&
+			 errno == ENOSPC)
+			goto destroy_ok;
+
 		exit_error(OTHER_PROBLEM,
 			   "Operation failed: %s",
 			   err2str(errno, CT_UPDATE));
-- 
2.30.2

