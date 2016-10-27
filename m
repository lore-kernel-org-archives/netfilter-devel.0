From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH] sync-mode: print errno message on failure
Date: Thu, 27 Oct 2016 12:20:17 +0200
Message-ID: <147756361728.15386.11786527603548778870.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46097 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751022AbcJ0NsH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 09:48:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 3514351F356
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 10:20:11 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id cUzq4Lq1v6bF for <netfilter-devel@vger.kernel.org>;
        Thu, 27 Oct 2016 12:20:05 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 9B8CC51F353
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 12:20:05 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have observed this message several times:

 [ERROR] can't open channel socket
 [ERROR] initialization failed

which is very difficult to understand.

The errno message should help this to be a bit more explicit.
With this patch, in the case of wrong interface:

 [ERROR] can't open channel socket: No such device
 [ERROR] initialization failed

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/sync-mode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/sync-mode.c b/src/sync-mode.c
index e69ecfe..8fe65f1 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -412,7 +412,8 @@ static int init_sync(void)
 	STATE_SYNC(channel) =
 		multichannel_open(CONFIG(channel), CONFIG(channel_num));
 	if (STATE_SYNC(channel) == NULL) {
-		dlog(LOG_ERR, "can't open channel socket");
+		dlog(LOG_ERR, "can't open channel socket: %s",
+		     strerror(errno));
 		return -1;
 	}
 	for (i=0; i<STATE_SYNC(channel)->channel_num; i++) {

