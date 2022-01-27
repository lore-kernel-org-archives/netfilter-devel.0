Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F57C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jan 2022 18:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239789AbiA0SSl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 13:18:41 -0500
Received: from mail.netfilter.org ([217.70.188.207]:40410 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiA0SSk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 13:18:40 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 30A7160693;
        Thu, 27 Jan 2022 19:15:35 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     crosser@average.org
Subject: [PATCH nftables] iface: handle EINTR case when creating the cache
Date:   Thu, 27 Jan 2022 19:18:35 +0100
Message-Id: <20220127181835.571673-1-pablo@netfilter.org>
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
 src/iface.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/src/iface.c b/src/iface.c
index d0e1834ca82f..2195937df0fa 100644
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
+				break;
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

