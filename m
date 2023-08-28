Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D5DC83F11
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 19:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjH1TKH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 15:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbjH1TJr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 15:09:47 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D68102
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 12:09:44 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-99c4923195dso439517666b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 12:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693249783; x=1693854583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pJxMkBSb1lZ0xJMdKo1DDG/kyyMBfsveTfQDguz5jUk=;
        b=Y9pgku4VVDIlyUXWsbX8ypSK0ii/2Zk8DmTlEXu9n1wgmOLMUZDxBmmQZnKUbQshg8
         BzdwQrk7zus6LBbd9FYldFOnETnGaVW6s5bqGIWLMVVCStmxaBlw/E/GC6dxzWXp5j/O
         IY6PSSs1aWPLjnOEJEvdgSgh6bXhobrChuVIcDft9KBAaasf8FNTRm0Nn0FKh5lBdGHi
         Ru6wjr0GVP7xPwEGz8yQkKPNjQ+Mx3sP6f8ubJMEQtxZcAIwauk7u39QKoed3a8a8CL0
         SVjkUPwjI7ujHEm3C6nRDXgMNfzY62mVXcNU5TI4aXXuTCKkwz3q/eYafezDe6QvS0Yf
         EHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693249783; x=1693854583;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pJxMkBSb1lZ0xJMdKo1DDG/kyyMBfsveTfQDguz5jUk=;
        b=FjTCAnU9LtHwsupT2D8EUtVZ/ByFK52Zx/3r9zMOrXOVj5gUJ4E8yHJAnKkkzbNUGt
         5BDnfBdPpE5Pc5nf7A2JuEypyYDsC5eVJmPsiOe1OlDbldpzCIX2Lhsov7RzTOZRVpSp
         BqlgIOFml1WHkNpGP8uc1OoUtCfs1Tx3whBm7Zp5C/KJy0BUbPB0y0wac62Ct/MiTBfP
         UvxKQnpSQyxbtVNNmvAT2Qua6Mxmds6GIRWTtap7yvToXxYGcjoIaitU2DdKbyMLZ1ao
         kVFh8dOOpeBUop0zcPH+m9iaf52bcy39vHjnSWhAdaZ87M3X0DaQVEjw7P0d4b9zjm/N
         9NTA==
X-Gm-Message-State: AOJu0YyhgKwF9OZMDkAruBciYVeh4A+iubQdFW2pDZkbmUxz0XS27Zbg
        o/r4Vblzi44SDn+/aIJr7DCLZRN9yEh/Pw==
X-Google-Smtp-Source: AGHT+IHabkUQjGt0ba9QqZad3GPZlABvbdJouQPNJ/qruSmKehNOZIcPsHi9YchObxsAvooV5vcsKw==
X-Received: by 2002:a17:906:30d9:b0:9a1:bd1d:61b2 with SMTP id b25-20020a17090630d900b009a1bd1d61b2mr12953509ejb.56.1693249782588;
        Mon, 28 Aug 2023 12:09:42 -0700 (PDT)
Received: from localhost.localdomain ([85.217.147.118])
        by smtp.gmail.com with ESMTPSA id u18-20020a1709064ad200b0099bc08862b6sm5088388ejt.171.2023.08.28.12.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 12:09:42 -0700 (PDT)
From:   Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     jortiz@teldat.com, Jorge Ortiz <jorge.ortiz.escribano@gmail.com>
Subject: [nft PATCH] evaluate: place byteorder conversion after numgen for IP address datatypes
Date:   Mon, 28 Aug 2023 21:09:10 +0200
Message-Id: <20230828190910.51041-1-jorge.ortiz.escribano@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The numgen extension generates numbers in little-endian.
This can be very tricky when trying to combine it with IP addresses, which use big endian.
This change adds a new byteorder operation to convert data type endianness.

Before this patch:
$ sudo nft -d netlink add rule nat snat_chain snat to numgen inc mod 7 offset 0x0a000001
ip nat snat_chain
  [ numgen reg 1 = inc mod 7 offset 167772161 ]
  [ nat snat ip addr_min reg 1 ]

After this patch:
$ sudo nft -d netlink add rule nat snat_chain snat to numgen inc mod 7 offset 0x0a000001
ip nat snat_chain
  [ numgen reg 1 = inc mod 7 offset 167772161 ]
  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
  [ nat snat ip addr_min reg 1 ]

Regression tests have been modified to include these new cases.
---
 src/evaluate.c                   |  4 ++
 tests/py/ip/numgen.t             |  2 +
 tests/py/ip/numgen.t.json        | 73 +++++++++++++++++++------
 tests/py/ip/numgen.t.json.output | 92 ++++++++++++++++++++++++++------
 tests/py/ip/numgen.t.payload     | 13 ++++-
 5 files changed, 152 insertions(+), 32 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 1ae2ef0d..fda72c34 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2830,6 +2830,10 @@ static int __stmt_evaluate_arg(struct eval_ctx *ctx, struct stmt *stmt,
 		return byteorder_conversion(ctx, expr, byteorder);
 	case EXPR_PREFIX:
 		return stmt_prefix_conversion(ctx, expr, byteorder);
+	case EXPR_NUMGEN:
+		if (dtype->type == TYPE_IPADDR)
+			return byteorder_conversion(ctx, expr, byteorder);
+		break;
 	default:
 		break;
 	}
diff --git a/tests/py/ip/numgen.t b/tests/py/ip/numgen.t
index 29a6a105..2a881460 100644
--- a/tests/py/ip/numgen.t
+++ b/tests/py/ip/numgen.t
@@ -5,3 +5,5 @@ ct mark set numgen inc mod 2;ok
 ct mark set numgen inc mod 2 offset 100;ok
 dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 };ok
 dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200};ok
+dnat to numgen inc mod 7 offset 167772161;ok
+dnat to numgen inc mod 255 offset 167772161;ok
diff --git a/tests/py/ip/numgen.t.json b/tests/py/ip/numgen.t.json
index 9902c2cf..77bc0a78 100644
--- a/tests/py/ip/numgen.t.json
+++ b/tests/py/ip/numgen.t.json
@@ -10,7 +10,8 @@
             "value": {
                 "numgen": {
                     "mod": 2,
-                    "mode": "inc"
+                    "mode": "inc",
+                    "offset": 0
                 }
             }
         }
@@ -43,12 +44,6 @@
         "dnat": {
             "addr": {
                 "map": {
-                    "key": {
-                        "numgen": {
-                            "mod": 2,
-                            "mode": "inc"
-                        }
-                    },
                     "data": {
                         "set": [
                             [
@@ -60,6 +55,13 @@
                                 "192.168.20.200"
                             ]
                         ]
+                    },
+                    "key": {
+                        "numgen": {
+                            "mod": 2,
+                            "mode": "inc",
+                            "offset": 0
+                        }
                     }
                 }
             }
@@ -73,23 +75,34 @@
         "dnat": {
             "addr": {
                 "map": {
-                    "key": {
-                        "numgen": {
-                            "mod": 10,
-                            "mode": "inc"
-                        }
-                    },
                     "data": {
                         "set": [
                             [
-                                { "range": [ 0, 5 ] },
+                                {
+                                    "range": [
+                                        0,
+                                        5
+                                    ]
+                                },
                                 "192.168.10.100"
                             ],
                             [
-                                { "range": [ 6, 9 ] },
+                                {
+                                    "range": [
+                                        6,
+                                        9
+                                    ]
+                                },
                                 "192.168.20.200"
                             ]
                         ]
+                    },
+                    "key": {
+                        "numgen": {
+                            "mod": 10,
+                            "mode": "inc",
+                            "offset": 0
+                        }
                     }
                 }
             }
@@ -97,3 +110,33 @@
     }
 ]
 
+# dnat to numgen inc mod 7 offset 167772161
+[
+    {
+        "dnat": {
+            "addr": {
+                "numgen": {
+                    "mod": 7,
+                    "mode": "inc",
+                    "offset": 167772161
+                }
+            }
+        }
+    }
+]
+
+# dnat to numgen inc mod 255 offset 167772161
+[
+    {
+        "dnat": {
+            "addr": {
+                "numgen": {
+                    "mod": 255,
+                    "mode": "inc",
+                    "offset": 167772161
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/ip/numgen.t.json.output b/tests/py/ip/numgen.t.json.output
index b54121ca..77bc0a78 100644
--- a/tests/py/ip/numgen.t.json.output
+++ b/tests/py/ip/numgen.t.json.output
@@ -18,19 +18,32 @@
     }
 ]
 
+# ct mark set numgen inc mod 2 offset 100
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "numgen": {
+                    "mod": 2,
+                    "mode": "inc",
+                    "offset": 100
+                }
+            }
+        }
+    }
+]
+
 # dnat to numgen inc mod 2 map { 0 : 192.168.10.100, 1 : 192.168.20.200 }
 [
     {
         "dnat": {
             "addr": {
                 "map": {
-                    "key": {
-                        "numgen": {
-                            "mod": 2,
-                            "mode": "inc",
-                            "offset": 0
-                        }
-                    },
                     "data": {
                         "set": [
                             [
@@ -42,6 +55,13 @@
                                 "192.168.20.200"
                             ]
                         ]
+                    },
+                    "key": {
+                        "numgen": {
+                            "mod": 2,
+                            "mode": "inc",
+                            "offset": 0
+                        }
                     }
                 }
             }
@@ -55,24 +75,34 @@
         "dnat": {
             "addr": {
                 "map": {
-                    "key": {
-                        "numgen": {
-                            "mod": 10,
-                            "mode": "inc",
-                            "offset": 0
-                        }
-                    },
                     "data": {
                         "set": [
                             [
-                                { "range": [ 0, 5 ] },
+                                {
+                                    "range": [
+                                        0,
+                                        5
+                                    ]
+                                },
                                 "192.168.10.100"
                             ],
                             [
-                                { "range": [ 6, 9 ] },
+                                {
+                                    "range": [
+                                        6,
+                                        9
+                                    ]
+                                },
                                 "192.168.20.200"
                             ]
                         ]
+                    },
+                    "key": {
+                        "numgen": {
+                            "mod": 10,
+                            "mode": "inc",
+                            "offset": 0
+                        }
                     }
                 }
             }
@@ -80,3 +110,33 @@
     }
 ]
 
+# dnat to numgen inc mod 7 offset 167772161
+[
+    {
+        "dnat": {
+            "addr": {
+                "numgen": {
+                    "mod": 7,
+                    "mode": "inc",
+                    "offset": 167772161
+                }
+            }
+        }
+    }
+]
+
+# dnat to numgen inc mod 255 offset 167772161
+[
+    {
+        "dnat": {
+            "addr": {
+                "numgen": {
+                    "mod": 255,
+                    "mode": "inc",
+                    "offset": 167772161
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index 3349c68b..34960093 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -7,7 +7,7 @@ ip test-ip4 pre
 __map%d x b
 __map%d x 0
         element 00000000  : 640aa8c0 0 [end]    element 00000001  : c814a8c0 0 [end]
-ip test-ip4 pre 
+ip test-ip4 pre
   [ numgen reg 1 = inc mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ nat dnat ip addr_min reg 1 ]
@@ -27,3 +27,14 @@ ip test-ip4 pre
   [ numgen reg 1 = inc mod 2 offset 100 ]
   [ ct set mark with reg 1 ]
 
+# dnat to numgen inc mod 7 offset 167772161
+ip test-ip4 pre
+  [ numgen reg 1 = inc mod 7 offset 167772161 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ nat dnat ip addr_min reg 1 ]
+
+# dnat to numgen inc mod 255 offset 167772161
+ip test-ip4 pre
+  [ numgen reg 1 = inc mod 255 offset 167772161 ]
+  [ byteorder reg 1 = hton(reg 1, 4, 4) ]
+  [ nat dnat ip addr_min reg 1 ]
-- 
2.34.1

