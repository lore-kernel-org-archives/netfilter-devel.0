From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] iptables: fix the dead loop when meeting unknown options
Date: Mon, 14 Mar 2011 14:23:31 +0800
Message-ID: <1300083811-27146-1-git-send-email-xiaosuo@gmail.com>
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33887 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab1CNGZn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Mar 2011 02:25:43 -0400
Received: by iwn34 with SMTP id 34so4617199iwn.19
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Mar 2011 23:25:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 xshared.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
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
