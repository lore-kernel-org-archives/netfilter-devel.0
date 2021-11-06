Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 837D8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7063861361
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhKFRRp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhKFRRp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:45 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BDCC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kfVtM/n6tJ2eZ3We3Ezb896JR3swtY86ek1iyhRTDrI=; b=bhX3ElMxd0CUYgpLIRSNwE444d
        8DvLXfIE1mALoLUxXV2elJ55mZ8uazonCXFxA0sDNc88BS49zJ3YXWHnlpVS+W+2tFg7xs/iXcZeb
        ezOvDWIMSeWlydQ/F68SJO2Nk9rPc3RSkPqIBq4LObG7Z7e28mzHjLh1KYaVYal755Yed2ylosrBx
        sVCWNttWBPk2uRBmu6dsKjw1rKXBHQWLwPfTxoYXiyopi9ZTj8XVaA/3lszkd7hN0GtWwrw2RpQ4o
        CjQLIZBmOpglfPvnmxRRasPX9CCfke6HEM3RHjjT3sBJew3R2TLDR8dhZtI6tGcy79XV3he4U8eNH
        vkhjEPEw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-71
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 13/27] input: UNIXSOCK: remove stat of socket-path
Date:   Sat,  6 Nov 2021 16:49:39 +0000
Message-Id: <20211106164953.130024-14-jeremy@azazel.net>
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

There is a TOCTOU race between the stat(2) and bind(2) calls, and if the
path is already bound, the bind(2) call will fail in any case.

A couple of error message fixes.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/packet/ulogd_inppkt_UNIXSOCK.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/input/packet/ulogd_inppkt_UNIXSOCK.c b/input/packet/ulogd_inppkt_UNIXSOCK.c
index f97c2e174b2d..62a1c1a00cdf 100644
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

