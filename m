From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 08/11] check if the received packet is
	large enough
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.39415.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:46715 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752514AbYAVOPG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:15:06 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/sync-mode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/src/sync-mode.c b/src/sync-mode.c
index bf8ddef..5f78bfb 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -100,6 +100,11 @@ static void mcast_handler(void)
 	while (remain > 0) {
 		struct nethdr *net = (struct nethdr *) ptr;
 
+		if (remain < sizeof(*net)) {
+			dlog(LOG_ERR, "packet too small");
+			break;
+		}
+
 		if (ntohs(net->len) > remain) {
 			dlog(LOG_ERR, "fragmented messages");
 			break;


