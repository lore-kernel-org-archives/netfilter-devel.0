From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables 2/2] xtables-translate-restore: do not escape quotes
Date: Tue, 16 Aug 2016 19:44:33 +0200
Message-ID: <20160816174433.28272-2-pablombg@gmail.com>
References: <20160816174433.28272-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34573 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcHPRpE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Aug 2016 13:45:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id q128so17642080wma.1
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Aug 2016 10:45:04 -0700 (PDT)
In-Reply-To: <20160816174433.28272-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If quotes are escaped, nft -f is unable to parse and load the translated
ruleset.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---
 iptables/xtables-translate.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3c577ed..914d3b1 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -72,6 +72,11 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.numeric	= numeric,
 				.escape_quotes	= true,
 			};
+			if (!strcmp(xtables_globals.program_name,
+				   "iptables-translate-restore") ||
+			    !strcmp(xtables_globals.program_name,
+				   "ip6tables-translate-restore"))
+				params.escape_quotes = false;
 			ret = cs->target->xlate(xl, &params);
 		}
 		else
@@ -100,6 +105,12 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.escape_quotes	= true,
 		};
 
+		if (!strcmp(xtables_globals.program_name,
+			   "iptables-translate-restore") ||
+		    !strcmp(xtables_globals.program_name,
+			   "ip6tables-translate-restore"))
+			params.escape_quotes = false;
+
 		if (!matchp->match->xlate)
 			return 0;
 
-- 
2.9.3

