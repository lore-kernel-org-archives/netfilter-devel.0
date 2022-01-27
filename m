Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 605B4C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 23:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244702AbiA0XGf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 18:06:35 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42778 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbiA0XGf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 18:06:35 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8665C60702;
        Fri, 28 Jan 2022 00:03:29 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     crosser@average.org
Subject: [PATCH nftables,v2] iface: handle EINTR case when creating the cache
Date:   Fri, 28 Jan 2022 00:06:29 +0100
Message-Id: <20220127230629.573287-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If interface netlink dump is interrupted, then retry.

Before this patch, the netlink socket is reopened to drop stale dump
messages, instead empty the netlink queue and retry.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: immediately return on non-eintr error (instead of breaking the loop),
    per Eugene Crosser.

 src/iface.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/src/iface.c b/src/iface.c
index d0e1834ca82f..c0642e0cc397 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -59,13 +59,13 @@ static int data_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
-void iface_cache_update(void)
+static int iface_mnl_talk(struct mnl_socket *nl, uint32_t portid)
 {
 	char buf[MNL_SOCKET_BUFFER_SIZE];
-	struct mnl_socket *nl;
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
-	uint32_t seq, portid;
+	bool eintr = false;
+	uint32_t seq;
 	int ret;
 
 	nlh = mnl_nlmsg_put_header(buf);
@@ -75,6 +75,38 @@ void iface_cache_update(void)
 	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
 	rt->rtgen_family = AF_PACKET;
 
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		return -1;
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
+		if (ret == 0)
+			break;
+		if (ret < 0) {
+			if (errno != EINTR)
+				return ret;
+
+			/* process all pending messages before reporting EINTR */
+			eintr = true;
+		}
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+
+	if (eintr) {
+		ret = -1;
+		errno = EINTR;
+	}
+
+	return ret;
+}
+
+void iface_cache_update(void)
+{
+	struct mnl_socket *nl;
+	uint32_t portid;
+	int ret;
+
 	nl = mnl_socket_open(NETLINK_ROUTE);
 	if (nl == NULL)
 		netlink_init_error();
@@ -84,16 +116,10 @@ void iface_cache_update(void)
 
 	portid = mnl_socket_get_portid(nl);
 
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
-		netlink_init_error();
+	do {
+		ret = iface_mnl_talk(nl, portid);
+	} while (ret < 0 && errno == EINTR);
 
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
-		if (ret <= MNL_CB_STOP)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
 	if (ret == -1)
 		netlink_init_error();
 
-- 
2.30.2

