From: Chris Boot <bootc@bootc.net>
Subject: [PATCH 1/2] ulogd: Perform nice() before giving up root
Date: Sat, 11 May 2013 18:01:52 +0100
Message-ID: <1368291713-40132-2-git-send-email-bootc@bootc.net>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
Cc: Chris Boot <bootc@bootc.net>, Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:46404 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab3EKRKm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 13:10:42 -0400
In-Reply-To: <1368291713-40132-1-git-send-email-bootc@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The daemon code currently tries to nice(-1) just after having given up root
privileges, which fails. This patch moves the nice(-1) call to just before
the code that gives up the required privileges.

Signed-off-by: Chris Boot <bootc@bootc.net>
---
 src/ulogd.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index b28d0f8..8a144e3 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1235,6 +1235,13 @@ int main(int argc, char* argv[])
 		warn_and_exit(daemonize);
 	}
 
+	errno = 0;
+	if (nice(-1) == -1) {
+		if (errno != 0)
+			ulogd_log(ULOGD_ERROR, "Could not nice process: %s\n",
+				  strerror(errno));
+	}
+
 	if (change_uid) {
 		ulogd_log(ULOGD_NOTICE, "Changing UID / GID\n");
 		if (setgid(gid)) {
@@ -1261,13 +1268,6 @@ int main(int argc, char* argv[])
 		}
 	}
 
-	errno = 0;
-	if (nice(-1) == -1) {
-		if (errno != 0)
-			ulogd_log(ULOGD_ERROR, "Could not nice process: %s\n",
-				  strerror(errno));
-	}
-
 
 	if (daemonize){
 		if (fork()) {
-- 
1.7.10.4

