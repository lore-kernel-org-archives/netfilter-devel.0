Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBB7C43219
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344260AbhKXW2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbhKXW2D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:03 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB571C06175A
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DnF+h/LU4qWzGkXtBV4tVtbGjFIonUr+7ezV63UjGug=; b=WyYOyfkkxPAxKQz7kbo0t3jWRN
        +mqsFXKldFjhYGKF2MyHhagdBVf65cblYM/ZM4LU5p8omHWRXXQWjtsCd0/C3gdmSyI9wWpb8CY+k
        NpkY9l7PAHJJgytYSpHqf+Gv0IdHoU5lxL6Ts/mcw/+rnhtMmy77V6qvvkQwhMIotGK1YRiXW89lG
        NdIjgOB6iQfcree1ahr5rBr5w08jXgQ2wf++ETqEgeXEztVJ1LxLS4zdXsyvlIkMekkcngNzI6aJ7
        5tgRmV5Zb/XF5egnnGesNZrgGWmi4Jgrt0Q9enEoE1xhZBZ2aCPAcqoGov3afK03iGky3Z6UxI/0F
        s243Qtig==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-1m
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 09/32] input: UNIXSOCK: fix possible truncation of socket path
Date:   Wed, 24 Nov 2021 22:24:04 +0000
Message-Id: <20211124222444.2597311-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Verify that the socket path is short enough, and replace `strncpy` with
`strcpy`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 3f3abc3a0b77..66735e3ab4fe 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -475,9 +475,18 @@ static int handle_packet(struct ulogd_pluginstance *upi, struct ulogd_unixsock_p
 static int _create_unix_socket(const char *unix_path)
 {
 	int ret = -1;
-	struct sockaddr_un server_sock;
+	struct sockaddr_un server_sock = { .sun_family = AF_UNIX };
 	int s;
 
+	if (strlen(unix_path) >= sizeof(server_sock.sun_path)) {
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

