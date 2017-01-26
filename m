From: Kevin Cernekee <cernekee@chromium.org>
Subject: [PATCH V2 2/2] netfilter: ctnetlink: Fix regression in CTA_HELP processing
Date: Thu, 26 Jan 2017 14:49:44 -0800
Message-ID: <20170126224944.29047-2-cernekee@chromium.org>
References: <20170126224944.29047-1-cernekee@chromium.org>
Cc: dianders@chromium.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:33945 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdAZW56 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Jan 2017 17:57:58 -0500
Received: by mail-pg0-f42.google.com with SMTP id 14so75857338pgg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Jan 2017 14:57:02 -0800 (PST)
In-Reply-To: <20170126224944.29047-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Prior to Linux 4.4, it was usually harmless to send a CTA_HELP attribute
containing the name of the current helper.  That is no longer the case:
as of Linux 4.4, if ctnetlink_change_helper() returns an error from
the ct->master check, processing of the request will fail, skipping the
NFQA_EXP attribute (if present).

This patch changes the behavior to improve compatibility with user
programs that expect the kernel interface to work the way it did prior
to Linux 4.4.  If a user program specifies CTA_HELP but the argument
matches the current conntrack helper name, ignore it instead of generating
an error.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---


V1->V2:

 - Add comment and update changelog, per code review feedback
 - Rebase + retest on net-next


 net/netfilter/nf_conntrack_netlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e8f704a6..891f02a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1503,14 +1503,23 @@ static int ctnetlink_change_helper(struct nf_conn *ct,
 	struct nlattr *helpinfo = NULL;
 	int err;
 
-	/* don't change helper of sibling connections */
-	if (ct->master)
-		return -EBUSY;
-
 	err = ctnetlink_parse_help(cda[CTA_HELP], &helpname, &helpinfo);
 	if (err < 0)
 		return err;
 
+	/* don't change helper of sibling connections */
+	if (ct->master) {
+		/* If we try to change the helper to the same thing twice,
+		 * treat the second attempt as a no-op instead of returning
+		 * an error.
+		 */
+		if (help && help->helper &&
+		    !strcmp(help->helper->name, helpname))
+			return 0;
+		else
+			return -EBUSY;
+	}
+
 	if (!strcmp(helpname, "")) {
 		if (help && help->helper) {
 			/* we had a helper before ... */
-- 
2.7.4

