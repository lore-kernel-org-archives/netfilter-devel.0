Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BB5847F73
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Mar 2024 16:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710347013; cv=none; b=FDjHhRjbRx7daHwPk4KP8DVDDltYRqdmCgGba58lxkGmQHqTtwLKgm1ccZtk5gM1KtiGLXtwbbi2rdUuH7mijmK10Qr9Ito5BSKNpGRZHMgAVyjZ1KIKjFlz9mv2+pVgHmEBgAf2tdPCe8ZoP/trv2sPCf6xbTytDPX/cuJNArw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710347013; c=relaxed/simple;
	bh=fi+SYDzEedNzNmgDhkJFjOxpcOTntbqxgWStYPQnIDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OvwX1BIUZFzulmhkDQA/D02NcH78Ax+wjRauufRHyrUHKK29YrCUeoPXmobz5mYhRpUcopPAETf85+r76w15dQ+ztjPDOxoCOD43wqiGX0pLyVZy/iKTylvImjZ5OuABsNqnKxT5SdPefYGH0qGqrmeog2ZnWFrLaoozoUMOblI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] tests: py: remove meter tests
Date: Wed, 13 Mar 2024 17:23:17 +0100
Message-Id: <20240313162317.192314-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Userspace performs an translation to dynamic set which does not fit well
into tests/py, move them to tests/shell.

Fixes: b8f8ddfff733 ("evaluate: translate meter into dynamic set")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/flowtable.t                       |   5 -
 tests/py/ip/flowtable.t.json                  |  24 ---
 tests/py/ip/flowtable.t.payload               |   7 -
 tests/py/ip6/flowtable.t                      |   6 -
 tests/py/ip6/flowtable.t.json                 |  62 ------
 tests/py/ip6/flowtable.t.json.output          |  62 ------
 tests/py/ip6/flowtable.t.payload              |  16 --
 .../testcases/sets/dumps/meter_0.json-nft     | 203 ++++++++++++++++++
 tests/shell/testcases/sets/dumps/meter_0.nft  |  29 +++
 tests/shell/testcases/sets/meter_0            |  18 ++
 10 files changed, 250 insertions(+), 182 deletions(-)
 delete mode 100644 tests/py/ip/flowtable.t
 delete mode 100644 tests/py/ip/flowtable.t.json
 delete mode 100644 tests/py/ip/flowtable.t.payload
 delete mode 100644 tests/py/ip6/flowtable.t
 delete mode 100644 tests/py/ip6/flowtable.t.json
 delete mode 100644 tests/py/ip6/flowtable.t.json.output
 delete mode 100644 tests/py/ip6/flowtable.t.payload
 create mode 100644 tests/shell/testcases/sets/dumps/meter_0.json-nft
 create mode 100644 tests/shell/testcases/sets/dumps/meter_0.nft
 create mode 100755 tests/shell/testcases/sets/meter_0

diff --git a/tests/py/ip/flowtable.t b/tests/py/ip/flowtable.t
deleted file mode 100644
index 086c6cf6b449..000000000000
--- a/tests/py/ip/flowtable.t
+++ /dev/null
@@ -1,5 +0,0 @@
-:input;type filter hook input priority 0
-
-*ip;test-ip;input
-
-meter xyz size 8192 { ip saddr timeout 30s counter};ok
diff --git a/tests/py/ip/flowtable.t.json b/tests/py/ip/flowtable.t.json
deleted file mode 100644
index a03cc9d79350..000000000000
--- a/tests/py/ip/flowtable.t.json
+++ /dev/null
@@ -1,24 +0,0 @@
-# meter xyz size 8192 { ip saddr timeout 30s counter}
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 30,
-                    "val": {
-                        "payload": {
-                            "field": "saddr",
-                            "protocol": "ip"
-                        }
-                    }
-                }
-            },
-            "name": "xyz",
-            "size": 8192,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip/flowtable.t.payload b/tests/py/ip/flowtable.t.payload
deleted file mode 100644
index c0aad39ea193..000000000000
--- a/tests/py/ip/flowtable.t.payload
+++ /dev/null
@@ -1,7 +0,0 @@
-# meter xyz size 8192 { ip saddr timeout 30s counter}
-xyz test-ip 31
-xyz test-ip 0
-ip test-ip input 
-  [ payload load 4b @ network header + 12 => reg 1 ]
-  [ dynset update reg_key 1 set xyz timeout 30000ms expr [ counter pkts 0 bytes 0 ] ]
-
diff --git a/tests/py/ip6/flowtable.t b/tests/py/ip6/flowtable.t
deleted file mode 100644
index e58d51bb9b8e..000000000000
--- a/tests/py/ip6/flowtable.t
+++ /dev/null
@@ -1,6 +0,0 @@
-:input;type filter hook input priority 0
-
-*ip6;test-ip6;input
-
-meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter };ok;meter acct_out size 4096 { iif . ip6 saddr timeout 10m counter }
-meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter };ok;meter acct_out size 12345 { ip6 saddr . iif timeout 10m counter }
diff --git a/tests/py/ip6/flowtable.t.json b/tests/py/ip6/flowtable.t.json
deleted file mode 100644
index d0b3a957f01b..000000000000
--- a/tests/py/ip6/flowtable.t.json
+++ /dev/null
@@ -1,62 +0,0 @@
-# meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "meta": { "key": "iif" }
-                            },
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 4096,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            {
-                                "meta": { "key": "iif" }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 12345,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/flowtable.t.json.output b/tests/py/ip6/flowtable.t.json.output
deleted file mode 100644
index d0b3a957f01b..000000000000
--- a/tests/py/ip6/flowtable.t.json.output
+++ /dev/null
@@ -1,62 +0,0 @@
-# meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "meta": { "key": "iif" }
-                            },
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 4096,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-[
-    {
-        "meter": {
-            "key": {
-                "elem": {
-                    "timeout": 600,
-                    "val": {
-                        "concat": [
-                            {
-                                "payload": {
-                                    "field": "saddr",
-                                    "protocol": "ip6"
-                                }
-                            },
-                            {
-                                "meta": { "key": "iif" }
-                            }
-                        ]
-                    }
-                }
-            },
-            "name": "acct_out",
-            "size": 12345,
-            "stmt": {
-                "counter": null
-            }
-        }
-    }
-]
-
diff --git a/tests/py/ip6/flowtable.t.payload b/tests/py/ip6/flowtable.t.payload
deleted file mode 100644
index 559475f6d2c6..000000000000
--- a/tests/py/ip6/flowtable.t.payload
+++ /dev/null
@@ -1,16 +0,0 @@
-# meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
-acct_out test-ip6 31
-acct_out test-ip6 0
-ip6 test-ip6 input
-  [ meta load iif => reg 1 ]
-  [ payload load 16b @ network header + 8 => reg 9 ]
-  [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
-
-# meter acct_out size 12345 { ip6 saddr . meta iif timeout 600s counter }
-acct_out test-ip6 31
-acct_out test-ip6 0
-ip6 test-ip6 input
-  [ payload load 16b @ network header + 8 => reg 1 ]
-  [ meta load iif => reg 2 ]
-  [ dynset update reg_key 1 set acct_out timeout 600000ms expr [ counter pkts 0 bytes 0 ] ]
-
diff --git a/tests/shell/testcases/sets/dumps/meter_0.json-nft b/tests/shell/testcases/sets/dumps/meter_0.json-nft
new file mode 100644
index 000000000000..71e83b19f136
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/meter_0.json-nft
@@ -0,0 +1,203 @@
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
+        "family": "ip6",
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip6",
+        "name": "acct_out",
+        "table": "test",
+        "type": [
+          "iface_index",
+          "ipv6_addr"
+        ],
+        "handle": 0,
+        "size": 4096,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ]
+      }
+    },
+    {
+      "set": {
+        "family": "ip6",
+        "name": "acct_out2",
+        "table": "test",
+        "type": [
+          "ipv6_addr",
+          "iface_index"
+        ],
+        "handle": 0,
+        "size": 12345,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ]
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "test",
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "test",
+        "chain": "test",
+        "handle": 0,
+        "expr": [
+          {
+            "set": {
+              "op": "update",
+              "elem": {
+                "elem": {
+                  "val": {
+                    "concat": [
+                      {
+                        "meta": {
+                          "key": "iif"
+                        }
+                      },
+                      {
+                        "payload": {
+                          "protocol": "ip6",
+                          "field": "saddr"
+                        }
+                      }
+                    ]
+                  },
+                  "timeout": 600
+                }
+              },
+              "set": "@acct_out",
+              "stmt": [
+                {
+                  "counter": null
+                }
+              ]
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "test",
+        "chain": "test",
+        "handle": 0,
+        "expr": [
+          {
+            "set": {
+              "op": "update",
+              "elem": {
+                "elem": {
+                  "val": {
+                    "concat": [
+                      {
+                        "payload": {
+                          "protocol": "ip6",
+                          "field": "saddr"
+                        }
+                      },
+                      {
+                        "meta": {
+                          "key": "iif"
+                        }
+                      }
+                    ]
+                  },
+                  "timeout": 600
+                }
+              },
+              "set": "@acct_out2",
+              "stmt": [
+                {
+                  "counter": null
+                }
+              ]
+            }
+          }
+        ]
+      }
+    },
+    {
+      "table": {
+        "family": "ip",
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "set": {
+        "family": "ip",
+        "name": "xyz",
+        "table": "test",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "size": 8192,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ]
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "test",
+        "chain": "test",
+        "handle": 0,
+        "expr": [
+          {
+            "set": {
+              "op": "update",
+              "elem": {
+                "elem": {
+                  "val": {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  "timeout": 30
+                }
+              },
+              "set": "@xyz",
+              "stmt": [
+                {
+                  "counter": null
+                }
+              ]
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/sets/dumps/meter_0.nft b/tests/shell/testcases/sets/dumps/meter_0.nft
new file mode 100644
index 000000000000..3843f9a9bf52
--- /dev/null
+++ b/tests/shell/testcases/sets/dumps/meter_0.nft
@@ -0,0 +1,29 @@
+table ip6 test {
+	set acct_out {
+		type iface_index . ipv6_addr
+		size 4096
+		flags dynamic,timeout
+	}
+
+	set acct_out2 {
+		type ipv6_addr . iface_index
+		size 12345
+		flags dynamic,timeout
+	}
+
+	chain test {
+		update @acct_out { iif . ip6 saddr timeout 10m counter }
+		update @acct_out2 { ip6 saddr . iif timeout 10m counter }
+	}
+}
+table ip test {
+	set xyz {
+		type ipv4_addr
+		size 8192
+		flags dynamic,timeout
+	}
+
+	chain test {
+		update @xyz { ip saddr timeout 30s counter }
+	}
+}
diff --git a/tests/shell/testcases/sets/meter_0 b/tests/shell/testcases/sets/meter_0
new file mode 100755
index 000000000000..82e6f20a8b07
--- /dev/null
+++ b/tests/shell/testcases/sets/meter_0
@@ -0,0 +1,18 @@
+#!/bin/bash
+
+set -e
+
+RULESET="table ip6 test {
+	chain test {
+		meter acct_out size 4096 { meta iif . ip6 saddr timeout 600s counter }
+		meter acct_out2 size 12345 { ip6 saddr . meta iif timeout 600s counter }
+	}
+}
+
+table ip test {
+	chain test {
+		meter xyz size 8192 { ip saddr timeout 30s counter}
+	}
+}"
+
+$NFT -f - <<< $RULESET
-- 
2.30.2

