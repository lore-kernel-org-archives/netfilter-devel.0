Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FD0C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CCE661360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhKFRRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbhKFRRa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:30 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB320C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PFRx3xhTY9XPPifuQm6vnBBOcJlI/6FG7OHuCn0muEk=; b=KTMIkIixcBtjyPo0k241W2cJo8
        5jCOnZ1RJ0hW3UjrE0b7oVlxo+EllAb+0dbM/Pf4EDyajLOyZPI7PrfDKL3Kj2KENVL4lUrxHOkv+
        rkoNbOOLxAWitt0X5mPWbCTKMLPv/V2pu8vX1YboEToEFBsnJKdF4F1srd5DOY57UYKSmdeap/Tpu
        uyyN4dKIDG6hcI+LeinbmYek41+WAr7+WpVDK7NBgO23VqvoPKtz8ZOiiUjxTOzSzZq2Jw8+bLA8T
        lqDtcQEQd9vvfJIOFkZaLN3kfT0k5Ohrmpj93ffGPBZTHMCUpfMEJF9Kc4uhEhn2cReqL1d9RvSHz
        iu70rksQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtL-004m1E-Ln
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:07 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 26/27] output: JSON: fix possible truncation of socket path
Date:   Sat,  6 Nov 2021 16:49:52 +0000
Message-Id: <20211106164953.130024-27-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
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

