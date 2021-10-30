Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1C4C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A640860F9B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJ3RNY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbhJ3RNX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD10C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lBrLuObem4pq92ZjZOWHEbT9ZTTyC8TARghZdMNAPwM=; b=I10pK9YBXnsKq78kUBftMGozbq
        dDcQFt2U5eRuugpZMoPIG81HA3FXPq4YjOFXfRo80rR9y02OvJLh3r+XgASjrrvE8eLKaGT2hDHME
        +5IPhqVw3Q9iEuz5yHIF/syDnFkR+D5PIRxATO1DlqxYlXjPqJyKQofC/PtPvlW1sNMrWLc/GFLj6
        3kSHZOeu39WplOP/iL/3WNRsgWW9dqi2HUl/+Ako6yNFgOn0MONy8jsp/9zybka3vNicjQ2qb0hPU
        tUfqw01JtFaEglVrrLBelu259zJon7wMnQQ2XG+mrSoIbccKs8aGf4u2hGKBDI1pCGW0Sr7ac8pjC
        naqDIbeQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT9-00AFgT-D0
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 13/26] input: UNIXSOCK: stat socket-path first before creating the socket.
Date:   Sat, 30 Oct 2021 17:44:19 +0100
Message-Id: <20211030164432.1140896-14-jeremy@azazel.net>
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

If the path is already bound, we close the socket immediately.

A couple of error message fixes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index f97c2e174b2d..d88609f203c4 100644
--- a/input/packet/ulogd_inppkt_UNIXSOCK.c
+++ b/input/packet/ulogd_inppkt_UNIXSOCK.c
@@ -479,10 +479,17 @@ static int _create_unix_socket(const char *unix_path)
 	int s;
 	struct stat st_dummy;
 
+	if (stat(unix_path, &st_dummy) == 0 && st_dummy.st_size > 0) {
+		ulogd_log(ULOGD_ERROR,
+			  "ulogd2: unix socket '%s' already exists\n",
+			  unix_path);
+		return -1;
+	}
+
 	s = socket(AF_UNIX, SOCK_STREAM, 0);
 	if (s < 0) {
 		ulogd_log(ULOGD_ERROR,
-				"ulogd2: could not create unix socket\n");
+			  "ulogd2: could not create unix socket\n");
 		return -1;
 	}
 
@@ -490,19 +497,11 @@ static int _create_unix_socket(const char *unix_path)
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
@@ -510,8 +509,8 @@ static int _create_unix_socket(const char *unix_path)
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

