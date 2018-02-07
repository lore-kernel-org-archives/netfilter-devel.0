From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 5/7] netfilter: x_tables: rate-limit table mismatch warnings
Date: Wed,  7 Feb 2018 14:48:26 +0100
Message-ID: <20180207134828.18691-6-fw@strlen.de>
References: <20180207134828.18691-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38830 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753794AbeBGNuB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Feb 2018 08:50:01 -0500
In-Reply-To: <20180207134828.18691-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 4 ++--
 net/ipv6/netfilter/ip6t_rpfilter.c | 4 ++--
 net/netfilter/xt_CONNSECMARK.c     | 4 ++--
 net/netfilter/xt_SECMARK.c         | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index ffd1cf65af3a..afea7aff80c1 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -111,8 +111,8 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "raw") != 0) {
-		pr_info("match only valid in the \'raw\' "
-			"or \'mangle\' tables, not \'%s\'.\n", par->table);
+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
+				    par->table);
 		return -EINVAL;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index c9e27d4687a2..9740f9c6428c 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -109,8 +109,8 @@ static int rpfilter_check(const struct xt_mtchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "raw") != 0) {
-		pr_info("match only valid in the \'raw\' "
-			"or \'mangle\' tables, not \'%s\'.\n", par->table);
+		pr_info_ratelimited("only valid in \'raw\' or \'mangle\' table, not \'%s\'\n",
+				    par->table);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index da56c06a443c..6f30cd399e42 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -91,8 +91,8 @@ static int connsecmark_tg_check(const struct xt_tgchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
-		pr_info("target only valid in the \'mangle\' "
-			"or \'security\' tables, not \'%s\'.\n", par->table);
+		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
+				    par->table);
 		return -EINVAL;
 	}
 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 36f7ad881a7e..1f2a0627478a 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -86,8 +86,8 @@ static int secmark_tg_check(const struct xt_tgchk_param *par)
 
 	if (strcmp(par->table, "mangle") != 0 &&
 	    strcmp(par->table, "security") != 0) {
-		pr_info("target only valid in the \'mangle\' "
-			"or \'security\' tables, not \'%s\'.\n", par->table);
+		pr_info_ratelimited("only valid in \'mangle\' or \'security\' table, not \'%s\'\n",
+				    par->table);
 		return -EINVAL;
 	}
 
-- 
2.13.6

