From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH 2/2] iptables: Remove unnecessary braces.
Date: Thu, 30 Mar 2017 00:57:43 +0530
Message-ID: <58dc0ab2.15dc630a.414de.570e@mx.google.com>
References: <cover.1490815157.git.rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: outreachy-kernel <outreachy-kernel@googlegroups.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35114 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753160AbdC2T1s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 15:27:48 -0400
Received: by mail-pg0-f67.google.com with SMTP id g2so4118588pge.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:27:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1490815157.git.rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove braces which are not required, to fix the check patch issue.
The following coccinelle script was used to fix this issue.

@@
expression e;
expression e1;
@@
if(e)
-{
 e1;
-}

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 iptables/iptables-standalone.c | 3 +--
 iptables/iptables.c            | 3 +--
 iptables/xtables-standalone.c  | 3 +--
 iptables/xtables-translate.c   | 6 ++----
 4 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/iptables/iptables-standalone.c b/iptables/iptables-standalone.c
index 4da1d7f..c211fb7 100644
--- a/iptables/iptables-standalone.c
+++ b/iptables/iptables-standalone.c
@@ -73,9 +73,8 @@ iptables_main(int argc, char *argv[])
 			fprintf(stderr, "iptables: %s.\n",
 				iptc_strerror(errno));
 		}
-		if (errno == EAGAIN) {
+		if (errno == EAGAIN)
 			exit(RESOURCE_PROBLEM);
-		}
 	}
 
 	exit(!ret);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 62731c5..97cbda9 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1114,9 +1114,8 @@ void print_rule4(const struct ipt_entry *e,
 		       e->ip.invflags & IPT_INV_FRAG ? " !" : "");
 
 	/* Print matchinfo part */
-	if (e->target_offset) {
+	if (e->target_offset)
 		IPT_MATCH_ITERATE(e, print_match_save, &e->ip);
-	}
 
 	/* print counters for iptables -R */
 	if (counters < 0)
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 355a446..139c477 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -85,9 +85,8 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 			fprintf(stderr, "iptables: %s.\n",
 				nft_strerror(errno));
 		}
-		if (errno == EAGAIN) {
+		if (errno == EAGAIN)
 			exit(RESOURCE_PROBLEM);
-		}
 	}
 
 	exit(!ret);
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 00de019..e049f24 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -236,9 +236,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	switch (p.command) {
 	case CMD_APPEND:
 		ret = 1;
-		if (!xlate(h, &p, &cs, &args, true, nft_rule_xlate_add)) {
+		if (!xlate(h, &p, &cs, &args, true, nft_rule_xlate_add))
 			print_ipt_cmd(argc, argv);
-		}
 		break;
 	case CMD_DELETE:
 		break;
@@ -250,9 +249,8 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 		break;
 	case CMD_INSERT:
 		ret = 1;
-		if (!xlate(h, &p, &cs, &args, false, nft_rule_xlate_add)) {
+		if (!xlate(h, &p, &cs, &args, false, nft_rule_xlate_add))
 			print_ipt_cmd(argc, argv);
-		}
 		break;
 	case CMD_FLUSH:
 		if (p.chain) {
-- 
2.9.3

