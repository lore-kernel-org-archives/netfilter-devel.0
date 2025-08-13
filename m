Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DBE23D7E4
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 17:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755104760; cv=none; b=BY6GzMs8MVmyMuShk/If/5RX5sx1O0IMm3/LcCWcT6toR8Sb6v9OL4EDOu6SNMdEHj6RpOGrKhrMblCYvhnHsQxjyejoQPUIaah2GuLIzQaBS8no5nvdQ45/mybUgmwOAdMG7Uxe8GH3S0sqcH4jy1h4SzYgZ6uIMqDk8pEoMuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755104760; c=relaxed/simple;
	bh=4jDACsZoANmdsCZ0pVEVGfWuPyxMooE0fBVA+65pjYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPezJSQ9ycQmGuEW16O0R0pme5uRf+XBJ0KbCIrK9BluXEHM0GdjdDydn9FWCdBAZpNHykNQ1imsVeISOKveCB1HjpNwrQTh5nDH/R3k94HBSQViqdp3+BtMQ5qrSJiE79ptDnVkXX9kNYSymjNVTQCt8KCH9N7UghVvKDzVbBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KyFnA13M; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KyFnA13M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6Atx6889DpZjavOpGjB7CfP5Zq06JHePyuIEdub5OXY=; b=KyFnA13Mu9Fkkfr5BtMknSbUeZ
	g0fOXXZqqydXs/IjxRWcVUJCLIDAzJQL4leDHOHicqzjis7HEU2VkygHHMS2lBihR8zEu6pc5trMP
	BTer7ZdOztv58gd24N4uk8NPDa/xOrXhaoQhq7n30Law0Z2Zw+w8aB2aEOuX1Ysyb+z/Er6BkZyM7
	2MB0V9kD02ezFiazgXOTQgwBYmTaYKlNDXXU9Uz6iruAXSvW8XHyTz1Blzxw5dAbsFVa0p96HTObG
	hSYsiyHqjnVmFFxtwdnYRz8if4hEhSPXI+gIvxIO6W3g8PERMt6zTLiCiQrQlCgzuZH0b4jwhWqq5
	8Mmrb1iQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1umEvE-000000003na-200x;
	Wed, 13 Aug 2025 19:05:56 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 02/14] tests: py: Drop stale entries since redundant test case removal
Date: Wed, 13 Aug 2025 19:05:37 +0200
Message-ID: <20250813170549.27880-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250813170549.27880-1-phil@nwl.cc>
References: <20250813170549.27880-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed commit left stale JSON equivalents and payload records in place,
drop them.

Fixes: ec1ea13314fa5 ("tests: remove redundant test cases")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/any/meta.t.json        |  38 ----------
 tests/py/ip6/dst.t.json         |  23 ------
 tests/py/ip6/dst.t.payload.inet |  10 ---
 tests/py/ip6/dst.t.payload.ip6  |   8 ---
 tests/py/ip6/frag.t.json        | 121 --------------------------------
 tests/py/ip6/ip6.t.json         |  40 -----------
 6 files changed, 240 deletions(-)

diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 8dcd1e13243de..85406efc4d773 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2294,44 +2294,6 @@
     }
 ]
 
-# meta cgroup {1048577-1048578}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "cgroup" }
-            },
-            "op": "==",
-            "right": {
-                "set": [
-                    {
-                        "range": [ 1048577, 1048578 ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
-# meta cgroup != { 1048577-1048578}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "cgroup" }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    {
-                        "range": [ 1048577, 1048578 ]
-                    }
-                ]
-            }
-        }
-    }
-]
-
 # meta iif . meta oif { "lo" . "lo" }
 [
     {
diff --git a/tests/py/ip6/dst.t.json b/tests/py/ip6/dst.t.json
index e947a76f4f4a9..7ba4572c50bbe 100644
--- a/tests/py/ip6/dst.t.json
+++ b/tests/py/ip6/dst.t.json
@@ -290,26 +290,3 @@
         }
     }
 ]
-
-# dst hdrlength != { 33, 55, 67, 88}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "hdrlength",
-                    "name": "dst"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    33,
-                    55,
-                    67,
-                    88
-                ]
-            }
-        }
-    }
-]
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 476fdbcd73630..eb7a87d577a31 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -117,13 +117,3 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-
-# dst hdrlength != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
-ip6 test-ip6 input
-  [ meta load nfproto => reg 1 ]
-  [ cmp eq reg 1 0x0000000a ]
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index af3bab9b1f75f..ac1fc8b39a2b7 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -87,11 +87,3 @@ __set%d test-ip6 0
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
   [ lookup reg 1 set __set%d ]
-
-# dst hdrlength != { 33, 55, 67, 88}
-__set%d test-ip6 3
-__set%d test-ip6 0
-	element 00000021  : 0 [end]	element 00000037  : 0 [end]	element 00000043  : 0 [end]	element 00000058  : 0 [end]
-ip6 test-ip6 input
-  [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ lookup reg 1 set __set%d 0x1 ]
diff --git a/tests/py/ip6/frag.t.json b/tests/py/ip6/frag.t.json
index b8c06dfb3429c..6953e872a8f97 100644
--- a/tests/py/ip6/frag.t.json
+++ b/tests/py/ip6/frag.t.json
@@ -230,46 +230,6 @@
     }
 ]
 
-# frag reserved { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "reserved",
-                    "name": "frag"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# frag reserved != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "reserved",
-                    "name": "frag"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # frag frag-off 22
 [
     {
@@ -384,46 +344,6 @@
     }
 ]
 
-# frag frag-off { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "frag-off",
-                    "name": "frag"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# frag frag-off != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "frag-off",
-                    "name": "frag"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
 # frag reserved2 1
 [
     {
@@ -601,44 +521,3 @@
         }
     }
 ]
-
-# frag id { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "id",
-                    "name": "frag"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
-# frag id != { 33-55}
-[
-    {
-        "match": {
-            "left": {
-                "exthdr": {
-                    "field": "id",
-                    "name": "frag"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 55 ] }
-                ]
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index 49e5a2dd6355a..72d91cc74688d 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -571,46 +571,6 @@
     }
 ]
 
-# ip6 nexthdr { 33-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "nexthdr",
-                    "protocol": "ip6"
-                }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    { "range": [ 33, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
-# ip6 nexthdr != { 33-44}
-[
-    {
-        "match": {
-            "left": {
-                "payload": {
-                    "field": "nexthdr",
-                    "protocol": "ip6"
-                }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    { "range": [ 33, 44 ] }
-                ]
-            }
-        }
-    }
-]
-
 # ip6 nexthdr 33-44
 [
     {
-- 
2.49.0

