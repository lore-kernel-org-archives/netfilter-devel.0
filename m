Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6C3C43217
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 15:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353091AbhLXPoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:44:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44502 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353080AbhLXPoD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:44:03 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id B0F2C62BD8
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 16:41:25 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 3/4] conntrack: use libmnl to create entry
Date:   Fri, 24 Dec 2021 16:43:50 +0100
Message-Id: <20211224154351.360124-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211224154351.360124-1-pablo@netfilter.org>
References: <20211224154351.360124-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl to create entries through the new nfct_mnl_create() helper
function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 3f74fa12fba2..fe604ff2efd4 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2505,6 +2505,24 @@ nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 	return nfct_mnl_talk(nlh, cb);
 }
 
+static int
+nfct_mnl_create(uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type,
+				    NLM_F_CREATE | NLM_F_ACK | NLM_F_EXCL,
+				    nfct_get_attr_u8(ct, ATTR_ORIG_L3PROTO));
+
+	err = nfct_nlmsg_build(nlh, ct);
+	if (err < 0)
+		return err;
+
+	return nfct_mnl_talk(nlh, NULL, NULL);
+}
+
 #define UNKNOWN_STATS_NUM 4
 
 static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
@@ -3322,14 +3340,16 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		res = nfct_mnl_socket_open(0);
+		if (res < 0)
+			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		res = nfct_query(cth, NFCT_Q_CREATE, cmd->tmpl.ct);
-		if (res != -1)
+		res = nfct_mnl_create(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW,
+				      cmd->tmpl.ct);
+		if (res >= 0)
 			counter++;
-		nfct_close(cth);
+
+		nfct_mnl_socket_close();
 		break;
 
 	case EXP_CREATE:
-- 
2.30.2

