Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75737A714
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Feb 2024 10:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203521; cv=none; b=d8v5wvnmMdSSeLuGyl0FKeRepsoAXHhClxO23m6XvxY0Me6u2GYRaHL86qalowhdTxPu2IHssdu/BdhLhlmDjGMXmBneLo/Vv7QdRSZu7vomGRSFhBJNOrrs7udtpvP5GCQd9FEUqlc+sF/4QTHv0TOnFHaY/ZMmRawF8yxFWGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203521; c=relaxed/simple;
	bh=JcF6Fe4d3BQ33BqlBCmoqolAQvWWmI7b/FzyumHbA30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBZ0UuIsLOyaTXbSJS6ca+MerUGxO7cV03w7bKliee5Yh2/d9QY308BVXok83edO9OpjF7ExldRNuOQ2CJnO8jmVhkv5wFyGgybVEM8ZmBSTXmpZYE7AR8yWZwM0SqroDyzAu1qbav0SsabwL502FuPSO6RTr5ffEPMBfsu/kuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rfduf-0007de-4K; Thu, 29 Feb 2024 11:45:17 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: maps: add a test case for "limit" objref map
Date: Thu, 29 Feb 2024 11:41:25 +0100
Message-ID: <20240229104347.5156-4-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240229104347.5156-1-fw@strlen.de>
References: <20240229104347.5156-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check add, delete and removal operations for objref maps.

Also check type vs. typeof declarations and use both
interval and interval+concatenation (rbtree, pipapo).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../maps/dumps/named_limits.json-nft          | 328 ++++++++++++++++++
 .../testcases/maps/dumps/named_limits.nft     |  55 +++
 tests/shell/testcases/maps/named_limits       |  59 ++++
 3 files changed, 442 insertions(+)
 create mode 100644 tests/shell/testcases/maps/dumps/named_limits.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/named_limits.nft
 create mode 100755 tests/shell/testcases/maps/named_limits

diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
new file mode 100644
index 000000000000..28a92529c8d2
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -0,0 +1,328 @@
+{
+  "nftables": [
+    {
+      "metainfo": {
+        "version": "VERSION",
+        "release_name": "RELEASE_NAME",
+        "json_schema_version": 1
+      }
+    },
+    {
+      "table": {
+        "family": "inet",
+        "name": "filter",
+        "handle": 0
+      }
+    },
+    {
+      "limit": {
+        "family": "inet",
+        "name": "tarpit-pps",
+        "table": "filter",
+        "handle": 0,
+        "rate": 1,
+        "per": "second",
+        "burst": 5
+      }
+    },
+    {
+      "limit": {
+        "family": "inet",
+        "name": "tarpit-bps",
+        "table": "filter",
+        "handle": 0,
+        "rate": 1,
+        "per": "second",
+        "rate_unit": "kbytes"
+      }
+    },
+    {
+      "limit": {
+        "family": "inet",
+        "name": "http-bulk-rl-1m",
+        "table": "filter",
+        "handle": 0,
+        "rate": 1,
+        "per": "second",
+        "rate_unit": "mbytes"
+      }
+    },
+    {
+      "limit": {
+        "family": "inet",
+        "name": "http-bulk-rl-10m",
+        "table": "filter",
+        "handle": 0,
+        "rate": 10,
+        "per": "second",
+        "rate_unit": "mbytes"
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "tarpit4",
+        "table": "filter",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "size": 10000,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ],
+        "timeout": 60
+      }
+    },
+    {
+      "set": {
+        "family": "inet",
+        "name": "tarpit6",
+        "table": "filter",
+        "type": "ipv6_addr",
+        "handle": 0,
+        "size": 10000,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ],
+        "timeout": 60
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "addr4limit",
+        "table": "filter",
+        "type": [
+          "inet_proto",
+          "ipv4_addr",
+          "inet_service"
+        ],
+        "handle": 0,
+        "map": "limit",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            {
+              "concat": [
+                "tcp",
+                {
+                  "prefix": {
+                    "addr": "192.168.0.0",
+                    "len": 16
+                  }
+                },
+                {
+                  "range": [
+                    1,
+                    65535
+                  ]
+                }
+              ]
+            },
+            "tarpit-bps"
+          ],
+          [
+            {
+              "concat": [
+                "udp",
+                {
+                  "prefix": {
+                    "addr": "192.168.0.0",
+                    "len": 16
+                  }
+                },
+                {
+                  "range": [
+                    1,
+                    65535
+                  ]
+                }
+              ]
+            },
+            "tarpit-pps"
+          ],
+          [
+            {
+              "concat": [
+                "tcp",
+                {
+                  "range": [
+                    "127.0.0.1",
+                    "127.1.2.3"
+                  ]
+                },
+                {
+                  "range": [
+                    1,
+                    1024
+                  ]
+                }
+              ]
+            },
+            "tarpit-pps"
+          ],
+          [
+            {
+              "concat": [
+                "tcp",
+                {
+                  "range": [
+                    "10.0.0.1",
+                    "10.0.0.255"
+                  ]
+                },
+                80
+              ]
+            },
+            "http-bulk-rl-1m"
+          ],
+          [
+            {
+              "concat": [
+                "tcp",
+                {
+                  "range": [
+                    "10.0.0.1",
+                    "10.0.0.255"
+                  ]
+                },
+                443
+              ]
+            },
+            "http-bulk-rl-1m"
+          ],
+          [
+            {
+              "concat": [
+                "tcp",
+                {
+                  "prefix": {
+                    "addr": "10.0.1.0",
+                    "len": 24
+                  }
+                },
+                {
+                  "range": [
+                    1024,
+                    65535
+                  ]
+                }
+              ]
+            },
+            "http-bulk-rl-10m"
+          ],
+          [
+            {
+              "concat": [
+                "tcp",
+                "10.0.2.1",
+                22
+              ]
+            },
+            "http-bulk-rl-10m"
+          ]
+        ]
+      }
+    },
+    {
+      "map": {
+        "family": "inet",
+        "name": "saddr6limit",
+        "table": "filter",
+        "type": "ipv6_addr",
+        "handle": 0,
+        "map": "limit",
+        "flags": [
+          "interval"
+        ],
+        "elem": [
+          [
+            {
+              "range": [
+                "dead::beef",
+                "dead::1:aced"
+              ]
+            },
+            "tarpit-pps"
+          ]
+        ]
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "limit": {
+              "map": {
+                "key": {
+                  "concat": [
+                    {
+                      "meta": {
+                        "key": "l4proto"
+                      }
+                    },
+                    {
+                      "payload": {
+                        "protocol": "ip",
+                        "field": "saddr"
+                      }
+                    },
+                    {
+                      "payload": {
+                        "protocol": "th",
+                        "field": "sport"
+                      }
+                    }
+                  ]
+                },
+                "data": "@addr4limit"
+              }
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "filter",
+        "chain": "input",
+        "handle": 0,
+        "expr": [
+          {
+            "limit": {
+              "map": {
+                "key": {
+                  "payload": {
+                    "protocol": "ip6",
+                    "field": "saddr"
+                  }
+                },
+                "data": "@saddr6limit"
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/named_limits.nft b/tests/shell/testcases/maps/dumps/named_limits.nft
new file mode 100644
index 000000000000..214df204b770
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/named_limits.nft
@@ -0,0 +1,55 @@
+table inet filter {
+	limit tarpit-pps {
+		rate 1/second
+	}
+
+	limit tarpit-bps {
+		rate 1 kbytes/second
+	}
+
+	limit http-bulk-rl-1m {
+		rate 1 mbytes/second
+	}
+
+	limit http-bulk-rl-10m {
+		rate 10 mbytes/second
+	}
+
+	set tarpit4 {
+		typeof ip saddr
+		size 10000
+		flags dynamic,timeout
+		timeout 1m
+	}
+
+	set tarpit6 {
+		typeof ip6 saddr
+		size 10000
+		flags dynamic,timeout
+		timeout 1m
+	}
+
+	map addr4limit {
+		typeof meta l4proto . ip saddr . tcp sport : limit
+		flags interval
+		elements = { tcp . 192.168.0.0/16 . 1-65535 : "tarpit-bps",
+			     udp . 192.168.0.0/16 . 1-65535 : "tarpit-pps",
+			     tcp . 127.0.0.1-127.1.2.3 . 1-1024 : "tarpit-pps",
+			     tcp . 10.0.0.1-10.0.0.255 . 80 : "http-bulk-rl-1m",
+			     tcp . 10.0.0.1-10.0.0.255 . 443 : "http-bulk-rl-1m",
+			     tcp . 10.0.1.0/24 . 1024-65535 : "http-bulk-rl-10m",
+			     tcp . 10.0.2.1 . 22 : "http-bulk-rl-10m" }
+	}
+
+	map saddr6limit {
+		typeof ip6 saddr : limit
+		flags interval
+		elements = { dead::beef-dead::1:aced : "tarpit-pps" }
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+		limit name meta l4proto . ip saddr . th sport map @addr4limit
+		limit name ip6 saddr map @saddr6limit
+	}
+}
diff --git a/tests/shell/testcases/maps/named_limits b/tests/shell/testcases/maps/named_limits
new file mode 100755
index 000000000000..5604f6caeda6
--- /dev/null
+++ b/tests/shell/testcases/maps/named_limits
@@ -0,0 +1,59 @@
+#!/bin/bash
+
+dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+
+$NFT -f "$dumpfile" || exit 1
+
+add_add_then_create()
+{
+	cmd="$@"
+
+	$NFT "add element inet filter $cmd" || exit 2
+
+	# again, kernel should suppress -EEXIST
+	$NFT "add element inet filter $cmd" || exit 3
+
+	# AGAIN, kernel should report -EEXIST
+	$NFT "create element inet filter $cmd" && echo "$cmd worked" 1>&2 && exit 4
+}
+
+add_create_dupe()
+{
+	cmd="$@"
+
+	$NFT "add element inet filter $cmd" && echo "$cmd worked" 1>&2 && exit 10
+	$NFT "create element inet filter $cmd" && echo "$cmd worked" 1>&2 && exit 11
+}
+
+delete()
+{
+	cmd="$@"
+
+	$NFT "delete element inet filter $cmd" || exit 30
+	$NFT "delete element inet filter $cmd" && echo "$cmd worked" 1>&2 && exit 31
+
+	# destroy should NOT report an error
+#	$NFT "destroy element inet filter $cmd" || exit 40
+}
+
+add_add_then_create 'saddr6limit { fee1::dead : "tarpit-pps" }'
+add_add_then_create 'saddr6limit { c01a::/64 : "tarpit-bps" }'
+
+# test same with a diffent set type (concat + interval)
+add_add_then_create 'addr4limit { udp . 1.2.3.4 . 42 : "tarpit-pps", tcp . 1.2.3.4 . 42 : "tarpit-pps" }'
+
+# now test duplicate key with *DIFFERENT* limiter, should fail
+add_create_dupe 'saddr6limit { fee1::dead : "tarpit-bps" }'
+
+add_create_dupe 'addr4limit { udp . 1.2.3.4 . 42 : "tarpit-pps", tcp . 1.2.3.4 . 42 : "http-bulk-rl-10m" }'
+add_create_dupe 'addr4limit { udp . 1.2.3.4 . 43 : "tarpit-pps", tcp . 1.2.3.4 . 42 : "http-bulk-rl-10m" }'
+add_create_dupe 'addr4limit { udp . 1.2.3.5 . 42 : "tarpit-pps", tcp . 1.2.3.4 . 42 : "http-bulk-rl-10m" }'
+add_create_dupe 'addr4limit { udp . 1.2.3.4 . 42 : "tarpit-bps", tcp . 1.2.3.4 . 42 : "tarpit-pps" }'
+
+# delete keys again
+delete 'addr4limit { udp . 1.2.3.4 . 42 : "tarpit-pps", tcp . 1.2.3.4 . 42 :"tarpit-pps" }'
+
+delete 'saddr6limit { fee1::dead : "tarpit-pps" }'
+delete 'saddr6limit { c01a::/64 : "tarpit-bps" }'
+
+exit 0
-- 
2.43.0

