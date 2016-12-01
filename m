From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH] src: add log message when resync is
 requested by other node
Date: Thu, 01 Dec 2016 10:59:02 +0100
Message-ID: <148058634219.22458.12922067063307832516.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60347 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753103AbcLAJ7M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 04:59:12 -0500
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 8A89451F387
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 09:59:09 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id b6Y4gY28Q5N3 for <netfilter-devel@vger.kernel.org>;
        Thu,  1 Dec 2016 10:59:04 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 515F851F2A8
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 10:59:03 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If a resync is requested with 'conntrackd -n', a log message is printed
in the caller node, but no message is printed in the other.

Print a message so tracking the behaviour of a cluster is a bit easier.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/sync-ftfw.c    |    2 +-
 src/sync-notrack.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/sync-ftfw.c b/src/sync-ftfw.c
index 1bc2d9f..aa6838a 100644
--- a/src/sync-ftfw.c
+++ b/src/sync-ftfw.c
@@ -351,7 +351,7 @@ static int digest_msg(const struct nethdr *net)
 		return MSG_CTL;
 
 	} else if (IS_RESYNC(net)) {
-		dp("RESYNC ALL\n");
+		dlog(LOG_NOTICE, "resync requested by other node");
 		cache_iterate(STATE(mode)->internal->ct.data, NULL,
 			      do_cache_to_tx);
 		cache_iterate(STATE(mode)->internal->exp.data, NULL,
diff --git a/src/sync-notrack.c b/src/sync-notrack.c
index c810bbb..7ade3a7 100644
--- a/src/sync-notrack.c
+++ b/src/sync-notrack.c
@@ -149,6 +149,7 @@ static int digest_msg(const struct nethdr *net)
 		return MSG_DATA;
 
 	if (IS_RESYNC(net)) {
+		dlog(LOG_NOTICE, "resync requested by other node");
 		if (CONFIG(sync).internal_cache_disable) {
 			kernel_resync();
 		} else {

