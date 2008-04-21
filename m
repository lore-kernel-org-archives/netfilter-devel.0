From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/5] Fix a bug in definition of seq_global_ce macro.
Date: Mon, 21 Apr 2008 22:43:45 +0200
Message-ID: <1208810627783-git-send-email-eric@inl.fr>
References: <12088106273628-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:40013 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751274AbYDUUnt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 16:43:49 -0400
In-Reply-To: <12088106273628-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index b0827a8..43e1bc4 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -86,8 +86,8 @@ static struct config_keyset libulog_kset = {
 #define rmem_ce(x)	(x->ces[2])
 #define af_ce(x)	(x->ces[3])
 #define unbind_ce(x)	(x->ces[4])
-#define seq_ce(x)	(x->ces[4])
-#define seq_global_ce(x)	(x->ces[5])
+#define seq_ce(x)	(x->ces[5])
+#define seq_global_ce(x)	(x->ces[6])
 
 enum nflog_keys {
 	NFLOG_KEY_RAW_MAC = 0,
-- 
1.5.2.5

