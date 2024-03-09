Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CA1381A4
	for <netfilter-devel@vger.kernel.org>; Sat,  9 Mar 2024 11:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709984140; cv=none; b=aRMa6C512rdHBjPm6zYYJtcA6WoxSnP/pJ02xLbZ8muXgUZY5M4ZAEMxOoS5d7Zp4RFobVjKFmRfbc2YlDsVcfoyX0tYHhrZn+Qgfflykywn/UMHDckLNatU8J+7wBfmBg9sC3+3WrtmBqgHYfurxBwnkUBk2DljHi9LZCJLPlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709984140; c=relaxed/simple;
	bh=A6Rr4mlgKu9vr/eMWIv4YanJYJMF3GNC1P8Vx4ajt/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDQ+XduSGea6JoLEi9C9SAQZFkOHTlnaBAoCNG4T9AAWin3Ae1md7IZia8cWWuICDZPuQMO6WMj6BQRAWXFAAV6dpnWWS5gLXJ+IjHtvV62KWCl+L5yEbHqbXjkBPKnqRjKmG9t6qhy1/zL3GdtpzCabHetZ1FbhAIp2EBDNUN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=puVS7ruW; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="puVS7ruW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=enhodQDtnvRNu2znwbDK1h0+xXifCve1rOq6ErVv260=; b=puVS7ruWcRv4+wdG56Z3DLBe2r
	ntCs5/A7mAyGkrKoyYG4goGOCGjrNh5L7UO6w2kzQEDypT6pV2ldfL4H8FwWASsePrri9lJd553jT
	0hKf0unpK3C94qY9VYcW2P3ckB7CBg0oZ9jm7U6YnuhHybmRZas8LcyRIh+BEtixpKWj9frmO/sMw
	fjXrFhVxfOPsIIuj57EaseXjdk9KuZKecA08+PzCRA18p+TzqvCvRrHx0gOrdG7Zj4te2Xx6uEGpV
	v82pmcnkhoz8iTR7ZXy+BoftKSvoJOXDeKHi7QrkLlH+QpgI356cEt6CJ2L3K7qFrNh0CY/VeazZm
	4vC6E+Vg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1riuzH-000000003hh-2OSt;
	Sat, 09 Mar 2024 12:35:35 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nft PATCH 4/7] tests: shell: Regenerate all json-nft dumps
Date: Sat,  9 Mar 2024 12:35:24 +0100
Message-ID: <20240309113527.8723-5-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240309113527.8723-1-phil@nwl.cc>
References: <20240309113527.8723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ordering of 'nft -j list ruleset' output has changed, Regenerate
existing json-nft dumps. No functional change intended, merely the
position of chain objects should have moved up in the "nftables" array.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../dumps/0001_cache_handling_0.json-nft      | 16 ++++----
 .../dumps/0005_cache_chain_flush.json-nft     | 28 ++++++-------
 .../dumps/0006_cache_table_flush.json-nft     | 28 ++++++-------
 .../comments/dumps/comments_0.json-nft        | 16 ++++----
 .../flowtable/dumps/0001flowtable_0.json-nft  | 16 ++++----
 .../dumps/0005delete_in_use_1.json-nft        | 16 ++++----
 .../dumps/0014addafterdelete_0.json-nft       | 22 +++++-----
 .../json/dumps/0001set_statements_0.json-nft  | 24 +++++------
 .../json/dumps/0005secmark_objref_0.json-nft  | 18 ++++-----
 .../listing/dumps/0013objects_0.json-nft      | 16 ++++----
 .../dumps/0021ruleset_json_terse_0.json-nft   | 16 ++++----
 .../listing/dumps/0022terse_0.json-nft        | 24 +++++------
 .../dumps/0007named_ifname_dtype_0.json-nft   | 16 ++++----
 .../dumps/0008interval_map_delete_0.json-nft  | 24 +++++------
 .../testcases/maps/dumps/0012map_0.json-nft   | 16 ++++----
 .../maps/dumps/0012map_concat_0.json-nft      | 24 +++++------
 .../testcases/maps/dumps/0013map_0.json-nft   | 24 +++++------
 .../maps/dumps/anon_objmap_concat.json-nft    | 24 +++++------
 .../maps/dumps/named_limits.json-nft          | 24 +++++------
 .../maps/dumps/named_snat_map_0.json-nft      | 16 ++++----
 .../maps/dumps/pipapo_double_flush.json-nft   | 16 ++++----
 .../dumps/typeof_maps_add_delete.json-nft     | 40 +++++++++----------
 .../maps/dumps/typeof_maps_update_0.json-nft  | 32 +++++++--------
 .../nft-f/dumps/0002rollback_rule_0.json-nft  | 22 +++++-----
 .../nft-f/dumps/0003rollback_jump_0.json-nft  | 22 +++++-----
 .../nft-f/dumps/0004rollback_set_0.json-nft   | 22 +++++-----
 .../nft-f/dumps/0005rollback_map_0.json-nft   | 22 +++++-----
 .../nft-f/dumps/0017ct_timeout_obj_0.json-nft | 16 ++++----
 .../dumps/0018ct_expectation_obj_0.json-nft   | 16 ++++----
 .../nft-f/dumps/0022variables_0.json-nft      | 24 +++++------
 .../nft-f/dumps/0029split_file_0.json-nft     | 18 ++++-----
 .../nft-f/dumps/0032pknock_0.json-nft         | 24 +++++------
 .../optimizations/dumps/merge_vmaps.json-nft  | 26 ++++++------
 .../optimizations/dumps/skip_merge.json-nft   | 32 +++++++--------
 .../dumps/skip_unsupported.json-nft           | 16 ++++----
 .../packetpath/dumps/set_lookups.json-nft     | 24 +++++------
 .../dumps/0011reset_0.json-nft                | 32 +++++++--------
 .../sets/dumps/0001named_interval_0.json-nft  | 16 ++++----
 .../dumps/0022type_selective_flush_0.json-nft | 16 ++++----
 .../sets/dumps/0026named_limit_0.json-nft     | 22 +++++-----
 .../sets/dumps/0028autoselect_0.json-nft      | 24 +++++------
 .../0037_set_with_inet_service_0.json-nft     | 24 +++++------
 .../sets/dumps/0038meter_list_0.json-nft      | 16 ++++----
 .../sets/dumps/0042update_set_0.json-nft      | 16 ++++----
 .../dumps/0043concatenated_ranges_0.json-nft  | 24 +++++------
 .../dumps/0045concat_ipv4_service.json-nft    | 16 ++++----
 .../sets/dumps/0048set_counters_0.json-nft    | 24 +++++------
 .../sets/dumps/0049set_define_0.json-nft      | 24 +++++------
 .../dumps/0051set_interval_counter_0.json-nft | 24 +++++------
 .../dumps/0058_setupdate_timeout_0.json-nft   | 16 ++++----
 .../dumps/0059set_update_multistmt_0.json-nft | 24 +++++------
 .../sets/dumps/0060set_multistmt_0.json-nft   | 24 +++++------
 .../sets/dumps/0060set_multistmt_1.json-nft   | 24 +++++------
 .../sets/dumps/0064map_catchall_0.json-nft    | 16 ++++----
 .../0071unclosed_prefix_interval_0.json-nft   | 16 ++++----
 .../sets/dumps/dynset_missing.json-nft        | 24 +++++------
 .../testcases/sets/dumps/inner_0.json-nft     | 16 ++++----
 .../testcases/sets/dumps/set_eval_0.json-nft  | 24 +++++------
 .../sets/dumps/type_set_symbol.json-nft       | 32 +++++++--------
 .../transactions/dumps/0040set_0.json-nft     | 20 +++++-----
 60 files changed, 647 insertions(+), 647 deletions(-)

diff --git a/tests/shell/testcases/cache/dumps/0001_cache_handling_0.json-nft b/tests/shell/testcases/cache/dumps/0001_cache_handling_0.json-nft
index 752196624c33f..7a2eacdd7b614 100644
--- a/tests/shell/testcases/cache/dumps/0001_cache_handling_0.json-nft
+++ b/tests/shell/testcases/cache/dumps/0001_cache_handling_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "test",
+        "name": "test",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -27,14 +35,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "test",
-        "name": "test",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/cache/dumps/0005_cache_chain_flush.json-nft b/tests/shell/testcases/cache/dumps/0005_cache_chain_flush.json-nft
index dbf561175a1b7..1c47d3ef0a266 100644
--- a/tests/shell/testcases/cache/dumps/0005_cache_chain_flush.json-nft
+++ b/tests/shell/testcases/cache/dumps/0005_cache_chain_flush.json-nft
@@ -15,34 +15,34 @@
       }
     },
     {
-      "map": {
+      "chain": {
         "family": "ip",
-        "name": "mapping",
         "table": "x",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "map": "inet_service",
-        "size": 65535,
-        "flags": [
-          "timeout",
-          "dynamic"
-        ]
+        "name": "y",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "x",
-        "name": "y",
+        "name": "z",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "map": {
         "family": "ip",
+        "name": "mapping",
         "table": "x",
-        "name": "z",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "inet_service",
+        "size": 65535,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/cache/dumps/0006_cache_table_flush.json-nft b/tests/shell/testcases/cache/dumps/0006_cache_table_flush.json-nft
index dbf561175a1b7..1c47d3ef0a266 100644
--- a/tests/shell/testcases/cache/dumps/0006_cache_table_flush.json-nft
+++ b/tests/shell/testcases/cache/dumps/0006_cache_table_flush.json-nft
@@ -15,34 +15,34 @@
       }
     },
     {
-      "map": {
+      "chain": {
         "family": "ip",
-        "name": "mapping",
         "table": "x",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "map": "inet_service",
-        "size": 65535,
-        "flags": [
-          "timeout",
-          "dynamic"
-        ]
+        "name": "y",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "x",
-        "name": "y",
+        "name": "z",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "map": {
         "family": "ip",
+        "name": "mapping",
         "table": "x",
-        "name": "z",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "inet_service",
+        "size": 65535,
+        "flags": [
+          "timeout",
+          "dynamic"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/comments/dumps/comments_0.json-nft b/tests/shell/testcases/comments/dumps/comments_0.json-nft
index 28898a52608d3..201abd6fb5ce1 100644
--- a/tests/shell/testcases/comments/dumps/comments_0.json-nft
+++ b/tests/shell/testcases/comments/dumps/comments_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -27,14 +35,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "x",
-        "name": "y",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.json-nft b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.json-nft
index 090c974456ca6..4d15fe3a39d17 100644
--- a/tests/shell/testcases/flowtable/dumps/0001flowtable_0.json-nft
+++ b/tests/shell/testcases/flowtable/dumps/0001flowtable_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "flowtable": {
         "family": "inet",
@@ -25,14 +33,6 @@
         "dev": "lo"
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.json-nft b/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.json-nft
index db73a53036632..302502dcab098 100644
--- a/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.json-nft
+++ b/tests/shell/testcases/flowtable/dumps/0005delete_in_use_1.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "x",
+        "handle": 0
+      }
+    },
     {
       "flowtable": {
         "family": "ip",
@@ -25,14 +33,6 @@
         "dev": "lo"
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "x",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.json-nft b/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.json-nft
index 79707ca30d958..471ba5be0faeb 100644
--- a/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.json-nft
+++ b/tests/shell/testcases/flowtable/dumps/0014addafterdelete_0.json-nft
@@ -14,17 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "flowtable": {
-        "family": "inet",
-        "name": "f",
-        "table": "filter",
-        "handle": 0,
-        "hook": "ingress",
-        "prio": -1,
-        "dev": "lo"
-      }
-    },
     {
       "chain": {
         "family": "inet",
@@ -37,6 +26,17 @@
         "policy": "accept"
       }
     },
+    {
+      "flowtable": {
+        "family": "inet",
+        "name": "f",
+        "table": "filter",
+        "handle": 0,
+        "hook": "ingress",
+        "prio": -1,
+        "dev": "lo"
+      }
+    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
index 3830b8450a93b..91db43e29ea9f 100644
--- a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "testt",
+        "name": "testc",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -27,18 +39,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "testt",
-        "name": "testc",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/json/dumps/0005secmark_objref_0.json-nft b/tests/shell/testcases/json/dumps/0005secmark_objref_0.json-nft
index f5519a6ed49ac..3783c6b78f5b2 100644
--- a/tests/shell/testcases/json/dumps/0005secmark_objref_0.json-nft
+++ b/tests/shell/testcases/json/dumps/0005secmark_objref_0.json-nft
@@ -14,15 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "secmark": {
-        "family": "inet",
-        "name": "ssh_server",
-        "table": "x",
-        "handle": 0,
-        "context": "system_u:object_r:ssh_server_packet_t:s0"
-      }
-    },
     {
       "chain": {
         "family": "inet",
@@ -47,6 +38,15 @@
         "policy": "accept"
       }
     },
+    {
+      "secmark": {
+        "family": "inet",
+        "name": "ssh_server",
+        "table": "x",
+        "handle": 0,
+        "context": "system_u:object_r:ssh_server_packet_t:s0"
+      }
+    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/listing/dumps/0013objects_0.json-nft b/tests/shell/testcases/listing/dumps/0013objects_0.json-nft
index feb32b1b34329..830aad85cad87 100644
--- a/tests/shell/testcases/listing/dumps/0013objects_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0013objects_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "input",
+        "handle": 0
+      }
+    },
     {
       "quota": {
         "family": "ip",
@@ -62,14 +70,6 @@
         "size": 12,
         "l3proto": "ip"
       }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "test",
-        "name": "input",
-        "handle": 0
-      }
     }
   ]
 }
diff --git a/tests/shell/testcases/listing/dumps/0021ruleset_json_terse_0.json-nft b/tests/shell/testcases/listing/dumps/0021ruleset_json_terse_0.json-nft
index e9bc05ac7be1a..d1131bb4045fd 100644
--- a/tests/shell/testcases/listing/dumps/0021ruleset_json_terse_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0021ruleset_json_terse_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -26,14 +34,6 @@
           "192.168.3.5"
         ]
       }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "test",
-        "name": "c",
-        "handle": 0
-      }
     }
   ]
 }
diff --git a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
index db19d0c3c2b5b..bd6383dac5e37 100644
--- a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "prerouting",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -30,18 +42,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "prerouting",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/maps/dumps/0007named_ifname_dtype_0.json-nft b/tests/shell/testcases/maps/dumps/0007named_ifname_dtype_0.json-nft
index ec409c6cb361a..ef57a749fbeed 100644
--- a/tests/shell/testcases/maps/dumps/0007named_ifname_dtype_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0007named_ifname_dtype_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "inet",
@@ -30,14 +38,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
index 0f8f25dcf77c5..bd3c6cc7ebf55 100644
--- a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -37,18 +49,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "filter",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
index e546a67979369..2892e11d71f54 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -44,14 +52,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "y",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
index 08fce28624c01..000522365df9f 100644
--- a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "k",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 1,
+        "policy": "accept"
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -66,18 +78,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "k",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 1,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.json-nft b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
index 0379746a1e062..e91a269d8e6e6 100644
--- a/tests/shell/testcases/maps/dumps/0013map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "FORWARD",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "drop"
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -58,18 +70,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "filter",
-        "name": "FORWARD",
-        "handle": 0,
-        "type": "filter",
-        "hook": "forward",
-        "prio": 0,
-        "policy": "drop"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft b/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
index f8352344eec73..642098427e6f9 100644
--- a/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
+++ b/tests/shell/testcases/maps/dumps/anon_objmap_concat.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
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
     {
       "ct helper": {
         "family": "inet",
@@ -36,18 +48,6 @@
         "l3proto": "ip"
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
index 28a92529c8d29..7fa1298103832 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
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
     {
       "limit": {
         "family": "inet",
@@ -251,18 +263,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/maps/dumps/named_snat_map_0.json-nft b/tests/shell/testcases/maps/dumps/named_snat_map_0.json-nft
index ed141597f7f85..ad9eb36eac94e 100644
--- a/tests/shell/testcases/maps/dumps/named_snat_map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_snat_map_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "nat",
+        "name": "postrouting",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -30,14 +38,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "nat",
-        "name": "postrouting",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
index 5cb600dbd0eed..ef8c3930f8153 100644
--- a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
+++ b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "inet",
@@ -29,14 +37,6 @@
           "interval"
         ]
       }
-    },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
     }
   ]
 }
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index 4a58602a99cd4..8130c46c154cd 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -14,26 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "map": {
-        "family": "ip",
-        "name": "dynmark",
-        "table": "dynset",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "map": "mark",
-        "size": 64,
-        "flags": [
-          "timeout"
-        ],
-        "timeout": 300,
-        "stmt": [
-          {
-            "counter": null
-          }
-        ]
-      }
-    },
     {
       "chain": {
         "family": "ip",
@@ -54,6 +34,26 @@
         "policy": "accept"
       }
     },
+    {
+      "map": {
+        "family": "ip",
+        "name": "dynmark",
+        "table": "dynset",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "mark",
+        "size": 64,
+        "flags": [
+          "timeout"
+        ],
+        "timeout": 300,
+        "stmt": [
+          {
+            "counter": null
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
index 826785d1fc04d..1d50477d783df 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
@@ -14,6 +14,22 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "kube-nfproxy-v4",
+        "name": "k8s-nfproxy-sep-TMVEFT7EX55F4T62",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "kube-nfproxy-v4",
+        "name": "k8s-nfproxy-sep-GMVEFT7EX55F4T62",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -44,22 +60,6 @@
         "timeout": 60
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "kube-nfproxy-v4",
-        "name": "k8s-nfproxy-sep-TMVEFT7EX55F4T62",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "kube-nfproxy-v4",
-        "name": "k8s-nfproxy-sep-GMVEFT7EX55F4T62",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.json-nft b/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.json-nft
index 8d500578d998c..99b0b28defb4d 100644
--- a/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0002rollback_rule_0.json-nft
@@ -15,31 +15,31 @@
       }
     },
     {
-      "set": {
+      "chain": {
         "family": "ip",
-        "name": "t",
         "table": "t",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "elem": [
-          "1.1.1.1"
-        ]
+        "name": "c",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "t",
-        "name": "c",
+        "name": "other",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "set": {
         "family": "ip",
+        "name": "t",
         "table": "t",
-        "name": "other",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "elem": [
+          "1.1.1.1"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.json-nft b/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.json-nft
index 8d500578d998c..99b0b28defb4d 100644
--- a/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0003rollback_jump_0.json-nft
@@ -15,31 +15,31 @@
       }
     },
     {
-      "set": {
+      "chain": {
         "family": "ip",
-        "name": "t",
         "table": "t",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "elem": [
-          "1.1.1.1"
-        ]
+        "name": "c",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "t",
-        "name": "c",
+        "name": "other",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "set": {
         "family": "ip",
+        "name": "t",
         "table": "t",
-        "name": "other",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "elem": [
+          "1.1.1.1"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.json-nft b/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.json-nft
index 8d500578d998c..99b0b28defb4d 100644
--- a/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0004rollback_set_0.json-nft
@@ -15,31 +15,31 @@
       }
     },
     {
-      "set": {
+      "chain": {
         "family": "ip",
-        "name": "t",
         "table": "t",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "elem": [
-          "1.1.1.1"
-        ]
+        "name": "c",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "t",
-        "name": "c",
+        "name": "other",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "set": {
         "family": "ip",
+        "name": "t",
         "table": "t",
-        "name": "other",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "elem": [
+          "1.1.1.1"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.json-nft b/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.json-nft
index 8d500578d998c..99b0b28defb4d 100644
--- a/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0005rollback_map_0.json-nft
@@ -15,31 +15,31 @@
       }
     },
     {
-      "set": {
+      "chain": {
         "family": "ip",
-        "name": "t",
         "table": "t",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "elem": [
-          "1.1.1.1"
-        ]
+        "name": "c",
+        "handle": 0
       }
     },
     {
       "chain": {
         "family": "ip",
         "table": "t",
-        "name": "c",
+        "name": "other",
         "handle": 0
       }
     },
     {
-      "chain": {
+      "set": {
         "family": "ip",
+        "name": "t",
         "table": "t",
-        "name": "other",
-        "handle": 0
+        "type": "ipv4_addr",
+        "handle": 0,
+        "elem": [
+          "1.1.1.1"
+        ]
       }
     },
     {
diff --git a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.json-nft b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.json-nft
index 581d4d415ae58..b56240eab0cf3 100644
--- a/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0017ct_timeout_obj_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "ct timeout": {
         "family": "ip",
@@ -28,14 +36,6 @@
         }
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "filter",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/nft-f/dumps/0018ct_expectation_obj_0.json-nft b/tests/shell/testcases/nft-f/dumps/0018ct_expectation_obj_0.json-nft
index 5e2b07f0d7ace..21c979703e096 100644
--- a/tests/shell/testcases/nft-f/dumps/0018ct_expectation_obj_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0018ct_expectation_obj_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "filter",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "ct expectation": {
         "family": "ip",
@@ -27,14 +35,6 @@
         "l3proto": "ip"
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "filter",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/nft-f/dumps/0022variables_0.json-nft b/tests/shell/testcases/nft-f/dumps/0022variables_0.json-nft
index b971454fc3ae0..09a4c1e3deb8f 100644
--- a/tests/shell/testcases/nft-f/dumps/0022variables_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0022variables_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "z",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -28,18 +40,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "z",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/nft-f/dumps/0029split_file_0.json-nft b/tests/shell/testcases/nft-f/dumps/0029split_file_0.json-nft
index c2aa400aa150f..ab680af8712d6 100644
--- a/tests/shell/testcases/nft-f/dumps/0029split_file_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0029split_file_0.json-nft
@@ -14,15 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "set": {
-        "family": "inet",
-        "name": "whitelist_v4",
-        "table": "filter",
-        "type": "ipv4_addr",
-        "handle": 0
-      }
-    },
     {
       "chain": {
         "family": "inet",
@@ -35,6 +26,15 @@
         "policy": "accept"
       }
     },
+    {
+      "set": {
+        "family": "inet",
+        "name": "whitelist_v4",
+        "table": "filter",
+        "type": "ipv4_addr",
+        "handle": 0
+      }
+    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/nft-f/dumps/0032pknock_0.json-nft b/tests/shell/testcases/nft-f/dumps/0032pknock_0.json-nft
index 57d57bb9ea8c3..4c7d2bbe3f843 100644
--- a/tests/shell/testcases/nft-f/dumps/0032pknock_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0032pknock_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "portknock",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": -10,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -45,18 +57,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "portknock",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": -10,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
index f2ac7917cd590..e87f1c4c082eb 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
@@ -14,19 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "set": {
-        "family": "ip",
-        "name": "s",
-        "table": "x",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
-      }
-    },
     {
       "chain": {
         "family": "ip",
@@ -51,6 +38,19 @@
         "handle": 0
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "s",
+        "table": "x",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "size": 65535,
+        "flags": [
+          "dynamic"
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/optimizations/dumps/skip_merge.json-nft b/tests/shell/testcases/optimizations/dumps/skip_merge.json-nft
index 3404a2e7521a6..7bb6c656435f5 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_merge.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_merge.json-nft
@@ -14,6 +14,22 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "udp_input",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "tcp_input",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -40,22 +56,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "udp_input",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "tcp_input",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
index a082020695b63..d6347b1eeed6e 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "x",
+        "name": "y",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -100,14 +108,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "x",
-        "name": "y",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
index 49b51ababd773..24363f9071b22 100644
--- a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
+++ b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -136,18 +148,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
index 94203517cedb3..bc242467e22a7 100644
--- a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
@@ -14,6 +14,22 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
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
     {
       "set": {
         "family": "ip",
@@ -43,22 +59,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c2",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
index c48f3a9c918f4..b9c66a21aa084 100644
--- a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -124,14 +132,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
index c82c12a171a54..ce391a6c37f9c 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -33,14 +41,6 @@
         "map": "inet_service"
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0026named_limit_0.json-nft b/tests/shell/testcases/sets/dumps/0026named_limit_0.json-nft
index 5307e26567f16..5d21f26cd5a37 100644
--- a/tests/shell/testcases/sets/dumps/0026named_limit_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0026named_limit_0.json-nft
@@ -14,17 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "limit": {
-        "family": "ip",
-        "name": "http-traffic",
-        "table": "filter",
-        "handle": 0,
-        "rate": 1,
-        "per": "second",
-        "burst": 5
-      }
-    },
     {
       "chain": {
         "family": "ip",
@@ -37,6 +26,17 @@
         "policy": "accept"
       }
     },
+    {
+      "limit": {
+        "family": "ip",
+        "name": "http-traffic",
+        "table": "filter",
+        "handle": 0,
+        "rate": 1,
+        "per": "second",
+        "burst": 5
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
index 682496a71c5c5..5968b2e0c11f0 100644
--- a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -53,18 +65,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
index 3305f040e69cd..1c3b559d48d43 100644
--- a/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0037_set_with_inet_service_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "forward",
+        "handle": 0,
+        "type": "filter",
+        "hook": "forward",
+        "prio": 0,
+        "policy": "drop"
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -64,18 +76,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "forward",
-        "handle": 0,
-        "type": "filter",
-        "hook": "forward",
-        "prio": 0,
-        "policy": "drop"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
index be24687c96d79..40b86f82eba33 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -28,14 +36,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
index 8521adb8283d1..bc1d4cc2284d8 100644
--- a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -36,14 +44,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
index d51db88452872..ffb76e2f3641d 100644
--- a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "map": {
         "family": "inet",
@@ -32,18 +44,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "output",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
index 211942c9ae63a..8473c3333889e 100644
--- a/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
+++ b/tests/shell/testcases/sets/dumps/0045concat_ipv4_service.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -39,14 +47,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft b/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
index 2fa0e78848308..62a6a177b7776 100644
--- a/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0048set_counters_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "z",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -57,18 +69,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "z",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
index 79e376b6e2931..f8495bab8b0f3 100644
--- a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "input",
+        "handle": 0,
+        "type": "filter",
+        "hook": "input",
+        "prio": 0,
+        "policy": "drop"
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -30,18 +42,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "drop"
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
index 0e67375999382..b468b5f9044ca 100644
--- a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -47,18 +59,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "y",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.json-nft b/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.json-nft
index a727b25bdcb1b..ac8d8bef71e7e 100644
--- a/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0058_setupdate_timeout_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "filter",
+        "name": "test",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -29,14 +37,6 @@
         "timeout": 2592000
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "filter",
-        "name": "test",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.json-nft b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.json-nft
index 9e5fae761fd70..16ecdb2ab8993 100644
--- a/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0059set_update_multistmt_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "z",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -29,18 +41,6 @@
         "timeout": 3600
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "z",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
index 0026ba915af10..1aede147cacf3 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_0.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -67,18 +79,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "y",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
index 86b70b20c42c6..6098dc563141f 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -67,18 +79,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "y",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
index eba5d40ef5645..64dd26670528b 100644
--- a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "x",
+        "name": "y",
+        "handle": 0
+      }
+    },
     {
       "map": {
         "family": "ip",
@@ -62,14 +70,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "x",
-        "name": "y",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
index 426bf2d1e1577..6b579a2e09fff 100644
--- a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "t",
+        "name": "c",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "inet",
@@ -66,14 +74,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "inet",
-        "table": "t",
-        "name": "c",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "inet",
diff --git a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
index 3462d67f05562..ad8a7cc0564a8 100644
--- a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
+++ b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
@@ -14,6 +14,18 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "test",
+        "name": "output",
+        "handle": 0,
+        "type": "filter",
+        "hook": "output",
+        "prio": 0,
+        "policy": "accept"
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -27,18 +39,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "test",
-        "name": "output",
-        "handle": 0,
-        "type": "filter",
-        "hook": "output",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/inner_0.json-nft b/tests/shell/testcases/sets/dumps/inner_0.json-nft
index cc48de6b4f47f..8d84e1ccecb9f 100644
--- a/tests/shell/testcases/sets/dumps/inner_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/inner_0.json-nft
@@ -14,6 +14,14 @@
         "handle": 0
       }
     },
+    {
+      "chain": {
+        "family": "netdev",
+        "table": "x",
+        "name": "y",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "netdev",
@@ -47,14 +55,6 @@
         ]
       }
     },
-    {
-      "chain": {
-        "family": "netdev",
-        "table": "x",
-        "name": "y",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "netdev",
diff --git a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
index 4590b88403985..6f692381b6f7c 100644
--- a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
@@ -14,18 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "set": {
-        "family": "ip",
-        "name": "set_with_interval",
-        "table": "nat",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "flags": [
-          "interval"
-        ]
-      }
-    },
     {
       "chain": {
         "family": "ip",
@@ -38,6 +26,18 @@
         "policy": "accept"
       }
     },
+    {
+      "set": {
+        "family": "ip",
+        "name": "set_with_interval",
+        "table": "nat",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "flags": [
+          "interval"
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/sets/dumps/type_set_symbol.json-nft b/tests/shell/testcases/sets/dumps/type_set_symbol.json-nft
index e4ae0a2e3df24..e22213ea3437a 100644
--- a/tests/shell/testcases/sets/dumps/type_set_symbol.json-nft
+++ b/tests/shell/testcases/sets/dumps/type_set_symbol.json-nft
@@ -14,6 +14,22 @@
         "handle": 0
       }
     },
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
+        "name": "c2",
+        "handle": 0
+      }
+    },
     {
       "set": {
         "family": "ip",
@@ -33,22 +49,6 @@
         "timeout": 10800
       }
     },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c1",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "t",
-        "name": "c2",
-        "handle": 0
-      }
-    },
     {
       "rule": {
         "family": "ip",
diff --git a/tests/shell/testcases/transactions/dumps/0040set_0.json-nft b/tests/shell/testcases/transactions/dumps/0040set_0.json-nft
index f8130d95a0fc5..1718a5b9d8b3b 100644
--- a/tests/shell/testcases/transactions/dumps/0040set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0040set_0.json-nft
@@ -14,16 +14,6 @@
         "handle": 0
       }
     },
-    {
-      "map": {
-        "family": "ip",
-        "name": "client_to_any",
-        "table": "filter",
-        "type": "ipv4_addr",
-        "handle": 0,
-        "map": "verdict"
-      }
-    },
     {
       "chain": {
         "family": "ip",
@@ -44,6 +34,16 @@
         "handle": 0
       }
     },
+    {
+      "map": {
+        "family": "ip",
+        "name": "client_to_any",
+        "table": "filter",
+        "type": "ipv4_addr",
+        "handle": 0,
+        "map": "verdict"
+      }
+    },
     {
       "rule": {
         "family": "ip",
-- 
2.43.0

