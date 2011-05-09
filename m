From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] iptables: fix the dead loop when meeting unknown options
Date: Mon,  9 May 2011 21:53:41 +0200
Message-ID: <1304970823-11244-2-git-send-email-jengelh@medozas.de>
References: <1304970823-11244-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54467 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102Ab1EITxq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:53:46 -0400
In-Reply-To: <1304970823-11244-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Changli Gao <xiaosuo@gmail.com>

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 xshared.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/xshared.c b/xshared.c
index 404a9f5..87402b4 100644
--- a/xshared.c
+++ b/xshared.c
@@ -92,7 +92,7 @@ static bool should_load_proto(struct iptables_command_state *cs)
 	if (find_proto(cs->protocol, XTF_DONT_LOAD,
 	    cs->options & OPT_NUMERIC, NULL) == NULL)
 		return true;
-	return cs->proto_used;
+	return !cs->proto_used;
 }
 
 struct xtables_match *load_proto(struct iptables_command_state *cs)
-- 
1.7.1

