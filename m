Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905534414
	for <netfilter-devel@vger.kernel.org>; Sat, 14 Sep 2024 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726351350; cv=none; b=s3wZwKvxOCXrTQ8Mha+/K8gp7TTN3ofB125wPuX0bdLQ4lYHnKkkB3UTCLOcN5KSGXv5gMklTiTpfqUdI02jetfRG6oE18LA+omuxJ/g1CZ3IQAyTLCYnZxa+yWUzLXSx+/jKE3+Tr9aWLX9hs5ZWEBDnwL7z9PNq+5g5rGIKQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726351350; c=relaxed/simple;
	bh=Yhh9Y+qe3jaoliQiGcT+F+wlGVDp10KkRsU2nk29OI4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T070hhBUe9H1i27naxqLPAnfNYaFN5z4pdx1DvGHCBZ6w1ZRZigSh1okyqPZcye/TuIEt20/spYIFofwnygUTxolzmvhae2VDh2z+QjUr61Lty9HwSn1QdaWcGG9iLP2Jvt++3P5T7wKismGM1sLk14OEMqKInwQOoGSS5tgBHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1spaqX-0008DY-N1; Sun, 15 Sep 2024 00:02:25 +0200
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: more ransomization for timeout parameter
Date: Sun, 15 Sep 2024 00:02:18 +0200
Message-ID: <20240914220222.132078-1-fw@strlen.de>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Either pass no timeout argument, pass timeout+expires or omit
timeout (uses default timeout, if any).

This should not expose further kernel code to run at this time,
but unlinke the existing (deterministic) element-update test
case this script does have live traffic and different set types,
including rhashtable which does async gc.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/transactions/30s-stress | 37 +++++++++++++++----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index e92b922660b8..69ceda71f490 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -290,8 +290,29 @@ available_flags()
 	fi
 }
 
-random_element_string=""
+random_timeout()
+{
+	local timeout=""
+	local expires
+	local r=$((RANDOM%3))
+
+	case "$r" in
+	0)
+		timeout=$((RANDOM%60))
+		timeout="timeout ${timeout}s"
+		;;
+	1)
+		timeout=$((RANDOM%60))
+		expires=$((timeout+1))
+		expires=$((RANDOM%expires))
+		timeout="timeout ${timeout}s expires ${expires}s"
+		;;
+	esac
+
+	echo -n "$timeout"
+}
 
+random_element_string=""
 # create a random element.  Could cause any of the following:
 # 1. Invalid set/map
 # 2. Element already exists in set/map w. create
@@ -354,17 +375,17 @@ random_elem()
 				r=$((RANDOM%7))
 				case "$r" in
 				0)
-					random_element_string=" inet $table set_${cnt} { $element }"
+					random_element_string="inet $table set_${cnt} { $element }"
 					;;
-				1)	random_element_string="inet $table sett${cnt} { $element timeout $((RANDOM%60))s }"
+				1)	random_element_string="inet $table sett${cnt} { $element $(random_timeout) }"
 					;;
 				2)	random_element_string="inet $table dmap_${cnt} { $element : $RANDOM }"
 					;;
-				3)	random_element_string="inet $table dmapt${cnt} { $element timeout $((RANDOM%60))s : $RANDOM }"
+				3)	random_element_string="inet $table dmapt${cnt} { $element $(random_timeout) : $RANDOM }"
 					;;
 				4)	random_element_string="inet $table vmap_${cnt} { $element : `random_verdict $count` }"
 					;;
-				5)	random_element_string="inet $table vmapt${cnt} { $element timeout $((RANDOM%60))s : `random_verdict $count` }"
+				5)	random_element_string="inet $table vmapt${cnt} { $element $(random_timeout) : `random_verdict $count` }"
 					;;
 				6)	random_element_string="inet $table setc${cnt} { $element }"
 					;;
@@ -625,11 +646,11 @@ for table in $tables; do
 				esac
 
 				echo "add element inet $table set_${cnt} { $element }" >> "$tmp"
-				echo "add element inet $table sett${cnt} { $element timeout $((RANDOM%60))s }" >> "$tmp"
+				echo "add element inet $table sett${cnt} { $element $(random_timeout) }" >> "$tmp"
 				echo "add element inet $table dmap_${cnt} { $element : $RANDOM }" >> "$tmp"
-				echo "add element inet $table dmapt${cnt} { $element timeout $((RANDOM%60))s : $RANDOM }" >> "$tmp"
+				echo "add element inet $table dmapt${cnt} { $element $(random_timeout) : $RANDOM }" >> "$tmp"
 				echo "add element inet $table vmap_${cnt} { $element : `random_verdict $count` }" >> "$tmp"
-				echo "add element inet $table vmapt${cnt} { $element timeout $((RANDOM%60))s : `random_verdict $count` }" >> "$tmp"
+				echo "add element inet $table vmapt${cnt} { $element $(random_timeout) : `random_verdict $count` }" >> "$tmp"
 			done
 		done
 	done
-- 
2.46.0

