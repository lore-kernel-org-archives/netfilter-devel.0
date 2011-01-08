From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/2] examples/genl: support dumping the genl families
Date: Sat,  8 Jan 2011 04:09:47 +0100
Message-ID: <1294456188-4221-3-git-send-email-jengelh@medozas.de>
References: <1294456188-4221-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41636 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab1AHDJw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 22:09:52 -0500
In-Reply-To: <1294456188-4221-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The usage text already specified [family] as optional, now implement it :-)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 examples/genl/genl-family-get.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/examples/genl/genl-family-get.c b/examples/genl/genl-family-get.c
index 1ad1a04..b16f7b6 100644
--- a/examples/genl/genl-family-get.c
+++ b/examples/genl/genl-family-get.c
@@ -178,6 +178,7 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 		printf("grps:\n");
 		parse_genl_mc_grps(tb[CTRL_ATTR_MCAST_GROUPS]);
 	}
+	printf("\n");
 	return MNL_CB_OK;
 }
 
@@ -190,7 +191,7 @@ int main(int argc, char *argv[])
 	int ret;
 	unsigned int seq, portid;
 
-	if (argc != 2) {
+	if (argc > 2) {
 		printf("%s [family name]\n", argv[0]);
 		exit(EXIT_FAILURE);
 	}
@@ -205,7 +206,10 @@ int main(int argc, char *argv[])
 	genl->version = 1;
 
 	mnl_attr_put_u32(nlh, CTRL_ATTR_FAMILY_ID, GENL_ID_CTRL);
-	mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
+	if (argc >= 2)
+		mnl_attr_put_strz(nlh, CTRL_ATTR_FAMILY_NAME, argv[1]);
+	else
+		nlh->nlmsg_flags |= NLM_F_DUMP;
 
 	nl = mnl_socket_open(NETLINK_GENERIC);
 	if (nl == NULL) {
-- 
1.7.1

