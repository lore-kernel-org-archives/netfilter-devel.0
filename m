Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A1915C0
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Aug 2025 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755986654; cv=none; b=Qwl009ase1woOk2k+KyqEV9O/oZDYtDvdEaPUDg80HDgRppgZR13JO8QJJgND7bEMIkTdU8qsk+C6HYD+LGV5k7TWDXltLzxT/U8anH0k5VmWGx1gUy6LZLqdGRfJfgVkMdF2pxOdW5T9lPLejf/hAZJnMIfQs1+M+efBmqVOp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755986654; c=relaxed/simple;
	bh=KeosvGF18b1LKMDrBe6cx9UOl6Cz1OJc00c0kvVS8Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVWsV9PBXNH/gDuk+EcRdn8+qUesbhIKPo+cXk53FkC7sGDxIGuLar2uwrcDK6mD60DUCQIKbp3M6JDYy2XCRLB5nwZuMFpjiwKv/oz7IrnxuLbI04a4cGgBzBYDLFAGdm6cONpNOK5KyOze7wg85tXvBSS1Eo7VfKzOvmoaA3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bGi6s15y; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bGi6s15y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mfVlkXQqlOtxGEwNmeJ8+MwPUw09yfTKQc43ZqDyN+A=; b=bGi6s15yiIX6+K5vdTWT8S9e7Q
	bhpu/RMBTM+kTTqeiRIsUEne53t7u+BweARb+kzn7VtAcbaUN27Q2ZrjzNDtg3fA5diYWBf5LIk3s
	JKwqEBoHaBfyWM6pBxMXYSiXLUSs1UieB1hU0bnSp5Zlx5PA/b0gGr6iYlZ48gELa1G33Rieu23BG
	p7PkQflKtYCnMuzWnJOnCrTZnQ8HmWqhKbSfO7eY5upbYQlMxZyTmgjSMu5X1/fWdhni7dxJYk7Oe
	bdWH2G2+eThjuDLDGjU4mpIFI48db7YYcREyCOoDMpjOpZk4Y443AMhcxuRgORmUtSp9PSGk3db2R
	ocUv29vw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1upwLC-000000006bi-3P2J;
	Sun, 24 Aug 2025 00:04:02 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH] tests: monitor: Fix for flag arrays in JSON output
Date: Sun, 24 Aug 2025 00:03:57 +0200
Message-ID: <20250823220357.18949-1-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missed to adjust the expected JSON output in this test suite, too.

Fixes: 5e492307c2c93 ("json: Do not reduce single-item arrays on output")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/monitor/testcases/map-expr.t            | 2 +-
 tests/monitor/testcases/set-concat-interval.t | 2 +-
 tests/monitor/testcases/set-interval.t        | 2 +-
 tests/monitor/testcases/set-maps.t            | 2 +-
 tests/monitor/testcases/set-mixed.t           | 2 +-
 tests/monitor/testcases/set-multiple.t        | 4 ++--
 tests/monitor/testcases/set-simple.t          | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tests/monitor/testcases/map-expr.t b/tests/monitor/testcases/map-expr.t
index 904200418745e..d11ad0ebc0d57 100644
--- a/tests/monitor/testcases/map-expr.t
+++ b/tests/monitor/testcases/map-expr.t
@@ -3,4 +3,4 @@ I add table ip t
 I add map ip t m { typeof meta day . meta hour : verdict; flags interval; counter; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": {"typeof": {"concat": [{"meta": {"key": "day"}}, {"meta": {"key": "hour"}}]}}, "handle": 0, "map": "verdict", "flags": "interval", "stmt": [{"counter": null}]}}}
+J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": {"typeof": {"concat": [{"meta": {"key": "day"}}, {"meta": {"key": "hour"}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"], "stmt": [{"counter": null}]}}}
diff --git a/tests/monitor/testcases/set-concat-interval.t b/tests/monitor/testcases/set-concat-interval.t
index a42682f503246..3542b8225ebd1 100644
--- a/tests/monitor/testcases/set-concat-interval.t
+++ b/tests/monitor/testcases/set-concat-interval.t
@@ -10,6 +10,6 @@ I add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; elem
 O add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; }
 O add element ip t s { 20-80 . 0x14 : accept }
 O add element ip t s { 1-10 . 0xa : drop }
-J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": {"typeof": {"concat": [{"payload": {"protocol": "udp", "field": "length"}}, {"payload": {"base": "ih", "offset": 32, "len": 32}}]}}, "handle": 0, "map": "verdict", "flags": "interval"}}}
+J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": {"typeof": {"concat": [{"payload": {"protocol": "udp", "field": "length"}}, {"payload": {"base": "ih", "offset": 32, "len": 32}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"]}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [20, 80]}, 20]}, {"accept": null}]]}}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [1, 10]}, 10]}, {"drop": null}]]}}}}
diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
index 84cf98c214671..5053c596b3b1b 100644
--- a/tests/monitor/testcases/set-interval.t
+++ b/tests/monitor/testcases/set-interval.t
@@ -10,7 +10,7 @@ I add set ip t s { type inet_service; flags interval; elements = { 20, 30-40 };
 O add set ip t s { type inet_service; flags interval; }
 O add element ip t s { 20 }
 O add element ip t s { 30-40 }
-J {"add": {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
+J {"add": {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [20]}}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [{"range": [30, 40]}]}}}}
 
diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
index aaf332f3caf98..acda480d86dbb 100644
--- a/tests/monitor/testcases/set-maps.t
+++ b/tests/monitor/testcases/set-maps.t
@@ -3,7 +3,7 @@ I add table ip t
 I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"map": {"family": "ip", "name": "portip", "table": "t", "type": "inet_service", "handle": 0, "map": "ipv4_addr", "flags": "interval"}}}
+J {"add": {"map": {"family": "ip", "name": "portip", "table": "t", "type": "inet_service", "handle": 0, "map": "ipv4_addr", "flags": ["interval"]}}}
 
 I add element ip t portip { 80-100: 10.0.0.1 }
 O -
diff --git a/tests/monitor/testcases/set-mixed.t b/tests/monitor/testcases/set-mixed.t
index 1cf3d38e34a7b..08c20116de92f 100644
--- a/tests/monitor/testcases/set-mixed.t
+++ b/tests/monitor/testcases/set-mixed.t
@@ -4,7 +4,7 @@ I add set ip t portrange { type inet_service; flags interval; }
 I add set ip t ports { type inet_service; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
 J {"add": {"set": {"family": "ip", "name": "ports", "table": "t", "type": "inet_service", "handle": 0}}}
 
 # make sure concurrent adds work
diff --git a/tests/monitor/testcases/set-multiple.t b/tests/monitor/testcases/set-multiple.t
index 84de98e94d139..bd7a6246a46b4 100644
--- a/tests/monitor/testcases/set-multiple.t
+++ b/tests/monitor/testcases/set-multiple.t
@@ -4,8 +4,8 @@ I add set ip t portrange { type inet_service; flags interval; }
 I add set ip t portrange2 { type inet_service; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
-J {"add": {"set": {"family": "ip", "name": "portrange2", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"set": {"family": "ip", "name": "portrange2", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
 
 # make sure concurrent adds work
 I add element ip t portrange { 1024-65535 }
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
index 4bef144875876..6853a0ebbb0cb 100644
--- a/tests/monitor/testcases/set-simple.t
+++ b/tests/monitor/testcases/set-simple.t
@@ -3,7 +3,7 @@ I add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
 
 # adding some ranges
 I add element ip t portrange { 1-10 }
-- 
2.51.0

