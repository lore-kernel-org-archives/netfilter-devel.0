From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] src: remove redundant casts
Date: Sat, 18 Dec 2010 21:16:08 +0100
Message-ID: <1292703371-15946-2-git-send-email-jengelh@medozas.de>
References: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47379 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203Ab0LRUQN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:16:13 -0500
In-Reply-To: <1292703371-15946-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/main.c b/src/main.c
index 7a4f8d0..448a5f1 100644
--- a/src/main.c
+++ b/src/main.c
@@ -18,7 +18,7 @@ struct nfct_handle *nfct_open_nfnl(struct nfnl_handle *nfnlh,
 {
 	struct nfct_handle *cth;
 
-	cth = (struct nfct_handle *) malloc(sizeof(struct nfct_handle));
+	cth = malloc(sizeof(struct nfct_handle));
 	if (!cth)
 		return NULL;
 	
-- 
1.7.1

