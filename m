From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 3/5] ipset: coalesce two ifs
Date: Mon, 08 Sep 2014 16:30:43 +0200
Message-ID: <20140908143043.16930.51865.stgit@jonathan.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:63529 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbaIHObr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:47 -0400
In-Reply-To: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because they are doing the same for both IPSET_CMD_LIST and
IPSET_CMD_SAVE.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 lib/session.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/session.c b/lib/session.c
index 7a719b2..d4fe836 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -1936,13 +1936,11 @@ ipset_cmd(struct ipset_session *session, enum ipset_cmd cmd, uint32_t lineno)
 	session->lineno = lineno;
 
 	/* Set default output mode */
-	if (cmd == IPSET_CMD_LIST) {
+	if (cmd == IPSET_CMD_LIST || cmd == IPSET_CMD_SAVE) {
 		if (session->mode == IPSET_LIST_NONE)
 			session->mode = IPSET_LIST_PLAIN;
-	} else if (cmd == IPSET_CMD_SAVE) {
-		if (session->mode == IPSET_LIST_NONE)
-			session->mode = IPSET_LIST_SAVE;
 	}
+
 	/* Start the root element in XML mode */
 	if ((cmd == IPSET_CMD_LIST || cmd == IPSET_CMD_SAVE) &&
 	    session->mode == IPSET_LIST_XML)

