Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5171C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD15E60F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhJ3RNV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbhJ3RNU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:20 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890C7C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6iAYycDQZIWps/uFOG2PqC+kOkFt5+Ijz7RPGEdnDTc=; b=TdHlKxQPKH3PGNNAIbSdYdXDps
        NMX0n72V8gdAq55EVnhpBlqv4wY9nsSj6d8msGlWPNRbV1gNC3zm8yCQF0RP0l8WUv8g9qLDMqZBh
        UXxhiki32/XjuOmZj9rjZFrWT99eahDXgtXxpONIGqcDudZO4bflGvhuvXWAt++OlBoEEyKUa+ccT
        GsPaleTdVOJuEETxbTus4LwV1KhME1la5UJ10tDc/A08bFj5eqNlvouWWHEkgvvqsep1lLpuGia1j
        DS0ooqG2u44FyN1Bjl9255jfz9EUKYdVz3bFuO1Eh1KcvDCjitWdeDwW2OYsW673OgNxqCHT58NWj
        olGWdwhQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT9-00AFgT-K4
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 14/26] input: UNIXSOCK: fix possible truncation of socket path
Date:   Sat, 30 Oct 2021 17:44:20 +0100
Message-Id: <20211030164432.1140896-15-jeremy@azazel.net>
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
 input/packet/ulogd_inppkt_UNIXSOCK.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index d88609f203c4..af2fbeca1f4c 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -475,10 +475,19 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 static int _create_unix_socket(const char *unix_path)
 {
 	int ret = -1;
-	struct sockaddr_un server_sock;
+	struct sockaddr_un server_sock = { .sun_family = AF_UNIX };
 	int s;
 	struct stat st_dummy;
 
+	if (sizeof(server_sock.sun_path) <= strlen(unix_path)) {
+		ulogd_log(ULOGD_ERROR,
+			  "ulogd2: unix socket path '%s' too long\n",
+			  unix_path);
+		return -1;
+	}
+
+	strcpy(server_sock.sun_path, unix_path);
+
 	if (stat(unix_path, &st_dummy) == 0 && st_dummy.st_size > 0) {
 		ulogd_log(ULOGD_ERROR,
 			  "ulogd2: unix socket '%s' already exists\n",
@@ -493,10 +502,6 @@ static int _create_unix_socket(const char *unix_path)
 		return -1;
 	}
 
-	server_sock.sun_family = AF_UNIX;
-	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path));
-	server_sock.sun_path[sizeof(server_sock.sun_path)-1] = '\0';
-
 	ret = bind(s, (struct sockaddr *)&server_sock, sizeof(server_sock));
 	if (ret < 0) {
 		ulogd_log(ULOGD_ERROR,
-- 
2.33.0

