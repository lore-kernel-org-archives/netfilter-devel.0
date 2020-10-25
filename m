Return-Path: <SRS0=hvDf=EA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76107C388F7
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3242920720
	for <netfilter-devel@archiver.kernel.org>; Sun, 25 Oct 2020 13:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="WO3vbzsi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416228AbgJYNQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 25 Oct 2020 09:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1416212AbgJYNQJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Oct 2020 09:16:09 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2974AC0613D2
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Oct 2020 06:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qgFy+Evnm7VbdSynDf95DEMqILnuM8zlrZbF2ay8Jrs=; b=WO3vbzsi8oMIGfqlB87hhxIega
        BdCYsPY7xRdbl0YjH2XYcZFqtYp1gBQUKN+Sp2ywweBKHomz3sEME5OdFCuXOXlJwretyzxMhjVaq
        /0Q0plstZa2AXnnyV/aA38YQfhwV+EviQhgzmjKtV40GJkz/uh9lzrosWOvnQYrX1l7t44dFUcb9f
        Hphoruy9zuMj4GU25RWh1h4M1gGtA7OS1EkDjAyV11QPqXTsVElI0D8kKn7r4yMJRzYVs19giaohy
        wdlB7xmM0JpDJsnUP403X/bwmABi3ixuDi9t0owkax6+956lQ6fTZD3GYC2oVBRISumHkxLNJI7tG
        CHZh166Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kWfsV-0001SE-FI; Sun, 25 Oct 2020 13:16:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons v2 08/13] pknock: pknlusr: always close socket.
Date:   Sun, 25 Oct 2020 13:15:54 +0000
Message-Id: <20201025131559.920038-10-jeremy@azazel.net>
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

On some error paths the socket was not being closed before exit.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/pknock/pknlusr.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/extensions/pknock/pknlusr.c b/extensions/pknock/pknlusr.c
index 2dd9ab7b9705..fba628e1f466 100644
--- a/extensions/pknock/pknlusr.c
+++ b/extensions/pknock/pknlusr.c
@@ -29,7 +29,7 @@ int main(void)
 
 	if (sock_fd == -1) {
 		perror("socket()");
-		return 1;
+		exit (EXIT_FAILURE);
 	}
 
 	local_addr.nl_groups = group;
@@ -37,9 +37,8 @@ int main(void)
 	status = bind(sock_fd, (struct sockaddr*)&local_addr, sizeof(local_addr));
 
 	if (status == -1) {
-		close(sock_fd);
 		perror("bind()");
-		return 1;
+		goto err_close_sock;
 	}
 
 	nlmsg_size = NLMSG_SPACE(sizeof(*cn_msg) + sizeof(*pknock_msg));
@@ -47,7 +46,7 @@ int main(void)
 
 	if (!nlmsg) {
 		perror("malloc()");
-		return 1;
+		goto err_close_sock;
 	}
 
 	while(1) {
@@ -61,7 +60,7 @@ int main(void)
 
 		if (status < 0) {
 			perror("recv()");
-			return 1;
+			goto err_free_msg;
 		}
 
 		if (status == 0)
@@ -74,9 +73,11 @@ int main(void)
 
 	}
 
-	close(sock_fd);
-
+err_free_msg:
 	free(nlmsg);
 
-	return 0;
+err_close_sock:
+	close(sock_fd);
+
+	exit (status == -1 ? EXIT_FAILURE : EXIT_SUCCESS);
 }
-- 
2.28.0

