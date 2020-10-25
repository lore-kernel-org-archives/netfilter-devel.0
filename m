Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B35EC388F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60AA220720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="a+6Kadii"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416230AbgJYNQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416213AbgJYNQG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDA0C0613D4
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LUWiGDDi8jt5gNy8euEWMKWf3FlJdvW9DFNK4/PeHQ8=; b=a+6KadiimYGuo+l8RUqSxqMgrp
        +I+pbCP3RJ85NIFxNVag62dqINJ1jvokYd1XWUdWUjpqada2A5TbZosi1/dsEquHPm/yqE4mVn7MB
        8dmTtrxL8LafUHKU1Xfu6kq+4RHfEqn/ZlEtim2agC/s35h7CAVfUAP21z9FN1sfXj9ck2aTNlnAc
        YovgpVsN3v6os7sdrmmBBvVYAfONihggfL9ncIISJNm+zF8l68aEF+P0iQyNYixSdEo6qOjd8shrA
        ry4v9D0YYZB/5W7Ia2Ve6lqN2d/fohPAIgfrLv0A08HWv3tj1XNLCZs4otiX33T682iSd2kR93RmK
        BsD+wJfA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsS-0001SE-Vz; Sun, 25 Oct 2020 13:16:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 02/13] pknock: pknlusr: remove dest_addr and rename src_addr.
Date:   Sun, 25 Oct 2020 13:15:48 +0000
Message-Id: <20201025131559.920038-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201025131559.920038-1-jeremy@azazel.net>
References: <20201025131559.920038-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We only need to specify the address at our end, and given that we are
receiving messages, not sending them, calling it `src_addr` is
misleading.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 14bc44a13887..4e3e02a0b9f0 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -12,7 +12,7 @@
 
 #define GROUP 1
 
-static struct sockaddr_nl src_addr, dest_addr;
+static struct sockaddr_nl local_addr;
 static int sock_fd;
 
 static unsigned char *buf;
@@ -21,7 +21,6 @@ static struct xt_pknock_nl_msg *nlmsg;
 
 int main(void)
 {
-	socklen_t addrlen;
 	int status;
 	int group = GROUP;
 
@@ -37,12 +36,12 @@ int main(void)
 		return 1;
 	}
 
-	memset(&src_addr, 0, sizeof(src_addr));
-	src_addr.nl_family = AF_NETLINK;
-	src_addr.nl_pid = getpid();
-	src_addr.nl_groups = group;
+	memset(&local_addr, 0, sizeof(local_addr));
+	local_addr.nl_family = AF_NETLINK;
+	local_addr.nl_pid = getpid();
+	local_addr.nl_groups = group;
 
-	status = bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr));
+	status = bind(sock_fd, (struct sockaddr*)&local_addr, sizeof(local_addr));
 
 	if (status == -1) {
 		close(sock_fd);
@@ -50,11 +49,6 @@ int main(void)
 		return 1;
 	}
 
-	memset(&dest_addr, 0, sizeof(dest_addr));
-	dest_addr.nl_family = AF_NETLINK;
-	dest_addr.nl_pid = 0;
-	dest_addr.nl_groups = group;
-
 	buf_size = sizeof(struct xt_pknock_nl_msg) + sizeof(struct cn_msg) + sizeof(struct nlmsghdr);
 	buf = malloc(buf_size);
 
@@ -63,16 +57,14 @@ int main(void)
 		return 1;
 	}
 
-	addrlen = sizeof(dest_addr);
-
 	while(1) {
 
 		memset(buf, 0, buf_size);
 
-		status = recvfrom(sock_fd, buf, buf_size, 0, (struct sockaddr *)&dest_addr, &addrlen);
+		status = recv(sock_fd, buf, buf_size, 0);
 
 		if (status <= 0) {
-			perror("recvfrom()");
+			perror("recv()");
 			return 1;
 		}
 		nlmsg = (struct xt_pknock_nl_msg *)(buf + sizeof(struct cn_msg) + sizeof(struct nlmsghdr));
-- 
2.28.0

