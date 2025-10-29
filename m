Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B8D13FEE
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 22:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761777959; cv=none; b=CO6Bq9L9IUhLOBbwTvTwrV3UB3JklqzevEUsH4G+ctvf3zirPVtS0Lts1XPu2+8IVDSDHrUPCtqAIai8EtwYuf4jkoHawAvF8GUtq7VH8tWGkXS8X2n8I8cF+UVmaBPtDH/oVbwZ8eNQVexI6o7oc0upowwNEIRlW86mJvSdIFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761777959; c=relaxed/simple;
	bh=p+oM04O/H7wRhfkK/ntVnSUsr4SUOXmTs1h89IMk3lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyzzewOLGRK1L5CUOXA+USFY/+R3k29t42ElDqDMnEE1UpEg791PEEwApSWwEUCxZpdAciPIplmr2xQ2SMK55HO0FvjwN5vulA8dK+fv2ggKixtkpxXpVFAcL9nDKk5YOYG9h/dZJJPoGQFlAeT28z46yKR/ysxBfSoKfplHLkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQw30m64; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQw30m64"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4270a3464bcso274635f8f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2025 15:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761777955; x=1762382755; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYl0FglliXOljtOev5rTotnwMG2nQs0Y97fbh4hCkyA=;
        b=UQw30m64m/3KsOktxfD1pV73MLVTWlu/IxZ70K0EyqilPBggILvmay3EkYUSK/68pF
         4T6ffSDOTwWfuJ5qr9oe2XYiJ3W52NRjII+0fuPMNYW3k2WUvFBKpZIz82jLpXllO4nz
         KcDTjG5DqZdo0hBqHBaACjzApfdgRlFGcrEfVK75FmbTg5a+AB53Uh+mr1IKVTuK889P
         Ev1hdRga+xcQQ/og9TYhg5ef/sFYNxTZTTzcPpp8VZSpEG6TZ4JPcBP+aMTzm93uHh8R
         H70y/fGLOiRKw3JnM3ZrgocSuOi1uhusWdGYUGATJ4p1RPxS0HFPXXHzFdJ4xCYS02rS
         pEPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761777955; x=1762382755;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYl0FglliXOljtOev5rTotnwMG2nQs0Y97fbh4hCkyA=;
        b=X67pxTkizC78Ib6npwmwyMMn/jagOkPSYyCsKWYnAKedjSrcusID+rJn3xH7HIpYN7
         SWrQJ5zEkbCHZG8kVYgAmeeOZeG4pwsbgaooUoxJiaxG/YJBwwaYpcq+MnI1Vk69ImFP
         CJpFaiPgyqyUuOMlJp6n5ipGZMUon0oCiwD3Met6Cp9BuE6Q0lBN6pzCuwBdlR2kL2y+
         d25kCXesFSnL8L8CRIhIxuJ8uIPnwhhD5saDVH2euSIkrg9eek0Q/9o274SUdbP7Mj5w
         SXulRcR446O+1aDB2P3Ok69nI0EgKrS0RuVUglzrm2K1FINuIXaD7a0qrap/d+QtQ5tc
         yXqw==
X-Gm-Message-State: AOJu0YzcZUlo2V49mGMBRRqdCRbkZUh5p49knjfcHsHC0lB+r2nMuYIV
	o986IYRmyWtoTL2K9g4a0fZuyqdOjfs/StUYxlt/0m/4/jLUcwu/7Mmn3f0izg==
X-Gm-Gg: ASbGncs85TGJxEoHkBHCApnQ34nvmQcahdq5s/ESeT0spBKBGRe1EzDb+jg1qzmjlIk
	Juf/Urxz40Q6i49KAeW6D2BM0KMPjCpQC0pzecdwJyhl6oYu6NW6EfdsMb/7XJfN5curLGG4q6X
	auqPDKkmunJWldX+mV+fu+lk/ykvF6adGre+zCjSsF4uxYw8hcs5g8H/GUHKsjtMv09su/vuq7g
	qohcDqgW0MPUAoMH2I+saVPr9GPiIPE5DYtH9YUSo6SwgooAyOxoTFVNt1tLqVQP7QmPaGL+E+r
	TJ6NworRyTST0zn25lcYdnq2C6Kly0d9Rv7Se5bukIuhoXzdOTw6aOYOw3zgvFYFlXY6D09L+Uz
	YmiTgX3uw1CxfX4qBrgdoS7kGzWN5S4XfxfAknCQ9lH2AoTHXK34RcyRIh9mlgMnaNMCsKHMfX8
	gbvUtpd8z5ilCzrwVlY3o0XzzsDhmp24i5bsgpazLgzpG3m0IabbOg/5PV
X-Google-Smtp-Source: AGHT+IExFTA/VUD2N/ZsSpTTPtIQv5ij4d7qenYXJg3I/dJ68I2Lxx+190b/o7aR4XEJ+qW7D3BoXw==
X-Received: by 2002:a05:6000:230c:b0:429:b1e4:1f6e with SMTP id ffacd0b85a97d-429b4c8a05dmr1079225f8f.16.1761777955167;
        Wed, 29 Oct 2025 15:45:55 -0700 (PDT)
Received: from pc-111.home ([2a01:cb1c:8441:2b00:c694:3c2c:878b:f4c0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5773sm30600955f8f.27.2025.10.29.15.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 15:45:54 -0700 (PDT)
From: Alexandre Knecht <knecht.alexandre@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	Alexandre Knecht <knecht.alexandre@gmail.com>
Subject: [nft PATCH v2] parser_json: support handle for rule positioning in JSON add rule
Date: Wed, 29 Oct 2025 23:45:03 +0100
Message-ID: <20251029224530.1962783-2-knecht.alexandre@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029224530.1962783-1-knecht.alexandre@gmail.com>
References: <20251029003044.548224-1-knecht.alexandre@gmail.com>
 <20251029224530.1962783-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes JSON-based rule positioning when using "add rule" with
a handle parameter. Previously, the handle was deleted before being used
for positioning, causing rules to always be appended at the end of the
chain instead of being placed after the specified rule handle.

The fix follows the same pattern used in json_parse_cmd_replace():
- Parse the handle field from JSON
- Convert handle to position for CMD_ADD operations
- Remove the code that was deleting the handle field

With NLM_F_APPEND set (as it always is for add operations), the kernel
interprets position as "add after this handle", which matches the CLI
behavior of "add rule position X".

Before this fix:
  nft -j add rule ... handle 2  --> rule added at end

After this fix:
  nft -j add rule ... handle 2  --> rule added after handle 2

The CLI version (nft add rule ... position X) was already working
correctly.

Tested with:
  # nft add table inet test
  # nft add chain inet test c
  # nft add rule inet test c tcp dport 80 accept
  # nft add rule inet test c tcp dport 443 accept
  # echo '{"nftables":[{"add":{"rule":{"family":"inet","table":"test","chain":"c","handle":2,"expr":[{"match":{"left":{"payload":{"protocol":"tcp","field":"dport"}},"op":"==","right":8080}},{"accept":null}]}}}]}' | nft -j -f -
  # nft -a list table inet test

Result: Rule with port 8080 correctly placed after handle 2 (port 80).

Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>
---
 src/parser_json.c                             |  11 +-
 .../json/0007rule_add_handle_position_0       |  22 ++++
 .../0007rule_add_handle_position_0.json-nft   | 101 ++++++++++++++++++
 .../dumps/0007rule_add_handle_position_0.nft  |   7 ++
 4 files changed, 138 insertions(+), 3 deletions(-)
 create mode 100755 tests/shell/testcases/json/0007rule_add_handle_position_0
 create mode 100644 tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.json-nft
 create mode 100644 tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.nft

diff --git a/src/parser_json.c b/src/parser_json.c
index 7b4f3384..c974a9e2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -3197,10 +3197,18 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		return NULL;
 	}
 
+	/* Parse handle and index (similar to json_parse_cmd_replace) */
+	json_unpack(root, "{s:I}", "handle", &h.handle.id);
 	if (!json_unpack(root, "{s:I}", "index", &h.index.id)) {
 		h.index.id++;
 	}
 
+	/* For CMD_ADD, convert handle to position for rule positioning */
+	if ((op == CMD_ADD || op == CMD_CREATE) && h.handle.id) {
+		h.position.id = h.handle.id;
+		h.handle.id = 0;
+	}
+
 	rule = rule_alloc(int_loc, NULL);
 
 	json_unpack(root, "{s:s}", "comment", &comment);
@@ -3226,9 +3234,6 @@ static struct cmd *json_parse_cmd_add_rule(struct json_ctx *ctx, json_t *root,
 		rule_stmt_append(rule, stmt);
 	}
 
-	if (op == CMD_ADD)
-		json_object_del(root, "handle");
-
 	return cmd_alloc(op, obj, &h, int_loc, rule);
 
 err_free_rule:
diff --git a/tests/shell/testcases/json/0007rule_add_handle_position_0 b/tests/shell/testcases/json/0007rule_add_handle_position_0
new file mode 100755
index 00000000..e7dde7c7
--- /dev/null
+++ b/tests/shell/testcases/json/0007rule_add_handle_position_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_json)
+
+# Test that JSON add rule with handle parameter positions rule correctly
+
+set -e
+
+$NFT flush ruleset
+
+# Create table, chain, and two initial rules
+# The first rule (port 80) will get handle 2
+# The second rule (port 443) will get handle 3
+SETUP='{"nftables": [{"add": {"table": {"family": "inet", "name": "test"}}}, {"add": {"chain": {"family": "inet", "table": "test", "name": "c"}}}, {"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 80}}, {"accept": null}]}}}, {"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 443}}, {"accept": null}]}}}]}'
+
+$NFT -j -f - <<< "$SETUP"
+
+# Add a new rule positioned after handle 2 (the port 80 rule)
+# This rule should end up between port 80 and port 443
+ADD_RULE='{"nftables": [{"add": {"rule": {"family": "inet", "table": "test", "chain": "c", "handle": 2, "expr": [{"match": {"left": {"payload": {"protocol": "tcp", "field": "dport"}}, "op": "==", "right": 8080}}, {"accept": null}]}}}]}'
+
+$NFT -j -f - <<< "$ADD_RULE"
diff --git a/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.json-nft b/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.json-nft
new file mode 100644
index 00000000..667e14c1
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.json-nft
@@ -0,0 +1,101 @@
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
+        "name": "test",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "inet",
+        "table": "test",
+        "name": "c",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "test",
+        "chain": "c",
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
+            "accept": null
+          }
+        ]
+      }
+    },
+    {
+      "rule": {
+        "family": "inet",
+        "table": "test",
+        "chain": "c",
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
+              "right": 8080
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
+        "table": "test",
+        "chain": "c",
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
+              "right": 443
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
diff --git a/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.nft b/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.nft
new file mode 100644
index 00000000..d3e8e1ba
--- /dev/null
+++ b/tests/shell/testcases/json/dumps/0007rule_add_handle_position_0.nft
@@ -0,0 +1,7 @@
+table inet test {
+	chain c {
+		tcp dport 80 accept
+		tcp dport 8080 accept
+		tcp dport 443 accept
+	}
+}
-- 
2.51.0

