Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2E62C87A
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Sep 2024 16:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725899336; cv=none; b=GrvRtQ3EaHV+oLiZQG2kUmL9BZRhL4EjW8DJSF/f0Sobt3GvRggzJFOojTtvoK8nEPRP/e/QFwwZyXCKkyI/15NphINpJbBHq+z7QqJWbFKKrgqbXg0S5dXUYugLEYA52x7xnOJBKPjFJ7LwBaFean57QRc4jcRVK3Jt92AqsFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725899336; c=relaxed/simple;
	bh=Qon+KDwZzs8RBua7g2XJuqiIRvgfnW1ZDfymHnLASsY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hF/Do7hc6G12MyurwK3X4eWehgie/8nZsOtI9OZYEUnE+6DJjTjj79RYmmaCTspmTPykAeJiUfqwVyqjxrkghPEmm9DtOE0kFz6j1DTbbxYP94/wi3s/FqhqOMhxG2DLE+cjZCO6k/lNAXLicKsHa0eAaJ6bgpK+W8lLHVAwcIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1snhG0-0000Ak-PH; Mon, 09 Sep 2024 18:28:52 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: extend vmap test with updates
Date: Mon,  9 Sep 2024 18:15:17 +0200
Message-ID: <20240909161520.4282-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It won't validate that the update is actually effective,
but it will trigger relevant update logic in kernel.

This means the updated test works even if the kernel doesn't
support updates.

A dedicated test will be added to check timeout updates work
as expected.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/maps/vmap_timeout | 48 +++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/tests/shell/testcases/maps/vmap_timeout b/tests/shell/testcases/maps/vmap_timeout
index 0cd965f76d0e..3f0563afacac 100755
--- a/tests/shell/testcases/maps/vmap_timeout
+++ b/tests/shell/testcases/maps/vmap_timeout
@@ -11,18 +11,52 @@ port=23
 for i in $(seq 1 100) ; do
 	timeout=$((RANDOM%5))
 	timeout=$((timeout+1))
+	expire=$((RANDOM%timeout))
 	j=1
 
 	batched="{ $port timeout 3s : jump other_input "
-	batched_addr="{ 10.0.$((i%256)).$j . $port timeout ${timeout}s : jump other_input "
+	ubatched="$batched"
+
+	timeout_str="timeout ${timeout}s"
+	expire_str=""
+	if [ "$expire" -gt 0 ]; then
+		expire_str="expires ${expire}s"
+	fi
+
+	batched_addr="{ 10.0.$((i%256)).$j . $port ${timeout_str} ${expire_str} : jump other_input "
+	ubatched_addr="$batched_addr"
+
 	port=$((port + 1))
 	for j in $(seq 2 400); do
 		timeout=$((RANDOM%5))
 		timeout=$((timeout+1))
+		expire=$((RANDOM%timeout))
+		utimeout=$((RANDOM%5))
+		utimeout=$((timeout+1))
+
+		timeout_str="timeout ${timeout}s"
+		expire_str=""
+		if [ "$expire" -gt 0 ]; then
+			expire_str="expires ${expire}s"
+		fi
 
-		batched="$batched, $port timeout ${timeout}s : jump other_input "
-		batched_addr="$batched_addr, 10.0.$((i%256)).$((j%256)) . $port timeout ${timeout}s : jump other_input "
+		batched="$batched, $port ${timeout_str} ${expire_str} : jump other_input "
+		batched_addr="$batched_addr, 10.0.$((i%256)).$((j%256)) . $port ${timeout_str} ${expire_str} : jump other_input "
 		port=$((port + 1))
+
+		timeout_str="timeout ${utimeout}s"
+		expire=$((RANDOM%utimeout))
+
+		expire_str=""
+		if [ "$expires" -gt 0 ]; then
+			expire_str="expires ${expire}s"
+		fi
+
+		update=$((RANDOM%2))
+		if [ "$update" -ne 0 ]; then
+			ubatched="$batched, $port ${timeout_str} ${expire_str} : jump other_input "
+			ubatched_addr="$batched_addr, 10.0.$((i%256)).$((j%256)) . $port ${timeout_str} ${expire_str} : jump other_input "
+		fi
 	done
 
 	fail_addr="$batched_addr, 1.2.3.4 . 23 timeout 5m : jump other_input,
@@ -40,6 +74,14 @@ for i in $(seq 1 100) ; do
 
 	$NFT add element inet filter portmap "$batched"
 	$NFT add element inet filter portaddrmap "$batched_addr"
+
+	update=$((RANDOM%2))
+	if [ "$update" -ne 0 ]; then
+		ubatched="$ubatched }"
+		ubatched_addr="$ubatched_addr }"
+		$NFT add element inet filter portmap "$ubatched"
+		$NFT add element inet filter portaddrmap "$ubatched_addr"
+	fi
 done
 
 if [ "$NFT_TEST_HAVE_catchall_element" = n ] ; then
-- 
2.44.2

