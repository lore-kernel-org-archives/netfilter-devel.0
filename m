Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=151.80.46.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792751777;
	b=brucO8Hr5nwSBNh3Frwl9JN4oyOw2/ppL9sI1UcPJp9XOeiiNE1jkYoSAot9bkEKcg3S
	 5G44Suw/hn5oQJGK93vxGFp6bXXAKO/Bu687FekttiGakbU/4ArtNT1+1el+cabBSnHgq
	 cuQoqnSWw+oLvgCagN/kfnshPpMZO+Q8TtwYuNKOWUBFN/ZLTb2dnxyMhUIvLuP+ILImg
	 S5ZCb3Obhn13UgG3F0aQFN16jex32yAFH6qKOfDzAu17oS5cx45mw3QRjv+NtsdGgtQ6z
	 uSujI3U76AbNfzGTo5iAb+W5fFNwdjIeDXofpJ32O+OcbI4XDxzsr0KVx+BJAiNXG5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792751777;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+wc2PdYiTkcyLsmTDAxE8kLOo7TjQ74TXeYwZYUbAaY=;
	b=LmIhc8uS3LMpOb6N8PMGcExjUXoVueCuBQ9LCooxWYQ9ajjhu5JpUuyED8Qm5s9b4ocA
	 R78pf08IK61K0ll188Aa47eEyG48X3sSEC8qXZBt/U1EFRcwk7BBRHiOnubu6o9H03NLV
	 TD6Z/G4raS33az0NnGE+9vCWBJtowJWueVLhG0cBC9x0l1PlF37GO/BmkD9fvmWPxjTis
	 NsDfk/Lfucp8+NJrNDPiac3UdObh1EvfyKeoRGJjGVjQU7p79UHjKy97TMogbTJfgEIaA
	 9eqRTTWei9XVrpPWD0Qx/cWWRS/StLZLJtAm2kQP0nhjH+zaoftOmvsDMMWbrIXlKmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=nwl.cc;
	spf=pass smtp.mailfrom=nwl.cc;
	dkim=pass header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=Qv1jJmZ1;
	arc=none smtp.remote-ip=151.80.46.58
Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E80606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 10:36:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1E80606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nwl.cc header.i=@nwl.cc header.a=rsa-sha256 header.s=mail2022 header.b=Qv1jJmZ1
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+wc2PdYiTkcyLsmTDAxE8kLOo7TjQ74TXeYwZYUbAaY=; b=Qv1jJmZ1UW5uuCLF16P30rA+Up
	jARv7w1jYsAeYBnVDDgwCsUq5g160Ts+1XdjcG5Gx5F8n+R858Oj4Qxmwi9LiBK5DPaRHC8pNKZwZ
	vL+HZBm6b7qecnuVcW4dpgnXy7MMliONo8p+Gx9+B9pupsczi6UF+AD+ZLNXGv8GLs6QTQI7EumRf
	dKZvNQsK1MQmQ+M0oiA0rQZ8p34hualOHRbDFpKcQPrWmnDbJEnKsHzgYzr87tSVQ0TgK05CSUAZi
	I6GOwm8KJ7wXIQ/bOW8dVhLBP0GmKdJgYCka9fs1FwhtVo+Rck2chX5yT4OCtpFI4bzIGVOmnfhQH
	k13R598g==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1xKCd6-000000000Su-15fO
	for netfilter-devel@vger.kernel.org;
	Fri, 23 Oct 2026 12:36:08 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests: shell: Fix for spurious fail in maps/typeof_maps_add_delete
Date: Fri, 23 Oct 2026 12:36:03 +0200
Message-ID: <20261023103603.1048380-1-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Testing on a (probably slow) aarch64 machine yielded dump failure since
ruleset listing had '# count 1' appended to map size statement. The 3s
delay supposedly wasn't long enough for the element to be reapped after
disabling.

The test itself seems to perform all desired ruleset checks though, so
just drop the stored dumps to avoid this problem.

Fixes: a8260c056a69a ("tests: add dynmap datapath add/delete test case")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .../dumps/typeof_maps_add_delete.json-nft     | 290 ------------------
 .../maps/dumps/typeof_maps_add_delete.nft     |  22 --
 .../maps/dumps/typeof_maps_add_delete.nodump  |   0
 3 files changed, 312 deletions(-)
 delete mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
 delete mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
 create mode 100644 tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nodump

diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
deleted file mode 100644
index 08c10819f1b9c..0000000000000
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.json-nft
+++ /dev/null
@@ -1,290 +0,0 @@
-{
-  "nftables": [
-    {
-      "metainfo": {
-        "version": "VERSION",
-        "release_name": "RELEASE_NAME",
-        "json_schema_version": 1
-      }
-    },
-    {
-      "table": {
-        "family": "ip",
-        "name": "dynset",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "dynset",
-        "name": "test_ping",
-        "handle": 0
-      }
-    },
-    {
-      "chain": {
-        "family": "ip",
-        "table": "dynset",
-        "name": "input",
-        "handle": 0,
-        "type": "filter",
-        "hook": "input",
-        "prio": 0,
-        "policy": "accept"
-      }
-    },
-    {
-      "map": {
-        "family": "ip",
-        "name": "dynmark",
-        "table": "dynset",
-        "type": {
-          "typeof": {
-            "payload": {
-              "protocol": "ip",
-              "field": "daddr"
-            }
-          }
-        },
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
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "test_ping",
-        "handle": 0,
-        "comment": "should not increment",
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "right": "@dynmark"
-            }
-          },
-          {
-            "counter": {
-              "packets": 0,
-              "bytes": 0
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "test_ping",
-        "handle": 0,
-        "expr": [
-          {
-            "match": {
-              "op": "!=",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "right": "@dynmark"
-            }
-          },
-          {
-            "map": {
-              "op": "add",
-              "elem": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "data": 1,
-              "map": "@dynmark"
-            }
-          },
-          {
-            "counter": {
-              "packets": 1,
-              "bytes": 84
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "test_ping",
-        "handle": 0,
-        "comment": "should increment",
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "right": "@dynmark"
-            }
-          },
-          {
-            "counter": {
-              "packets": 1,
-              "bytes": 84
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "test_ping",
-        "handle": 0,
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "right": "@dynmark"
-            }
-          },
-          {
-            "map": {
-              "op": "delete",
-              "elem": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "data": 1,
-              "map": "@dynmark"
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "test_ping",
-        "handle": 0,
-        "comment": "delete should be instant but might fail under memory pressure",
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "saddr"
-                }
-              },
-              "right": "@dynmark"
-            }
-          },
-          {
-            "counter": {
-              "packets": 0,
-              "bytes": 0
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "input",
-        "handle": 0,
-        "comment": "also check timeout-gc",
-        "expr": [
-          {
-            "map": {
-              "op": "add",
-              "elem": {
-                "elem": {
-                  "val": "10.2.3.4",
-                  "timeout": 2
-                }
-              },
-              "data": 2,
-              "map": "@dynmark"
-            }
-          }
-        ]
-      }
-    },
-    {
-      "rule": {
-        "family": "ip",
-        "table": "dynset",
-        "chain": "input",
-        "handle": 0,
-        "expr": [
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "meta": {
-                  "key": "l4proto"
-                }
-              },
-              "right": 1
-            }
-          },
-          {
-            "match": {
-              "op": "==",
-              "left": {
-                "payload": {
-                  "protocol": "ip",
-                  "field": "daddr"
-                }
-              },
-              "right": "127.0.0.42"
-            }
-          },
-          {
-            "jump": {
-              "target": "test_ping"
-            }
-          }
-        ]
-      }
-    }
-  ]
-}
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
deleted file mode 100644
index 3f3ef17dd5493..0000000000000
--- a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nft
+++ /dev/null
@@ -1,22 +0,0 @@
-table ip dynset {
-	map dynmark {
-		typeof ip daddr : meta mark
-		size 64
-		counter
-		timeout 5m
-	}
-
-	chain test_ping {
-		ip saddr @dynmark counter packets 0 bytes 0 comment "should not increment"
-		ip saddr != @dynmark add @dynmark { ip saddr : 0x00000001 } counter packets 1 bytes 84
-		ip saddr @dynmark counter packets 1 bytes 84 comment "should increment"
-		ip saddr @dynmark delete @dynmark { ip saddr : 0x00000001 }
-		ip saddr @dynmark counter packets 0 bytes 0 comment "delete should be instant but might fail under memory pressure"
-	}
-
-	chain input {
-		type filter hook input priority filter; policy accept;
-		add @dynmark { 10.2.3.4 timeout 2s : 0x00000002 } comment "also check timeout-gc"
-		meta l4proto 1 ip daddr 127.0.0.42 jump test_ping
-	}
-}
diff --git a/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nodump b/tests/shell/testcases/maps/dumps/typeof_maps_add_delete.nodump
new file mode 100644
index 0000000000000..e69de29bb2d1d
-- 
2.54.0

