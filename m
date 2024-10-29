Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3EA2076B1
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Oct 2024 20:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730232882; cv=none; b=teb3MQpDCLQHt3Nu1ubtczzdpYwZaz6Jf3u2QDCLVEc44iPA8loM52N3aFzp4BMBr8wVoiaaXvoWkxejcnbZxEblus6hcexJwoLyIPDLyV3dfW/Eygiwk4kOJ7Ii1yqingGRVgyDMR9JAUfPhz4pY6huRTgy9JlZwYO5/hRW54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730232882; c=relaxed/simple;
	bh=/ZZ8G/lGMJe/j6YyeRXHjRfGx1Pcn5CYAOPayUDLuYc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RH1ZNRR7CE6IxgIudI+8L80FLUC0pv2SuB/0CnaQAHhE4DbG0zVLdl+7jy4HEC1u9xIqtwh+wT4mfXZCNIJVB54lLEczmmoZBCwpjkeI9Mmj21c9AIX01npbeR+tVdVH45fD9iZSzEoWLb37mBi6nVACbJyU5t5PKTBgAaKekcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1t5sbt-0002mI-Q3; Tue, 29 Oct 2024 21:14:37 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: monitor: fix up test case breakage
Date: Tue, 29 Oct 2024 21:12:19 +0100
Message-ID: <20241029201221.17865-1-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Monitor test fails:

echo: running tests from file set-simple.t
echo output differs!
--- /tmp/tmp.FGtiyL99bB/tmp.2QxLSjzQqk  2024-10-29 20:54:41.308293201 +0100
+++ /tmp/tmp.FGtiyL99bB/tmp.A5rp0Z0dBJ  2024-10-29 20:54:41.317293201 +0100
@@ -1,2 +1,3 @@
-add element ip t portrange { 1024-65535 }
 add element ip t portrange { 100-200 }
+add element ip t portrange { 1024-65535 }
+# new generation 510 by process 129009 (nft)

I also noticed -j mode did not work correctly, add missing json annotations
in set-concat-interval.t while at it.

Fixes: 20f1c60ac8c8 ("src: collapse set element commands from parser")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/monitor/testcases/set-concat-interval.t | 3 +++
 tests/monitor/testcases/set-simple.t          | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tests/monitor/testcases/set-concat-interval.t b/tests/monitor/testcases/set-concat-interval.t
index 763dc319f0d1..75f38280bf82 100644
--- a/tests/monitor/testcases/set-concat-interval.t
+++ b/tests/monitor/testcases/set-concat-interval.t
@@ -10,3 +10,6 @@ I add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; elem
 O add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; }
 O add element ip t s { 20-80 . 0x14 : accept }
 O add element ip t s { 1-10 . 0xa : drop }
+J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": ["integer", "integer"], "handle": 0, "map": "verdict", "flags": ["interval"]}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [20, 80]}, 20]}, {"accept": null}]]}}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [1, 10]}, 10]}, {"drop": null}]]}}}}
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
index 8ca4f32463fd..6853a0ebbb0c 100644
--- a/tests/monitor/testcases/set-simple.t
+++ b/tests/monitor/testcases/set-simple.t
@@ -37,9 +37,10 @@ J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem"
 # make sure half open before other element works
 I add element ip t portrange { 1024-65535 }
 I add element ip t portrange { 100-200 }
-O -
-J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
+O add element ip t portrange { 100-200 }
+O add element ip t portrange { 1024-65535 }
 J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [100, 200]}]}}}}
+J {"add": {"element": {"family": "ip", "table": "t", "name": "portrange", "elem": {"set": [{"range": [1024, 65535]}]}}}}
 
 # make sure deletion of elements works
 I delete element ip t portrange { 0-10 }
-- 
2.45.2

