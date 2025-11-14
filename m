Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E622127A
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2025 00:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763079960; cv=none; b=dWPr8lSzPP72Wj7UAKlnCE/P+qgUqChEwQ3u+XrdBRUXhNHSKdO1GCnswxzwmJG91zdrKCkCCcUBKwTyymCnpsK5BbISX3AAZEJeVrF+Fabunma+q8Ws1kVG6C6UBj357A4oUie7+6SpJhe+OfzSdb1uhTyW+KQS5OZ3/bBUI1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763079960; c=relaxed/simple;
	bh=eNamro/Hki2C9Gl+RIKND4AU2AD0KwxFP9eeQ/I1K7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXvcTpKEUHIWRfzTvugFUaqpyiKeQxpOQ3R2S7gdRjBrDZD+Q8azAIgn3okJMyQP+1XFUvnQc6/T7COFwbohLQX/303zaDk/7fxx/gRtzN98kr+g5jKhmxtISVkSbfi8npebdCqSwL08Ei/G38qqqPR16UylIah2GFdhubwKPFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=TPfLuhsO; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="TPfLuhsO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UHizrEKMno1n6ARrhZYNsrpUhw23jR/DQGnZAIjhJYE=; b=TPfLuhsO0SuTQMqTXMfDDHjrVe
	cOK6c+f0VvKjkGZB4DBA65tChU5BQTV2lCIsBpQjUKQvpGp7C39qOkF+a5V6bJl08Fd2ifqOOftYS
	Uc/xEULdK4RF1HNVtwnfNmrCNeijaMA+XYfzFPMJK5brfrX8MNEXQz03HaPrlxCaAfS99paDiKVmB
	W2p8uut1+Fn6MyZAZC1DWL7Ku6LvIIbx/wlSrETECsyXV+lQma2w0VECsak7T+6J+38JFsYDeSQuq
	2dkDdZizlHbbf8ivHYRwQvlq2y8nTlnHVVvTGTb6CQClo3jjTztCWZiYbBzA1IefY4nbONz3aN0SK
	D58pILfQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vJhdU-000000005kj-49sc;
	Fri, 14 Nov 2025 01:25:57 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 02/11] mergesort: Fix sorting of string values
Date: Fri, 14 Nov 2025 01:25:33 +0100
Message-ID: <20251114002542.22667-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251114002542.22667-1-phil@nwl.cc>
References: <20251114002542.22667-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sorting order was obviously wrong, e.g. "ppp0" ordered before "eth1".
Moreover, this happened on Little Endian only so sorting order actually
depended on host's byteorder. By reimporting string values as Big
Endian, both issues are fixed: On one hand, GMP-internal byteorder no
longer depends on host's byteorder, on the other comparing strings
really starts with the first character, not the last.

Fixes: 14ee0a979b622 ("src: sort set elements in netlink_get_setelems()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mergesort.c                               |  7 +++
 tests/py/any/meta.t.json.output               | 54 -------------------
 tests/py/any/queue.t.json.output              |  4 +-
 tests/py/inet/osf.t.json.output               | 54 +++++++++++++++++++
 .../testcases/maps/dumps/0012map_0.json-nft   | 20 +++----
 .../shell/testcases/maps/dumps/0012map_0.nft  |  8 +--
 .../maps/dumps/named_ct_objects.json-nft      |  4 +-
 .../testcases/maps/dumps/named_ct_objects.nft |  4 +-
 .../sets/dumps/sets_with_ifnames.json-nft     |  4 +-
 .../sets/dumps/sets_with_ifnames.nft          |  2 +-
 10 files changed, 84 insertions(+), 77 deletions(-)

diff --git a/src/mergesort.c b/src/mergesort.c
index a9cba614612ed..97e36917280f3 100644
--- a/src/mergesort.c
+++ b/src/mergesort.c
@@ -37,6 +37,13 @@ static mpz_srcptr expr_msort_value(const struct expr *expr, mpz_t value)
 	case EXPR_RANGE:
 		return expr_msort_value(expr->left, value);
 	case EXPR_VALUE:
+		if (expr_basetype(expr)->type == TYPE_STRING) {
+			char buf[expr->len];
+
+			mpz_export_data(buf, expr->value, BYTEORDER_HOST_ENDIAN, expr->len);
+			mpz_import_data(value, buf, BYTEORDER_BIG_ENDIAN, expr->len);
+			return value;
+		}
 		return expr->value;
 	case EXPR_RANGE_VALUE:
 		return expr->range.low;
diff --git a/tests/py/any/meta.t.json.output b/tests/py/any/meta.t.json.output
index 8f4d597a5034e..4454bb960385d 100644
--- a/tests/py/any/meta.t.json.output
+++ b/tests/py/any/meta.t.json.output
@@ -233,60 +233,6 @@
     }
 ]
 
-# meta iifname {"dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "iifname" }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
-# meta iifname != {"dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "iifname" }
-            },
-            "op": "!=",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
-# meta oifname { "dummy0", "lo"}
-[
-    {
-        "match": {
-            "left": {
-                "meta": { "key": "oifname" }
-            },
-	    "op": "==",
-            "right": {
-                "set": [
-                    "lo",
-                    "dummy0"
-                ]
-            }
-        }
-    }
-]
-
 # meta skuid {"bin", "root", "daemon"} accept
 [
     {
diff --git a/tests/py/any/queue.t.json.output b/tests/py/any/queue.t.json.output
index ea3722383f113..90670cc938866 100644
--- a/tests/py/any/queue.t.json.output
+++ b/tests/py/any/queue.t.json.output
@@ -104,11 +104,11 @@
                                 0
                             ],
                             [
-                                "ppp0",
+                                "eth1",
                                 2
                             ],
                             [
-                                "eth1",
+                                "ppp0",
                                 2
                             ]
                         ]
diff --git a/tests/py/inet/osf.t.json.output b/tests/py/inet/osf.t.json.output
index 922e395f202c7..77ca7e30e0f77 100644
--- a/tests/py/inet/osf.t.json.output
+++ b/tests/py/inet/osf.t.json.output
@@ -18,6 +18,26 @@
     }
 ]
 
+# osf version { "Windows:XP", "MacOs:Sierra" }
+[
+    {
+        "match": {
+            "left": {
+                "osf": {
+                    "key": "version"
+                }
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    "MacOs:Sierra",
+                    "Windows:XP"
+                ]
+            }
+        }
+    }
+]
+
 # ct mark set osf name map { "Windows" : 0x00000001, "MacOs" : 0x00000002 }
 [
     {
@@ -51,3 +71,37 @@
         }
     }
 ]
+
+# ct mark set osf version map { "Windows:XP" : 0x00000003, "MacOs:Sierra" : 0x00000004 }
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "map": {
+                    "data": {
+                        "set": [
+                            [
+                                "MacOs:Sierra",
+                                4
+                            ],
+                            [
+                                "Windows:XP",
+                                3
+                            ]
+                        ]
+                    },
+                    "key": {
+                        "osf": {
+                            "key": "version"
+                        }
+                    }
+                }
+            }
+        }
+    }
+]
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.json-nft b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
index 2892e11d71f54..6c885703ffd6b 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.json-nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.json-nft
@@ -32,21 +32,21 @@
         "map": "verdict",
         "elem": [
           [
-            "lo",
+            "eth0",
             {
-              "accept": null
+              "drop": null
             }
           ],
           [
-            "eth0",
+            "eth1",
             {
               "drop": null
             }
           ],
           [
-            "eth1",
+            "lo",
             {
-              "drop": null
+              "accept": null
             }
           ]
         ]
@@ -69,21 +69,21 @@
               "data": {
                 "set": [
                   [
-                    "lo",
+                    "eth0",
                     {
-                      "accept": null
+                      "drop": null
                     }
                   ],
                   [
-                    "eth0",
+                    "eth1",
                     {
                       "drop": null
                     }
                   ],
                   [
-                    "eth1",
+                    "lo",
                     {
-                      "drop": null
+                      "accept": null
                     }
                   ]
                 ]
diff --git a/tests/shell/testcases/maps/dumps/0012map_0.nft b/tests/shell/testcases/maps/dumps/0012map_0.nft
index e734fc1c70b93..0df329a550518 100644
--- a/tests/shell/testcases/maps/dumps/0012map_0.nft
+++ b/tests/shell/testcases/maps/dumps/0012map_0.nft
@@ -1,12 +1,12 @@
 table ip x {
 	map z {
 		type ifname : verdict
-		elements = { "lo" : accept,
-			     "eth0" : drop,
-			     "eth1" : drop }
+		elements = { "eth0" : drop,
+			     "eth1" : drop,
+			     "lo" : accept }
 	}
 
 	chain y {
-		iifname vmap { "lo" : accept, "eth0" : drop, "eth1" : drop }
+		iifname vmap { "eth0" : drop, "eth1" : drop, "lo" : accept }
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
index c0f270e372b24..34c8798dee8fb 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.json-nft
@@ -195,8 +195,8 @@
         },
         "handle": 0,
         "elem": [
-          "sip",
-          "ftp"
+          "ftp",
+          "sip"
         ]
       }
     },
diff --git a/tests/shell/testcases/maps/dumps/named_ct_objects.nft b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
index 59f18932b28ad..dab683bf5cdbd 100644
--- a/tests/shell/testcases/maps/dumps/named_ct_objects.nft
+++ b/tests/shell/testcases/maps/dumps/named_ct_objects.nft
@@ -50,8 +50,8 @@ table inet t {
 
 	set helpname {
 		typeof ct helper
-		elements = { "sip",
-			     "ftp" }
+		elements = { "ftp",
+			     "sip" }
 	}
 
 	chain y {
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
index ac4284293c32a..7b4849e0530d3 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.json-nft
@@ -260,8 +260,8 @@
               },
               "right": {
                 "set": [
-                  "eth0",
-                  "abcdef0"
+                  "abcdef0",
+                  "eth0"
                 ]
               }
             }
diff --git a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
index 77a8baf58cef2..8abca03a080ec 100644
--- a/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
+++ b/tests/shell/testcases/sets/dumps/sets_with_ifnames.nft
@@ -39,7 +39,7 @@ table inet testifsets {
 	chain v4icmp {
 		iifname @simple counter packets 0 bytes 0
 		iifname @simple_wild counter packets 0 bytes 0
-		iifname { "eth0", "abcdef0" } counter packets 0 bytes 0
+		iifname { "abcdef0", "eth0" } counter packets 0 bytes 0
 		iifname { "abcdef*", "eth0" } counter packets 0 bytes 0
 		iifname vmap @map_wild
 	}
-- 
2.51.0

