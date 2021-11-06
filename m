Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23E5A61360
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbhKFRRt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbhKFRRt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:49 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49EBC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NKj7WNGWduPK1lzG8v+10PkjDV640AQmW3pjyChajIc=; b=q3hT0gH4i/hh0V+lnf2v8tTOVC
        s+8x0n/nnPpahU9bhuexE+z5Mpu0sSbbTuObZIl0takVc7LT5Ao++4omAK0jEu/2KZZFWHE44FoNa
        FbaabsRvRZq62DMMF+rr1AMi1zfSTBftJlBsIOG5etV2iHTm5/sU+ei90pzg+OG5Z63aBh4ZQO5My
        7qQkwh+/25D1AgWAq7NKmNnYVzn7KW/JQYdIfDBLDLq6Me0Y7qFI75ppsqsSD5lC8SgvdK7+KzD7s
        ZMffEICwj8/mdJatbZ9m26gHrXvxdL7+ZnLZxN2DV7sLpE8806g/baHcaRsFwzxQ5ZHxdXUPLkyPw
        jH9LTaoA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-A2
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 14/27] input: UNIXSOCK: fix possible truncation of socket path
Date:   Sat,  6 Nov 2021 16:49:40 +0000
Message-Id: <20211106164953.130024-15-jeremy@azazel.net>
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
 input/packet/ulogd_inppkt_UNIXSOCK.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 62a1c1a00cdf..f318250f1fe1 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -475,9 +475,18 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 static int _create_unix_socket(const char *unix_path)
 {
 	int ret = -1;
-	struct sockaddr_un server_sock;
+	struct sockaddr_un server_sock = { .sun_family = AF_UNIX };
 	int s;
 
+	if (sizeof(server_sock.sun_path) <= strlen(unix_path)) {
+		ulogd_log(ULOGD_ERROR,
+			  "ulogd2: unix socket path '%s' too long\n",
+			  unix_path);
+		return -1;
+	}
+
+	strcpy(server_sock.sun_path, unix_path);
+
 	s = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (s < 0) {
 		ulogd_log(ULOGD_ERROR,
@@ -485,10 +494,6 @@ static int _create_unix_socket(const char *unix_path)
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

