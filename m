From: Kevin Cernekee <cernekee@chromium.org>
Subject: [RFC/PATCH 3/3] netfilter: ctnetlink: Fix regression in CTA_HELP processing
Date: Mon, 16 Jan 2017 21:14:08 -0800
Message-ID: <1484630048-25416-4-git-send-email-cernekee@chromium.org>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

If a user program specifies CTA_HELP but the argument matches the
current conntrack helper name, ignore it instead of generating an error.

Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
---
 net/netfilter/nf_conntrack_netlink.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index cc59f388928e..2912f582da65 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1472,14 +1472,19 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
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
