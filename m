From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 01/11] -1 means error, not 0
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.12472.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:50926 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751134AbYAVOIH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:08:07 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/run.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/src/run.c b/src/run.c
index abe968f..bdf6b0b 100644
--- a/src/run.c
+++ b/src/run.c
@@ -116,7 +116,7 @@ init(void)
 
 	/* local UNIX socket */
 	STATE(local) = local_server_create(&CONFIG(local));
-	if (!STATE(local)) {
+	if (STATE(local) == -1) {
 		dlog(LOG_ERR, "can't open unix socket!");
 		return -1;
 	}


