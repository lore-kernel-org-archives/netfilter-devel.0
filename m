Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D15E2107
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Mar 2024 15:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711294187; cv=none; b=eHa9haz0joqKsUUZC/PaZoA7YpdyBvH6Dxm5Y0ROM1f0SnWwmABBE4nIQHDC84U2n9fiPwKitID8D2rtfpIoq7pbCB2UhD4/QZ7A2YUDB2Hh0L8H8CEWYBl3wh79Q2I3uZSU1y6UXsGe+tM6Wq7ERv7wA9YRZ3RyDO87+bIBelg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711294187; c=relaxed/simple;
	bh=uEdmYIYoQqAHmZC9tvRMo2BfmpLiY/22/73WTAigM+c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=nMzyTHWPbfYpRRhBgD5D6Fw8Xbx+osuPIDKW5ejCzY4PE8n7WnpMilKA/gLQP5Mz7wtrXVMlBswvw+rNITqjCRfW9e9nbpAuaij79P82dsbtEpcbCVh/mg8IHxxjxJydz/rZwZhOe0G3zvHLhIJzXWpeQwo+4PNzutyrsdmBVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=FsYRX3aW; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FsYRX3aW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Zit4U/NxuwHysCeW2Lt5g7UFWeQ5kFORMcegqsvf3Fs=; b=FsYRX3aW/U5FqN7sCR0ztdppm9
	7H178bg0xmflVUkEtYiWWw37XdVJKd99Ur5eCkesHJ1KmfG9vxYK0P3Wsc1Y+qDdjhTOO59US/gNR
	ZvWDYiiD8rKi/pj0DhnHaba9THG23b9ftK+UFZLZgDDDSa5TaFI+ZNA/CCq8S26e4m+reqeFgw9Be
	yI6+zUyBBS0IfLro/pULosFm3gi4kFHQYJop+t64jNJARhP9Vaq1LrN4rlcFO8S3tqyAgIXvrjpb1
	t8gsfxc85omnPDShhZCbfDrJqFCsd5e20o8kkcwncIj4djKlvpeb2bnxCbdDoIwU6EmKj/QMxskSa
	cwsE7j7A==;
Received: from [2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
	by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1roPJv-007Ivj-2i
	for netfilter-devel@vger.kernel.org;
	Sun, 24 Mar 2024 14:59:35 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables] evaluate: add support for variables in map expressions
Date: Sun, 24 Mar 2024 14:59:07 +0000
Message-ID: <20240324145908.2643098-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false

It is possible to use a variable to initialize a map, which is then used in a
map statement:

  define m = { ::1234 : 5678 }

  table ip6 nat {
    map m {
      typeof ip6 daddr : tcp dport;
      elements = $m
    }
    chain prerouting {
      ip6 nexthdr tcp redirect to ip6 daddr map @m
    }
  }

However, if one tries to use the variable directly in the statement:

  define m = { ::1234 : 5678 }

  table ip6 nat {
    chain prerouting {
      ip6 nexthdr tcp redirect to ip6 daddr map $m
    }
  }

nft rejects it:

  /space/azazel/tmp/ruleset.1067161.nft:5:47-48: Error: invalid mapping expression variable
      ip6 nexthdr tcp redirect to ip6 daddr map $m
                                  ~~~~~~~~~     ^^

Extend `expr_evaluate_map` to allow it.

Add a test-case.

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067161
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/evaluate.c                                |  1 +
 .../shell/testcases/maps/anonymous_snat_map_1 | 16 +++++
 .../maps/dumps/anonymous_snat_map_1.json-nft  | 58 +++++++++++++++++++
 .../maps/dumps/anonymous_snat_map_1.nft       |  5 ++
 4 files changed, 80 insertions(+)
 create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
 create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft

diff --git a/src/evaluate.c b/src/evaluate.c
index 1682ba58989e..d49213f8d6bd 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2061,6 +2061,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	mappings->set_flags |= NFT_SET_MAP;
 
 	switch (map->mappings->etype) {
+	case EXPR_VARIABLE:
 	case EXPR_SET:
 		if (ctx->ectx.key && ctx->ectx.key->etype == EXPR_CONCAT) {
 			key = expr_clone(ctx->ectx.key);
diff --git a/tests/shell/testcases/maps/anonymous_snat_map_1 b/tests/shell/testcases/maps/anonymous_snat_map_1
new file mode 100755
index 000000000000..031de0c1a83f
--- /dev/null
+++ b/tests/shell/testcases/maps/anonymous_snat_map_1
@@ -0,0 +1,16 @@
+#!/bin/bash
+
+# Variable containing anonymous map can be added to a snat rule
+
+set -e
+
+RULESET='
+define m = {1.1.1.1 : 2.2.2.2}
+table nat {
+  chain postrouting {
+    snat ip saddr map $m
+  }
+}
+'
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
new file mode 100644
index 000000000000..f4c55706787c
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.json-nft
@@ -0,0 +1,58 @@
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
+        "name": "nat",
+        "handle": 0
+      }
+    },
+    {
+      "chain": {
+        "family": "ip",
+        "table": "nat",
+        "name": "postrouting",
+        "handle": 0
+      }
+    },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "nat",
+        "chain": "postrouting",
+        "handle": 0,
+        "expr": [
+          {
+            "snat": {
+              "addr": {
+                "map": {
+                  "key": {
+                    "payload": {
+                      "protocol": "ip",
+                      "field": "saddr"
+                    }
+                  },
+                  "data": {
+                    "set": [
+                      [
+                        "1.1.1.1",
+                        "2.2.2.2"
+                      ]
+                    ]
+                  }
+                }
+              }
+            }
+          }
+        ]
+      }
+    }
+  ]
+}
diff --git a/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft
new file mode 100644
index 000000000000..5009560c9d69
--- /dev/null
+++ b/tests/shell/testcases/maps/dumps/anonymous_snat_map_1.nft
@@ -0,0 +1,5 @@
+table ip nat {
+	chain postrouting {
+		snat to ip saddr map { 1.1.1.1 : 2.2.2.2 }
+	}
+}
-- 
2.43.0

