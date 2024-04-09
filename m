Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17A65473F
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Apr 2024 03:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712631810; cv=none; b=gknBebB3a3aUQHi23m5aehhjwuyeYYZLuRY03MCE+Ms19KzRSGIv4LowjTxuvrU7umMJcTXLnnG+NngC4V4M/dyj5aEq+qlANvA4KecwGS4bKzhqcVNJSoPTZEptf2JnhVkighSCMWyAAAAC/H2zqdo0EnttkAKLYjp6cEVk7YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712631810; c=relaxed/simple;
	bh=zMCZB83S21kXHWwgleWtFLpNVdQwP+M8sUoRc6lXuWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3S5Nn+ZyM0i4ENeSAa/1Ivm3oBJ9pOHuw6X5qJEPVqRQEKNKy6IPVfPKeeYuhV49rD2PwS7ess6Q+YkTqe2sd3W9UXNLpdtY9GyH1GttkHxEOFqUlGz146j+iy/MCwqZMJAcCaEvR1xA5yKwvYQDRe6kR59Ry6l4Gl0Uxu9r64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YNhFsIby; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNhFsIby"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c5fa88c6a4so582880b6e.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2024 20:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712631807; x=1713236607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6p0Rk36YiRfXNsRE7Rie0j+FHUHfqaVk3zghddANo0w=;
        b=YNhFsIby3S+hJA1gdzg+85n8p6slJaV4SLAehmrs1cHVOQ2iB85XBLJSg/RsttYr8r
         qfjxjH8rcs1QhY7GY3I3zP/4oVPp6OOG6qG8INXJaQzBoo1oq4JOYq6LITBTwLVslx8r
         CVaBED5RD6AojQb3/PPMgidZeWRaWFBo8uAH9wfU2oG9iI5271DKou/PXqv8Iqa9KzoQ
         piIDWiudf479fRPkZ+Mk4EKuv+940fnwiQ8KMcVEw7cwINaX/TtutG3deF6HdIQwR9HL
         Hy4sl3aNsNzbw7kIkDq3KA47RBOdVEu3UpOt0d/IJzEmZKIWG8/0Pjuaxj+w8FPtz0P6
         T1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712631807; x=1713236607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6p0Rk36YiRfXNsRE7Rie0j+FHUHfqaVk3zghddANo0w=;
        b=wy0QJZNBF8I1SuHHMNKXuJ5LyxQVJHLXkIJ5y4zgeDD0KzZ3Rk/MtRer5/qpKBlAUx
         E0BaErHs/F0Vw8c5M8G1aYoNo3d+pgo7BVSAEFJHVxF/MC2jVX+9lkUU7tqus2PZJrIH
         ghUnXNzBOdcM1abRnPGeLZpnFhenAypSFPEIEpawMeimJsKRmEjiPS+nL502X8CekVGX
         gAVVL2byB18r96Q9+RKtWL+5wsEPzcVFMciUL2Q0cXqpA1kRogyhIIiNweucRHF629+E
         /THKffFYevpXEdC82WmrUT6gCV7b16IJmTTFfwxdqi+63oUWbXsmaZj4UCW7sHcpqREZ
         MFyg==
X-Gm-Message-State: AOJu0YybzdLv8XZ8AAd0WZxyFqbwIlBTCe+EH9YWgS248DIV7smBiU3c
	8+fFXhfuYca9IMFnd/KIkxv7OkOnrNzMA+RiAidXWw6HY0h9iG9z/yHbtMzboqI=
X-Google-Smtp-Source: AGHT+IGItufyTAUfRUuRYfRbBTugixJDRXww3Dk6G9EDlzf2ecvCCQaVV2sOqEdHQSdZLWSVCQmDaw==
X-Received: by 2002:a05:6808:1922:b0:3c5:e91e:2a61 with SMTP id bf34-20020a056808192200b003c5e91e2a61mr10872659oib.23.1712631807174;
        Mon, 08 Apr 2024 20:03:27 -0700 (PDT)
Received: from localhost.localdomain (122-151-81-38.sta.wbroadband.net.au. [122.151.81.38])
        by smtp.gmail.com with ESMTPSA id o5-20020a056a001b4500b006e72c8ece23sm7265341pfv.191.2024.04.08.20.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Apr 2024 20:03:26 -0700 (PDT)
From: Son Dinh <dinhtrason@gmail.com>
To: netfilter-devel@vger.kernel.org,
	fw@netfilter.org
Cc: pablo@netfilter.org,
	Son Dinh <dinhtrason@gmail.com>
Subject: [nft PATCH v2] dynset: avoid errouneous assert with ipv6 concat data
Date: Tue,  9 Apr 2024 13:02:48 +1000
Message-ID: <20240409030248.2870-1-dinhtrason@gmail.com>
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
 src/netlink_linearize.c            |  6 +++---
 tests/py/ip/sets.t                 |  2 ++
 tests/py/ip/sets.t.payload.inet    | 11 +++++++++++
 tests/py/ip/sets.t.payload.ip      |  8 ++++++++
 tests/py/ip/sets.t.payload.netdev  | 10 ++++++++++
 tests/py/ip6/sets.t                |  3 +++
 tests/py/ip6/sets.t.payload.inet   | 11 +++++++++++
 tests/py/ip6/sets.t.payload.ip6    |  8 ++++++++
 tests/py/ip6/sets.t.payload.netdev | 10 ++++++++++
 tests/py/nft-test.py               |  4 ++++
 10 files changed, 70 insertions(+), 3 deletions(-)

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

