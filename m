Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15803BCD2B
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786042233; cv=none; b=T2wUvcK68C2bn7+7KNre8RASmXcTXWai0A9Pt4mo4Dpy50zz0VgKYQaapQEMvGL0a+yYfFEsdnpBF5vn+rPkIdksm//zN0lgV5ZDP2v8FFjlpWb9zUyp8khOWgjygs96qXtaH2PAk2kNqkT/ZpvkYvDUllsmeIdZ58mejDeW6Ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786042233; c=relaxed/simple;
	bh=DBnkCMAmCKuT31ViqxSr91wpFBjz3360bx75E2ZkSkA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k1vv32cx0b5jPySwXPBJOV/Fe2j7qki74dqOQWxu1feNDY84W9WxtM7fFjWuWSI187GC4y7SZDzmDKCOR3LvDxo0/BUUZkKVe3SPonK9gEZu1TJ4Zfhd1sjZVGOWFgPUUQ0X5fF6njqeYXUCEFQFzDnsJ1V5YQW25FP0a1RxlMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=changeover.za.net; spf=pass smtp.mailfrom=changeover.za.net; dkim=pass (2048-bit key) header.d=changeover.za.net header.i=@changeover.za.net header.b=S2mxGcXp; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=changeover.za.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=changeover.za.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=changeover.za.net header.i=@changeover.za.net header.b="S2mxGcXp"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so25695735e9.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Aug 2026 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=changeover.za.net; s=google; t=1786042228; x=1786647028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FNRp3qlIjcFwfs/cNn7jQs88eCiz0wt3sU5SsY+blnA=;
        b=S2mxGcXptzf5SfFdSCyytfKrxWyFyXBD8rm+PIzcXPY0mj42pjECD/q4o86mV8/tT1
         x7og2rx0rxZW96oMtdT0fKVmjqge8jS4m4RbD+Lc9AlDf2z1Rpow+2z8asBEeNJ0xIxl
         0o5c+IXu2SL9+cYwfNDqhgt3j9ZsK6TWjvOhfSgwOziXQ7ZveSEWO6eKeEIdKgwYhP/n
         TPgsXiPxFmv61Vp+r7hLbmiHbv89HcA+pSvPgogwgrcu6G3rAi7/uKYf00Qzk2OSZlAK
         VskcD08TATvuULMYt2QzspQaKGlZda5+Wum+3hhON8P2L2VZ7x1YeTsYu8H8FEx3gwLz
         HVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786042228; x=1786647028;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FNRp3qlIjcFwfs/cNn7jQs88eCiz0wt3sU5SsY+blnA=;
        b=DTdDElEYnAYCrc1aFVcJupPARkBBOd3nWAv0/2PgaeYZ1cQGdYxx/Oilq3Cisbjvrr
         8XFUdC9qJLa99cJx51nQlxZWG1UL8WWpOLcygv/k0cyOWZUct50VGz15sDPCmDT1Fzc+
         vTu2oPcqyQSeZ23gTvCAY9axyeI6xNkfZjnBIQ56Iz5ca0Eo1OWUJJIAE3cF8uoGWcwA
         sVhV4P99opdc68ahTAMdroFuyxFQgjI785skmslY1wTNIhyt5I9J8DReirUauijDTHmd
         Tl0OSy/TH9gna2OztU2CE29B1AhZxxCXQuxUxkgoh8lsC+p3pHhhM1CC7RuFbVwiTlbd
         x7eg==
X-Gm-Message-State: AOJu0YzutoSVcnunjHMkmJbx8HRliEvPG3SBm6/GXjKHijMWMIxcvKLM
	369t+vnIBG4d8+HtvXhUues6o3rQUUiMQ4HTJvbeQnkUHxnam4rovt1h5YEwXXdIH286FBek46S
	BnRd6RA==
X-Gm-Gg: AR+sD12/jdpwR1N3HAPnobfHOIbUEPlLucS+Mj5v+KpBgWXYDBkatblDV+2bv804gIB
	UlCTDOWIlPUHGQ6Kc2RtrXuXzbbMvLTKqogGCKBFVH7W69nspZYHijHTfNJ5cZJzqXqYwvTYkp0
	qeushiuPJaGtfe+1lxsZqtTg8K9VOkZo1ZbetZTH2iDsk3GvbK8zFxKFUIj2E4mFuSm+5jDm+a4
	sRlnze/sFZylpsN6SbDObYuJDevzAQWOG2uOOkCUCITKYDwcztVcfPJSkcO0RBDRZqkOwzr/N6K
	khwotGLb69T5rQU4s9Yxopr2eQX4jiFkGLoSTrkjMXaaYXheN5UvVZsFd6/Hg7DeTwaPK5TbjZI
	Ze35AGzXgqVM0xEKB1Urbs5DzIFTml5Fp0ru6xcGspqy4FnkACKYVwFQY5yCBmJLOs+67uTZS3M
	WarmhbOiBUNPcf63h+HtchVEdFTBSbNwuiUTjn0FO9jMPv5gteQ0E0RXjT2a02JfMB7HeuTXK6l
	z+jwek4xq/XIaERJ+pvJp7v
X-Received: by 2002:a05:600c:6c50:b0:499:48bb:417e with SMTP id 5b1f17b1804b1-49959e0176bmr42898285e9.2.1786042228018;
        Thu, 06 Aug 2026 11:50:28 -0700 (PDT)
Received: from localhost.localdomain ([102.135.242.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995c69c8ffsm567865e9.2.2026.08.06.11.50.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 11:50:27 -0700 (PDT)
From: Adrian Moisey <adrian@changeover.za.net>
To: netfilter-devel@vger.kernel.org
Cc: Adrian Moisey <adrian@changeover.za.net>
Subject: [PATCH nft] netlink_linearize: size nat register allocation by address expression
Date: Thu,  6 Aug 2026 20:50:20 +0200
Message-ID: <20260806185020.95154-1-adrian@changeover.za.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nat statements with a literal concatenation of address and port, e.g.

  dnat ip6 addr . port to fd00:10:244::4 . 6443

allocated a fixed 128-bit register block for the address, but the ip6
address . port concatenation is 144 bits (5 registers), so
netlink_gen_concat overran into unallocated registers and hit the
assertion 'dreg < ctx->reg_low' in netlink_gen_expr. IPv4 escaped by
luck since its 48-bit concatenation fits into the padded block.

Allocate the register based on the address expression instead, which
sizes by expr->len for concatenations, and add the matching
release_register() call. Extend the nat_addr_port test with literal
concatenation rules for ip and ip6.

Signed-off-by: Adrian Moisey <adrian@changeover.za.net>
---
 src/netlink_linearize.c                       |  6 ++-
 .../maps/dumps/nat_addr_port.json-nft         | 54 +++++++++++++++++++
 .../testcases/maps/dumps/nat_addr_port.nft    |  2 +
 tests/shell/testcases/maps/nat_addr_port      |  2 +
 4 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index ac0eaff9..dfa841c6 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -1292,8 +1292,7 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		nftnl_expr_set_u32(nle, nftnl_flag_attr, stmt->nat.flags);
 
 	if (stmt->nat.addr) {
-		amin_reg = get_register(ctx, NULL);
-		registers++;
+		amin_reg = get_register(ctx, stmt->nat.addr);
 
 		if (stmt->nat.addr->etype == EXPR_RANGE) {
 			amax_reg = get_register(ctx, NULL);
@@ -1374,6 +1373,9 @@ static void netlink_gen_nat_stmt(struct netlink_linearize_ctx *ctx,
 		registers--;
 	}
 
+	if (stmt->nat.addr)
+		release_register(ctx, stmt->nat.addr);
+
 	nft_rule_add_expr(ctx, nle, &stmt->location);
 }
 
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
index 38b01e69..09052c43 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.json-nft
@@ -320,6 +320,33 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip",
+        "table": "ipfoo",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "l4proto"
+                }
+              },
+              "right": "tcp"
+            }
+          },
+          {
+            "dnat": {
+              "addr": "10.2.3.4",
+              "port": 4242
+            }
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip",
@@ -670,6 +697,33 @@
         ]
       }
     },
+    {
+      "rule": {
+        "family": "ip6",
+        "table": "ip6foo",
+        "chain": "c",
+        "handle": 0,
+        "expr": [
+          {
+            "match": {
+              "op": "==",
+              "left": {
+                "meta": {
+                  "key": "l4proto"
+                }
+              },
+              "right": "tcp"
+            }
+          },
+          {
+            "dnat": {
+              "addr": "fd00:10:244::4",
+              "port": 6443
+            }
+          }
+        ]
+      }
+    },
     {
       "rule": {
         "family": "ip6",
diff --git a/tests/shell/testcases/maps/dumps/nat_addr_port.nft b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
index c8493b3a..fb1c190a 100644
--- a/tests/shell/testcases/maps/dumps/nat_addr_port.nft
+++ b/tests/shell/testcases/maps/dumps/nat_addr_port.nft
@@ -29,6 +29,7 @@ table ip ipfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
 		meta l4proto tcp dnat ip to ip saddr map @y
 		dnat ip to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat to 10.2.3.4:4242
 		dnat to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip to numgen inc mod 2 map @t2
 	}
@@ -62,6 +63,7 @@ table ip6 ip6foo {
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
 		meta l4proto tcp dnat ip6 to ip6 saddr map @y
 		dnat ip6 to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat to [fd00:10:244::4]:6443
 		dnat to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip6 to numgen inc mod 2 map @t2
 	}
diff --git a/tests/shell/testcases/maps/nat_addr_port b/tests/shell/testcases/maps/nat_addr_port
index 703a2ad9..5f6ff1c4 100755
--- a/tests/shell/testcases/maps/nat_addr_port
+++ b/tests/shell/testcases/maps/nat_addr_port
@@ -31,6 +31,7 @@ table ip ipfoo {
 		ip saddr 10.1.1.2 tcp dport 42 dnat to 10.2.3.4:4242
 		meta l4proto tcp dnat ip addr . port to ip saddr map @y
 		meta l4proto tcp dnat ip addr . port to ip saddr . tcp dport map @z
+		meta l4proto tcp dnat ip addr . port to 10.2.3.4 . 4242
 		dnat ip to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip addr . port to numgen inc mod 2 map @t2
 	}
@@ -72,6 +73,7 @@ table ip6 ip6foo {
 		ip6 saddr dead::2 tcp dport 42 dnat to [c0::1a]:4242
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr map @y
 		meta l4proto tcp dnat ip6 addr . port to ip6 saddr . tcp dport map @z
+		meta l4proto tcp dnat ip6 addr . port to fd00:10:244::4 . 6443
 		dnat ip6 to numgen inc mod 2 map @t1
 		meta l4proto tcp dnat ip6 addr . port to numgen inc mod 2 map @t2
 	}
-- 
2.55.0

