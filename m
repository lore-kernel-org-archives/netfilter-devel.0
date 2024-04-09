Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453D06FE35
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712643853; cv=none; b=t4Eorj/f6Oj1otWxYbudvJQjPd1uUILK9PW7ZNUGKYXVwdMZxxH4elY7gPzkAKDwNIH5yOTHU4NnqDtNBAKrN4JgDX/VYL+6LenBG0LiVqAqUxNnmU3AUv9Zu1I/guGBBfykWc7CA8bisPAVIZ+8MEg2wk/4Wn5pfmGguYCNNJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712643853; c=relaxed/simple;
	bh=n/xgLHNWse4LTN7aIkQ+kAgz4y1Ne0w+y9JNbin59J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOcHnYnerx2n5mwSLTDnqxZ9CnNPOjkSxE2ze2GJYfbVwYdZ8rcsJDoBSyQNd0+FmhYLIRkRgIBYvoe6cKoZUag/MBEGsBpLAw+E4w/QYtUDzDv1ERdy4zfIM+iG7D9efdIwUtE0+ceFsGmYB21IIEA5XHROny6YXiRfrGBQXLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nNrAaBO9; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nNrAaBO9"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-22eccfeee22so2181725fac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 23:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712643849; x=1713248649; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0djhO2ggMGZD+pDIvRYDBMEW5mU/C5XsoDNJQBsMZQ0=;
        b=nNrAaBO9/4rjDYLCvLCN/kucKCVhOdMoCPGtDxKuijDltAWDxi/eeTjUEF2bFvNzFp
         4CBxQ92LZ6V34ml80mt3izPEFTa6Vssmhy1XXrryGCeu2C8agJ9ByB+/KCFGDiBOQDr5
         AUXPn+pZIJxhTm2SP6oguaeMSwJrVJExJbuIAW8zDUZ7JHxIelbcdDYxhqNhFtb227Q9
         icAU4jIjvLAEvApJJak+3Rk5JMBbcl4UOiwXbJ96fdJRCRFQHQWPlVjs1bhd5bHy+HBd
         oSNdcJVU6phd4uUOiXgF//K2iEiHvOL4T3q3QhCXzLQ4kxefAiWOzOfEtGo9UM76isy3
         hXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712643849; x=1713248649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0djhO2ggMGZD+pDIvRYDBMEW5mU/C5XsoDNJQBsMZQ0=;
        b=m2WtuVfCaapMZKOh6VtV8u/zwPMFuEcU5/htHUnFJrNH1Ff5TFqssdzJ3i2SWJEG2h
         yE1aR7IpKn+0FlvoIfIKk80814sSXIZgt5qxuq8Qz9q1MW6hrnIw+NSpYI0DP9vAxjUt
         7cNYTdioP+SMXu4v9/l0N8gHF9vljGEM37BH4PxL/BoSI5iwnFt9L2bPB8KLJSGOA+5P
         e2R8iuHweHcfW8pACfn3X7+RGGo28mCbOvBe/FpLkN3nwSWQvwT4uwFkuYj9eOYZ7nx9
         B1NuoiV0CMClQ7UPlOJNnFp1plNwgYlcHFYKnfNDgcmWw+sfowHxlQ+QS8YqOZlqCMhr
         SYoA==
X-Gm-Message-State: AOJu0YxfDZAdoQxfsqaU8v0FIxp0FDbCKgGWtSha1837sygAt+4CnuQL
	ei4sqqc1kcUNf/tlWGBxDFbVjECdwvT1sjHoVJLcAVjerXeueQvFZIX7kXfIs3E=
X-Google-Smtp-Source: AGHT+IFdBl2BpRaF7+1vduuTngrF4u30gHCDFexU6grhXQWTMuNpEWUP/6Pl5MKoQc3GNGO1sDAzQQ==
X-Received: by 2002:a05:6870:a2ca:b0:229:ec0e:7348 with SMTP id w10-20020a056870a2ca00b00229ec0e7348mr11748304oak.46.1712643848798;
        Mon, 08 Apr 2024 23:24:08 -0700 (PDT)
Received: from localhost.localdomain (122-151-81-38.sta.wbroadband.net.au. [122.151.81.38])
        by smtp.gmail.com with ESMTPSA id r15-20020a056a00216f00b006e685994cdesm7565527pff.63.2024.04.08.23.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 23:24:08 -0700 (PDT)
From: Son Dinh <dinhtrason@gmail.com>
To: netfilter-devel@vger.kernel.org,
	fw@netfilter.org
Cc: pablo@netfilter.org,
	Son Dinh <dinhtrason@gmail.com>
Subject: [nft PATCH v3] dynset: avoid errouneous assert with ipv6 concat data
Date: Tue,  9 Apr 2024 16:23:31 +1000
Message-ID: <20240409062331.3285-1-dinhtrason@gmail.com>
X-Mailer: git-send-email 2.44.0.windows.1
In-Reply-To: <CA+Xkr6hrT0QvYn3V2S7=drzCLYky-ebe3J_9k8uf-KjSV=kdFw@mail.gmail.com>
References: <CA+Xkr6hrT0QvYn3V2S7=drzCLYky-ebe3J_9k8uf-KjSV=kdFw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix assert bug of map dynset having ipv6 concat data

 nft add rule ip6 table-test chain-1 update @map-X { ip6 saddr : 1000::1 . 5001 }
 nft: src/netlink_linearize.c:873: netlink_gen_expr: Assertion `dreg < ctx->reg_low' failed.
 Aborted (core dumped)

The current code allocates upto 4 registers for map dynset data, but ipv6 concat
data of a dynset requires more than 4 registers, resulting in the assert in
netlink_gen_expr when generating netlink info for the dynset data.

Signed-off-by: Son Dinh <dinhtrason@gmail.com>
---
 src/netlink_linearize.c            |  6 ++---
 tests/py/ip/sets.t                 |  2 ++
 tests/py/ip/sets.t.json            | 37 ++++++++++++++++++++++++++++++
 tests/py/ip/sets.t.payload.inet    | 11 +++++++++
 tests/py/ip/sets.t.payload.ip      |  8 +++++++
 tests/py/ip/sets.t.payload.netdev  | 10 ++++++++
 tests/py/ip6/sets.t                |  3 +++
 tests/py/ip6/sets.t.json           | 37 ++++++++++++++++++++++++++++++
 tests/py/ip6/sets.t.payload.inet   | 11 +++++++++
 tests/py/ip6/sets.t.payload.ip6    |  8 +++++++
 tests/py/ip6/sets.t.payload.netdev | 10 ++++++++
 tests/py/nft-test.py               |  4 ++++
 12 files changed, 144 insertions(+), 3 deletions(-)

diff --git src/netlink_linearize.c src/netlink_linearize.c
index 6204d8fd..de9e975f 100644
--- src/netlink_linearize.c
+++ src/netlink_linearize.c
@@ -1592,11 +1592,11 @@ static void netlink_gen_map_stmt(struct netlink_linearize_ctx *ctx,
 	sreg_key = get_register(ctx, stmt->map.key->key);
 	netlink_gen_expr(ctx, stmt->map.key->key, sreg_key);
 
-	sreg_data = get_register(ctx, stmt->map.data);
-	netlink_gen_expr(ctx, stmt->map.data, sreg_data);
+	sreg_data = get_register(ctx, stmt->map.data->key);
+	netlink_gen_expr(ctx, stmt->map.data->key, sreg_data);
 
 	release_register(ctx, stmt->map.key->key);
-	release_register(ctx, stmt->map.data);
+	release_register(ctx, stmt->map.data->key);
 
 	nle = alloc_nft_expr("dynset");
 	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
diff --git tests/py/ip/sets.t tests/py/ip/sets.t
index 46d9686b..828a1f1f 100644
--- tests/py/ip/sets.t
+++ tests/py/ip/sets.t
@@ -66,3 +66,5 @@ ip saddr @set6 drop;ok
 ip saddr vmap { 1.1.1.1 : drop, * : accept };ok
 meta mark set ip saddr map { 1.1.1.1 : 0x00000001, * : 0x00000002 };ok
 
+!map2 type ipv4_addr . ipv4_addr . inet_service : ipv4_addr . inet_service;ok
+add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 };ok
\ No newline at end of file
diff --git tests/py/ip/sets.t.json tests/py/ip/sets.t.json
index 44ca1528..f2637d93 100644
--- tests/py/ip/sets.t.json
+++ tests/py/ip/sets.t.json
@@ -303,3 +303,40 @@
     }
 ]
 
+# add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
+[
+    {
+        "map": {
+            "data": {
+                "concat": [
+                    "10.0.0.1",
+                    80
+                ]
+            },
+            "elem": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "th"
+                        }
+                    }
+                ]
+            },
+            "map": "@map2",
+            "op": "add"
+        }
+    }
+]
diff --git tests/py/ip/sets.t.payload.inet tests/py/ip/sets.t.payload.inet
index fd6517a5..cc04b43d 100644
--- tests/py/ip/sets.t.payload.inet
+++ tests/py/ip/sets.t.payload.inet
@@ -104,3 +104,14 @@ inet
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ immediate reg 11 0x0100000a ]
+  [ immediate reg 2 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git tests/py/ip/sets.t.payload.ip tests/py/ip/sets.t.payload.ip
index d9cc32b6..f9ee1f98 100644
--- tests/py/ip/sets.t.payload.ip
+++ tests/py/ip/sets.t.payload.ip
@@ -81,3 +81,11 @@ ip test-ip4 input
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ immediate reg 11 0x0100000a ]
+  [ immediate reg 2 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git tests/py/ip/sets.t.payload.netdev tests/py/ip/sets.t.payload.netdev
index d41b9e8b..3d0dc79a 100644
--- tests/py/ip/sets.t.payload.netdev
+++ tests/py/ip/sets.t.payload.netdev
@@ -105,3 +105,13 @@ netdev test-netdev ingress
   [ meta load mark => reg 10 ]
   [ dynset add reg_key 1 set map1 sreg_data 10 ]
 
+# add @map2 { ip saddr . ip daddr . th dport : 10.0.0.1 . 80 }
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ immediate reg 11 0x0100000a ]
+  [ immediate reg 2 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 11 ]
diff --git tests/py/ip6/sets.t tests/py/ip6/sets.t
index 17fd62f5..cc26bd22 100644
--- tests/py/ip6/sets.t
+++ tests/py/ip6/sets.t
@@ -46,3 +46,6 @@ add @set5 { ip6 saddr . ip6 daddr };ok
 add @map1 { ip6 saddr . ip6 daddr : meta mark };ok
 
 delete @set5 { ip6 saddr . ip6 daddr };ok
+
+!map2 type ipv6_addr . ipv6_addr . inet_service : ipv6_addr . inet_service;ok
+add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 };ok
\ No newline at end of file
diff --git tests/py/ip6/sets.t.json tests/py/ip6/sets.t.json
index 2029d2b5..99236099 100644
--- tests/py/ip6/sets.t.json
+++ tests/py/ip6/sets.t.json
@@ -148,3 +148,40 @@
     }
 ]
 
+# add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
+[
+    {
+        "map": {
+            "data": {
+                "concat": [
+                    "1234::1",
+                    80
+                ]
+            },
+            "elem": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip6"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip6"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "th"
+                        }
+                    }
+                ]
+            },
+            "map": "@map2",
+            "op": "add"
+        }
+    }
+]
diff --git tests/py/ip6/sets.t.payload.inet tests/py/ip6/sets.t.payload.inet
index 2bbd5573..2dbb818a 100644
--- tests/py/ip6/sets.t.payload.inet
+++ tests/py/ip6/sets.t.payload.inet
@@ -47,3 +47,14 @@ inet test-inet input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ payload load 16b @ network header + 24 => reg 2 ]
   [ dynset delete reg_key 1 set set5 ]
+
+# add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 3 ]
+  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 21 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git tests/py/ip6/sets.t.payload.ip6 tests/py/ip6/sets.t.payload.ip6
index c59f7b5c..7234b989 100644
--- tests/py/ip6/sets.t.payload.ip6
+++ tests/py/ip6/sets.t.payload.ip6
@@ -36,3 +36,11 @@ ip6 test-ip6 input
   [ meta load mark => reg 3 ]
   [ dynset add reg_key 1 set map1 sreg_data 3 ]
 
+# add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
+ip6 test-ip6 input
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 3 ]
+  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 21 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git tests/py/ip6/sets.t.payload.netdev tests/py/ip6/sets.t.payload.netdev
index 1866d26b..2ad0f434 100644
--- tests/py/ip6/sets.t.payload.netdev
+++ tests/py/ip6/sets.t.payload.netdev
@@ -48,3 +48,13 @@ netdev test-netdev ingress
   [ meta load mark => reg 3 ]
   [ dynset add reg_key 1 set map1 sreg_data 3 ]
 
+# add @map2 { ip6 saddr . ip6 daddr . th dport : 1234::1 . 80 }
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x0000dd86 ]
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ payload load 16b @ network header + 24 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 3 ]
+  [ immediate reg 17 0x00003412 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 21 0x00005000 ]
+  [ dynset add reg_key 1 set map2 sreg_data 17 ]
diff --git tests/py/nft-test.py tests/py/nft-test.py
index a7d27c25..eafa258e 100755
--- tests/py/nft-test.py
+++ tests/py/nft-test.py
@@ -1162,6 +1162,10 @@ def set_process(set_line, filename, lineno):
         set_data = tokens[i+1]
         i += 2
 
+    while len(tokens) > i and tokens[i] == ".":
+        set_data += " . " + tokens[i+1]
+        i += 2
+
     if parse_typeof and tokens[i] == "mark":
         set_data += " " + tokens[i]
         i += 1;
-- 
2.44.0.windows.1

