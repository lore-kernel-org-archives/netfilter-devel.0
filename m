Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8953D24A076
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2026 09:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193060; cv=none; b=JPLMiifQeYQpB6XMETAjrkWs5CykwzSYyhSsUppo2x9eCmX5gq+T+tFX59TsaBGnTbqRuV3tCY8KD+JssQCdCSh9qePWXPoCm3GlvfXX9Y+KTn/ymtBL75g1Cbm9XWjzpbHaWfz3OuPCPUP3DwbJ0NXuIxqsen5Nd3gpqOqvWMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193060; c=relaxed/simple;
	bh=gLAonWj1tXP5fCwDS8GRMWDltugzUguEUUz/KSlrr00=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gxNRrpCTZxuef2WeoRi3540V10fEUQVoW9E47ScFwAUdrYoID3SOAn3G5xhQ28hpToflnibeBnR750IGns5mkAAxEOy9cIkdhQ1nnQR13/jl7Cg+8SXcJ8eBsWhSNHTAeRAtZykY1zEU1X5YqL++0/0Jd/hoBX1fZrvb0gt16Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1487E6058F; Thu, 16 Jul 2026 11:10:46 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add template match bug test
Date: Thu, 16 Jul 2026 11:10:32 +0200
Message-ID: <20260716091037.15018-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Template should not be matched via "ct" expression.  Else this
makes us read an l3num of 0.  This is a test for kernel commit
3027ecbdb5fd ("netfilter: nft_ct: bail out on template ct in get eval").

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../packetpath/dumps/nft_ct_template.json-nft | 252 ++++++++++++++++++
 .../packetpath/dumps/nft_ct_template.nft      |  22 ++
 .../testcases/packetpath/nft_ct_template      |  38 +++
 3 files changed, 312 insertions(+)
 create mode 100644 tests/shell/testcases/packetpath/dumps/nft_ct_template.json-nft
 create mode 100644 tests/shell/testcases/packetpath/dumps/nft_ct_template.nft
 create mode 100755 tests/shell/testcases/packetpath/nft_ct_template

diff --git a/tests/shell/testcases/packetpath/dumps/nft_ct_template.json-nft b/tests/shell/testcases/packetpath/dumps/nft_ct_template.json-nft
new file mode 100644
index 000000000000..9c38046f5b7e
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/nft_ct_template.json-nft
@@ -0,0 +1,252 @@
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
+        "family": "ip",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -300,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "zone"
+                }
+              },
+              "value": 1
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "ct": {
+                  "key": "saddr",
+                  "dir": "original"
+                }
+              },
+              "right": "0.0.0.0"
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "table": {
+        "family": "ip6",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -300,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "zone"
+                }
+              },
+              "value": 1
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "ct": {
+                  "key": "saddr",
+                  "dir": "original"
+                }
+              },
+              "right": "::"
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "table": {
+        "family": "inet",
+        "name": "t",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -300,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "mangle": {
+              "key": {
+                "ct": {
+                  "key": "zone"
+                }
+              },
+              "value": 1
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "ct": {
+                  "key": "ip saddr",
+                  "dir": "original"
+                }
+              },
+              "right": "0.0.0.0"
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "t",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "ct": {
+                  "key": "ip6 saddr",
+                  "dir": "original"
+                }
+              },
+              "right": "::"
+            }
+          },
+          {
+            "counter": {
+              "packets": 0,
+              "bytes": 0
+            }
+          },
+          {
+            "accept": null
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/packetpath/dumps/nft_ct_template.nft b/tests/shell/testcases/packetpath/dumps/nft_ct_template.nft
new file mode 100644
index 000000000000..efe5dbb265a7
--- /dev/null
+++ b/tests/shell/testcases/packetpath/dumps/nft_ct_template.nft
@@ -0,0 +1,22 @@
+table ip t {
+	chain c {
+		type filter hook output priority raw; policy accept;
+		ct zone set 1
+		ct original ip saddr 0.0.0.0 counter packets 0 bytes 0 accept
+	}
+}
+table ip6 t {
+	chain c {
+		type filter hook output priority raw; policy accept;
+		ct zone set 1
+		ct original ip6 saddr :: counter packets 0 bytes 0 accept
+	}
+}
+table inet t {
+	chain c {
+		type filter hook output priority raw; policy accept;
+		ct zone set 1
+		ct original ip saddr 0.0.0.0 counter packets 0 bytes 0 accept
+		ct original ip6 saddr :: counter packets 0 bytes 0 accept
+	}
+}
diff --git a/tests/shell/testcases/packetpath/nft_ct_template b/tests/shell/testcases/packetpath/nft_ct_template
new file mode 100755
index 000000000000..02051f3345c9
--- /dev/null
+++ b/tests/shell/testcases/packetpath/nft_ct_template
@@ -0,0 +1,38 @@
+#!/bin/bash
+
+# test for kernel commit 3027ecbdb5fd ("netfilter: nft_ct: bail out on template ct in get eval")
+
+set -e
+
+$NFT -f - <<EOF
+table ip t {
+	chain c {
+		type filter hook output priority -300; policy accept;
+		ct zone set 1
+		ct original saddr 0.0.0.0 counter accept
+	}
+}
+
+table ip6 t {
+	chain c {
+		type filter hook output priority -300; policy accept;
+		ct zone set 1
+		ct original saddr :: counter accept
+	}
+}
+
+table inet t {
+	chain c {
+		type filter hook output priority -300; policy accept;
+		ct zone set 1
+		ct original ip saddr 0.0.0.0 counter accept
+		ct original ip6 saddr :: counter accept
+	}
+}
+EOF
+
+ip link set lo up
+ping -c 1 127.0.0.1
+ping -c 1 ::1
+
+# counter validation via dump file.
-- 
2.55.0

