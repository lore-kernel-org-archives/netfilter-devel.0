From: Max Kellermann <max@duempel.org>
Subject: [conntrack-utils PATCH r7285 05/11] added missing ntohs()
Date: Tue, 22 Jan 2008 15:10:51 +0100
Message-ID: <20080122141051.30077.23200.stgit@rabbit.intern.cm-ag>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:46706 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754238AbYAVOMG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:12:06 -0500
In-Reply-To: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 src/sync-mode.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/src/sync-mode.c b/src/sync-mode.c
index 4b2fad7..7db180e 100644
--- a/src/sync-mode.c
+++ b/src/sync-mode.c
@@ -113,8 +113,8 @@ static void mcast_handler(void)
 			return;
 		}
 		do_mcast_handler_step(net);
-		ptr += net->len;
-		remain -= net->len;
+		ptr += ntohs(net->len);
+		remain -= ntohs(net->len);
 	}
 }
 


