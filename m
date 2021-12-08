Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4AFC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Dec 2021 13:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhLHNxT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Dec 2021 08:53:19 -0500
Received: from dehost.average.org ([88.198.2.197]:47502 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbhLHNxT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Dec 2021 08:53:19 -0500
Received: from wncross.fkb.profitbricks.net (unknown [IPv6:2a02:8106:1:6800:8b1c:cff2:1ce3:e09b])
        by dehost.average.org (Postfix) with ESMTPA id 258D3394DEAB;
        Wed,  8 Dec 2021 14:49:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1638971386; bh=s1fhuSWfF4Cs5J9Br+0mqP+BL0meUj5ax/rruKiXRH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoyhlj+xmBvB+/ceUt38bkKAlFdv+zgwXjZPV29F4Blo9DoY98QedS3J5NFNbQT1q
         iJGvv8PGdnvT1sgUfUWrRQ+kdk6U6T5TjsK2WYTmPUNIKNOAiTsMWkm93Qubl6Sbex
         RlbPrWPdvfQEQae9ufM/NsSeDHtK9PSmuOiXSerc=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Cc:     Eugene Crosser <crosser@average.org>
Subject: [PATCH nft 2/2] Handle retriable errors from mnl functions
Date:   Wed,  8 Dec 2021 14:49:14 +0100
Message-Id: <20211208134914.16365-3-crosser@average.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208134914.16365-1-crosser@average.org>
References: <20211208134914.16365-1-crosser@average.org>
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
 src/iface.c | 73 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

diff --git a/src/iface.c b/src/iface.c
index d0e1834c..029f6476 100644
--- a/src/iface.c
+++ b/src/iface.c
@@ -66,39 +66,54 @@ void iface_cache_update(void)
 	struct nlmsghdr *nlh;
 	struct rtgenmsg *rt;
 	uint32_t seq, portid;
+	bool need_restart;
+	int retry_count = 5;
 	int ret;
 
-	nlh = mnl_nlmsg_put_header(buf);
-	nlh->nlmsg_type	= RTM_GETLINK;
-	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
-	nlh->nlmsg_seq = seq = time(NULL);
-	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
-	rt->rtgen_family = AF_PACKET;
-
-	nl = mnl_socket_open(NETLINK_ROUTE);
-	if (nl == NULL)
-		netlink_init_error();
-
-	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
-		netlink_init_error();
-
-	portid = mnl_socket_get_portid(nl);
-
-	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
-		netlink_init_error();
-
-	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	while (ret > 0) {
-		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
-		if (ret <= MNL_CB_STOP)
-			break;
-		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
-	}
-	if (ret == -1)
+	do {
+		nlh = mnl_nlmsg_put_header(buf);
+		nlh->nlmsg_type	= RTM_GETLINK;
+		nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
+		nlh->nlmsg_seq = seq = time(NULL);
+		rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
+		rt->rtgen_family = AF_PACKET;
+
+		nl = mnl_socket_open(NETLINK_ROUTE);
+		if (nl == NULL)
+			netlink_init_error();
+
+		if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+			netlink_init_error();
+
+		portid = mnl_socket_get_portid(nl);
+
+		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+			netlink_init_error();
+
+		need_restart = false;
+		while (true) {
+			ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+			if (ret == -1) {
+				if (errno == EINTR)
+					continue;
+				else
+					netlink_init_error();
+			}
+			ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
+			if (ret == MNL_CB_STOP)
+				break;
+			if (ret == -1) {
+				if (errno == EINTR)
+					need_restart = true;
+				else
+					netlink_init_error();
+			}
+		}
+		mnl_socket_close(nl);
+	} while (need_restart && retry_count--);
+	if (need_restart)
 		netlink_init_error();
 
-	mnl_socket_close(nl);
-
 	iface_cache_init = true;
 }
 
-- 
2.32.0

