Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0421C55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADDEE20720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="j1xye2EA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416226AbgJYNQL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416216AbgJYNQH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA8DC0613D7
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nfWXc5JEFWpJhWHhyTt+vjN+n8ZVp082hYpO+KvKboE=; b=j1xye2EAIt24FzsswH9usEJ2AL
        jJr2qmt+s73WA3xicqwiih8x6tkugxVtr5Wk8iUmXeiG0Z0egCghJmJpuItLYjLSi4aPzeSMnE6vk
        lz3Kzr20OCTq8geOBqYBUaZqBJ+UTdueGgTbzfqLqUk163WgY8Cf3Blg+LI7X1fHVTsBLu1h1+/cN
        kS1364Ih1/t9LwYJT1H8yO3KYkYQKdnCsGCEWUg26LxozvyXQpg6jc5kR1345BAUGStzPTwT2fqMD
        bVQAZ9rVbJR7ZgvrOJKo7evq1daYW4zNDyAmoDaqxop5sjcReEnLbGf/fvsbIJp28WnumpIu8lxIG
        3RL4gbMQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsT-0001SE-Ty; Sun, 25 Oct 2020 13:16:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 05/13] pknock: pknlusr: use NLMSG macros and proper types, rather than arithmetic on char pointers.
Date:   Sun, 25 Oct 2020 13:15:51 +0000
Message-Id: <20201025131559.920038-7-jeremy@azazel.net>
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

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index ed741599558b..252fd42ffecd 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -20,8 +20,10 @@ int main(void)
 	struct sockaddr_nl local_addr = { .nl_family = AF_NETLINK };
 	int sock_fd;
 
-	int buf_size;
-	unsigned char *buf;
+	size_t nlmsg_size;
+	struct nlmgrhdr *nlmsg;
+	struct cn_msg *cn_msg;
+	struct xt_pknock_nl_msg *pknock_msg;
 
 	sock_fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 
@@ -40,38 +42,38 @@ int main(void)
 		return 1;
 	}
 
-	buf_size = sizeof(struct xt_pknock_nl_msg) + sizeof(struct cn_msg) + sizeof(struct nlmsghdr);
-	buf = malloc(buf_size);
+	nlmsg_size = NLMSG_SPACE(sizeof(*cn_msg) + sizeof(*pknock_msg));
+	nlmsg = malloc(nlmsg_size);
 
-	if (!buf) {
+	if (!nlmsg) {
 		perror("malloc()");
 		return 1;
 	}
 
 	while(1) {
 
-		struct xt_pknock_nl_msg *nlmsg;
-
 		const char *ip;
 		char ipbuf[48];
 
-		memset(buf, 0, buf_size);
+		memset(nlmsg, 0, nlmsg_size);
 
-		status = recv(sock_fd, buf, buf_size, 0);
+		status = recv(sock_fd, nlmsg, nlmsg_size, 0);
 
 		if (status <= 0) {
 			perror("recv()");
 			return 1;
 		}
-		nlmsg = (struct xt_pknock_nl_msg *)(buf + sizeof(struct cn_msg) + sizeof(struct nlmsghdr));
-		ip = inet_ntop(AF_INET, &nlmsg->peer_ip, ipbuf, sizeof(ipbuf));
-		printf("rule_name: %s - ip %s\n", nlmsg->rule_name, ip);
+
+		cn_msg = NLMSG_DATA(nlmsg);
+		pknock_msg = (struct xt_pknock_nl_msg *)(cn_msg->data);
+		ip = inet_ntop(AF_INET, &pknock_msg->peer_ip, ipbuf, sizeof(ipbuf));
+		printf("rule_name: %s - ip %s\n", pknock_msg->rule_name, ip);
 
 	}
 
 	close(sock_fd);
 
-	free(buf);
+	free(nlmsg);
 
 	return 0;
 }
-- 
2.28.0

