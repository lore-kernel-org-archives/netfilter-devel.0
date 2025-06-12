Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E114223DF6
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Jun 2025 11:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749729155; cv=none; b=ms95/5+f0Kw0q6nFIUeh3p5IKh2La75wvhAQUhaFAftOQUyUuzb/Y0TYuxQwQbQuUGod3Jfunhq7Nuj7Pen756h2q2JZx2ONWGXXeu6CvuDdopoUxgrbOAT3iFrVFBp9qd72QI3z+wuurt+Be4uWyjtXbrN+lQZy3tN9nh0W+Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749729155; c=relaxed/simple;
	bh=QNwE+CTyXyQAxfhYB/MX6i+dmcgNxuH+vv70zPeeW9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe+jfh/7tMLoD46D11fgns0i1O1b9KfdTiAOglbHEBV0anI230uQmmsyRWuYBg6JM6ekycHLv70cOG02LlYv4iOiuG9ZyjINjDjzS2cLXDfwcRJyyB0w2kwLOfal8iVvd31YCN14vvfnrgKXEd21SUDQbJiV4YJeVK0GR+/6e6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=WAsxIMRH; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="WAsxIMRH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mI6+xxfK1gcXKZaZ7doQsVwTOn4r7FVFvD7U6OdXGEY=; b=WAsxIMRHFttYmIac4EcoeZWy+0
	0D5z8vtBKzotTPtXy0IktozItx+NzhUD4FbsVBsFMmS72Qm/0xJOVv5n+ycWazlGY5wSN5Dxvso8S
	N30hE7eDVhtZpN5pULjH6O1q8TzkGOBIDeX/ElGS2R2pmdhps3zOcQcV8or1RNQL5gYTauYB6gxGY
	cOrSYOMSVNmc2NMAgGHA6xl519ORr5SR41rGU9dlsKaInqVBXJGfuzYgvVNgyj8vLJktAXj4ZHHQR
	qDpB6TUlbtdpeBdpzMvi0y+4tHoXIvXmeAJ1HwJeInaTJZRPIBdpoZOf6VTwY5yRNelLm55D2mFaT
	LDcND6Xg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uPgTt-000000006Fv-0ozt;
	Thu, 12 Jun 2025 13:52:29 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 5/7] tests: monitor: Fix for single flag array avoidance
Date: Thu, 12 Jun 2025 13:52:16 +0200
Message-ID: <20250612115218.4066-6-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250612115218.4066-1-phil@nwl.cc>
References: <20250612115218.4066-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Missed to update the JSON monitor expected output.

Fixes: 6bedb12af1658 ("json: Print single set flag as non-array")
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
index d11ad0ebc0d57..904200418745e 100644
--- a/tests/monitor/testcases/map-expr.t
+++ b/tests/monitor/testcases/map-expr.t
@@ -3,4 +3,4 @@ I add table ip t
 I add map ip t m { typeof meta day . meta hour : verdict; flags interval; counter; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": {"typeof": {"concat": [{"meta": {"key": "day"}}, {"meta": {"key": "hour"}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"], "stmt": [{"counter": null}]}}}
+J {"add": {"map": {"family": "ip", "name": "m", "table": "t", "type": {"typeof": {"concat": [{"meta": {"key": "day"}}, {"meta": {"key": "hour"}}]}}, "handle": 0, "map": "verdict", "flags": "interval", "stmt": [{"counter": null}]}}}
diff --git a/tests/monitor/testcases/set-concat-interval.t b/tests/monitor/testcases/set-concat-interval.t
index 3542b8225ebd1..a42682f503246 100644
--- a/tests/monitor/testcases/set-concat-interval.t
+++ b/tests/monitor/testcases/set-concat-interval.t
@@ -10,6 +10,6 @@ I add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; elem
 O add map ip t s { typeof udp length . @ih,32,32 : verdict; flags interval; }
 O add element ip t s { 20-80 . 0x14 : accept }
 O add element ip t s { 1-10 . 0xa : drop }
-J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": {"typeof": {"concat": [{"payload": {"protocol": "udp", "field": "length"}}, {"payload": {"base": "ih", "offset": 32, "len": 32}}]}}, "handle": 0, "map": "verdict", "flags": ["interval"]}}}
+J {"add": {"map": {"family": "ip", "name": "s", "table": "t", "type": {"typeof": {"concat": [{"payload": {"protocol": "udp", "field": "length"}}, {"payload": {"base": "ih", "offset": 32, "len": 32}}]}}, "handle": 0, "map": "verdict", "flags": "interval"}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [20, 80]}, 20]}, {"accept": null}]]}}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [[{"concat": [{"range": [1, 10]}, 10]}, {"drop": null}]]}}}}
diff --git a/tests/monitor/testcases/set-interval.t b/tests/monitor/testcases/set-interval.t
index 5053c596b3b1b..84cf98c214671 100644
--- a/tests/monitor/testcases/set-interval.t
+++ b/tests/monitor/testcases/set-interval.t
@@ -10,7 +10,7 @@ I add set ip t s { type inet_service; flags interval; elements = { 20, 30-40 };
 O add set ip t s { type inet_service; flags interval; }
 O add element ip t s { 20 }
 O add element ip t s { 30-40 }
-J {"add": {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"set": {"family": "ip", "name": "s", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [20]}}}}
 J {"add": {"element": {"family": "ip", "table": "t", "name": "s", "elem": {"set": [{"range": [30, 40]}]}}}}
 
diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
index acda480d86dbb..aaf332f3caf98 100644
--- a/tests/monitor/testcases/set-maps.t
+++ b/tests/monitor/testcases/set-maps.t
@@ -3,7 +3,7 @@ I add table ip t
 I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"map": {"family": "ip", "name": "portip", "table": "t", "type": "inet_service", "handle": 0, "map": "ipv4_addr", "flags": ["interval"]}}}
+J {"add": {"map": {"family": "ip", "name": "portip", "table": "t", "type": "inet_service", "handle": 0, "map": "ipv4_addr", "flags": "interval"}}}
 
 I add element ip t portip { 80-100: 10.0.0.1 }
 O -
diff --git a/tests/monitor/testcases/set-mixed.t b/tests/monitor/testcases/set-mixed.t
index 08c20116de92f..1cf3d38e34a7b 100644
--- a/tests/monitor/testcases/set-mixed.t
+++ b/tests/monitor/testcases/set-mixed.t
@@ -4,7 +4,7 @@ I add set ip t portrange { type inet_service; flags interval; }
 I add set ip t ports { type inet_service; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
 J {"add": {"set": {"family": "ip", "name": "ports", "table": "t", "type": "inet_service", "handle": 0}}}
 
 # make sure concurrent adds work
diff --git a/tests/monitor/testcases/set-multiple.t b/tests/monitor/testcases/set-multiple.t
index bd7a6246a46b4..84de98e94d139 100644
--- a/tests/monitor/testcases/set-multiple.t
+++ b/tests/monitor/testcases/set-multiple.t
@@ -4,8 +4,8 @@ I add set ip t portrange { type inet_service; flags interval; }
 I add set ip t portrange2 { type inet_service; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
-J {"add": {"set": {"family": "ip", "name": "portrange2", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
+J {"add": {"set": {"family": "ip", "name": "portrange2", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
 
 # make sure concurrent adds work
 I add element ip t portrange { 1024-65535 }
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
index 6853a0ebbb0cb..4bef144875876 100644
--- a/tests/monitor/testcases/set-simple.t
+++ b/tests/monitor/testcases/set-simple.t
@@ -3,7 +3,7 @@ I add table ip t
 I add set ip t portrange { type inet_service; flags interval; }
 O -
 J {"add": {"table": {"family": "ip", "name": "t", "handle": 0}}}
-J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": ["interval"]}}}
+J {"add": {"set": {"family": "ip", "name": "portrange", "table": "t", "type": "inet_service", "handle": 0, "flags": "interval"}}}
 
 # adding some ranges
 I add element ip t portrange { 1-10 }
-- 
2.49.0

