Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299C483CCB
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2024 21:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720647712; cv=none; b=uu0zglQQmuPrGFZi+O6GXsH2BOLiRyGC9Cl8kDPces0/p0Cco0F8qweeofgIT/32tZuuDm4qZYSR9He8xdLqG/SorxZzsPVlszxpd5FjWMGu9VrqdAJx/ixK2qsgJC7taBiSIKCoAS5XPEBkV4wfhQBNJdDoNR+U/IumJB09rgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720647712; c=relaxed/simple;
	bh=RUaB9VJH9jLCgAZlCY2cqlnOpwijbZnSur0S0nPNpYg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gx7YHQi2lrMR9lf1U6yb9RDq7pFLIuSkZqP4NvkgnvYehLdYqEk7AtzOYd7LU4SfrwYqr46rKP41Qza1YkCiccM2rH9Aee5P53Hlp3/o5cF4kDA6seXiyDlI3c0ONMyWS6vYjqflZmT2IUpLjWDcRj7BBTaMaI1UNZZUfS1ze4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sRf4O-0000mN-C3; Wed, 10 Jul 2024 23:41:48 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] tests: add more ruleset validation test cases
Date: Wed, 10 Jul 2024 23:42:18 +0200
Message-ID: <20240710214224.11841-1-fw@strlen.de>
X-Mailer: git-send-email 2.44.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Same as existing tests, but try harder to fool the validation:

1. Add a ruleset where the jump that that exceeds 16 is "broken", i.e.
   c0 -> c1 ... -> c8
   c9-> c1 ... -> c16

Where c0 is a base chain, with a graph thats really a linear list
from c0 to c8 and c9 to c16 is a linear list not connected to the former
or a hook point.

Then try to link them either directly via jump/goto rule or indirectly
with a verdict map.

Try both unbound map with element doing 'goto c9' and then trying to add
vmap rule to c8 (must fail, creates link).

Then try reverse: with empty map, add vmap rule to c8 (should work, no
elements...).

Then, add map element with jump or goto to c9.  This should be rejected.

Try the same thing with a tproxy expression in a user-defined chain:
attempt to make it reachable from c0 (filter input), which is illegal.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/transactions/bad_rule_graphs    | 262 ++++++++++++++++++
 .../dumps/bad_rule_graphs.json-nft            | 201 ++++++++++++++
 .../transactions/dumps/bad_rule_graphs.nft    |  30 ++
 3 files changed, 493 insertions(+)
 create mode 100755 tests/shell/testcases/transactions/bad_rule_graphs
 create mode 100644 tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
 create mode 100644 tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft

diff --git a/tests/shell/testcases/transactions/bad_rule_graphs b/tests/shell/testcases/transactions/bad_rule_graphs
new file mode 100755
index 000000000000..53047c3c229f
--- /dev/null
+++ b/tests/shell/testcases/transactions/bad_rule_graphs
@@ -0,0 +1,262 @@
+#!/bin/bash
+
+# test case to attempt to fool ruleset validation.
+# Initial ruleset added here is fine, then we try to make the
+# ruleset exceed the jump chain depth via jumps, gotos, verdict
+# map entries etc, either by having the map loop back to itself,
+# jumping back to an earlier chain and so on.
+#
+# Also check that can't hook up a user-defined chain with a
+# restricted expression (here: tproxy, only valid from prerouting
+# hook) to the input hook, even if reachable indirectly via vmap.
+
+bad_ruleset()
+{
+	ret=$1
+	shift
+
+	if [ $ret -eq 0 ];then
+		echo "Accepted bad ruleset with $@"
+		$NFT list ruleset
+		exit 1
+	fi
+}
+
+good_ruleset()
+{
+	ret=$1
+	shift
+
+	if [ $ret -ne 0 ];then
+		echo "Rejected good ruleset with $@"
+		exit 1
+	fi
+}
+
+# add a loop with a vmap statement, either goto or jump,
+# both with single rule and delta-transaction that also
+# contains valid information.
+check_loop()
+{
+	what=$1
+
+	$NFT "add element t m { 1.2.3.9 : $what c1 }"
+	bad_ruleset $? "bound map with $what to backjump should exceed jump stack"
+
+	$NFT "add element t m { 1.2.3.9 : $what c7 }"
+	bad_ruleset $? "bound map with $what to backjump should exceed jump stack"
+
+	$NFT "add element t m { 1.2.3.9 : $what c8 }"
+	bad_ruleset $? "bound map with $what to self should exceed jump stack"
+
+	# rule bound to c8, this should not work -- jump stack should be exceeded.
+	$NFT "add element t m { 1.2.3.9 : jump c9 }"
+	bad_ruleset $? "bound map with $what should exceed jump stack"
+
+	# rule bound to c8, this should be within jump stack limit
+	$NFT "add element t m { 1.2.3.9 : jump c10 }"
+	good_ruleset $? "bound map with $what should not have exceeded jump stack"
+
+$NFT -f - <<EOF
+flush chain t c16
+flush chain t c15
+table t {
+	chain c9 {
+		ip protocol 6 goto c14
+	}
+
+	# calls @m again, but @m now runs c10, which is linked to c14 already.
+	chain c14 {
+		ip protocol 6 return
+		ip daddr vmap @m
+	}
+}
+EOF
+	bad_ruleset $? "delta with bound map with $what loop and rule deletions"
+
+	# delete mapping again
+	$NFT "delete element t m { 1.2.3.9 }"
+	good_ruleset $? "cannot delete mapping"
+}
+
+check_bad_expr()
+{
+$NFT -f -<<EOF
+table t {
+	chain c1 {
+		jump c9
+	}
+}
+EOF
+bad_ruleset $? "tproxy expr exposed to input hook"
+
+$NFT -f -<<EOF
+flush map t m
+
+table t {
+	chain c1 {
+		ip saddr vmap @m
+	}
+}
+EOF
+good_ruleset $? "bound vmap to c1"
+
+$NFT -f -<<EOF
+table t {
+	map m {
+		type ipv4_addr : verdict
+		elements = { 1.2.3.4 : jump c9 }
+	}
+}
+EOF
+bad_ruleset $? "tproxy expr exposed to input hook by vmap"
+
+$NFT -f -<<EOF
+flush chain t c10
+flush chain t c11
+add rule t c8 jump c9
+
+table t {
+	map m {
+		type ipv4_addr : verdict
+		elements = { 1.2.3.4 : goto c2 }
+	}
+}
+EOF
+bad_ruleset $? "tproxy expr exposed to input hook by vmap"
+
+$NFT -f -<<EOF
+flush chain t c2
+flush chain t c3
+flush chain t c4
+flush chain t c5
+flush chain t c6
+flush chain t c7
+flush chain t c10
+flush chain t c11
+flush chain t c12
+flush chain t c13
+flush chain t c14
+flush chain t c15
+flush chain t c16
+delete chain t c16
+delete chain t c15
+delete chain t c14
+delete chain t c13
+delete chain t c12
+delete chain t c11
+delete chain t c7
+delete chain t c6
+delete chain t c5
+delete chain t c4
+delete chain t c3
+add rule t c8 jump c9
+EOF
+good_ruleset $? "connect chain c8 to chain c9"
+
+$NFT -f -<<EOF
+table t {
+	map m {
+		type ipv4_addr : verdict
+		elements = { 1.2.3.4 : goto c8 }
+	}
+}
+EOF
+bad_ruleset $? "tproxy expr exposed to input hook by vmap c1 -> vmap -> c8 -> c9"
+}
+
+# 16 jump levels are permitted.
+# First ruleset is fine, there is no jump
+# from c8 to c9.
+$NFT -f - <<EOF
+table t {
+	map m {
+		type ipv4_addr : verdict
+	}
+
+	chain c16 { }
+	chain c15 { jump c16; }
+	chain c14 { jump c15; }
+	chain c13 { jump c14; }
+	chain c12 { jump c13; }
+	chain c11 { jump c12; }
+	chain c10 { jump c11; }
+	chain c9 { jump c10; }
+	chain c8 { }
+	chain c7 { jump c8; }
+	chain c6 { jump c7; }
+	chain c5 { jump c6; }
+	chain c4 { jump c5; }
+	chain c3 { jump c4; }
+	chain c2 { jump c3; }
+	chain c1 { jump c2; }
+	chain c0 { type filter hook input priority 0;
+		jump c1
+	}
+}
+EOF
+
+ret=$?
+if [ $ret -ne 0 ];then
+	exit 1
+fi
+
+# ensure kernel catches the exceeded jumpstack use, despite no new chains
+# are added here and cycle is acyclic.
+$NFT -f - <<EOF
+# unrelated rule.
+add rule t c14 accept
+add rule t c15 accept
+
+# close jump gap; after this jumpstack limit is exceeded.
+add rule t c8 goto c9
+
+# unrelated rules.
+add rule t c14 accept
+add rule t c15 accept
+EOF
+
+bad_ruleset $? "chain jump stack exhausted without cycle"
+
+$NFT -f - <<EOF
+# unrelated rule.
+add rule t c12 accept
+add rule t c13 accept
+
+add element t m { 1.2.3.1 : accept }
+add element t m { 1.2.3.16 : goto c16 }
+add element t m { 1.2.3.15 : goto c15 }
+
+# after this jumpstack limit is exceeded,
+# IFF @m was bound to c8, but it is not.
+add element t m { 1.2.3.9 : jump c9 }
+
+# unrelated rules.
+add rule t c12 accept
+add rule t c13 accept
+
+add element t m { 1.2.3.16 : goto c16 }
+EOF
+good_ruleset $? "unbounded map"
+
+# bind vmap to c8.  This MUST fail, map jumps to c9.
+$NFT "add rule t c8 ip saddr vmap @m"
+bad_ruleset $? "jump c8->c9 via vmap expression"
+
+# delete the mapping again.
+$NFT "delete element t m { 1.2.3.9 }"
+$NFT "add rule t c8 ip saddr vmap @m"
+good_ruleset $? "bind empty map to c8"
+
+check_loop "jump"
+check_loop "goto"
+
+$NFT "flush chain t c8"
+good_ruleset $? "flush chain t c8"
+
+# should work, c9 not connected to c0 aka filter input.
+$NFT "add rule t c9 tcp dport 80 tproxy to :20000 meta mark set 1 accept"
+good_ruleset $? "add tproxy expression to c9"
+check_bad_expr
+
+exit $?
diff --git a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
new file mode 100644
index 000000000000..30789211ff4a
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.json-nft
@@ -0,0 +1,201 @@
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
+        "name": "c10",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c9",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c8",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c2",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c1",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c0",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
+    {
+      "map": {
+        "family": "ip",
+        "name": "m",
+        "table": "t",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict"
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c9",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "c10"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c9",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "payload": {
+                  "protocol": "tcp",
+                  "field": "dport"
+                }
+              },
+              "right": 80
+            }
+          },
+          {
+            "tproxy": {
+              "port": 20000
+            }
+          },
+          {
+            "mangle": {
+              "key": {
+                "meta": {
+                  "key": "mark"
+                }
+              },
+              "value": 1
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
+        "family": "ip",
+        "table": "t",
+        "chain": "c8",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "c9"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c1",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "c2"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c1",
+        "handle": 0,
+        "expr": [
+          {
+            "vmap": {
+              "key": {
+                "payload": {
+                  "protocol": "ip",
+                  "field": "saddr"
+                }
+              },
+              "data": "@m"
+            }
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "t",
+        "chain": "c0",
+        "handle": 0,
+        "expr": [
+          {
+            "jump": {
+              "target": "c1"
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft
new file mode 100644
index 000000000000..3a5936500c6e
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/bad_rule_graphs.nft
@@ -0,0 +1,30 @@
+table ip t {
+	map m {
+		type ipv4_addr : verdict
+	}
+
+	chain c10 {
+	}
+
+	chain c9 {
+		jump c10
+		tcp dport 80 tproxy to :20000 meta mark set 0x00000001 accept
+	}
+
+	chain c8 {
+		jump c9
+	}
+
+	chain c2 {
+	}
+
+	chain c1 {
+		jump c2
+		ip saddr vmap @m
+	}
+
+	chain c0 {
+		type filter hook input priority filter; policy accept;
+		jump c1
+	}
+}
-- 
2.44.2

