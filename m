Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900253;
	b=tBA5evKXFbT4/GQb8oTq0h0Hn8imqltdcf3LqvhnMVOuLG+OsP1utBgo/qQSWd+UM18A
	 1Z/hTqU1tJqRyuOUe4Ky+fYCV5QWPLYzCbSHilqy/XmxeVp7AdGJiP/mpSunQm0Nw7ooB
	 LQv5ejNjik6a8NEsDMl+ZZIIsG0UNleNL2pWsAQmCmihWfNNjEZgDvvP/pIu5rVttE/3s
	 7G9+XCEBI18fT8+v98V3eYLl7Y1eUSHwAaqAVYpvEKRqQa42D++70AOL/+r/gP8udm4G6
	 b9hEOQdpoBSKNI8F/ElAIWaqqkzxy9MkS6Av3Y0QGA3bhW2PuurIZAm/n6xEyWAa6oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900253;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D9HIzTJ9L5iA1FCKiDtXzdiRaq67YfDj0/V/IbP5emg=;
	b=URd2HOi+oZ3lH6LynIuiHjj/UcqfnVhe7jy91JAaYrkryoVHf9korLoZBZZ4RxTAhx6p
	 MMq35ZE1V2K3qdf+yGVHoANs4j+mBP0VF9QLOQvyIRlt7BfxpYdZoCdwrVkwEI4UI3NjQ
	 TGz+zjUbn2lnwGJRmQXyE/7qrCVpeTgW98+W9nm3Dt2USvt9OdH4HOYuShF2oLMAMTeu2
	 xfIRw61ZCcDVTHkAyy6N/B7JqcIDhUS0LA2KYZW78H0D4QaLJNSThBggLJewbjWE/VCoi
	 sz5skzAi3R4HmsPd9Y+FJUtnFwJoetI97csf2hGFKRfAEkkyRMA1XXMF11PtohAMptg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD10606A33F
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 17:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3BD10606A33F
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=D9HIzTJ9L5iA1FCKiDtXzdiRaq67YfDj0/V/IbP5emg=; b=PhvRN0yX21BC1xDgy97gL2fJA1
	tVBJOQGYbavP+NF5acro8XaHJPUdBH1/NLN4sMXgFasLoYIJA5gjDSDPyPsgn1cmnjIHDzgPzuHGC
	WWm7gkhV5+vP6RRRJ9eXfkyeZfzjH37rEfHmGMxjk+CPx7SfnTNxIigNxy+fperOhU1pSjktQW4fV
	6MpN2Kh72dyZlrie0O6fGcVdsWfSfzGKy8aulQsb01Dij1KW2RmZmq/b4WjS1DwjxXtU5tg9w+kt5
	2suLRKMM4ASP+FshdpKEwdzJ1RvHnRUJRsMWcyOuBYbJdUCGzU8L+fh6qbggLN9z3F/B67l2wKHqK
	5dLap3Fw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=tia)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xP1Op-000000005lj-3WjP;
	Thu, 05 Nov 2026 18:37:19 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>,
	xelra <xelra@protonmail.com>
Subject: [nft PATCH 2/3] scanner: Fix delayed start condition pop logic
Date: Thu,  5 Nov 2026 18:37:12 +0100
Message-ID: <20261105173713.72238-3-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105173713.72238-1-phil@nwl.cc>
References: <20261105173713.72238-1-phil@nwl.cc>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If scanner_pop_start_cond() is called and the passed start condition is
currently active, it is supposed to pop it and all delayed states
identified by a zero field value in state->startcond_active. The counter
state->flex_state_pop reflects the number of delayed start conditions
waiting to be popped.

The implementation mixed up popping of the currently active state with
delayed ones though and therefore decremented flex_state_pop for the
currently active (i.e., not delayed) state as well. As a consequence,
the first delayed state remained active after the function returned,
causing problems in corner-cases.

Reported-by: xelra <xelra@protonmail.com>
Fixes: 8623772af0610 ("scanner: don't pop active flex scanner scope")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/scanner.l                                 | 11 +++---
 .../dumps/exclusive_start_cond.json-nft       | 34 +++++++++++++++++++
 .../parsing/dumps/exclusive_start_cond.nft    |  1 +
 .../testcases/parsing/exclusive_start_cond    |  3 ++
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/src/scanner.l b/src/scanner.l
index b35dddd94eb4a..aa83d8590f5e1 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -1404,17 +1404,14 @@ void scanner_pop_start_cond(void *scanner, enum startcond_type t)
 		return; /* Can't pop just yet! */
 	}
 
-	while (state->flex_state_pop) {
+	t = state->startcond_type = yy_top_state(scanner);
+	yy_pop_state(scanner);
+
+	while (state->flex_state_pop && !state->startcond_active[t]) {
 		state->flex_state_pop--;
 		state->startcond_type = yy_top_state(scanner);
 		yy_pop_state(scanner);
 
 		t = state->startcond_type;
-		if (state->startcond_active[t])
-			return;
 	}
-
-	state->startcond_type = yy_top_state(scanner);
-
-	yy_pop_state(scanner);
 }
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
index 1de5007c6fc9d..092a5278cf708 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.json-nft
@@ -2021,6 +2021,40 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "comment": "x",
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "l4proto"
+                }
+              },
+              "right": 6
+            }
+          },
+          {
+            "limit": {
+              "rate": 1,
+              "burst": 5,
+              "per": "second"
+            }
+          },
+          {
+            "reject": {
+              "type": "tcp reset"
+            }
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
index 1b9b369e67640..a1a6e44faf6ed 100644
--- a/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
+++ b/tests/shell/testcases/parsing/dumps/exclusive_start_cond.nft
@@ -84,6 +84,7 @@ table ip t {
 		limit rate 1/second burst 5 packets osf name "foo"
 		limit rate 1/second burst 5 packets ipsec in spi 0
 		limit rate 1/second burst 5 packets comment "foobar"
+		meta l4proto 6 limit rate 1/second burst 5 packets reject with tcp reset comment "x"
 		meta l4proto 6 limit rate 1/second burst 5 packets tproxy to 0.0.0.1
 		meta l4proto 17 limit rate 1/second burst 5 packets vxlan vni 0
 		meta l4proto 17 limit rate 1/second burst 5 packets geneve vni 0
diff --git a/tests/shell/testcases/parsing/exclusive_start_cond b/tests/shell/testcases/parsing/exclusive_start_cond
index 1fce6826f7cca..b4b34b23d428e 100755
--- a/tests/shell/testcases/parsing/exclusive_start_cond
+++ b/tests/shell/testcases/parsing/exclusive_start_cond
@@ -98,6 +98,9 @@ stmts+=("ipsec in spi 0")
 # comment_spec
 stmts+=("comment foobar")
 
+# this revealed a bug in scanner_pop_start_cond() code
+stmts+=("reject with tcp reset comment x")
+
 $NFT -f - <<EOF
 table t {
 	flowtable ft {
-- 
2.54.0

