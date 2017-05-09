From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 1/2] conntrackd: consolidate more code to
 use resync_send()
Date: Tue, 09 May 2017 09:41:10 +0200
Message-ID: <149431567027.23472.7461747418695885217.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:39542 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752407AbdEIHlT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 03:41:19 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id D9C8F51F559
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2017 07:41:16 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i9ZYXcteUu2u for <netfilter-devel@vger.kernel.org>;
        Tue,  9 May 2017 09:41:11 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 15CF351F503
        for <netfilter-devel@vger.kernel.org>; Tue,  9 May 2017 09:41:10 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These digest_msg() functions can use resync_send() as well.

While at it, bring back a call to kernel_resync() in notrack_local() which was
lost in a previous commit.

Fixes: 131df891f77dc75515d5eabdedd9818105d29f5a ("conntrackd: factorize resync operations")
Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/sync-ftfw.c    |    5 +----
 src/sync-notrack.c |   15 +++++++--------
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 6fdb058..6dca3dc 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -313,10 +313,7 @@ static int digest_msg(const struct nethdr *net)
 
 	} else if (IS_RESYNC(net)) {
 		dlog(LOG_NOTICE, "resync requested by other node");
-		cache_iterate(STATE(mode)->internal->ct.data, NULL,
-			      do_cache_to_tx);
-		cache_iterate(STATE(mode)->internal->exp.data, NULL,
-			      do_cache_to_tx);
+		resync_send(do_cache_to_tx);
 		return MSG_CTL;
 
 	} else if (IS_ALIVE(net))
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index 7ce62d9..1b53e1b 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -107,7 +107,10 @@ static int notrack_local(int fd, int type, void *data)
 		resync_req();
 		break;
 	case SEND_BULK:
-		resync_send(do_cache_to_tx);
+		if (CONFIG(sync).internal_cache_disable)
+			kernel_resync();
+		else
+			resync_send(do_cache_to_tx);
 		break;
 	default:
 		ret = 0;
@@ -124,14 +127,10 @@ static int digest_msg(const struct nethdr *net)
 
 	if (IS_RESYNC(net)) {
 		dlog(LOG_NOTICE, "resync requested by other node");
-		if (CONFIG(sync).internal_cache_disable) {
+		if (CONFIG(sync).internal_cache_disable)
 			kernel_resync();
-		} else {
-			cache_iterate(STATE(mode)->internal->ct.data,
-				      NULL, do_cache_to_tx);
-			cache_iterate(STATE(mode)->internal->exp.data,
-				      NULL, do_cache_to_tx);
-		}
+		else
+			resync_send(do_cache_to_tx);
 		return MSG_CTL;
 	}
 

