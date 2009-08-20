From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/4] length: support semi-infinite length description
Date: Thu, 20 Aug 2009 17:09:35 +0200
Message-ID: <1250780978-14013-2-git-send-email-jengelh@medozas.de>
References: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40281 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbZHTPJn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:43 -0400
In-Reply-To: <1250780978-14013-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code is already there, it just was not documented. Also use
UINT16_MAX instead and pretty-print iptables's -L/-S output.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_length.c   |   18 +++++++++++-------
 extensions/libxt_length.man |   13 ++++++++++---
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 0f954cf..adfa116 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -12,8 +12,8 @@ static void length_help(void)
 {
 	printf(
 "length match options:\n"
-"[!] --length length[:length]    Match packet length against value or range\n"
-"                                of values (inclusive)\n");
+"[!] --length length[:[length]]  Match packet length against value, anything\n"
+"                                above value or a  range of values (inclusive)\n");
 }
   
 static const struct option length_opts[] = {
@@ -40,14 +40,14 @@ parse_lengths(const char *s, struct xt_length_info *info)
 	char *cp;
 
 	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
+	if ((cp = strchr(buffer, ':')) == NULL) {
 		info->min = info->max = parse_length(buffer);
-	else {
+	} else {
 		*cp = '\0';
 		cp++;
 
 		info->min = buffer[0] ? parse_length(buffer) : 0;
-		info->max = cp[0] ? parse_length(cp) : 0xFFFF;
+		info->max = cp[0] ? parse_length(cp) : UINT16_MAX;
 	}
 	free(buffer);
 	
@@ -97,9 +97,11 @@ length_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 	printf("length %s", info->invert ? "!" : "");
 	if (info->min == info->max)
-		printf("%u ", info->min);
+		printf("== %u ", info->min);
+	else if (info->max == UINT16_MAX)
+		printf(">= %u ", info->min);
 	else
-		printf("%u:%u ", info->min, info->max);
+		printf("%u..%u ", info->min, info->max);
 }
 
 static void length_save(const void *ip, const struct xt_entry_match *match)
@@ -109,6 +111,8 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 	printf("%s--length ", info->invert ? "! " : "");
 	if (info->min == info->max)
 		printf("%u ", info->min);
+	else if (info->max == UINT16_MAX)
+		printf("%u: ", info->min);
 	else
 		printf("%u:%u ", info->min, info->max);
 }
diff --git a/extensions/libxt_length.man b/extensions/libxt_length.man
index e324e03..cf1e815 100644
--- a/extensions/libxt_length.man
+++ b/extensions/libxt_length.man
@@ -1,5 +1,12 @@
-This module matches the length of the layer-3 payload (e.g. layer-4 packet)
-f a packet against a specific value
+This module matches the length of the layer-3 payload (e.g. layer-4
+header and data) of a packet against a specific value
 or range of values.
 .TP
-[\fB!\fP] \fB\-\-length\fP \fIlength\fP[\fB:\fP\fIlength\fP]
+[\fB!\fP] \fB\-\-length\fP \fIvalue\fP
+Match against exact value
+.TP
+[\fB!\fP] \fB\-\-length\fP \fImin\fP\fB:\fP
+Match against value or anything above it
+.TP
+[\fB!\fP] \fB\-\-length\fP \fImin\fP\fB:\fP\fImax\fP
+Match exact range (inclusive).
-- 
1.6.4

