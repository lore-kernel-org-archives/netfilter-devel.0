Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3EF15B0EF
	for <netfilter-devel@vger.kernel.org>; Thu,  8 May 2025 21:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746740853; cv=none; b=p+zCJjKQ3q15+5P3VXKT+Tb4SivG3FVxDKqijRGvlfcj8vkji75de9Pc/zAz+BQTpndp/tKwINdMSaBlIMpTD5yYlkAK6GaeN9jVsQSIOMtD8DdzX7LDSQFeJmx5XNncFNH1XC9jILg/ESBrD5FIQpU8DPjvOuxvNcwxGcV4gdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746740853; c=relaxed/simple;
	bh=qkOMplTXwB5Dm5YcmUTzjRr8gUm+5stB4fMYB0o0sFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwxsrqhScckA2ZOLfSBUMIpCXGAOPpBc6/jeCMcbWUiR1SSzruVrcugWwsV7eHsuE+IJrftDR4FGhI6aTtRna0RhjyX0LjP0UAUKUTgx1vwlDr33ncS335uwr77j1yXy3lT+eNZy5lrwO3maBv9ABljxPJu4qy5zFpIJBpP6WVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=Tho388Ex; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="Tho388Ex"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kHSr+y+RRjUVWCf4SxjK5P1A7qxJeso8DdzWeuFWqMM=; b=Tho388ExpB41meLpsI+vvkvFky
	YpHVsChySd35Hbt1neQE3GbzDMxMWdv2SJmW4IXana32kiHl+OI0AfneCs82tmoxvmKHhrlvBniIR
	7DLtwWgbklzIkACMr2TlpzsJmGb6ijjudi8hbgEKv46/1ayYTACIDJ9MRMItmYhO1eX0pHsEg69im
	HPa9bcy2toD/Hu5SMYIDUNSrlPSzz1g7g//17FCI4elM47lQgr7uBe3+lvAbQva8/LEi+Qyod7hGm
	50GxsS5MR4cTzxjvkpt7KbtgMb+rOyCcPpNi4LlJsdykmZuM15eO4mioqwxLac8P1onoEiz6Y8ZAP
	g0+rea1Q==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uD95T-000000000mi-3Wqb;
	Thu, 08 May 2025 23:47:27 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/6] json: Print single set flag as non-array
Date: Thu,  8 May 2025 23:47:18 +0200
Message-ID: <20250508214722.20808-3-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250508214722.20808-1-phil@nwl.cc>
References: <20250507222830.22525-1-phil@nwl.cc>
 <20250508214722.20808-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The code obviously intended to do this already but got the array length
check wrong.

Fixes: e70354f53e9f6 ("libnftables: Implement JSON output support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/json.c                                       |  2 +-
 .../cache/dumps/0002_interval_0.json-nft         |  4 +---
 .../json/dumps/0001set_statements_0.json-nft     |  4 +---
 .../testcases/listing/dumps/0010sets_0.json-nft  |  8 ++------
 .../testcases/listing/dumps/0012sets_0.json-nft  |  8 ++------
 .../testcases/listing/dumps/0022terse_0.json-nft |  4 +---
 ...0005interval_map_add_many_elements_0.json-nft |  4 +---
 .../dumps/0006interval_map_overlap_0.json-nft    |  4 +---
 .../dumps/0008interval_map_delete_0.json-nft     |  4 +---
 .../maps/dumps/0012map_concat_0.json-nft         |  4 +---
 .../testcases/maps/dumps/0013map_0.json-nft      |  4 +---
 .../maps/dumps/map_with_flags_0.json-nft         |  4 +---
 .../testcases/maps/dumps/named_limits.json-nft   |  8 ++------
 .../maps/dumps/pipapo_double_flush.json-nft      |  4 +---
 .../maps/dumps/typeof_maps_add_delete.json-nft   |  4 +---
 .../maps/dumps/typeof_maps_update_0.json-nft     |  8 ++------
 .../testcases/maps/dumps/vmap_timeout.json-nft   |  8 ++------
 .../nft-f/dumps/0025empty_dynset_0.json-nft      | 12 +++---------
 .../optimizations/dumps/merge_vmaps.json-nft     |  4 +---
 .../dumps/skip_unsupported.json-nft              |  4 +---
 .../packetpath/dumps/set_lookups.json-nft        |  8 ++------
 .../rule_management/dumps/0004replace_0.json-nft |  4 +---
 .../rule_management/dumps/0011reset_0.json-nft   |  4 +---
 .../sets/dumps/0001named_interval_0.json-nft     | 16 ++++------------
 .../0002named_interval_automerging_0.json-nft    |  4 +---
 .../dumps/0004named_interval_shadow_0.json-nft   |  4 +---
 .../dumps/0005named_interval_shadow_0.json-nft   |  4 +---
 .../sets/dumps/0008comments_interval_0.json-nft  |  4 +---
 .../sets/dumps/0009comments_timeout_0.json-nft   |  4 +---
 .../sets/dumps/0015rulesetflush_0.json-nft       |  4 +---
 .../dumps/0022type_selective_flush_0.json-nft    |  4 +---
 .../testcases/sets/dumps/0024synproxy_0.json-nft |  4 +---
 .../sets/dumps/0027ipv6_maps_ipv4_0.json-nft     |  4 +---
 .../sets/dumps/0028autoselect_0.json-nft         | 12 +++---------
 .../sets/dumps/0028delete_handle_0.json-nft      |  4 +---
 .../sets/dumps/0032restore_set_simple_0.json-nft |  8 ++------
 .../dumps/0033add_set_simple_flat_0.json-nft     |  8 ++------
 .../sets/dumps/0034get_element_0.json-nft        | 12 +++---------
 .../dumps/0035add_set_elements_flat_0.json-nft   |  4 +---
 .../sets/dumps/0038meter_list_0.json-nft         |  4 +---
 .../sets/dumps/0039delete_interval_0.json-nft    |  4 +---
 .../0040get_host_endian_elements_0.json-nft      |  4 +---
 .../testcases/sets/dumps/0041interval_0.json-nft |  4 +---
 .../sets/dumps/0042update_set_0.json-nft         |  4 +---
 .../dumps/0043concatenated_ranges_1.json-nft     |  8 ++------
 .../sets/dumps/0044interval_overlap_1.json-nft   |  4 +---
 .../sets/dumps/0049set_define_0.json-nft         |  4 +---
 .../dumps/0051set_interval_counter_0.json-nft    |  4 +---
 .../testcases/sets/dumps/0052overlap_0.json-nft  |  4 +---
 .../sets/dumps/0054comments_set_0.json-nft       |  8 ++------
 .../testcases/sets/dumps/0055tcpflags_0.json-nft |  4 +---
 .../sets/dumps/0060set_multistmt_1.json-nft      |  4 +---
 .../sets/dumps/0062set_connlimit_0.json-nft      |  8 ++------
 .../sets/dumps/0063set_catchall_0.json-nft       |  4 +---
 .../sets/dumps/0064map_catchall_0.json-nft       |  4 +---
 .../sets/dumps/0069interval_merge_0.json-nft     |  4 +---
 .../0071unclosed_prefix_interval_0.json-nft      |  8 ++------
 .../sets/dumps/0073flat_interval_set.json-nft    |  4 +---
 .../sets/dumps/0074nested_interval_set.json-nft  |  4 +---
 .../sets/dumps/concat_interval_0.json-nft        |  8 ++------
 .../testcases/sets/dumps/dynset_missing.json-nft |  4 +---
 .../sets/dumps/exact_overlap_0.json-nft          |  4 +---
 .../shell/testcases/sets/dumps/inner_0.json-nft  |  4 +---
 .../sets/dumps/meter_set_reuse.json-nft          |  4 +---
 .../dumps/range_with_same_start_end.json-nft     |  4 +---
 .../dumps/set_element_timeout_updates.json-nft   |  4 +---
 .../testcases/sets/dumps/set_eval_0.json-nft     |  4 +---
 .../sets/dumps/sets_with_ifnames.json-nft        | 12 +++---------
 .../transactions/dumps/0037set_0.json-nft        |  4 +---
 .../transactions/dumps/0038set_0.json-nft        |  4 +---
 .../transactions/dumps/0039set_0.json-nft        |  4 +---
 .../transactions/dumps/0047set_0.json-nft        |  4 +---
 .../transactions/dumps/doubled-set.json-nft      |  4 +---
 73 files changed, 97 insertions(+), 289 deletions(-)

diff --git a/src/json.c b/src/json.c
index 41a5720188419..6b27ccb927017 100644
--- a/src/json.c
+++ b/src/json.c
@@ -199,7 +199,7 @@ static json_t *set_print_json(struct output_ctx *octx, const struct set *set)
 	if (set->flags & NFT_SET_EVAL)
 		json_array_append_new(tmp, json_pack("s", "dynamic"));
 
-	if (json_array_size(tmp) > 0) {
+	if (json_array_size(tmp) > 1) {
 		json_object_set_new(root, "flags", tmp);
 	} else {
 		if (json_array_size(tmp))
diff --git a/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft b/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
index fa15d658dcd5c..5e2b9b420b6db 100644
--- a/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
+++ b/tests/shell/testcases/cache/dumps/0002_interval_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
index 91db43e29ea9f..ecc7eade91a60 100644
--- a/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
+++ b/tests/shell/testcases/json/dumps/0001set_statements_0.json-nft
@@ -34,9 +34,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/listing/dumps/0010sets_0.json-nft b/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
index efca892e3667b..6aa99b4e16d24 100644
--- a/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0010sets_0.json-nft
@@ -62,9 +62,7 @@
         "table": "test_arp",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "constant"
-        ]
+        "flags": "constant"
       }
     },
     {
@@ -106,9 +104,7 @@
         "table": "filter",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "constant"
-        ]
+        "flags": "constant"
       }
     },
     {
diff --git a/tests/shell/testcases/listing/dumps/0012sets_0.json-nft b/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
index efca892e3667b..6aa99b4e16d24 100644
--- a/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0012sets_0.json-nft
@@ -62,9 +62,7 @@
         "table": "test_arp",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "constant"
-        ]
+        "flags": "constant"
       }
     },
     {
@@ -106,9 +104,7 @@
         "table": "filter",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "constant"
-        ]
+        "flags": "constant"
       }
     },
     {
diff --git a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
index bd6383dac5e37..1a33d6888033b 100644
--- a/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
+++ b/tests/shell/testcases/listing/dumps/0022terse_0.json-nft
@@ -33,9 +33,7 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           "10.10.10.10",
           "10.10.11.11"
diff --git a/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft b/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
index d1a4629500533..f9ac5bce9315b 100644
--- a/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0005interval_map_add_many_elements_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft b/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
index 1e983219ae0d4..d6b32d0f8204c 100644
--- a/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0006interval_map_overlap_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
index bd3c6cc7ebf55..09cb6c8578ffb 100644
--- a/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0008interval_map_delete_0.json-nft
@@ -34,9 +34,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "mark",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             "127.0.0.2",
diff --git a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
index 88bf4984dbde7..85384c5329614 100644
--- a/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_concat_0.json-nft
@@ -50,9 +50,7 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/0013map_0.json-nft b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
index e91a269d8e6e6..2c8d21b43f20e 100644
--- a/tests/shell/testcases/maps/dumps/0013map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0013map_0.json-nft
@@ -38,9 +38,7 @@
         ],
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft b/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
index 97b7e94e59fa4..94ec5f751ba57 100644
--- a/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/map_with_flags_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": [
-          "timeout"
-        ]
+        "flags": "timeout"
       }
     }
   ]
diff --git a/tests/shell/testcases/maps/dumps/named_limits.json-nft b/tests/shell/testcases/maps/dumps/named_limits.json-nft
index 3c6845ac43b42..07e2892915392 100644
--- a/tests/shell/testcases/maps/dumps/named_limits.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_limits.json-nft
@@ -144,9 +144,7 @@
         },
         "handle": 0,
         "map": "limit",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
@@ -286,9 +284,7 @@
         },
         "handle": 0,
         "map": "limit",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
index ef8c3930f8153..dc793a65f16dd 100644
--- a/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
+++ b/tests/shell/testcases/maps/dumps/pipapo_double_flush.json-nft
@@ -33,9 +33,7 @@
         ],
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     }
   ]
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
index effe02dcf8364..8b18a78d6982f 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
@@ -50,9 +50,7 @@
         "handle": 0,
         "map": "mark",
         "size": 64,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "timeout": 300,
         "stmt": [
           {
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
index 731514663b1aa..b79237d0838db 100644
--- a/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/typeof_maps_update_0.json-nft
@@ -39,9 +39,7 @@
         "handle": 0,
         "map": "mark",
         "size": 65535,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "timeout": 360
       }
     },
@@ -61,9 +59,7 @@
         "handle": 0,
         "map": "mark",
         "size": 65535,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "timeout": 60
       }
     },
diff --git a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
index 71e9a9ee9f21b..2d7d8cc2306cd 100644
--- a/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
+++ b/tests/shell/testcases/maps/dumps/vmap_timeout.json-nft
@@ -66,9 +66,7 @@
         "type": "inet_service",
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "gc-interval": 10,
         "elem": [
           [
@@ -107,9 +105,7 @@
         },
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "gc-interval": 10,
         "elem": [
           [
diff --git a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
index 0cde23b00000a..63d6764172ff6 100644
--- a/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
+++ b/tests/shell/testcases/nft-f/dumps/0025empty_dynset_0.json-nft
@@ -27,9 +27,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "dynamic"
-        ],
+        "flags": "dynamic",
         "elem": [
           {
             "elem": {
@@ -64,9 +62,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
@@ -82,9 +78,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "dynamic"
-        ],
+        "flags": "dynamic",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
index e87f1c4c082eb..f058d6f1db069 100644
--- a/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/merge_vmaps.json-nft
@@ -46,9 +46,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
index d6347b1eeed6e..bf5a8cec53630 100644
--- a/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
+++ b/tests/shell/testcases/optimizations/dumps/skip_unsupported.json-nft
@@ -29,9 +29,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
index bcf6914e95cb9..23f4b17fc53c3 100644
--- a/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
+++ b/tests/shell/testcases/packetpath/dumps/set_lookups.json-nft
@@ -36,9 +36,7 @@
           "iface_index"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
@@ -113,9 +111,7 @@
         "table": "t",
         "type": "iface_index",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           "lo"
         ]
diff --git a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
index 767e80f14ff26..811cb73804f5d 100644
--- a/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0004replace_0.json-nft
@@ -38,9 +38,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     },
     {
diff --git a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
index bc242467e22a7..e57dee799b4f3 100644
--- a/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
+++ b/tests/shell/testcases/rule_management/dumps/0011reset_0.json-nft
@@ -38,9 +38,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ],
+        "flags": "dynamic",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
index b9c66a21aa084..9200154a6ed85 100644
--- a/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0001named_interval_0.json-nft
@@ -29,9 +29,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "range": [
@@ -55,9 +53,7 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
@@ -81,9 +77,7 @@
         "table": "t",
         "type": "inet_proto",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "range": [
@@ -107,9 +101,7 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft b/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
index 4c0be67000a02..b083ecb52bb52 100644
--- a/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0002named_interval_automerging_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft b/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
index c55858fa9c9b9..c79d9ba8518af 100644
--- a/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0004named_interval_shadow_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft b/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
index a75681f36cb8e..464661e62ae14 100644
--- a/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0005named_interval_shadow_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
index c6f5aa68837ce..e7152413d4bb9 100644
--- a/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0008comments_interval_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft b/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
index 2418b39a76a06..a67a06707106d 100644
--- a/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0009comments_timeout_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft b/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
index 6268e216aa03c..86d7eb6a4b6b1 100644
--- a/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0015rulesetflush_0.json-nft
@@ -36,9 +36,7 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
index c617139235c23..dcb62eb739d56 100644
--- a/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0022type_selective_flush_0.json-nft
@@ -49,9 +49,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 1024,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
index 0af613333592d..dd71bb394442d 100644
--- a/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0024synproxy_0.json-nft
@@ -58,9 +58,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "synproxy",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft b/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
index b9251ffa58900..75d8b46d86a10 100644
--- a/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0027ipv6_maps_ipv4_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
index 5968b2e0c11f0..05fc072c3ca7f 100644
--- a/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0028autoselect_0.json-nft
@@ -34,9 +34,7 @@
         "type": "inet_proto",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
@@ -47,9 +45,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
@@ -60,9 +56,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 1024,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft b/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
index 96314141bc084..9e5f708df3a74 100644
--- a/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0028delete_handle_0.json-nft
@@ -30,9 +30,7 @@
         "table": "test-ip",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "timeout": 10845
       }
     },
diff --git a/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft b/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
index 4d194bff1b164..7a723150c1a35 100644
--- a/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0032restore_set_simple_0.json-nft
@@ -25,9 +25,7 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": [
-          "timeout"
-        ]
+        "flags": "timeout"
       }
     },
     {
@@ -40,9 +38,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "timeout"
-        ]
+        "flags": "timeout"
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft b/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
index 16684438c37f2..5697652859078 100644
--- a/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0033add_set_simple_flat_0.json-nft
@@ -25,9 +25,7 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": [
-          "timeout"
-        ]
+        "flags": "timeout"
       }
     },
     {
@@ -40,9 +38,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "timeout"
-        ]
+        "flags": "timeout"
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
index bfc0e4a0f5886..4f5ba0aaac578 100644
--- a/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0034get_element_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           10,
           {
@@ -49,9 +47,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           "10.0.0.1",
           {
@@ -91,9 +87,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft b/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
index e4c77147b88f6..f9fe4e6f113ea 100644
--- a/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0035add_set_elements_flat_0.json-nft
@@ -21,9 +21,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
index 5b13f59a72615..6f6555d224371 100644
--- a/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0038meter_list_0.json-nft
@@ -44,9 +44,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 128,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
index d6e46aad20a50..afa819584e5b3 100644
--- a/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0039delete_interval_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft b/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
index 4b6cf03c45961..486ca453281e4 100644
--- a/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0040get_host_endian_elements_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "mark",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "range": [
diff --git a/tests/shell/testcases/sets/dumps/0041interval_0.json-nft b/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
index 14a393305a3f3..c59a65ae29fd8 100644
--- a/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0041interval_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           "192.168.2.196"
         ]
diff --git a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
index bc1d4cc2284d8..3f98e120d19bd 100644
--- a/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0042update_set_0.json-nft
@@ -39,9 +39,7 @@
         "type": "ether_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
index 92b59c861de10..5ce063d7e4304 100644
--- a/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0043concatenated_ranges_1.json-nft
@@ -24,9 +24,7 @@
           "ipv6_addr"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
@@ -1584,9 +1582,7 @@
           "ipv4_addr"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
index f4aae383524ff..8f82990af70d6 100644
--- a/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0044interval_overlap_1.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           25,
           30,
diff --git a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
index f8495bab8b0f3..98ccafd463cc4 100644
--- a/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0049set_define_0.json-nft
@@ -33,9 +33,7 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "auto-merge": true,
         "elem": [
           "1.1.1.1"
diff --git a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
index b468b5f9044ca..96cb397f0c584 100644
--- a/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0051set_interval_counter_0.json-nft
@@ -33,9 +33,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft b/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
index 96d5fbccd7d40..1ea8ede677aa3 100644
--- a/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0052overlap_0.json-nft
@@ -21,9 +21,7 @@
         "table": "filter",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "auto-merge": true,
         "elem": [
           "10.10.10.10",
diff --git a/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft b/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
index 3fd6d37e18103..a729392270c01 100644
--- a/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0054comments_set_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "comment": "test",
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     },
     {
@@ -36,9 +34,7 @@
         "handle": 0,
         "comment": "another test",
         "map": "ipv4_addr",
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     }
   ]
diff --git a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
index e37139f334466..0232ad6f28e3b 100644
--- a/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0055tcpflags_0.json-nft
@@ -21,9 +21,7 @@
         "table": "test",
         "type": "tcp_flag",
         "handle": 0,
-        "flags": [
-          "constant"
-        ],
+        "flags": "constant",
         "elem": [
           {
             "|": [
diff --git a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
index 6098dc563141f..99805e553da0e 100644
--- a/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
+++ b/tests/shell/testcases/sets/dumps/0060set_multistmt_1.json-nft
@@ -34,9 +34,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ],
+        "flags": "dynamic",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft b/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
index c5e60e36c89ea..7a948b1da0cff 100644
--- a/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0062set_connlimit_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
@@ -35,9 +33,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ],
+        "flags": "dynamic",
         "stmt": [
           {
             "ct count": {
diff --git a/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft b/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
index 3006f75a8fcc6..fcfe9830f3600 100644
--- a/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0063set_catchall_0.json-nft
@@ -55,9 +55,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "elem": {
diff --git a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
index 64dd26670528b..b7496ac853f10 100644
--- a/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0064map_catchall_0.json-nft
@@ -50,9 +50,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "ipv4_addr",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft b/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
index d7b32f8cc0e24..7868cb3359160 100644
--- a/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0069interval_merge_0.json-nft
@@ -21,9 +21,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "auto-merge": true,
         "elem": [
           {
diff --git a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
index 6b579a2e09fff..588c2b1b6689c 100644
--- a/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/0071unclosed_prefix_interval_0.json-nft
@@ -29,9 +29,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
@@ -55,9 +53,7 @@
         "table": "t",
         "type": "ipv6_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft b/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
index e2fb6214238fa..e4649a7d0c22e 100644
--- a/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
+++ b/tests/shell/testcases/sets/dumps/0073flat_interval_set.json-nft
@@ -32,9 +32,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "counter",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft b/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
index e2fb6214238fa..e4649a7d0c22e 100644
--- a/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
+++ b/tests/shell/testcases/sets/dumps/0074nested_interval_set.json-nft
@@ -32,9 +32,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "counter",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             {
diff --git a/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft b/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
index d65065e4f0947..3283f26958f71 100644
--- a/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/concat_interval_0.json-nft
@@ -25,9 +25,7 @@
           "inet_service"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "stmt": [
           {
             "counter": null
@@ -45,9 +43,7 @@
           "mark"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
diff --git a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
index ad8a7cc0564a8..9de5b821f79e7 100644
--- a/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
+++ b/tests/shell/testcases/sets/dumps/dynset_missing.json-nft
@@ -34,9 +34,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft b/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
index 958d1e5cf6caf..7bba69d54556a 100644
--- a/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/exact_overlap_0.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/sets/dumps/inner_0.json-nft b/tests/shell/testcases/sets/dumps/inner_0.json-nft
index e5dc198f436be..581d534012e44 100644
--- a/tests/shell/testcases/sets/dumps/inner_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/inner_0.json-nft
@@ -74,9 +74,7 @@
         },
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
index ab4ac06184d03..9210c90b158d4 100644
--- a/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
+++ b/tests/shell/testcases/sets/dumps/meter_set_reuse.json-nft
@@ -33,9 +33,7 @@
         ],
         "handle": 0,
         "size": 65535,
-        "flags": [
-          "dynamic"
-        ]
+        "flags": "dynamic"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
index c4682475917e5..e1daa8f86529f 100644
--- a/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
+++ b/tests/shell/testcases/sets/dumps/range_with_same_start_end.json-nft
@@ -21,9 +21,7 @@
         "table": "t",
         "type": "inet_service",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           10,
           30,
diff --git a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
index d92d8d7a54940..acb2f1f4944ac 100644
--- a/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_element_timeout_updates.json-nft
@@ -40,9 +40,7 @@
           }
         },
         "handle": 0,
-        "flags": [
-          "timeout"
-        ],
+        "flags": "timeout",
         "timeout": 60
       }
     }
diff --git a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
index 6f692381b6f7c..6f4f4c61600b2 100644
--- a/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
+++ b/tests/shell/testcases/sets/dumps/set_eval_0.json-nft
@@ -33,9 +33,7 @@
         "table": "nat",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     },
     {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
index ac4284293c32a..77ca50868f26f 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -71,9 +71,7 @@
         "table": "testifsets",
         "type": "ifname",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           "abcdef*",
           "othername",
@@ -117,9 +115,7 @@
           "ifname"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
@@ -166,9 +162,7 @@
         "type": "ifname",
         "handle": 0,
         "map": "verdict",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             "abcdef*",
diff --git a/tests/shell/testcases/transactions/dumps/0037set_0.json-nft b/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
index e4c77147b88f6..f9fe4e6f113ea 100644
--- a/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0037set_0.json-nft
@@ -21,9 +21,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ]
+        "flags": "interval"
       }
     }
   ]
diff --git a/tests/shell/testcases/transactions/dumps/0038set_0.json-nft b/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
index 0a36f4a809a0d..5f97d09e82c6c 100644
--- a/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0038set_0.json-nft
@@ -21,9 +21,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/transactions/dumps/0039set_0.json-nft b/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
index 0a36f4a809a0d..5f97d09e82c6c 100644
--- a/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0039set_0.json-nft
@@ -21,9 +21,7 @@
         "table": "x",
         "type": "ipv4_addr",
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "prefix": {
diff --git a/tests/shell/testcases/transactions/dumps/0047set_0.json-nft b/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
index a7e677b2e702c..fb6348f229b57 100644
--- a/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
+++ b/tests/shell/testcases/transactions/dumps/0047set_0.json-nft
@@ -22,9 +22,7 @@
         "type": "ipv4_addr",
         "handle": 0,
         "map": "classid",
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           [
             "10.1.26.2",
diff --git a/tests/shell/testcases/transactions/dumps/doubled-set.json-nft b/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
index 2dced1240528f..1b9af211945ec 100644
--- a/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
+++ b/tests/shell/testcases/transactions/dumps/doubled-set.json-nft
@@ -24,9 +24,7 @@
           "ifname"
         ],
         "handle": 0,
-        "flags": [
-          "interval"
-        ],
+        "flags": "interval",
         "elem": [
           {
             "concat": [
-- 
2.49.0

