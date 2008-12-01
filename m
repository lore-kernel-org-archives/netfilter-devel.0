From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 08/18] Treat nice function return.
Date: Mon,  1 Dec 2008 22:36:06 +0100
Message-ID: <1228167376-22101-9-git-send-email-eric@inl.fr>
References: <1228167376-22101-1-git-send-email-eric@inl.fr>
Cc: pablo@netfilter.org, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:39308 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555AbYLAVgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:36:22 -0500
In-Reply-To: <1228167376-22101-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

gcc was warning that the return of the nice function should
be treated. This patch adds an error message in case of failure.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/ulogd.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index e69079d..ead35b5 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1129,7 +1129,13 @@ int main(int argc, char* argv[])
 		}
 	}
 
-	nice(-1);
+	errno = 0;
+	if (nice(-1) == -1) {
+		if (errno != 0)
+			ulogd_log(ULOGD_ERROR, "Could not nice process: %s\n",
+				  strerror(errno));
+	}
+
 
 	if (daemonize){
 		if (fork()) {
-- 
1.5.6.3

