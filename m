From: Joonwoo Park <joonwpark81@gmail.com>
Subject: [PATCH 8/8] iptables: string extension case insensitive matching
Date: Sat, 21 Jun 2008 00:54:25 -0700
Message-ID: <1214034865-1420-1-git-send-email-joonwpark81@gmail.com>
Cc: Joonwoo Park <joonwpark81@gmail.com>
To: netfilter-devel <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.234]:58005 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYFUHym (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2008 03:54:42 -0400
Received: by rv-out-0506.google.com with SMTP id k40so6015127rvb.1
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jun 2008 00:54:42 -0700 (PDT)
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The string extension can search patterns case insensitively with --icase
option.

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
---
 extensions/libxt_string.c           |   12 ++++++++++++
 include/linux/netfilter/xt_string.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 5eec44b..b8220ef 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -38,6 +38,7 @@ static void string_help(void)
 "--from                       Offset to start searching from\n"
 "--to                         Offset to stop searching\n"
-"--algo	                      Algorithm\n"
+"--algo                       Algorithm\n"
+"--icase                      Ignore case (default: 0)\n"
 "[!] --string string          Match a string in a packet\n"
 "[!] --hex-string string      Match a hex string in a packet\n");
 }
@@ -48,6 +49,7 @@ static const struct option string_opts[] = {
 	{ "algo", 1, NULL, '3' },
 	{ "string", 1, NULL, '4' },
 	{ "hex-string", 1, NULL, '5' },
+	{ "icase", 0, NULL, '6' },
 	{ .name = NULL }
 };
 
@@ -162,6 +164,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 #define ALGO   0x2
 #define FROM   0x4
 #define TO     0x8
+#define ICASE  0x10
 
 /* Function which parses command options; returns true if it
    ate an option */
@@ -217,6 +220,11 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= STRING;
 		break;
 
+	case '6':
+		stringinfo->icase = 1;
+		*flags |= ICASE;
+		break;
+
 	default:
 		return 0;
 	}
@@ -300,6 +308,8 @@ string_print(const void *ip, const struct xt_entry_match *match, int numeric)
 		printf("FROM %u ", info->from_offset);
 	if (info->to_offset != 0)
 		printf("TO %u ", info->to_offset);
+	if (info->icase != 0)
+		printf("ICASE ");
 }
 
 
@@ -321,6 +331,8 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 		printf("--from %u ", info->from_offset);
 	if (info->to_offset != 0)
 		printf("--to %u ", info->to_offset);
+	if (info->icase != 0)
+		printf("--icase ");
 }
 
 
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index bb21dd1..dfd347f 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -12,6 +12,7 @@ struct xt_string_info
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
 	u_int8_t  patlen;
 	u_int8_t  invert;
+	u_int8_t  icase;
 
 	/* Used internally by the kernel */
 	struct ts_config __attribute__((aligned(8))) *config;
-- 
1.5.4.3

