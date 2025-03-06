Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9D520297E
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741267756; cv=none; b=QK/defkxY3z5r8CscKpWJOhZ5/JILmG2roGBH2wQgw7f1UOe5T7NAkNps0IeqqZxU8Cuc0SDVLJoA3o2Ik7JixZn6ENmD2SMWQ4M4UcZlAwiCGQ+RSwq5MxC9JjzK3+q8ONQGoGhYdR6h12122T2mL1KU3eWsI7yadOhcPy1a/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741267756; c=relaxed/simple;
	bh=2X8fUXCSWonBFDgFY+4nH5jnOR4gu1o9SwuuWOqmocw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJTFhGlSbQdwLUKdEMxg3fym+yGKDSwXgMzTI8aufy9Y7UmvbFdgLjaQcovA8fPO1jmv1wgPHDu9baNsxb0CnYUuj9kDA29pueVvUP16ny7QTQjOMZH7fTCf8WOzVKQ9vLlB19C0dxwx/JdoyrJC7ggY57gRoqGEXwam13Y7LY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1tqBHk-00045V-1b; Thu, 06 Mar 2025 14:29:12 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/2] tests: extend reset test case to cover rbtree set type
Date: Thu,  6 Mar 2025 14:23:31 +0100
Message-ID: <20250306132336.17675-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.3
In-Reply-To: <20250306132336.17675-1-fw@strlen.de>
References: <20250306132336.17675-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make sure segtree processing doesn't drop associated stateful elements.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/sets/reset_command_0 | 47 +++++++++++++++++-----
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/tests/shell/testcases/sets/reset_command_0 b/tests/shell/testcases/sets/reset_command_0
index d38ddb3ffeeb..f3c1102b4b41 100755
--- a/tests/shell/testcases/sets/reset_command_0
+++ b/tests/shell/testcases/sets/reset_command_0
@@ -17,6 +17,19 @@ RULESET="table t {
 			2.0.0.2 . tcp . 22 counter packets 10 bytes 100 timeout 15m expires 10m
 		}
 	}
+
+	set s2 {
+		type ipv4_addr
+		flags interval, timeout
+		counter
+		timeout 30m
+		elements = {
+			1.0.0.1 counter packets 5 bytes 30 expires 20m,
+			1.0.1.1-1.0.1.10 counter packets 5 bytes 30 expires 20m,
+			2.0.0.2 counter packets 10 bytes 100 timeout 15m expires 10m
+		}
+	}
+
 	map m {
 		type ipv4_addr : ipv4_addr
 		quota 50 bytes
@@ -38,17 +51,31 @@ expires_minutes() {
 	sed -n 's/.*expires \([0-9]*\)m.*/\1/p'
 }
 
-echo -n "get set elem matches reset set elem: "
-elem='element t s { 1.0.0.1 . udp . 53 }'
-[[ $($NFT "get $elem ; reset $elem" | \
-	grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
-echo OK
+get_and_reset()
+{
+	local setname="$1"
+	local key="$2"
 
-echo -n "counters are reset, expiry left alone: "
-NEW=$($NFT "get $elem")
-grep -q 'counter packets 0 bytes 0' <<< "$NEW"
-[[ $(expires_minutes <<< "$NEW") -lt 20 ]]
-echo OK
+	echo -n "get set elem matches reset set elem in set $setname: "
+
+	elem="element t $setname { $key }"
+	echo $NFT get $elem
+	$NFT get $elem
+	[[ $($NFT "get $elem ; reset $elem" | \
+		grep 'elements = ' | drop_seconds | uniq | wc -l) == 1 ]]
+	echo OK
+
+	echo -n "counters are reset, expiry left alone in set $setname: "
+	NEW=$($NFT "get $elem")
+	echo NEW $NEW
+	grep -q 'counter packets 0 bytes 0' <<< "$NEW"
+	[[ $(expires_minutes <<< "$NEW") -lt 20 ]]
+	echo OK
+}
+
+get_and_reset "s" "1.0.0.1 . udp . 53"
+get_and_reset "s2" "1.0.0.1"
+get_and_reset "s2" "1.0.1.1-1.0.1.10"
 
 echo -n "get map elem matches reset map elem: "
 elem='element t m { 1.2.3.4 }'
-- 
2.45.3

