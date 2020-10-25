Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5240C55178
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B211920720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IRVJHCac"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416229AbgJYNQN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416214AbgJYNQH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:07 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93FCC0613D5
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1gwp9Sfej2IAD4Kbg80SXLVX4/NLD0VbWfWINGSvkQk=; b=IRVJHCacJ4U0/jsjVe+sGYWclW
        S1pMKBbwn5S5iW/n5FtMg/UB8sR/jHe1vRtP5YX1U1mnw/WwwmCX+PG112YXWVXqjNxOdlldS+tGi
        1RHYDLKVL7xbBigO4WEzWorjmMpzYaJ+cZdJidPmiYE8jCVLVsIiYqW1d5DnifdHyjnHDEbCLNqho
        b1dllZvUvXkZp1XvGWXp/ucf0PbbrnbO3z70g5Bcc2+i6nloubc+Xb4f2l42N/o2vD+LGgbc+TVI3
        6by7rTVh3HDHPJF+tfo/XkUCPZTX1wXyA05SCH2bs7S7owEajb8VjBjmlHpjKH3J0PHMUJWE6ItAE
        l9xbL0DA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsT-0001SE-At; Sun, 25 Oct 2020 13:16:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 03/13] pknock: pknlusr: tighten up variable scopes.
Date:   Sun, 25 Oct 2020 13:15:49 +0000
Message-Id: <20201025131559.920038-5-jeremy@azazel.net>
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

Make global variables local, and move variables local to while-loop into
the loop.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 4e3e02a0b9f0..808b737f1db2 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -12,22 +12,16 @@
 
 #define GROUP 1
 
-static struct sockaddr_nl local_addr;
-static int sock_fd;
-
-static unsigned char *buf;
-
-static struct xt_pknock_nl_msg *nlmsg;
-
 int main(void)
 {
 	int status;
 	int group = GROUP;
 
-	int buf_size;
+	struct sockaddr_nl local_addr;
+	int sock_fd;
 
-	const char *ip;
-	char ipbuf[48];
+	int buf_size;
+	unsigned char *buf;
 
 	sock_fd = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_CONNECTOR);
 
@@ -59,6 +53,11 @@ int main(void)
 
 	while(1) {
 
+		struct xt_pknock_nl_msg *nlmsg;
+
+		const char *ip;
+		char ipbuf[48];
+
 		memset(buf, 0, buf_size);
 
 		status = recv(sock_fd, buf, buf_size, 0);
-- 
2.28.0

