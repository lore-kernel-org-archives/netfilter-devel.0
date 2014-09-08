From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 2/5] ipset: avoid duplicate command flags
Date: Mon, 08 Sep 2014 16:30:38 +0200
Message-ID: <20140908143038.16930.38790.stgit@jonathan.eitzenberger.org>
References: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64754 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaIHObr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:47 -0400
In-Reply-To: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NLM_F_DUMP is #defined as (NLM_F_ROOT | NLM_F_ACK), so specifying
all of them is redundant.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
---
 lib/mnl.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/mnl.c b/lib/mnl.c
index 786c9e5..a0fa66e 100644
--- a/lib/mnl.c
+++ b/lib/mnl.c
@@ -38,10 +38,8 @@ static const uint16_t cmdflags[] = {
 	[IPSET_CMD_FLUSH-1]	= NLM_F_REQUEST|NLM_F_ACK,
 	[IPSET_CMD_RENAME-1]	= NLM_F_REQUEST|NLM_F_ACK,
 	[IPSET_CMD_SWAP-1]	= NLM_F_REQUEST|NLM_F_ACK,
-	[IPSET_CMD_LIST-1]	= NLM_F_REQUEST|NLM_F_ACK|
-					NLM_F_ROOT|NLM_F_MATCH|NLM_F_DUMP,
-	[IPSET_CMD_SAVE-1]	= NLM_F_REQUEST|NLM_F_ACK|
-					NLM_F_ROOT|NLM_F_MATCH|NLM_F_DUMP,
+	[IPSET_CMD_LIST-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
+	[IPSET_CMD_SAVE-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_DUMP,
 	[IPSET_CMD_ADD-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
 	[IPSET_CMD_DEL-1]	= NLM_F_REQUEST|NLM_F_ACK|NLM_F_EXCL,
 	[IPSET_CMD_TEST-1]	= NLM_F_REQUEST|NLM_F_ACK,

