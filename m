From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: [conntrack-tools PATCH 1/4] conntrackd: evaluate configuration
 earlier
Date: Tue, 06 Jun 2017 12:58:27 +0200
Message-ID: <149674670719.18546.7841033150308352826.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:40554 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751500AbdFFK6g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 06:58:36 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id 1C99851F358
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 10:58:34 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ySo88nanrU2s for <netfilter-devel@vger.kernel.org>;
        Tue,  6 Jun 2017 12:58:28 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id 01FCC51F2B3
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2017 12:58:27 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Run the evaluation step sooner in the conntrackd startup routine.
Don't close log or unlink lockfile at this stage.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 src/main.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/src/main.c b/src/main.c
index fb20f1d..4b6d17d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -338,6 +338,15 @@ int main(int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
+	/*
+	 * Evaluate configuration
+	 */
+	if (evaluate() == -1) {
+		dlog(LOG_ERR, "conntrackd cannot start, please review your "
+		     "configuration");
+		exit(EXIT_FAILURE);
+	}
+
 	if (type == REQUEST) {
 		if (do_local_request(action, &conf.local, local_step) == -1) {
 			dlog(LOG_ERR, "can't connect: is conntrackd "
@@ -383,17 +392,6 @@ int main(int argc, char *argv[])
 	}
 
 	/*
-	 * Evaluate configuration
-	 */
-	if (evaluate() == -1) {
-		dlog(LOG_ERR, "conntrackd cannot start, please review your "
-		     "configuration");
-		close_log();
-		unlink(CONFIG(lockfile));
-		exit(EXIT_FAILURE);
-	}
-
-	/*
 	 * initialization process
 	 */
 

