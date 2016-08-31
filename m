From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: [PATCH iptables v3] xtables-translate-restore: do not escape quotes
Date: Wed, 31 Aug 2016 09:59:16 +0200
Message-ID: <20160831075916.4432-1-pablombg@gmail.com>
Cc: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34792 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758387AbcHaH7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2016 03:59:49 -0400
Received: by mail-wm0-f65.google.com with SMTP id d196so2259782wmd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2016 00:59:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If quotes are escaped, nft -f is unable to parse and load the translated
ruleset.

Signed-off-by: Pablo M. Bermudo Garay <pablombg@gmail.com>
---

Changes in v3:
  - Add a new field to the iptables_command_state struct instead of
    propagate 'bool restore' argument.

 iptables/xshared.h           | 1 +
 iptables/xtables-translate.c | 6 ++++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index 6eb8eb8..18b1cf3 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -63,6 +63,7 @@ struct iptables_command_state {
 	int proto_used;
 	const char *jumpto;
 	char **argv;
+	bool restore;
 };
 
 typedef int (*mainfunc_t)(int, char **);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 3c577ed..689533f 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -70,7 +70,7 @@ int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 				.ip		= (const void *)&cs->fw,
 				.target		= cs->target->t,
 				.numeric	= numeric,
-				.escape_quotes	= true,
+				.escape_quotes	= !cs->restore,
 			};
 			ret = cs->target->xlate(xl, &params);
 		}
@@ -97,7 +97,7 @@ int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl)
 			.ip		= (const void *)&cs->fw,
 			.match		= matchp->match->m,
 			.numeric	= numeric,
-			.escape_quotes	= true,
+			.escape_quotes	= !cs->restore,
 		};
 
 		if (!matchp->match->xlate)
@@ -226,6 +226,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 
 	do_parse(h, argc, argv, &p, &cs, &args);
 
+	cs.restore = restore;
+
 	if (!restore)
 		printf("nft ");
 
-- 
2.9.3

