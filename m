Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48313C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2772860F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhJ3RNA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJ3RNA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:00 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0413BC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PFRx3xhTY9XPPifuQm6vnBBOcJlI/6FG7OHuCn0muEk=; b=DFfEOIgMAVWCYxoosgi0hXTQHF
        B7WVpGbcj6PcN7wj9RcvU9dGRjXKmSMMykTd6tJZs2wn4nKUYhWPEaIx34IAhaeDw9TpzNJyHCMQ3
        D2S6+0WbWJmqj9z4SpsQw6DzBggsIGjU94WCN3KVqtlvz1rBTJTup1QRhYaz0mMvsJXwDvV9GcI+O
        fDdyu5PURsc80a0exMH6f3UB08A7Ym9zCKWAYFfREZMw9CNcnwFcWoSFel1WmW2sKATWrgMAUguFA
        IJ+DJeqaOLLu6brbLYa8q17gagxLzGOQPAj+Fab3TNLsX0t7xQYyG5eYKmRZn04mUvruBOD9uVWxd
        2zWD/PDg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTB-00AFgT-CG
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:37 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 26/26] output: JSON: fix possible truncation of socket path
Date:   Sat, 30 Oct 2021 17:44:32 +0100
Message-Id: <20211030164432.1140896-27-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verify that the path is short enough, and replace `strncpy` with `strcpy`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index c15c9f239441..3b0338991548 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -147,7 +147,8 @@ static void close_socket(struct json_priv *op) {
 static int _connect_socket_unix(struct ulogd_pluginstance *pi)
 {
 	struct json_priv *op = (struct json_priv *) &pi->private;
-	struct sockaddr_un u_addr;
+	struct sockaddr_un u_addr = { .sun_family = AF_UNIX };
+	const char *socket_path = file_ce(pi->config_kset).u.string;
 	int sfd;
 
 	close_socket(op);
@@ -156,13 +157,15 @@ static int _connect_socket_unix(struct ulogd_pluginstance *pi)
 		  file_ce(pi->config_kset).u.string);
 
 	sfd = socket(AF_UNIX, SOCK_STREAM, 0);
-	if (sfd == -1) {
+	if (sfd == -1)
 		return -1;
-	}
-	u_addr.sun_family = AF_UNIX;
-	strncpy(u_addr.sun_path, file_ce(pi->config_kset).u.string,
-		sizeof(u_addr.sun_path) - 1);
-	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(struct sockaddr_un)) == -1) {
+
+	if (sizeof(u_addr.sun_path) <= strlen(socket_path))
+		return -1;
+
+	strcpy(u_addr.sun_path, socket_path);
+
+	if (connect(sfd, (struct sockaddr *) &u_addr, sizeof(u_addr)) == -1) {
 		close(sfd);
 		return -1;
 	}
-- 
2.33.0

