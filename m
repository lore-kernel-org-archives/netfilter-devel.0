Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97728C84C
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 17:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315070; cv=none; b=H9IGToxodcdoYxnM76AnQn6+ZPxH8Gh7iUD3wQecjqIOLVr1xwt+Pkiew35QyJmjDgMjLdDmaVl8K9sXUhIELxZdTcIxRebY7BYgU0nXmLbRJxwT7vKs7nExyrNS4mcI2o4Faw90WHXgeKx4HsINnCGel52WiF2jETJLVlSRClw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315070; c=relaxed/simple;
	bh=fcNUNXHuMGIuC1xJwApMmQ9doYwbBRLeLAFu1ZGbtWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sj9hCZj8MmKg381CR7dvdMQ+lBeR39iCM6bNAK8Hw7gl39tAAp6ezAOqsk1VC+L8fQDLemyPbnBasVKlA2GiQIGklh8BkBZax6G0S3wWkqZ8XWagWGzg63tAHPcJdvFNfYSR3LyT7H2k/XwdRLCn9f8pE7ujwr7D7FjkQrqejZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 7BD9060224; Wed, 27 Aug 2025 19:17:46 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	Yi Chen <yiche@redhat.com>
Subject: [PATCH nf] selftests: netfilter: fix udpclash tool hang
Date: Wed, 27 Aug 2025 19:17:32 +0200
Message-ID: <20250827171736.7513-1-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Yi Chen reports that 'udpclash' loops forever depending on compiler
(and optimization level used); while (x == 1) gets optimized into
for (;;).  Switch to stdatomic to prevent this.

While at it, also run it under timeout(1) and fix the resize script
to not ignore the timeout passed as second parameter to insert_flood.

Reported-by: Yi Chen <yiche@redhat.com>
Suggested-by: Yi Chen <yiche@redhat.com>
Fixes: 78a588363587 ("selftests: netfilter: add conntrack clash resolution test case")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tools/testing/selftests/net/netfilter/conntrack_clash.sh  | 2 +-
 tools/testing/selftests/net/netfilter/conntrack_resize.sh | 5 +++--
 tools/testing/selftests/net/netfilter/udpclash.c          | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
index 606a43a60f73..7fc6c5dbd551 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -99,7 +99,7 @@ run_one_clash_test()
 	local entries
 	local cre
 
-	if ! ip netns exec "$ns" ./udpclash $daddr $dport;then
+	if ! ip netns exec "$ns" timeout 30 ./udpclash $daddr $dport;then
 		echo "INFO: did not receive expected number of replies for $daddr:$dport"
 		ip netns exec "$ctns" conntrack -S
 		# don't fail: check if clash resolution triggered after all.
diff --git a/tools/testing/selftests/net/netfilter/conntrack_resize.sh b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
index 788cd56ea4a0..615fe3c6f405 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_resize.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_resize.sh
@@ -187,7 +187,7 @@ ct_udpclash()
 	[ -x udpclash ] || return
 
         while [ $now -lt $end ]; do
-		ip netns exec "$ns" ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
+		ip netns exec "$ns" timeout 30 ./udpclash 127.0.0.1 $((RANDOM%65536)) > /dev/null 2>&1
 
 		now=$(date +%s)
 	done
@@ -277,6 +277,7 @@ check_taint()
 insert_flood()
 {
 	local n="$1"
+	local timeout="$2"
 	local r=0
 
 	r=$((RANDOM%$insert_count))
@@ -302,7 +303,7 @@ test_floodresize_all()
 	read tainted_then < /proc/sys/kernel/tainted
 
 	for n in "$nsclient1" "$nsclient2";do
-		insert_flood "$n" &
+		insert_flood "$n" "$timeout" &
 	done
 
 	# resize table constantly while flood/insert/dump/flushs
diff --git a/tools/testing/selftests/net/netfilter/udpclash.c b/tools/testing/selftests/net/netfilter/udpclash.c
index 85c7b906ad08..0a3b8890b530 100644
--- a/tools/testing/selftests/net/netfilter/udpclash.c
+++ b/tools/testing/selftests/net/netfilter/udpclash.c
@@ -14,6 +14,7 @@
  *  ed07d9a021df ("netfilter: nf_conntrack: resolve clash for matching conntracks")
  *  6a757c07e51f ("netfilter: conntrack: allow insertion of clashing entries")
  */
+#include <stdatomic.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -29,7 +30,7 @@ struct thread_args {
 	int sockfd;
 };
 
-static int wait = 1;
+static atomic_int wait = ATOMIC_VAR_INIT(1);
 
 static void *thread_main(void *varg)
 {
-- 
2.49.1

