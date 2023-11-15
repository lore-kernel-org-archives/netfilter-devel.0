Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79348C47075
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 09:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbjKOJmo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 04:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbjKOJml (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 04:42:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 10808109
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 01:42:38 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, thaller@redhat.com
Subject: [PATCH nft 3/4] tests: shell: skip pipapo set backend in transactions/30s-stress
Date:   Wed, 15 Nov 2023 10:42:30 +0100
Message-Id: <20231115094231.168870-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231115094231.168870-1-pablo@netfilter.org>
References: <20231115094231.168870-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Skip tests with concatenations and intervals if kernel does not support it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/transactions/30s-stress | 51 ++++++++++++++++---
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index 4c3c6a275941..b6ad06abed32 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -38,6 +38,10 @@ if [ -z "${NFT_TEST_HAVE_chain_binding+x}" ] ; then
 	fi
 fi
 
+if [ "$NFT_TEST_HAVE_pipapo" != y ] ;then
+	echo "Skipping pipapo set backend, kernel does not support it"
+fi
+
 testns=testns-$(mktemp -u "XXXXXXXX")
 tmp=""
 
@@ -264,6 +268,19 @@ randdelns()
 	done
 }
 
+available_flags()
+{
+	local -n available_flags=$1
+	selected_key=$2
+	if [ "$selected_key" == "single" ] ;then
+		available_flags+=("interval")
+	elif [ "$selected_key" == "concat" ] ;then
+		if [ "$NFT_TEST_HAVE_pipapo" = y ] ;then
+			available_flags+=("interval")
+		fi
+	fi
+}
+
 random_element_string=""
 
 # create a random element.  Could cause any of the following:
@@ -295,7 +312,10 @@ random_elem()
 
 			fr=$((RANDOM%2))
 			f=0
-			for flags in "" "interval" ; do
+
+			FLAGS=("")
+			available_flags FLAGS $key
+			for flags in ${FLAGS[@]} ; do
 				cnt=$((cnt+1))
 				if [ $f -ne fkr ] ;then
 					f=$((f+1))
@@ -504,8 +524,10 @@ for table in $tables; do
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
-	# pipapo (concat + set), with goto anonymous chain.
-	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
+	if [ "$NFT_TEST_HAVE_pipapo" = y ] ;then
+		# pipapo (concat + set), with goto anonymous chain.
+		gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
+	fi
 
 	# add a few anonymous sets. rhashtable is convered by named sets below.
 	c=$((RANDOM%$count))
@@ -518,8 +540,10 @@ for table in $tables; do
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
-	# pipapo (concat + set), with goto anonymous chain.
-	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
+	if [ "$NFT_TEST_HAVE_pipapo" = y ] ;then
+		# pipapo (concat + set), with goto anonymous chain.
+		gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
+	fi
 
 	# add constant/immutable sets
 	size=$((RANDOM%5120000))
@@ -533,12 +557,21 @@ for table in $tables; do
 
 	# add named sets with various combinations (plain value, range, concatenated values, concatenated ranges, with timeouts, with data ...)
 	for key in "ip saddr" "ip saddr . tcp dport"; do
-		for flags in "" "flags interval;" ; do
+		FLAGS=("")
+		if [ "$key" == "ip saddr" ] ;then
+			FLAGS+=("flags interval;")
+		elif [ "$key" == "ip saddr . tcp dport" ] ;then
+			if [ "$NFT_TEST_HAVE_pipapo" = y ] ;then
+				FLAGS+=("flags interval;")
+			fi
+		fi
+		for ((i = 0; i < ${#FLAGS[@]}; i++)) ; do
 			timeout=$((RANDOM%10))
 			timeout=$((timeout+1))
 			timeout="timeout ${timeout}s"
 
 			cnt=$((cnt+1))
+			flags=${FLAGS[$i]}
 			echo "add set inet $table set_${cnt}  { typeof ${key} ; ${flags} }" >> "$tmp"
 			echo "add set inet $table sett${cnt} { typeof ${key} ; $timeout; ${flags} }" >> "$tmp"
 			echo "add map inet $table dmap_${cnt} { typeof ${key} : meta mark ; ${flags} }" >> "$tmp"
@@ -550,7 +583,11 @@ for table in $tables; do
 
 	cnt=0
 	for key in "single" "concat"; do
-		for flags in "" "interval" ; do
+		FLAGS=("")
+		available_flags FLAGS $key
+
+		for ((i = 0; i < ${#FLAGS[@]}; i++)) ; do
+			flags=${FLAGS[$i]}
 			want="${key}${flags}"
 			cnt=$((cnt+1))
 			maxip=$((RANDOM%256))
-- 
2.30.2

