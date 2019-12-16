Return-Path: <SRS0=8ADT=2G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B632EC43603
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 21:42:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 938E620717
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Dec 2019 21:42:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLPVmG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Dec 2019 16:42:06 -0500
Received: from correo.us.es ([193.147.175.20]:36804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbfLPVmG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Dec 2019 16:42:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C1ACF2DFF
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 22:42:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7D893DA70F
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Dec 2019 22:42:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 73472DA70D; Mon, 16 Dec 2019 22:42:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4034BDA703;
        Mon, 16 Dec 2019 22:41:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 16 Dec 2019 22:41:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 1EF584265A5A;
        Mon, 16 Dec 2019 22:41:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc, fw@strlen.de
Subject: [PATCH nft,RFC] main: remove need to escape quotes
Date:   Mon, 16 Dec 2019 22:41:57 +0100
Message-Id: <20191216214157.551511-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If argv[i] contains spaces, then restore the quotes on this string.

There is one exception though: in case that argc == 2, then assume the
whole input is coming as a quoted string, eg. nft "add rule x ...;add ..."

This patch is adjusting a one test that uses quotes to skip escaping one
semicolon from bash. Two more tests do not need them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Currently nft accepts quotes everywhere, which makes things a bit tricky.
I think this provides a model that can be documented and that skips quote
escaping from bash.

 src/main.c                                         | 30 +++++++++++++++++++---
 tests/shell/testcases/flowtable/0007prio_0         |  2 +-
 tests/shell/testcases/sets/0034get_element_0       |  2 +-
 .../testcases/sets/0040get_host_endian_elements_0  | 12 ++++-----
 4 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/src/main.c b/src/main.c
index 74199f93fa66..00ef999eaf4b 100644
--- a/src/main.c
+++ b/src/main.c
@@ -10,6 +10,7 @@
 
 #include <stdlib.h>
 #include <stddef.h>
+#include <ctype.h>
 #include <unistd.h>
 #include <stdio.h>
 #include <errno.h>
@@ -243,10 +244,21 @@ static bool nft_options_check(int argc, char * const argv[])
 	return true;
 }
 
+static bool nft_quoted_string(const char *arg)
+{
+	unsigned int i;
+
+	for (i = 0; i < strlen(arg); i++) {
+		if (isspace(arg[i]))
+			return true;
+	}
+	return false;
+}
+
 int main(int argc, char * const *argv)
 {
+	unsigned int output_flags = 0, quotes;
 	char *buf = NULL, *filename = NULL;
-	unsigned int output_flags = 0;
 	bool interactive = false;
 	unsigned int debug_mask;
 	unsigned int len;
@@ -365,8 +377,14 @@ int main(int argc, char * const *argv)
 	nft_ctx_output_set_flags(nft, output_flags);
 
 	if (optind != argc) {
-		for (len = 0, i = optind; i < argc; i++)
-			len += strlen(argv[i]) + strlen(" ");
+		for (len = 0, i = optind; i < argc; i++) {
+			if (argc != 2 && nft_quoted_string(argv[i]))
+				quotes = 2;
+			else
+				quotes = 0;
+
+			len += strlen(argv[i]) + strlen(" ") + quotes;
+		}
 
 		buf = calloc(1, len);
 		if (buf == NULL) {
@@ -375,7 +393,11 @@ int main(int argc, char * const *argv)
 			exit(EXIT_FAILURE);
 		}
 		for (i = optind; i < argc; i++) {
-			strcat(buf, argv[i]);
+			if (argc != 2 && nft_quoted_string(argv[i]))
+				sprintf(buf + strlen(buf), "\"%s\"", argv[i]);
+			else
+				strcat(buf, argv[i]);
+
 			if (i + 1 < argc)
 				strcat(buf, " ");
 		}
diff --git a/tests/shell/testcases/flowtable/0007prio_0 b/tests/shell/testcases/flowtable/0007prio_0
index 49bbcac7c93b..138fe4d58788 100755
--- a/tests/shell/testcases/flowtable/0007prio_0
+++ b/tests/shell/testcases/flowtable/0007prio_0
@@ -18,7 +18,7 @@ format_offset () {
 $NFT add table t
 for offset in -11 -10 0 10 11
 do
-	$NFT add flowtable t f "{ hook ingress priority filter `format_offset $offset`; devices = { lo }; }"
+	$NFT add flowtable t f { hook ingress priority filter `format_offset $offset`\; devices = { lo }\; }
 	$NFT delete flowtable t f
 done
 
diff --git a/tests/shell/testcases/sets/0034get_element_0 b/tests/shell/testcases/sets/0034get_element_0
index c7e7298a4aac..47f93464b687 100755
--- a/tests/shell/testcases/sets/0034get_element_0
+++ b/tests/shell/testcases/sets/0034get_element_0
@@ -3,7 +3,7 @@
 RC=0
 
 check() { # (elems, expected)
-	out=$($NFT get element ip t s "{ $1 }" 2>/dev/null)
+	out=$($NFT get element ip t s { $1 } 2>/dev/null)
 	out=$(grep "elements =" <<< "$out")
 	out="${out#* \{ }"
 	out="${out% \}}"
diff --git a/tests/shell/testcases/sets/0040get_host_endian_elements_0 b/tests/shell/testcases/sets/0040get_host_endian_elements_0
index caf6a4af326a..889d28780be7 100755
--- a/tests/shell/testcases/sets/0040get_host_endian_elements_0
+++ b/tests/shell/testcases/sets/0040get_host_endian_elements_0
@@ -12,32 +12,32 @@ RULESET="table ip t {
 
 $NFT -f - <<< "$RULESET" || { echo "can't apply basic ruleset"; exit 1; }
 
-$NFT get element ip t s '{ 0x23-0x42 }' || {
+$NFT get element ip t s { 0x23-0x42 } || {
 	echo "can't find existing range 0x23-0x42"
 	exit 1
 }
 
-$NFT get element ip t s '{ 0x26-0x28 }' || {
+$NFT get element ip t s { 0x26-0x28 } || {
 	echo "can't find existing sub-range 0x26-0x28"
 	exit 1
 }
 
-$NFT get element ip t s '{ 0x26-0x99 }' && {
+$NFT get element ip t s { 0x26-0x99 } && {
 	echo "found non-existing range 0x26-0x99"
 	exit 1
 }
 
-$NFT get element ip t s '{ 0x55-0x99 }' && {
+$NFT get element ip t s { 0x55-0x99 } && {
 	echo "found non-existing range 0x55-0x99"
 	exit 1
 }
 
-$NFT get element ip t s '{ 0x55 }' && {
+$NFT get element ip t s { 0x55 } && {
 	echo "found non-existing element 0x55"
 	exit 1
 }
 
-$NFT get element ip t s '{ 0x1337 }' || {
+$NFT get element ip t s { 0x1337 } || {
 	echo "can't find existing element 0x1337"
 	exit 1
 }
-- 
2.11.0

