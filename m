Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA68C43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDA8D20651
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550956659;
	bh=AoAhagqnA8fQRWmtJByUmWYHaEN2UPlIQx9UHWUrLOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YG7qKCeuwZ2wvzD3H0uUIUwmrMP1jNCE8AxYTyo5UD9sdNQXmigTDCl1ysDZWyTX1
	 lUones6ijB5NIWskSvIkFKpmd/RQ4s8ZFaUzAmhEy9ax4Rjmuud9uqvVs//q0idhn3
	 /4q0jGGfkjUzFfisbghhK1hHrcJA5TC4qWvQqmN4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbfBWVRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:17:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbfBWVKE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:10:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C810620861;
        Sat, 23 Feb 2019 21:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956203;
        bh=AoAhagqnA8fQRWmtJByUmWYHaEN2UPlIQx9UHWUrLOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=re/AH3lpMFJJMm+aVI4lqO1sfhyR/e044ODuDYy7uek4eUOZGWfefngENxp8QISPR
         RySGwyoEvZXvvBpWFXUXGQIzAMv30xls+8Ul5+nlIPalcBrQQhO6DncWkUneTFv4DT
         zsFQcBYsUGCj+LfyDEtHOvdT0omOlY/mG1v6k4nE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH AUTOSEL 4.9 08/32] ipvs: Fix signed integer overflow when setsockopt timeout
Date:   Sat, 23 Feb 2019 16:09:27 -0500
Message-Id: <20190223210951.202268-8-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210951.202268-1-sashal@kernel.org>
References: <20190223210951.202268-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 53ab60baa1ac4f20b080a22c13b77b6373922fd7 ]

There is a UBSAN bug report as below:
UBSAN: Undefined behaviour in net/netfilter/ipvs/ip_vs_ctl.c:2227:21
signed integer overflow:
-2147483647 * 1000 cannot be represented in type 'int'

Reproduce program:
	#include <stdio.h>
	#include <sys/types.h>
	#include <sys/socket.h>

	#define IPPROTO_IP 0
	#define IPPROTO_RAW 255

	#define IP_VS_BASE_CTL		(64+1024+64)
	#define IP_VS_SO_SET_TIMEOUT	(IP_VS_BASE_CTL+10)

	/* The argument to IP_VS_SO_GET_TIMEOUT */
	struct ipvs_timeout_t {
		int tcp_timeout;
		int tcp_fin_timeout;
		int udp_timeout;
	};

	int main() {
		int ret = -1;
		int sockfd = -1;
		struct ipvs_timeout_t to;

		sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
		if (sockfd == -1) {
			printf("socket init error\n");
			return -1;
		}

		to.tcp_timeout = -2147483647;
		to.tcp_fin_timeout = -2147483647;
		to.udp_timeout = -2147483647;

		ret = setsockopt(sockfd,
				 IPPROTO_IP,
				 IP_VS_SO_SET_TIMEOUT,
				 (char *)(&to),
				 sizeof(to));

		printf("setsockopt return %d\n", ret);
		return ret;
	}

Return -EINVAL if the timeout value is negative or max than 'INT_MAX / HZ'.

Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8382b7880b240..8037b25ddb76a 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2258,6 +2258,18 @@ static int ip_vs_set_timeout(struct netns_ipvs *ipvs, struct ip_vs_timeout_user
 		  u->tcp_fin_timeout,
 		  u->udp_timeout);
 
+#ifdef CONFIG_IP_VS_PROTO_TCP
+	if (u->tcp_timeout < 0 || u->tcp_timeout > (INT_MAX / HZ) ||
+	    u->tcp_fin_timeout < 0 || u->tcp_fin_timeout > (INT_MAX / HZ)) {
+		return -EINVAL;
+	}
+#endif
+
+#ifdef CONFIG_IP_VS_PROTO_UDP
+	if (u->udp_timeout < 0 || u->udp_timeout > (INT_MAX / HZ))
+		return -EINVAL;
+#endif
+
 #ifdef CONFIG_IP_VS_PROTO_TCP
 	if (u->tcp_timeout) {
 		pd = ip_vs_proto_data_get(ipvs, IPPROTO_TCP);
-- 
2.19.1

