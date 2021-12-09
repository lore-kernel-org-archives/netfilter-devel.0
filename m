Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA07C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Dec 2021 18:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbhLISaE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:30:04 -0500
Received: from dehost.average.org ([88.198.2.197]:49808 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243257AbhLISaD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 13:30:03 -0500
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:300b:b575:41c4:b71a])
        by dehost.average.org (Postfix) with ESMTPA id D4F26394FB2D;
        Thu,  9 Dec 2021 19:26:28 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1639074388; bh=M0JfwGc6PMjalbUpgfaK7VacfFW8X1n9Oa6zbZdOnnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lNNNbEYVcyR51JJUb8Zn3EgS4ZXp3IDuV3QBaBib3mYRsLu2WA0ApSaq4QhVBImAd
         BV1ho11eXO+Zhu5PZZtJCZUG3RCVa5JyxZSoPH6b10tcM21FqAL3LvpD9tZYwUJmls
         oRBDSpTCFKlxrj+TxIvgNxYslAzqsFFBAalb0SWQ=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Eugene Crosser <crosser@average.org>
Subject: [PATCH nft v2 2/2] Handle retriable errors from mnl functions
Date:   Thu,  9 Dec 2021 19:26:07 +0100
Message-Id: <20211209182607.18550-3-crosser@average.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211209182607.18550-1-crosser@average.org>
References: <20211209182607.18550-1-crosser@average.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

rc == -1 and errno == EINTR mean:

mnl_socket_recvfrom() - blindly rerun the function
mnl_cb_run()          - restart dump request from scratch

This commit introduces handling of both these conditions

Signed-off-by: Eugene Crosser <crosser@average.org>
---
 src/iface.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/src/iface.c b/src/iface.c
index d0e1834c..5ecc087d 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -59,14 +59,14 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-void iface_cache_update(void)
+static int __iface_cache_update(void)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
 	struct mnl_socket *nl;
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	uint32_t seq, portid;
-	int ret;
+	int ret = -1;
 
 	nlh = mnl_nlmsg_put_header(buf);
 	nlh->nlmsg_type	= RTM_GETLINK;
@@ -77,28 +77,39 @@ void iface_cache_update(void)
 
 	nl = mnl_socket_open(NETLINK_ROUTE);
 	if (nl == NULL)
-		netlink_init_error();
+		return -1;
 
 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
-		netlink_init_error();
+		goto close_and_return;
 
 	portid = mnl_socket_get_portid(nl);
 
 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
-		netlink_init_error();
+		goto close_and_return;
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
-		if (ret <= MNL_CB_STOP)
+	do {
+		do ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		while (ret == -1 && errno == EINTR);
+		if (ret == -1)
 			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1)
-		netlink_init_error();
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
+	} while (ret > MNL_CB_STOP);
 
+close_and_return:
 	mnl_socket_close(nl);
 
+	return ret;
+}
+
+void iface_cache_update(void)
+{
+	int ret;
+
+	do ret = __iface_cache_update();
+	while (ret == -1 && errno == EINTR);
+	if (ret == -1)
+		netlink_init_error();
+
 	iface_cache_init = true;
 }
 
-- 
2.32.0

