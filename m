Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EC76C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 15:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353093AbhLXPoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 10:44:03 -0500
Received: from mail.netfilter.org ([217.70.188.207]:44498 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353090AbhLXPoC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 10:44:02 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9CF27607C4
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 16:41:24 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack 1/4] conntrack: add nfct_mnl_talk() and nfct_mnl_recv() helper functions
Date:   Fri, 24 Dec 2021 16:43:48 +0100
Message-Id: <20211224154351.360124-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211224154351.360124-1-pablo@netfilter.org>
References: <20211224154351.360124-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to consolidate nfct_mnl_dump() and nfct_mnl_get().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 54 +++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 5bd3cb56b641..067ae4156676 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2440,20 +2440,11 @@ static void nfct_mnl_socket_close(void)
 	mnl_socket_close(sock.mnl);
 }
 
-static int
-nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
-	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
+static int nfct_mnl_recv(const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
 {
-	uint8_t family = cmd ? cmd->family : AF_UNSPEC;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct nlmsghdr *nlh;
 	int res;
 
-	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
-
-	if (filter_dump)
-		nfct_nlmsg_build_filter(nlh, filter_dump);
-
 	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
 	if (res < 0)
 		return res;
@@ -2461,7 +2452,7 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
 	while (res > 0) {
 		res = mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid,
-				 cb, cmd);
+				 cb, data);
 		if (res <= MNL_CB_STOP)
 			break;
 
@@ -2472,23 +2463,46 @@ nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
 }
 
 static int
-nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+nfct_mnl_dump(uint16_t subsys, uint16_t type, mnl_cb_t cb,
+	      struct ct_cmd *cmd, const struct nfct_filter_dump *filter_dump)
 {
+	uint8_t family = cmd ? cmd->family : AF_UNSPEC;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct nlmsghdr *nlh;
-	int res;
 
 	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
 
-	res = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
-	if (res < 0)
-		return res;
+	if (filter_dump)
+		nfct_nlmsg_build_filter(nlh, filter_dump);
 
-	res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
-	if (res < 0)
-		return res;
+	return nfct_mnl_recv(nlh, cb, cmd);
+}
+
+static int nfct_mnl_talk(const struct nlmsghdr *nlh, mnl_cb_t cb)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret;
+
+	ret = mnl_socket_sendto(sock.mnl, nlh, nlh->nlmsg_len);
+	if (ret < 0)
+		return ret;
+
+	ret = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+	if (ret < 0)
+		return ret;
+
+	return mnl_cb_run(buf, ret, nlh->nlmsg_seq, sock.portid, cb, NULL);
+}
+
+static int
+nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+
+	nlh = nfct_mnl_nlmsghdr_put(buf, subsys, type, family);
 
-	return mnl_cb_run(buf, res, nlh->nlmsg_seq, sock.portid, cb, NULL);
+	return nfct_mnl_talk(nlh, cb);
 }
 
 #define UNKNOWN_STATS_NUM 4
-- 
2.30.2

