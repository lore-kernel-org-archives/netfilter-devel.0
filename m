Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B1CC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbhK3K7b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:59:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236478AbhK3K71 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:59:27 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCF6C061746
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5I1eE3B2Uuqo9fdmhPD2H+nzQLZ4N18Y0s73qGoIs3Y=; b=BllNfaxfD8Rlf0uyXBvKokKUn0
        gurL5MWpioo5gvhlRk0G8+0xmm9Gp4kYV9hqCTPTRMZ11QETHfQPYRJspK5HsVJc8LY3uh+FzEzD5
        WotV6mj9Mz4jEtanG5cqRaAs9XyX7iQZRIdAUlR8reGDM39f+53YGPH0r2+mS3yU5GvYHa36u1Y91
        3s5z3zYZUTscqjtE29XnPJOUdujsRT7i72n8ObO3Ox61rfA/TrdMjbGan6HXX9RHGAbFH/vpwk76v
        oGhKM0Nfe7R3SE18fKoDbrVh9RztEPmlZeG6XziAYO6H87h+Ch1hzoB4YJk4wIxlEvcX5KKAWAgyY
        XHvrJcRQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nr-00Awwr-Ky
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 08/32] input: UNIXSOCK: remove stat of socket-path
Date:   Tue, 30 Nov 2021 10:55:36 +0000
Message-Id: <20211130105600.3103609-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When creating the UNIX socket, there is a TOCTOU race between the
stat(2) and bind(2) calls, and if the path is already bound, the bind(2)
call will fail in any case.  Remove the stat(2) call.

Tidy up a couple of error message.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index 86ab590073d8..3f3abc3a0b77 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -477,12 +477,11 @@ static int _create_unix_socket(const char *unix_path)
 	int ret = -1;
 	struct sockaddr_un server_sock;
 	int s;
-	struct stat st_dummy;
 
 	s = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (s < 0) {
 		ulogd_log(ULOGD_ERROR,
-				"ulogd2: could not create unix socket\n");
+			  "ulogd2: could not create unix socket\n");
 		return -1;
 	}
 
@@ -490,19 +489,11 @@ static int _create_unix_socket(const char *unix_path)
 	strncpy(server_sock.sun_path, unix_path, sizeof(server_sock.sun_path));
 	server_sock.sun_path[sizeof(server_sock.sun_path)-1] = '\0';
 
-	if (stat(unix_path, &st_dummy) == 0 && st_dummy.st_size > 0) {
-		ulogd_log(ULOGD_ERROR,
-				"ulogd2: unix socket \'%s\' already exists\n",
-				unix_path);
-		close(s);
-		return -1;
-	}
-
 	ret = bind(s, (struct sockaddr *)&server_sock, sizeof(server_sock));
 	if (ret < 0) {
 		ulogd_log(ULOGD_ERROR,
-				"ulogd2: could not bind to unix socket \'%s\'\n",
-				server_sock.sun_path);
+			  "ulogd2: could not bind to unix socket '%s'\n",
+			  server_sock.sun_path);
 		close(s);
 		return -1;
 	}
@@ -510,8 +501,8 @@ static int _create_unix_socket(const char *unix_path)
 	ret = listen(s, 10);
 	if (ret < 0) {
 		ulogd_log(ULOGD_ERROR,
-				"ulogd2: could not bind to unix socket \'%s\'\n",
-				server_sock.sun_path);
+			  "ulogd2: could not listen to unix socket '%s'\n",
+			  server_sock.sun_path);
 		close(s);
 		return -1;
 	}
-- 
2.33.0

