From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH] rule: add flag to display rule handle as comment
Date: Thu, 30 May 2013 16:22:46 +0200
Message-ID: <1369923766-15549-1-git-send-email-eric@regit.org>
References: <20130521135328.GA5301@localhost>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44051 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab3E3OXP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 May 2013 10:23:15 -0400
In-Reply-To: <20130521135328.GA5301@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Knowing the rule handle is necessary to be able to delete a single
rule. It was not displayed till now in the output and it was thus
impossible to remove a single rule.
This patch modify the listing output to add a comment containing
the handle when the -a/--handle flag is provided.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 include/nftables.h |    1 +
 src/main.c         |   12 +++++++++++-
 src/rule.c         |    3 +++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/nftables.h b/include/nftables.h
index 0eab1e5..ff91d93 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -21,6 +21,7 @@ enum debug_level {
 #define INCLUDE_PATHS_MAX	16
 
 extern unsigned int numeric_output;
+extern unsigned int handle_output;
 extern unsigned int debug_level;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
diff --git a/src/main.c b/src/main.c
index 283ec28..48d4e03 100644
--- a/src/main.c
+++ b/src/main.c
@@ -26,6 +26,7 @@
 #include <erec.h>
 
 unsigned int numeric_output;
+unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
@@ -41,10 +42,11 @@ enum opt_vals {
 	OPT_INCLUDEPATH		= 'I',
 	OPT_NUMERIC		= 'n',
 	OPT_DEBUG		= 'd',
+	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vn"
+#define OPTSTRING	"hvf:iI:vna"
 
 static const struct option options[] = {
 	{
@@ -81,6 +83,10 @@ static const struct option options[] = {
 	},
 #endif
 	{
+		.name		= "handle",
+		.val		= OPT_HANDLE_OUTPUT,
+	},
+	{
 		.name		= NULL
 	}
 };
@@ -100,6 +106,7 @@ static void show_help(const char *name)
 "  -n/--numeric			When specified once, show network addresses numerically.\n"
 "  				When specified twice, also show Internet protocols,\n"
 "				Internet services, user IDs and group IDs numerically.\n"
+"  -a/--handle			Output rule handle.\n"
 "  -I/--includepath <directory>	Add <directory> to the paths searched for include files.\n"
 #ifdef DEBUG
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, all)\n"
@@ -244,6 +251,9 @@ int main(int argc, char * const *argv)
 			}
 			break;
 #endif
+		case OPT_HANDLE_OUTPUT:
+			handle_output++;
+			break;
 		case OPT_INVALID:
 			exit(NFT_EXIT_FAILURE);
 		}
diff --git a/src/rule.c b/src/rule.c
index 9d9eaee..e77323d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdint.h>
 #include <string.h>
+#include <inttypes.h>
 
 #include <statement.h>
 #include <rule.h>
@@ -136,6 +137,8 @@ void rule_print(const struct rule *rule)
 		printf(" ");
 		stmt->ops->print(stmt);
 	}
+	if (handle_output > 0)
+		printf(" # handle %" PRIu64, rule->handle.handle);
 	printf("\n");
 }
 
-- 
1.7.10.4

