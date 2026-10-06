Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD23503BF3
	for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2026 23:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791328827; cv=none; b=h+NmUQ1jr/YQ/uodbQFgrL0r7LH/EU90XlXJ/ognFRdXkkzDq++pEnjW3s2A2N+T0xBaCD8QymnS4HkhPkanDSR5/ArQDdv68LPr17GBjMVTMAvMnc76aYKlnJJkJ13Ugn3PoH80sZwfDqSkajaaeQekj8MayzzoFLV1VFUz6Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791328827; c=relaxed/simple;
	bh=P516KjCi1kW2guE97uPxRHVWC9dK+TsMSStJuoaS31E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eOMiGx+nCDua626nKsrLptuak8XFmJ7Xqf8I1qk7tIn743pa0l2ikbHtFsmuSeJMVoIjC+hILKfflZ0Nkpq2yDfPy7zjsV0VEP5LQ5gxtB0fonTFXl0u0eYStpEWJtlNa5TFzBMEK0dBRVa8hwN/FxBoE5Kvx2IftCdRkrlqbMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B20CD6059E; Wed, 07 Oct 2026 01:20:00 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] tests: shell: add conntrack template attachment test
Date: Wed,  7 Oct 2026 01:19:53 +0200
Message-ID: <20261006231953.6338-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Try to attach ct templates at various priorities and check that
attachmet only works at the acceptable positions: prerouting + output,
before nf_conntrack_in() on the kernel side.

Relax the test for now to not fail on kernels that lack the required
validation and SKIP if all attachment request work.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Companion nftables.git shell test for the
 'netfilter: nft_ct: validate hook and priority for ct zone set' kernel
 patch.

 It could be added to nftables.git already, its expected to PASS or
 SKIP only.

 ...te_ct_zone_set_template_attach.sh.json-nft | 918 ++++++++++++++++++
 ...alidate_ct_zone_set_template_attach.sh.nft | 206 ++++
 .../validate_ct_zone_set_template_attach.sh   | 377 +++++++
 3 files changed, 1501 insertions(+)
 create mode 100644 tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.json-nft
 create mode 100644 tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.nft
 create mode 100755 tests/shell/testcases/transactions/validate_ct_zone_set_template_attach.sh

diff --git a/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.json-nft b/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.json-nft
new file mode 100644
index 000000000000..9dd84f95cad9
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.json-nft
@@ -0,0 +1,918 @@
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
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "prerouting_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "prerouting_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "prerouting_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "forward",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "output_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "output_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "output_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "postrouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "postrouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "ctz",
+        "chain": "prerouting_before",
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
+        "table": "ctz",
+        "chain": "prerouting_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "ctz",
+        "chain": "output_before",
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
+        "table": "ctz",
+        "chain": "output_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "ctz",
+        "chain": "nonbase",
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
+      "table": {
+        "family": "ip6",
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "prerouting_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "prerouting_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "prerouting_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "forward",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "output_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "output_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "output_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "postrouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "postrouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "ip6",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "ctz",
+        "chain": "prerouting_before",
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
+        "table": "ctz",
+        "chain": "prerouting_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "ctz",
+        "chain": "output_before",
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
+        "table": "ctz",
+        "chain": "output_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "ctz",
+        "chain": "nonbase",
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
+      "table": {
+        "family": "bridge",
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "prerouting_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "prerouting_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "prerouting_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "forward",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "output_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "output_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "output_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "postrouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "postrouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "bridge",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "bridge",
+        "table": "ctz",
+        "chain": "prerouting_before",
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
+        "family": "bridge",
+        "table": "ctz",
+        "chain": "prerouting_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "bridge",
+        "table": "ctz",
+        "chain": "nonbase",
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
+      "table": {
+        "family": "inet",
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "prerouting_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "prerouting_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "prerouting_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "forward",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "output_before",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -201,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "output_at",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -200,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "output_after",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": -199,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "postrouting",
+        "handle": 0,
+        "type": "filter",
+        "hook": "postrouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "ctz",
+        "name": "ingress",
+        "handle": 0,
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "ctz",
+        "chain": "prerouting_before",
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
+        "table": "ctz",
+        "chain": "prerouting_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "ctz",
+        "chain": "output_before",
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
+        "table": "ctz",
+        "chain": "output_before",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "nonbase"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "ctz",
+        "chain": "nonbase",
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
+      "table": {
+        "family": "arp",
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "arp",
+        "table": "ctz",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "arp",
+        "table": "ctz",
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "arp",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "table": {
+        "family": "netdev",
+        "name": "ctz",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "ctz",
+        "name": "ingress",
+        "handle": 0,
+        "type": "filter",
+        "hook": "ingress",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "ctz",
+        "name": "nonbase",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "ctz",
+        "name": "egress",
+        "handle": 0,
+        "type": "filter",
+        "hook": "egress",
+        "prio": 0,
+        "policy": "accept"
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.nft b/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.nft
new file mode 100644
index 000000000000..dee5c6259e0e
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/validate_ct_zone_set_template_attach.sh.nft
@@ -0,0 +1,206 @@
+table ip ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain prerouting_at {
+		type filter hook prerouting priority -200; policy accept;
+	}
+
+	chain prerouting_after {
+		type filter hook prerouting priority -199; policy accept;
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+
+	chain forward {
+		type filter hook forward priority filter; policy accept;
+	}
+
+	chain output_before {
+		type filter hook output priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain output_at {
+		type filter hook output priority -200; policy accept;
+	}
+
+	chain output_after {
+		type filter hook output priority -199; policy accept;
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority filter; policy accept;
+	}
+
+	chain nonbase {
+		ct zone set 1
+	}
+}
+table ip6 ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain prerouting_at {
+		type filter hook prerouting priority -200; policy accept;
+	}
+
+	chain prerouting_after {
+		type filter hook prerouting priority -199; policy accept;
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+
+	chain forward {
+		type filter hook forward priority filter; policy accept;
+	}
+
+	chain output_before {
+		type filter hook output priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain output_at {
+		type filter hook output priority -200; policy accept;
+	}
+
+	chain output_after {
+		type filter hook output priority -199; policy accept;
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority filter; policy accept;
+	}
+
+	chain nonbase {
+		ct zone set 1
+	}
+}
+table bridge ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority filter - 1; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain prerouting_at {
+		type filter hook prerouting priority filter; policy accept;
+	}
+
+	chain prerouting_after {
+		type filter hook prerouting priority filter + 1; policy accept;
+	}
+
+	chain input {
+		type filter hook input priority 0; policy accept;
+	}
+
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+	}
+
+	chain output_before {
+		type filter hook output priority filter - 1; policy accept;
+	}
+
+	chain output_at {
+		type filter hook output priority filter; policy accept;
+	}
+
+	chain output_after {
+		type filter hook output priority filter + 1; policy accept;
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority 0; policy accept;
+	}
+
+	chain nonbase {
+		ct zone set 1
+	}
+}
+table inet ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain prerouting_at {
+		type filter hook prerouting priority -200; policy accept;
+	}
+
+	chain prerouting_after {
+		type filter hook prerouting priority -199; policy accept;
+	}
+
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+
+	chain forward {
+		type filter hook forward priority filter; policy accept;
+	}
+
+	chain output_before {
+		type filter hook output priority -201; policy accept;
+		ct zone set 1
+		jump nonbase
+	}
+
+	chain output_at {
+		type filter hook output priority -200; policy accept;
+	}
+
+	chain output_after {
+		type filter hook output priority -199; policy accept;
+	}
+
+	chain postrouting {
+		type filter hook postrouting priority filter; policy accept;
+	}
+
+	chain nonbase {
+		ct zone set 1
+	}
+
+	chain ingress {
+		type filter hook ingress priority filter; policy accept;
+	}
+}
+table arp ctz {
+	chain input {
+		type filter hook input priority filter; policy accept;
+	}
+
+	chain output {
+		type filter hook output priority filter; policy accept;
+	}
+
+	chain nonbase {
+	}
+}
+table netdev ctz {
+	chain ingress {
+		type filter hook ingress priority filter; policy accept;
+	}
+
+	chain nonbase {
+	}
+
+	chain egress {
+		type filter hook egress priority filter; policy accept;
+	}
+}
diff --git a/tests/shell/testcases/transactions/validate_ct_zone_set_template_attach.sh b/tests/shell/testcases/transactions/validate_ct_zone_set_template_attach.sh
new file mode 100755
index 000000000000..c2dab6ac6b25
--- /dev/null
+++ b/tests/shell/testcases/transactions/validate_ct_zone_set_template_attach.sh
@@ -0,0 +1,377 @@
+#!/bin/bash
+#
+# Test ct zone set placement in base chains across all families and hooks.
+#
+# ct zone set is only valid in:
+#  - PREROUTING hook with priority < -200 (before conntrack)
+#  - OUTPUT hook in ip/ip6/inet families (bridge OUTPUT does not see traffic)
+#
+# For every other base chain the kernel must reject both
+#   'ct zone set <n>'
+# and
+#   'jump <non-base-chain containing ct zone set>'
+#
+# same for the unsupported families and hooks.
+
+set -e
+
+expected_fail=0
+actual_fail=0
+total=0
+expected_ok=0
+actual_ok=0
+bad=0
+
+errlog() {
+	local fam=$1 chain=$2 what=$3 err=$4
+
+	echo "Unxpected $err: add rule $fam ctz $chain $what"
+	$NFT list table $fam ctz
+}
+
+test_chain() {
+	local fam=$1 chain=$2 expected=$3
+	local pass="n"
+
+	total=$((total + 1))
+
+	if [ "$expected" = "y" ]; then
+		expected_ok=$((expected_ok + 1))
+	fi
+
+	if $NFT add rule "$fam" ctz "$chain" ct zone set 1; then
+		# accepted -- jump to non-base chain must also be accepted
+		if ! $NFT add rule "$fam" ctz "$chain" jump nonbase; then
+			errlog $fam $chain "jump" "failure"
+			bad=$((bad + 1))
+		else
+			pass="y"
+			actual_ok=$((actual_ok + 1))
+		fi
+	else
+		if [ "$expected" = "y" ]; then
+			errlog $fam $chain "ct zone set 1" "failure"
+			bad=$((bad + 1))
+			return
+		fi
+
+		# rejected -- jump to non-base chain must also be rejected
+		if [ "$fam" = "netdev" ] || [ "$fam" = "arp" ] ; then
+			# non-basechain doesn't have a ct zone set rule.
+			if $NFT add rule "$fam" ctz "nonbase" ct zone set 1; then
+				errlog $fam $chain "ct zone set 1" "success"
+				bad=$((bad + 1))
+			else
+				expected_fail=$((expected_fail + 1))
+			fi
+
+			return
+		fi
+
+		if $NFT add rule "$fam" ctz "$chain" jump nonbase; then
+			errlog $fam $chain "jump" "success"
+			bad=$((bad + 1))
+		fi
+	fi
+
+	if [ "$pass" = "y" ] && [ "$expected" = "n" ]; then
+		errlog $fam "$chain" "both" "success"
+	fi
+}
+
+# ---------------------------------------------------------------------------
+# Create tables with base chains in every family / hook.
+# PREROUTING and OUTPUT each get three chains:
+#   -201 (before conntrack), -200 (at conntrack), -201 (after conntrack).
+#
+# Each table also carries a non-base chain "nonbase" holding
+# 'ct zone set 1'; no base chain jumps to it at this point.
+# ---------------------------------------------------------------------------
+
+$NFT -f - <<EOF
+table ip ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201;
+		policy accept;
+	}
+	chain prerouting_at {
+		type filter hook prerouting priority -200;
+		policy accept;
+	}
+	chain prerouting_after {
+		type filter hook prerouting priority -199;
+		policy accept;
+	}
+	chain input {
+		type filter hook input priority 0;
+		policy accept;
+	}
+	chain forward {
+		type filter hook forward priority 0;
+		policy accept;
+	}
+	chain output_before {
+		type filter hook output priority -201;
+		policy accept;
+	}
+	chain output_at {
+		type filter hook output priority -200;
+		policy accept;
+	}
+	chain output_after {
+		type filter hook output priority -199;
+		policy accept;
+	}
+	chain postrouting {
+		type filter hook postrouting priority 0;
+		policy accept;
+	}
+	chain nonbase {
+		ct zone set 1;
+	}
+}
+
+table ip6 ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201;
+		policy accept;
+	}
+	chain prerouting_at {
+		type filter hook prerouting priority -200;
+		policy accept;
+	}
+	chain prerouting_after {
+		type filter hook prerouting priority -199;
+		policy accept;
+	}
+	chain input {
+		type filter hook input priority 0;
+		policy accept;
+	}
+	chain forward {
+		type filter hook forward priority 0;
+		policy accept;
+	}
+	chain output_before {
+		type filter hook output priority -201;
+		policy accept;
+	}
+	chain output_at {
+		type filter hook output priority -200;
+		policy accept;
+	}
+	chain output_after {
+		type filter hook output priority -199;
+		policy accept;
+	}
+	chain postrouting {
+		type filter hook postrouting priority 0;
+		policy accept;
+	}
+	chain nonbase {
+		ct zone set 1;
+	}
+}
+
+table bridge ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201;
+		policy accept;
+	}
+	chain prerouting_at {
+		type filter hook prerouting priority -200;
+		policy accept;
+	}
+	chain prerouting_after {
+		type filter hook prerouting priority -199;
+		policy accept;
+	}
+	chain input {
+		type filter hook input priority 0;
+		policy accept;
+	}
+	chain forward {
+		type filter hook forward priority 0;
+		policy accept;
+	}
+	chain output_before {
+		type filter hook output priority -201;
+		policy accept;
+	}
+	chain output_at {
+		type filter hook output priority -200;
+		policy accept;
+	}
+	chain output_after {
+		type filter hook output priority -199;
+		policy accept;
+	}
+	chain postrouting {
+		type filter hook postrouting priority 0;
+		policy accept;
+	}
+	chain nonbase {
+		ct zone set 1;
+	}
+}
+
+table inet ctz {
+	chain prerouting_before {
+		type filter hook prerouting priority -201;
+		policy accept;
+	}
+	chain prerouting_at {
+		type filter hook prerouting priority -200;
+		policy accept;
+	}
+	chain prerouting_after {
+		type filter hook prerouting priority -199;
+		policy accept;
+	}
+	chain input {
+		type filter hook input priority 0;
+		policy accept;
+	}
+	chain forward {
+		type filter hook forward priority 0;
+		policy accept;
+	}
+	chain output_before {
+		type filter hook output priority -201;
+		policy accept;
+	}
+	chain output_at {
+		type filter hook output priority -200;
+		policy accept;
+	}
+	chain output_after {
+		type filter hook output priority -199;
+		policy accept;
+	}
+	chain postrouting {
+		type filter hook postrouting priority 0;
+		policy accept;
+	}
+	chain nonbase {
+		ct zone set 1;
+	}
+}
+
+table arp ctz {
+	chain input {
+		type filter hook input priority 0;
+		policy accept;
+	}
+	chain output {
+		type filter hook output priority 0;
+		policy accept;
+	}
+	chain nonbase {
+	}
+}
+
+table netdev ctz {
+	chain ingress {
+		type filter hook ingress priority 0;
+		policy accept;
+	}
+	chain nonbase {
+	}
+}
+EOF
+
+# Conditionally add netdev egress and inet ingress when supported.
+if [ "${NFT_TEST_HAVE_netdev_egress}" = "y" ]; then
+$NFT -f - <<EOF
+	table netdev ctz {
+		chain egress {
+			type filter hook egress priority 0;
+			policy accept;
+		}
+	}
+EOF
+fi
+
+if [ "${NFT_TEST_HAVE_inet_ingress}" = "y" ]; then
+$NFT -f - <<EOF
+	table inet ctz {
+		chain ingress {
+			type filter hook ingress priority 0;
+			policy accept;
+		}
+	}
+EOF
+fi
+
+# ---------------------------------------------------------------------------
+# Exercise every base chain.
+# Expected: "y" = ct zone set must be accepted, "n" = must be rejected.
+# ---------------------------------------------------------------------------
+
+# --- inet ---
+for family in ip ip6 inet; do
+	test_chain $family prerouting_before y
+	test_chain $family prerouting_at     n
+	test_chain $family prerouting_after  n
+	test_chain $family input             n
+	test_chain $family forward           n
+	test_chain $family output_before     y
+	test_chain $family output_at         n
+	test_chain $family output_after      n
+	test_chain $family postrouting       n
+done
+
+# --- bridge (OUTPUT is NOT expected to work) ---
+test_chain bridge prerouting_before y
+test_chain bridge prerouting_at     n
+test_chain bridge prerouting_after  n
+test_chain bridge input             n
+test_chain bridge forward           n
+test_chain bridge output_before     n
+test_chain bridge output_at         n
+test_chain bridge output_after      n
+test_chain bridge postrouting       n
+
+# --- arp ---
+test_chain arp input n
+test_chain arp output n
+
+# --- netdev ---
+test_chain netdev ingress n
+
+# ingress, arp in + out.
+if [ "${NFT_TEST_HAVE_netdev_egress}" = "y" ]; then
+	test_chain netdev egress n
+fi
+
+# --- inet ingress (if supported) ---
+if [ "${NFT_TEST_HAVE_inet_ingress}" = "y" ]; then
+	test_chain inet ingress n
+fi
+
+# ---------------------------------------------------------------------------
+# Evaluate results.
+# ---------------------------------------------------------------------------
+echo "Bad $bad, actual_ok $actual_ok, expected_ok $expected_ok, total $total"
+
+if [ "$bad" -ne 0 ]; then
+	echo "FAIL: $bad unexpected result(s) out of $total"
+	exit 1
+fi
+
+# Expected successes and failures matched exactly.
+if [ "$actual_ok" -eq "$expected_ok" ]; then
+	exit 0
+fi
+
+actual_ok=$((actual_ok+expected_fail))
+if [ "$actual_ok" -eq "$total" ]; then
+	# Every chain accepted ct zone set -- kernel does not enforce the
+	# restriction, so the test has nothing to verify.
+	# This can hopefully be removed in the future.
+	exit 77
+fi
+
+# Unexpected
+echo "Error: no rules failed, but inconsistent number of passed/failed tests"
+exit 1
-- 
2.55.0

