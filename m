From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] examples/genl: fix newline imbalance
Date: Sat,  8 Jan 2011 04:09:46 +0100
Message-ID: <1294456188-4221-2-git-send-email-jengelh@medozas.de>
References: <1294456188-4221-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41632 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1AHDJv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:09:51 -0500
In-Reply-To: <1294456188-4221-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Running `genl-family-get VFS_DQUOT` forgets to print a newline.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/genl/genl-family-get.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index ba8291e..1ad1a04 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -169,12 +169,13 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 		printf("maxattr=%u\t",
 			mnl_attr_get_u32(tb[CTRL_ATTR_MAXATTR]));
 	}
+	printf("\n");
 	if (tb[CTRL_ATTR_OPS]) {
-		printf("\nops:\n");
+		printf("ops:\n");
 		parse_genl_family_ops(tb[CTRL_ATTR_OPS]);
 	}
 	if (tb[CTRL_ATTR_MCAST_GROUPS]) {
-		printf("\ngrps:\n");
+		printf("grps:\n");
 		parse_genl_mc_grps(tb[CTRL_ATTR_MCAST_GROUPS]);
 	}
 	return MNL_CB_OK;
-- 
1.7.1

