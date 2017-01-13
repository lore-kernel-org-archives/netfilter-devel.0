From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] src: Allow to list ruleset without stateful information
Date: Fri, 13 Jan 2017 12:50:58 -0200
Message-ID: <20170113145058.GA8030@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36018 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdAMOvH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2017 09:51:07 -0500
Received: by mail-vk0-f67.google.com with SMTP id n19so3904760vkd.3
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2017 06:51:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently only counter and quota have stateful information.

Standard list ruleset:

table ip x {
	chain y {
		type filter hook output priority 0; policy accept;
		tcp dport https counter packets 149 bytes 10085
		tcp dport https quota 1025 mbytes used 9 kbytes
	}
}

With stateless option, -s:

table ip x {
	chain y {
		type filter hook output priority 0; policy accept;
		tcp dport https counter
		tcp dport https quota 1025 mbytes
	}
}

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 include/nftables.h |  1 +
 src/main.c         | 12 +++++++++++-
 src/statement.c    |  9 +++++++--
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/include/nftables.h b/include/nftables.h
index d3f471b..760bbff 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -29,6 +29,7 @@ extern unsigned int numeric_output;
 extern unsigned int ip2name_output;
 extern unsigned int handle_output;
 extern unsigned int debug_level;
+extern bool stateless_output;
 extern const char *include_paths[INCLUDE_PATHS_MAX];
 
 enum nftables_exit_codes {
diff --git a/src/main.c b/src/main.c
index 5c72fc0..fdcaffc 100644
--- a/src/main.c
+++ b/src/main.c
@@ -35,6 +35,7 @@ unsigned int handle_output;
 #ifdef DEBUG
 unsigned int debug_level;
 #endif
+bool stateless_output;
 
 const char *include_paths[INCLUDE_PATHS_MAX] = { DEFAULT_INCLUDE_PATH };
 static unsigned int num_include_paths = 1;
@@ -46,13 +47,14 @@ enum opt_vals {
 	OPT_INTERACTIVE		= 'i',
 	OPT_INCLUDEPATH		= 'I',
 	OPT_NUMERIC		= 'n',
+	OPT_STATELESS		= 's',
 	OPT_IP2NAME		= 'N',
 	OPT_DEBUG		= 'd',
 	OPT_HANDLE_OUTPUT	= 'a',
 	OPT_INVALID		= '?',
 };
 
-#define OPTSTRING	"hvf:iI:vnNa"
+#define OPTSTRING	"hvf:iI:vnsNa"
 
 static const struct option options[] = {
 	{
@@ -77,6 +79,10 @@ static const struct option options[] = {
 		.val		= OPT_NUMERIC,
 	},
 	{
+		.name		= "stateless",
+		.val		= OPT_STATELESS,
+	},
+	{
 		.name		= "reversedns",
 		.val		= OPT_IP2NAME,
 	},
@@ -116,6 +122,7 @@ static void show_help(const char *name)
 "  -n, --numeric			When specified once, show network addresses numerically (default behaviour).\n"
 "  				Specify twice to also show Internet services (port numbers) numerically.\n"
 "				Specify three times to also show protocols, user IDs, and group IDs numerically.\n"
+"  -s, --stateless	       	Omit stateful information of ruleset.\n"
 "  -N				Translate IP addresses to names.\n"
 "  -a, --handle			Output rule handle.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files.\n"
@@ -283,6 +290,9 @@ int main(int argc, char * const *argv)
 		case OPT_NUMERIC:
 			numeric_output++;
 			break;
+		case OPT_STATELESS:
+			stateless_output = true;
+			break;
 		case OPT_IP2NAME:
 			ip2name_output++;
 			break;
diff --git a/src/statement.c b/src/statement.c
index 24a53ee..25bed65 100644
--- a/src/statement.c
+++ b/src/statement.c
@@ -142,7 +142,12 @@ struct stmt *flow_stmt_alloc(const struct location *loc)
 
 static void counter_stmt_print(const struct stmt *stmt)
 {
-	printf("counter packets %" PRIu64 " bytes %" PRIu64,
+	printf("counter");
+
+	if (stateless_output)
+		return;
+
+	printf(" packets %" PRIu64 " bytes %" PRIu64,
 	       stmt->counter.packets, stmt->counter.bytes);
 }
 
@@ -391,7 +396,7 @@ static void quota_stmt_print(const struct stmt *stmt)
 	printf("quota %s%"PRIu64" %s",
 	       inv ? "over " : "", bytes, data_unit);
 
-	if (stmt->quota.used) {
+	if (!stateless_output && stmt->quota.used) {
 		data_unit = get_rate(stmt->quota.used, &used);
 		printf(" used %"PRIu64" %s", used, data_unit);
 	}
-- 
2.7.4

