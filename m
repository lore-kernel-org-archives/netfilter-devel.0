Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479B8212B29
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2025 09:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784263; cv=none; b=OrRXWTQPxee6epMPvTzQBx73snoFrzKptUGArPCTYKTGaA/kD0R7u/kTOX/I2C1OkryYcqL1wQEd8eScf1l5lAiJA97m59ddErrAl9T86ikUaPT6G4bffuIJmaT6jttIRxJ8fN9UOkEqH9/qkKNTYJwZ4qKP12j4bblO6CyCMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784263; c=relaxed/simple;
	bh=WqTP7GQjNbEZJZQ35mv3YiC/LLvCECAkRxmGVzYOjGo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=WVO2n8VO5uiYit1k9HuwvZnda3v7wnVx0mnqeHeEYPa+wzprwRShsCqTHX+FrOyrLtkgxTK7rO0Sef9g6fGbN3UAo7+69DdtwJ84KtC5bFuvoUAlsJPsM6EbaxANKiREtVqU36zJu/9vFcZTX169fqi6LkSKXBH/+h4mOFOPBIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LAuD7MI9; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wDLs0NDO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LAuD7MI9";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wDLs0NDO"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 46D9060725; Mon, 17 Feb 2025 10:24:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739784247;
	bh=KheQDjpXB9O+/t85yw2hdAijhZXfwrQq+x3FR5NaU9k=;
	h=From:To:Subject:Date:From;
	b=LAuD7MI9RyIwVsmLRCYt5xgqFJmaJ15s+wEOr5TiQWY1Wr/2EaJguLA1rsC/BZMSz
	 M+N/4Sv13gEXK2xjRpJyxwlYCg2zVguBYizy2lVEMIw1g0GBUpG0z5qGQwuUEwWU3P
	 TRS6QB/pVlGEUfrFeRZWvxIWJFdKbbqY1lYFNglF5nvhYbMzuijj9EqCdxGXId2Aux
	 J/Haf2XOw5mnNa9v/DBws/ClwlR9HJdIxRH0q4GujzPa43LxJWzk5yMK2YBQ7b9f/y
	 MK8N71PLsVH1SNztSfm0BWy65LJtWvfcB4h65SrG/EK+xd3FRHb6quo6ytPaO/D0aZ
	 HdxoLHSoVKBMA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE6BA6026D
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Feb 2025 10:24:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1739784245;
	bh=KheQDjpXB9O+/t85yw2hdAijhZXfwrQq+x3FR5NaU9k=;
	h=From:To:Subject:Date:From;
	b=wDLs0NDOB4+Mi5VTe0OL3cc6zncXnWIRt8A9SWH5JhavSB9fnLzf1/flHZt+5fCiz
	 BJpVQJ4jRuAnp/dDdBy7mML8nL41HuCsDmLdAOD3qVnjWCEzgX2CK7g1glCVQWPqr/
	 qBunNTkg+9ePcaPEyNkaaegZ3VVnI+HJTsGyAb6DTtIu6MnfNQJINTuFRv7cnNApT/
	 QjWzL5ETP0vUKqQJVkwnLeoAYGM1+EIf9c3uB5J4043rxBGPYyv2qs7ONpAMnYaOQc
	 uxnzsOss2FQqS1sCsrof6tm+TuO6EZIcVeYnIosvsCkENn62iBc35ANRBmFGdP7xbd
	 GB68aQxnrBWFw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_linearize: use range expression for OP_EQ and OP_IMPLICIT
Date: Mon, 17 Feb 2025 10:24:01 +0100
Message-Id: <20250217092401.626273-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

range expression is available since v4.9-rc1~127^2~67^2~3, replace the
two cmp expression when generating netlink bytecode.

Code to delinearize the two cmp expressions to represent the range
remains in place for backwards compatibility.

The delinearize path to parse range expressions with NFT_OP_EQ is
already present since:

 3ed932917cc7 ("src: use new range expression for != [a,b] intervals")

Update tests/py payload accordingly, json tests need no update since
they already use the range to represent them.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c               | 22 +++---------------
 tests/py/any/ct.t.payload             |  9 +++-----
 tests/py/any/meta.t.payload           | 21 ++++++-----------
 tests/py/arp/arp.t.payload            | 12 ++++------
 tests/py/arp/arp.t.payload.netdev     | 12 ++++------
 tests/py/bridge/vlan.t.payload        |  3 +--
 tests/py/bridge/vlan.t.payload.netdev |  3 +--
 tests/py/inet/ah.t.payload            | 12 ++++------
 tests/py/inet/comp.t.payload          |  6 ++---
 tests/py/inet/dccp.t.payload          |  6 ++---
 tests/py/inet/esp.t.payload           |  6 ++---
 tests/py/inet/ipsec.t.payload         |  3 +--
 tests/py/inet/sctp.t.payload          | 12 ++++------
 tests/py/inet/tcp.t.payload           | 21 ++++++-----------
 tests/py/inet/udp.t.payload           | 12 ++++------
 tests/py/inet/udplite.t.payload       |  9 +++-----
 tests/py/ip/dnat.t.payload.ip         |  3 +--
 tests/py/ip/icmp.t.payload.ip         | 21 ++++++-----------
 tests/py/ip/igmp.t.payload            |  3 +--
 tests/py/ip/ip.t.payload              | 33 +++++++++------------------
 tests/py/ip/ip.t.payload.bridge       | 33 +++++++++------------------
 tests/py/ip/ip.t.payload.inet         | 33 +++++++++------------------
 tests/py/ip/ip.t.payload.netdev       | 33 +++++++++------------------
 tests/py/ip/masquerade.t.payload      |  3 +--
 tests/py/ip/redirect.t.payload        |  3 +--
 tests/py/ip/snat.t.payload            |  9 +++-----
 tests/py/ip6/dnat.t.payload.ip6       |  9 +++-----
 tests/py/ip6/dst.t.payload.inet       |  6 ++---
 tests/py/ip6/dst.t.payload.ip6        |  6 ++---
 tests/py/ip6/frag.t.payload.inet      |  9 +++-----
 tests/py/ip6/frag.t.payload.ip6       |  9 +++-----
 tests/py/ip6/frag.t.payload.netdev    |  9 +++-----
 tests/py/ip6/hbh.t.payload.inet       |  6 ++---
 tests/py/ip6/hbh.t.payload.ip6        |  6 ++---
 tests/py/ip6/icmpv6.t.payload.ip6     | 18 +++++----------
 tests/py/ip6/ip6.t.payload.inet       |  9 +++-----
 tests/py/ip6/ip6.t.payload.ip6        |  9 +++-----
 tests/py/ip6/masquerade.t.payload.ip6 |  3 +--
 tests/py/ip6/mh.t.payload.inet        | 12 ++++------
 tests/py/ip6/mh.t.payload.ip6         | 12 ++++------
 tests/py/ip6/redirect.t.payload.ip6   |  3 +--
 tests/py/ip6/rt.t.payload.inet        | 12 ++++------
 tests/py/ip6/rt.t.payload.ip6         | 12 ++++------
 tests/py/ip6/snat.t.payload.ip6       |  6 ++---
 44 files changed, 162 insertions(+), 337 deletions(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 42310115f02e..e69d323cdeaf 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -493,9 +493,11 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 
 	switch (expr->op) {
 	case OP_NEQ:
+	case OP_EQ:
+	case OP_IMPLICIT:
 		nle = alloc_nft_expr("range");
 		netlink_put_register(nle, NFTNL_EXPR_RANGE_SREG, sreg);
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_RANGE_OP, NFT_RANGE_NEQ);
+		nftnl_expr_set_u32(nle, NFTNL_EXPR_RANGE_OP, netlink_gen_cmp_op(expr->op));
 		netlink_gen_data(range->left, &nld);
 		nftnl_expr_set(nle, NFTNL_EXPR_RANGE_FROM_DATA,
 			       nld.value, nld.len);
@@ -504,24 +506,6 @@ static void netlink_gen_range(struct netlink_linearize_ctx *ctx,
 			       nld.value, nld.len);
 		nft_rule_add_expr(ctx, nle, &expr->location);
 		break;
-	case OP_EQ:
-	case OP_IMPLICIT:
-		nle = alloc_nft_expr("cmp");
-		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				   netlink_gen_cmp_op(OP_GTE));
-		netlink_gen_data(range->left, &nld);
-		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-		nft_rule_add_expr(ctx, nle, &expr->location);
-
-		nle = alloc_nft_expr("cmp");
-		netlink_put_register(nle, NFTNL_EXPR_CMP_SREG, sreg);
-		nftnl_expr_set_u32(nle, NFTNL_EXPR_CMP_OP,
-				   netlink_gen_cmp_op(OP_LTE));
-		netlink_gen_data(range->right, &nld);
-		nftnl_expr_set(nle, NFTNL_EXPR_CMP_DATA, nld.value, nld.len);
-		nft_rule_add_expr(ctx, nle, &expr->location);
-		break;
 	default:
 		BUG("invalid range operation %u\n", expr->op);
 
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index 14385cf7ead2..6016009425ec 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -172,8 +172,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x32000000 ]
-  [ cmp lte reg 1 0x45000000 ]
+  [ range eq reg 1 0x32000000 0x45000000 ]
 
 # ct mark != 0x00000032-0x00000045
 ip test-ip4 output
@@ -240,8 +239,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x60ea0000 ]
-  [ cmp lte reg 1 0x80ee3600 ]
+  [ range eq reg 1 0x60ea0000 0x80ee3600 ]
 
 # ct expiration > 4d23h59m59s
 ip test-ip4 output
@@ -258,8 +256,7 @@ ip test-ip4 output
 ip test-ip4 output
   [ ct load expiration => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0xe8800000 ]
-  [ cmp lte reg 1 0xc8af0000 ]
+  [ range eq reg 1 0xe8800000 0xc8af0000 ]
 
 # ct expiration != 33-45
 ip test-ip4 output
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index 49dd729bd111..a037e0673fec 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -17,8 +17,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load len => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # meta length != 33-45
 ip test-ip4 input
@@ -99,8 +98,7 @@ ip test-ip4 input
 # meta l4proto 33-45
 ip test-ip4 input
   [ meta load l4proto => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # meta l4proto != 33-45
 ip test-ip4 input
@@ -385,8 +383,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skuid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0xb90b0000 ]
-  [ cmp lte reg 1 0xbd0b0000 ]
+  [ range eq reg 1 0xb90b0000 0xbd0b0000 ]
   [ immediate reg 0 accept ]
 
 # meta skuid != 2001-2005 accept
@@ -448,8 +445,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load skgid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0xd1070000 ]
-  [ cmp lte reg 1 0xd5070000 ]
+  [ range eq reg 1 0xd1070000 0xd5070000 ]
   [ immediate reg 0 accept ]
 
 # meta skgid != 2001-2005 accept
@@ -583,8 +579,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cpu => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x01000000 ]
-  [ cmp lte reg 1 0x03000000 ]
+  [ range eq reg 1 0x01000000 0x03000000 ]
 
 # meta cpu != 1-2
 ip test-ip4 input
@@ -703,8 +698,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load cgroup => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0x01001000 ]
-  [ cmp lte reg 1 0x02001000 ]
+  [ range eq reg 1 0x01001000 0x02001000 ]
 
 # meta cgroup != 1048577-1048578
 ip test-ip4 input
@@ -789,8 +783,7 @@ ip test-ip4 input
 ip test-ip4 input
   [ meta load priority => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
-  [ cmp gte reg 1 0xdadaadbc ]
-  [ cmp lte reg 1 0xdcdaadbc ]
+  [ range eq reg 1 0xdadaadbc 0xdcdaadbc ]
 
 # meta priority != bcad:dada-bcad:dadc
 ip test-ip4 input
diff --git a/tests/py/arp/arp.t.payload b/tests/py/arp/arp.t.payload
index d56927b55ad8..0182bb1b1438 100644
--- a/tests/py/arp/arp.t.payload
+++ b/tests/py/arp/arp.t.payload
@@ -21,8 +21,7 @@ arp test-arp input
 # arp htype 33-45
 arp test-arp input
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # arp htype != 33-45
 arp test-arp input
@@ -63,8 +62,7 @@ arp test-arp input
 # arp hlen 33-45
 arp test-arp input
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # arp hlen != 33-45
 arp test-arp input
@@ -100,8 +98,7 @@ arp test-arp input
 # arp plen 33-45
 arp test-arp input
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # arp plen != 33-45
 arp test-arp input
@@ -143,8 +140,7 @@ arp test-arp input
 # arp operation 1-2
 arp test-arp input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00000100 ]
-  [ cmp lte reg 1 0x00000200 ]
+  [ range eq reg 1 0x00000100 0x00000200 ]
 
 # arp operation request
 arp test-arp input
diff --git a/tests/py/arp/arp.t.payload.netdev b/tests/py/arp/arp.t.payload.netdev
index 92df24002018..d118811263e0 100644
--- a/tests/py/arp/arp.t.payload.netdev
+++ b/tests/py/arp/arp.t.payload.netdev
@@ -31,8 +31,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # arp htype != 33-45
 netdev test-netdev ingress 
@@ -87,8 +86,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # arp hlen != 33-45
 netdev test-netdev ingress 
@@ -136,8 +134,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 1b @ network header + 5 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # arp plen != 33-45
 netdev test-netdev ingress 
@@ -191,8 +188,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000608 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00000100 ]
-  [ cmp lte reg 1 0x00000200 ]
+  [ range eq reg 1 0x00000100 0x00000200 ]
 
 # arp operation request
 netdev test-netdev ingress 
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 2592bb96ad7c..0144a9a5b036 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -207,8 +207,7 @@ bridge test-bridge input
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000020 ]
-  [ cmp lte reg 1 0x00000060 ]
+  [ range eq reg 1 0x00000020 0x00000060 ]
 
 # ether type vlan ip protocol 1 accept
 bridge test-bridge input
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index f33419470ad5..330fb4a32df5 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -243,8 +243,7 @@ netdev test-netdev ingress
   [ lookup reg 1 set __set%d ]
   [ payload load 1b @ link header + 14 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x000000e0 ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000020 ]
-  [ cmp lte reg 1 0x00000060 ]
+  [ range eq reg 1 0x00000020 0x00000060 ]
 
 # ether type vlan ip protocol 1 accept
 netdev test-netdev ingress
diff --git a/tests/py/inet/ah.t.payload b/tests/py/inet/ah.t.payload
index 7ddd72d57363..e0cd2002ba55 100644
--- a/tests/py/inet/ah.t.payload
+++ b/tests/py/inet/ah.t.payload
@@ -3,8 +3,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x0000000b ]
-  [ cmp lte reg 1 0x00000017 ]
+  [ range eq reg 1 0x0000000b 0x00000017 ]
 
 # ah hdrlength != 11-23
 inet test-inet input
@@ -52,8 +51,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ah reserved != 33-45
 inet test-inet input
@@ -101,8 +99,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
+  [ range eq reg 1 0x6f000000 0xde000000 ]
 
 # ah spi != 111-222
 inet test-inet input
@@ -170,8 +167,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000033 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x17000000 ]
-  [ cmp lte reg 1 0x21000000 ]
+  [ range eq reg 1 0x17000000 0x21000000 ]
 
 # ah sequence != 23-33
 inet test-inet input
diff --git a/tests/py/inet/comp.t.payload b/tests/py/inet/comp.t.payload
index 024e47cd99ed..2ffe3b318651 100644
--- a/tests/py/inet/comp.t.payload
+++ b/tests/py/inet/comp.t.payload
@@ -24,8 +24,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000033 ]
-  [ cmp lte reg 1 0x00000045 ]
+  [ range eq reg 1 0x00000033 0x00000045 ]
 
 # comp flags != 0x33-0x45
 inet test-inet input
@@ -73,8 +72,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000006c ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # comp cpi != 33-45
 inet test-inet input
diff --git a/tests/py/inet/dccp.t.payload b/tests/py/inet/dccp.t.payload
index c0b87be18da7..7cb9721c1cd8 100644
--- a/tests/py/inet/dccp.t.payload
+++ b/tests/py/inet/dccp.t.payload
@@ -3,8 +3,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001500 ]
-  [ cmp lte reg 1 0x00002300 ]
+  [ range eq reg 1 0x00001500 0x00002300 ]
 
 # dccp sport != 21-35
 inet test-inet input
@@ -38,8 +37,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000021 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001400 ]
-  [ cmp lte reg 1 0x00003200 ]
+  [ range eq reg 1 0x00001400 0x00003200 ]
 
 # dccp dport {23, 24, 25}
 __set%d test-ip4 3
diff --git a/tests/py/inet/esp.t.payload b/tests/py/inet/esp.t.payload
index 0353b056bb66..bb67aad6848f 100644
--- a/tests/py/inet/esp.t.payload
+++ b/tests/py/inet/esp.t.payload
@@ -17,8 +17,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x6f000000 ]
-  [ cmp lte reg 1 0xde000000 ]
+  [ range eq reg 1 0x6f000000 0xde000000 ]
 
 # esp spi != 111-222
 inet test-inet input
@@ -59,8 +58,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000032 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x16000000 ]
-  [ cmp lte reg 1 0x18000000 ]
+  [ range eq reg 1 0x16000000 0x18000000 ]
 
 # esp sequence != 22-24
 inet test-inet input
diff --git a/tests/py/inet/ipsec.t.payload b/tests/py/inet/ipsec.t.payload
index 9648255df02e..f8ecd9d1cc1f 100644
--- a/tests/py/inet/ipsec.t.payload
+++ b/tests/py/inet/ipsec.t.payload
@@ -16,8 +16,7 @@ ip ipsec-ip4 ipsec-input
 # ipsec out spi 1-561
 inet ipsec-inet ipsec-post
   [ xfrm load out 0 spi => reg 1 ]
-  [ cmp gte reg 1 0x01000000 ]
-  [ cmp lte reg 1 0x31020000 ]
+  [ range eq reg 1 0x01000000 0x31020000 ]
 
 # ipsec in spnum 2 ip saddr { 1.2.3.4, 10.6.0.0/16 }
 __set%d ipsec-ip4 7 size 5
diff --git a/tests/py/inet/sctp.t.payload b/tests/py/inet/sctp.t.payload
index 7337e2eab490..0f6b3a8b1fc8 100644
--- a/tests/py/inet/sctp.t.payload
+++ b/tests/py/inet/sctp.t.payload
@@ -17,8 +17,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
+  [ range eq reg 1 0x00001700 0x00002c00 ]
 
 # sctp sport != 23-44
 inet test-inet input
@@ -66,8 +65,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00001700 ]
-  [ cmp lte reg 1 0x00002c00 ]
+  [ range eq reg 1 0x00001700 0x00002c00 ]
 
 # sctp dport != 23-44
 inet test-inet input
@@ -115,8 +113,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x15000000 ]
-  [ cmp lte reg 1 0x4d010000 ]
+  [ range eq reg 1 0x15000000 0x4d010000 ]
 
 # sctp checksum != 32-111
 inet test-inet input
@@ -164,8 +161,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000084 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # sctp vtag != 33-45
 inet test-inet input
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index bc6bb989ae1a..5c36ad3e4a21 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -17,8 +17,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # tcp dport != 33-45
 inet test-inet input
@@ -117,8 +116,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # tcp sport != 33-45
 inet test-inet input
@@ -223,8 +221,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # tcp sequence != 33-45
 inet test-inet input
@@ -280,8 +277,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 4b @ transport header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # tcp ackseq != 33-45
 inet test-inet input
@@ -500,8 +496,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 14 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # tcp window != 33-45
 inet test-inet input
@@ -549,8 +544,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # tcp checksum != 33-45
 inet test-inet input
@@ -606,8 +600,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 18 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # tcp urgptr != 33-45
 inet test-inet input
diff --git a/tests/py/inet/udp.t.payload b/tests/py/inet/udp.t.payload
index 32f7f8c3f564..d2c62d92653b 100644
--- a/tests/py/inet/udp.t.payload
+++ b/tests/py/inet/udp.t.payload
@@ -19,8 +19,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
+  [ range eq reg 1 0x00003200 0x00004600 ]
   [ immediate reg 0 accept ]
 
 # udp sport != 50-60 accept
@@ -74,8 +73,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
+  [ range eq reg 1 0x00004600 0x00004b00 ]
   [ immediate reg 0 accept ]
 
 # udp dport != 50-60 accept
@@ -127,8 +125,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004100 ]
+  [ range eq reg 1 0x00003200 0x00004100 ]
   [ immediate reg 0 accept ]
 
 # udp length != 50-65 accept
@@ -199,8 +196,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # udp checksum != 33-45
 inet test-inet input 
diff --git a/tests/py/inet/udplite.t.payload b/tests/py/inet/udplite.t.payload
index de9d09edf5ee..dbaeaa78c354 100644
--- a/tests/py/inet/udplite.t.payload
+++ b/tests/py/inet/udplite.t.payload
@@ -19,8 +19,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00003200 ]
-  [ cmp lte reg 1 0x00004600 ]
+  [ range eq reg 1 0x00003200 0x00004600 ]
   [ immediate reg 0 accept ]
 
 # udplite sport != 50-60 accept
@@ -74,8 +73,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004600 ]
-  [ cmp lte reg 1 0x00004b00 ]
+  [ range eq reg 1 0x00004600 0x00004b00 ]
   [ immediate reg 0 accept ]
 
 # udplite dport != 50-60 accept
@@ -146,8 +144,7 @@ inet test-inet input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000088 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # udplite checksum != 33-45
 inet test-inet input
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 439c6abef03f..72b52546c64e 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -5,8 +5,7 @@ ip test-ip4 prerouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat dnat ip addr_min reg 1 ]
 
diff --git a/tests/py/ip/icmp.t.payload.ip b/tests/py/ip/icmp.t.payload.ip
index 3bc6de3cf717..04a53cff4635 100644
--- a/tests/py/ip/icmp.t.payload.ip
+++ b/tests/py/ip/icmp.t.payload.ip
@@ -133,8 +133,7 @@ ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x00000037 ]
+  [ range eq reg 1 0x00000021 0x00000037 ]
 
 # icmp code != 33-55
 ip test-ip4 input
@@ -184,8 +183,7 @@ ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000001 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000b00 ]
-  [ cmp lte reg 1 0x00005701 ]
+  [ range eq reg 1 0x00000b00 0x00005701 ]
   [ immediate reg 0 accept ]
 
 # icmp checksum != 11-343 accept
@@ -265,8 +263,7 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # icmp id != 33-45
 __set%d test-ip4 3
@@ -344,8 +341,7 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # icmp sequence != 33-45
 __set%d test-ip4 3
@@ -438,8 +434,7 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00001600 ]
-  [ cmp lte reg 1 0x00002100 ]
+  [ range eq reg 1 0x00001600 0x00002100 ]
 
 # icmp mtu 22
 ip test-ip4 input
@@ -466,8 +461,7 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000003 ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # icmp mtu != 33-45
 ip test-ip4 input
@@ -527,8 +521,7 @@ ip test-ip4 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000005 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # icmp gateway != 33-45
 ip test-ip4 input
diff --git a/tests/py/ip/igmp.t.payload b/tests/py/ip/igmp.t.payload
index 940fe2cd3014..872fc3afa3b7 100644
--- a/tests/py/ip/igmp.t.payload
+++ b/tests/py/ip/igmp.t.payload
@@ -52,8 +52,7 @@ ip test-ip4 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000b00 ]
-  [ cmp lte reg 1 0x00005701 ]
+  [ range eq reg 1 0x00000b00 0x00005701 ]
 
 # igmp checksum != 11-343
 ip test-ip4 input 
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d7ddf7be0c3b..b0e9efa5f8e4 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -63,8 +63,7 @@ ip test-ip4 input
 # ip length 333-435
 ip test-ip4 input
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004d01 ]
-  [ cmp lte reg 1 0x0000b301 ]
+  [ range eq reg 1 0x00004d01 0x0000b301 ]
 
 # ip length != 333-453
 ip test-ip4 input
@@ -100,8 +99,7 @@ ip test-ip4 input
 # ip id 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip id != 33-45
 ip test-ip4 input
@@ -138,8 +136,7 @@ ip test-ip4 input
 # ip frag-off 0x21-0x2d
 ip test-ip4 input
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off != 0x21-0x2d
 ip test-ip4 input
@@ -194,8 +191,7 @@ ip test-ip4 input
 # ip ttl 33-55
 ip test-ip4 input
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x00000037 ]
+  [ range eq reg 1 0x00000021 0x00000037 ]
 
 # ip ttl != 45-50
 ip test-ip4 input
@@ -270,8 +266,7 @@ ip test-ip4 input
 # ip checksum 33-45
 ip test-ip4 input
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum != 33-45
 ip test-ip4 input
@@ -324,26 +319,22 @@ ip test-ip4 input
 # ip daddr 192.168.0.1-192.168.0.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0100a8c0 ]
-  [ cmp lte reg 1 0xfa00a8c0 ]
+  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0xffffff0a ]
+  [ range eq reg 1 0x0000000a 0xffffff0a ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x000010ac ]
-  [ cmp lte reg 1 0xffff1fac ]
+  [ range eq reg 1 0x000010ac 0xffff1fac ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0103a8c0 ]
-  [ cmp lte reg 1 0xfa04a8c0 ]
+  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 ip test-ip4 input
@@ -371,8 +362,7 @@ ip test-ip4 input
 # ip daddr 192.168.1.2-192.168.1.55
 ip test-ip4 input
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0201a8c0 ]
-  [ cmp lte reg 1 0x3701a8c0 ]
+  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 ip test-ip4 input
@@ -382,8 +372,7 @@ ip test-ip4 input
 # ip saddr 192.168.1.3-192.168.33.55
 ip test-ip4 input
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp gte reg 1 0x0301a8c0 ]
-  [ cmp lte reg 1 0x3721a8c0 ]
+  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 ip test-ip4 input
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 53f881d336df..9400fd0fb004 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -83,8 +83,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004d01 ]
-  [ cmp lte reg 1 0x0000b301 ]
+  [ range eq reg 1 0x00004d01 0x0000b301 ]
 
 # ip length != 333-453
 bridge test-bridge input 
@@ -132,8 +131,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip id != 33-45
 bridge test-bridge input 
@@ -182,8 +180,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off != 0x21-0x2d
 bridge test-bridge input 
@@ -256,8 +253,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x00000037 ]
+  [ range eq reg 1 0x00000021 0x00000037 ]
 
 # ip ttl != 45-50
 bridge test-bridge input 
@@ -356,8 +352,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum != 33-45
 bridge test-bridge input 
@@ -428,32 +423,28 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0100a8c0 ]
-  [ cmp lte reg 1 0xfa00a8c0 ]
+  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0xffffff0a ]
+  [ range eq reg 1 0x0000000a 0xffffff0a ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x000010ac ]
-  [ cmp lte reg 1 0xffff1fac ]
+  [ range eq reg 1 0x000010ac 0xffff1fac ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0103a8c0 ]
-  [ cmp lte reg 1 0xfa04a8c0 ]
+  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 bridge test-bridge input 
@@ -489,8 +480,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0201a8c0 ]
-  [ cmp lte reg 1 0x3701a8c0 ]
+  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 bridge test-bridge input 
@@ -504,8 +494,7 @@ bridge test-bridge input
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp gte reg 1 0x0301a8c0 ]
-  [ cmp lte reg 1 0x3721a8c0 ]
+  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 bridge test-bridge input 
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 08674c98e022..16df241f5a41 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -83,8 +83,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004d01 ]
-  [ cmp lte reg 1 0x0000b301 ]
+  [ range eq reg 1 0x00004d01 0x0000b301 ]
 
 # ip length != 333-453
 inet test-inet input
@@ -132,8 +131,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip id != 33-45
 inet test-inet input
@@ -182,8 +180,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off != 0x21-0x2d
 inet test-inet input
@@ -256,8 +253,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x00000037 ]
+  [ range eq reg 1 0x00000021 0x00000037 ]
 
 # ip ttl != 45-50
 inet test-inet input
@@ -356,8 +352,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum != 33-45
 inet test-inet input
@@ -428,32 +423,28 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0100a8c0 ]
-  [ cmp lte reg 1 0xfa00a8c0 ]
+  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0xffffff0a ]
+  [ range eq reg 1 0x0000000a 0xffffff0a ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x000010ac ]
-  [ cmp lte reg 1 0xffff1fac ]
+  [ range eq reg 1 0x000010ac 0xffff1fac ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0103a8c0 ]
-  [ cmp lte reg 1 0xfa04a8c0 ]
+  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 inet test-inet input
@@ -489,8 +480,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0201a8c0 ]
-  [ cmp lte reg 1 0x3701a8c0 ]
+  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 inet test-inet input
@@ -504,8 +494,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp gte reg 1 0x0301a8c0 ]
-  [ cmp lte reg 1 0x3721a8c0 ]
+  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 inet test-inet input
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 8220b05d11c1..0a80af343803 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -17,8 +17,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00004d01 ]
-  [ cmp lte reg 1 0x0000b301 ]
+  [ range eq reg 1 0x00004d01 0x0000b301 ]
 
 # ip length != 333-453
 netdev test-netdev ingress 
@@ -66,8 +65,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip id != 33-45
 netdev test-netdev ingress 
@@ -116,8 +114,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip frag-off != 0x21-0x2d
 netdev test-netdev ingress 
@@ -183,8 +180,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 1b @ network header + 8 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x00000037 ]
+  [ range eq reg 1 0x00000021 0x00000037 ]
 
 # ip ttl != 45-50
 netdev test-netdev ingress 
@@ -269,8 +265,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 2b @ network header + 10 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip checksum != 33-45
 netdev test-netdev ingress 
@@ -334,32 +329,28 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0100a8c0 ]
-  [ cmp lte reg 1 0xfa00a8c0 ]
+  [ range eq reg 1 0x0100a8c0 0xfa00a8c0 ]
 
 # ip daddr 10.0.0.0-10.255.255.255
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0xffffff0a ]
+  [ range eq reg 1 0x0000000a 0xffffff0a ]
 
 # ip daddr 172.16.0.0-172.31.255.255
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x000010ac ]
-  [ cmp lte reg 1 0xffff1fac ]
+  [ range eq reg 1 0x000010ac 0xffff1fac ]
 
 # ip daddr 192.168.3.1-192.168.4.250
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0103a8c0 ]
-  [ cmp lte reg 1 0xfa04a8c0 ]
+  [ range eq reg 1 0x0103a8c0 0xfa04a8c0 ]
 
 # ip daddr != 192.168.0.1-192.168.0.250
 netdev test-netdev ingress 
@@ -395,8 +386,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0201a8c0 ]
-  [ cmp lte reg 1 0x3701a8c0 ]
+  [ range eq reg 1 0x0201a8c0 0x3701a8c0 ]
 
 # ip daddr != 192.168.1.2-192.168.1.55
 netdev test-netdev ingress 
@@ -410,8 +400,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
   [ payload load 4b @ network header + 12 => reg 1 ]
-  [ cmp gte reg 1 0x0301a8c0 ]
-  [ cmp lte reg 1 0x3721a8c0 ]
+  [ range eq reg 1 0x0301a8c0 0x3721a8c0 ]
 
 # ip saddr != 192.168.1.3-192.168.33.55
 netdev test-netdev ingress 
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index 79e52856a22d..c4957fd74f8f 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -100,8 +100,7 @@ ip test-ip4 postrouting
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter masquerade
 ip test-ip4 postrouting
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0x0403020a ]
+  [ range eq reg 1 0x0000000a 0x0403020a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/py/ip/redirect.t.payload b/tests/py/ip/redirect.t.payload
index 4bed47c18ef9..8a543057e76a 100644
--- a/tests/py/ip/redirect.t.payload
+++ b/tests/py/ip/redirect.t.payload
@@ -182,8 +182,7 @@ ip test-ip4 output
 # ip daddr 10.0.0.0-10.2.3.4 udp dport 53 counter redirect
 ip test-ip4 output
   [ payload load 4b @ network header + 16 => reg 1 ]
-  [ cmp gte reg 1 0x0000000a ]
-  [ cmp lte reg 1 0x0403020a ]
+  [ range eq reg 1 0x0000000a 0x0403020a ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 71a5e2f1a54e..7044d7b023bb 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -5,8 +5,7 @@ ip test-ip4 postrouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ nat snat ip addr_min reg 1 ]
 
@@ -67,8 +66,7 @@ ip
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0003a8c0 ]
   [ immediate reg 2 0xff03a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 2 ]
@@ -80,8 +78,7 @@ ip
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0f03a8c0 ]
   [ immediate reg 2 0xf003a8c0 ]
   [ nat snat ip addr_min reg 1 addr_max reg 2 ]
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 004ffdeb3171..fe6e0422f074 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -3,8 +3,7 @@ ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00005000 ]
@@ -16,8 +15,7 @@ ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
@@ -28,8 +26,7 @@ ip6 test-ip6 prerouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x00005000 ]
   [ nat dnat ip6 addr_min reg 1 proto_min reg 2 flags 0x2 ]
diff --git a/tests/py/ip6/dst.t.payload.inet b/tests/py/ip6/dst.t.payload.inet
index 90d6bda1e0b4..476fdbcd7363 100644
--- a/tests/py/ip6/dst.t.payload.inet
+++ b/tests/py/ip6/dst.t.payload.inet
@@ -17,8 +17,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr != 33-45
 inet test-inet input
@@ -100,8 +99,7 @@ ip6 test-ip6 input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/dst.t.payload.ip6 b/tests/py/ip6/dst.t.payload.ip6
index 941140d0c0e7..af3bab9b1f75 100644
--- a/tests/py/ip6/dst.t.payload.ip6
+++ b/tests/py/ip6/dst.t.payload.ip6
@@ -11,8 +11,7 @@ ip6 test-ip6 input
 # dst nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # dst nexthdr != 33-45
 ip6 test-ip6 input
@@ -74,8 +73,7 @@ ip6 test-ip6 input
 # dst hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 60 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # dst hdrlength != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/frag.t.payload.inet b/tests/py/ip6/frag.t.payload.inet
index 20334f441158..1100896eb61c 100644
--- a/tests/py/ip6/frag.t.payload.inet
+++ b/tests/py/ip6/frag.t.payload.inet
@@ -65,8 +65,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved != 33-45
 inet test-inet output
@@ -117,8 +116,7 @@ inet test-inet output
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000801 ]
-  [ cmp lte reg 1 0x00006801 ]
+  [ range eq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off != 33-45
 inet test-inet output
@@ -176,8 +174,7 @@ inet test-inet output
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # frag id != 33-45
 inet test-inet output
diff --git a/tests/py/ip6/frag.t.payload.ip6 b/tests/py/ip6/frag.t.payload.ip6
index 7c3e7a4e7264..0556395a87ca 100644
--- a/tests/py/ip6/frag.t.payload.ip6
+++ b/tests/py/ip6/frag.t.payload.ip6
@@ -47,8 +47,7 @@ ip6 test-ip6 output
 # frag reserved 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved != 33-45
 ip6 test-ip6 output
@@ -87,8 +86,7 @@ ip6 test-ip6 output
 ip6 test-ip6 output
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000801 ]
-  [ cmp lte reg 1 0x00006801 ]
+  [ range eq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off != 33-45
 ip6 test-ip6 output
@@ -132,8 +130,7 @@ ip6 test-ip6 output
 # frag id 33-45
 ip6 test-ip6 output
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # frag id != 33-45
 ip6 test-ip6 output
diff --git a/tests/py/ip6/frag.t.payload.netdev b/tests/py/ip6/frag.t.payload.netdev
index 056207544763..68257f5bcefe 100644
--- a/tests/py/ip6/frag.t.payload.netdev
+++ b/tests/py/ip6/frag.t.payload.netdev
@@ -65,8 +65,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ exthdr load ipv6 1b @ 44 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # frag reserved != 33-45
 netdev test-netdev ingress
@@ -117,8 +116,7 @@ netdev test-netdev ingress
   [ cmp eq reg 1 0x0000dd86 ]
   [ exthdr load ipv6 2b @ 44 + 2 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000f8ff ) ^ 0x00000000 ]
-  [ cmp gte reg 1 0x00000801 ]
-  [ cmp lte reg 1 0x00006801 ]
+  [ range eq reg 1 0x00000801 0x00006801 ]
 
 # frag frag-off != 33-45
 netdev test-netdev ingress
@@ -200,8 +198,7 @@ netdev test-netdev ingress
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
   [ exthdr load ipv6 4b @ 44 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # frag id != 33-45
 netdev test-netdev ingress
diff --git a/tests/py/ip6/hbh.t.payload.inet b/tests/py/ip6/hbh.t.payload.inet
index 63afd832b235..10f010aa57f5 100644
--- a/tests/py/ip6/hbh.t.payload.inet
+++ b/tests/py/ip6/hbh.t.payload.inet
@@ -17,8 +17,7 @@ inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength != 33-45
 inet test-inet filter-input
@@ -86,8 +85,7 @@ inet test-inet filter-input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr != 33-45
 inet test-inet filter-input
diff --git a/tests/py/ip6/hbh.t.payload.ip6 b/tests/py/ip6/hbh.t.payload.ip6
index 913505a5b779..a6bc7ae65475 100644
--- a/tests/py/ip6/hbh.t.payload.ip6
+++ b/tests/py/ip6/hbh.t.payload.ip6
@@ -11,8 +11,7 @@ ip6 test-ip6 filter-input
 # hbh hdrlength 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # hbh hdrlength != 33-45
 ip6 test-ip6 filter-input
@@ -64,8 +63,7 @@ ip6 test-ip6 filter-input
 # hbh nexthdr 33-45
 ip6 test-ip6 filter-input
   [ exthdr load ipv6 1b @ 0 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # hbh nexthdr != 33-45
 ip6 test-ip6 filter-input
diff --git a/tests/py/ip6/icmpv6.t.payload.ip6 b/tests/py/ip6/icmpv6.t.payload.ip6
index 5b6035d10f70..8a637afae7fb 100644
--- a/tests/py/ip6/icmpv6.t.payload.ip6
+++ b/tests/py/ip6/icmpv6.t.payload.ip6
@@ -206,8 +206,7 @@ ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 1b @ transport header + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000003 ]
-  [ cmp lte reg 1 0x00000042 ]
+  [ range eq reg 1 0x00000003 0x00000042 ]
 
 # icmpv6 code {5, 6, 7} accept
 __set%d test-ip6 3
@@ -252,8 +251,7 @@ ip6 test-ip6 input
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x0000003a ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x0000de00 ]
-  [ cmp lte reg 1 0x0000e200 ]
+  [ range eq reg 1 0x0000de00 0x0000e200 ]
 
 # icmpv6 checksum != 222-226
 ip6
@@ -307,8 +305,7 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
   [ payload load 4b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x21000000 ]
-  [ cmp lte reg 1 0x2d000000 ]
+  [ range eq reg 1 0x21000000 0x2d000000 ]
 
 # icmpv6 mtu != 33-45
 ip6 test-ip6 input
@@ -362,8 +359,7 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # icmpv6 id != 33-45
 __set%d test-ip6 3
@@ -496,8 +492,7 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ payload load 2b @ transport header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00000200 ]
-  [ cmp lte reg 1 0x00000400 ]
+  [ range eq reg 1 0x00000200 0x00000400 ]
 
 # icmpv6 sequence != 2-4
 __set%d test-ip6 3
@@ -518,8 +513,7 @@ ip6 test-ip6 input
   [ payload load 1b @ transport header + 0 => reg 1 ]
   [ cmp eq reg 1 0x00000082 ]
   [ payload load 2b @ transport header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # icmpv6 max-delay != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index dbb430af7ff6..f0c1843d4b3e 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -165,8 +165,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip6 length != 33-45
 inet test-inet input
@@ -244,8 +243,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002c ]
+  [ range eq reg 1 0x00000021 0x0000002c ]
 
 # ip6 nexthdr != 33-44
 inet test-inet input
@@ -273,8 +271,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # ip6 hoplimit != 33-45
 inet test-inet input
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index b1289232f932..5118d4f22be5 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -129,8 +129,7 @@ ip6 test-ip6 input
 # ip6 length 33-45
 ip6 test-ip6 input
   [ payload load 2b @ network header + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # ip6 length != 33-45
 ip6 test-ip6 input
@@ -190,8 +189,7 @@ ip6 test-ip6 input
 # ip6 nexthdr 33-44
 ip6 test-ip6 input
   [ payload load 1b @ network header + 6 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002c ]
+  [ range eq reg 1 0x00000021 0x0000002c ]
 
 # ip6 nexthdr != 33-44
 ip6 test-ip6 input
@@ -211,8 +209,7 @@ ip6 test-ip6 input
 # ip6 hoplimit 33-45
 ip6 test-ip6 input
   [ payload load 1b @ network header + 7 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # ip6 hoplimit != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 43ae2ae48244..086a6dda8274 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -100,8 +100,7 @@ ip6 test-ip6 postrouting
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter masquerade
 ip6 test-ip6 postrouting
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
-  [ cmp lte reg 1 0x000000fe 0x00000000 0x00000000 0x00020000 ]
+  [ range eq reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 0x000000fe 0x00000000 0x00000000 0x00020000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/py/ip6/mh.t.payload.inet b/tests/py/ip6/mh.t.payload.inet
index 54eaa70ea671..7ab9b75cedec 100644
--- a/tests/py/ip6/mh.t.payload.inet
+++ b/tests/py/ip6/mh.t.payload.inet
@@ -65,8 +65,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr != 33-45
 inet test-inet input
@@ -114,8 +113,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength != 33-45
 inet test-inet input
@@ -187,8 +185,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved != 33-45
 inet test-inet input
@@ -236,8 +233,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum != 33-45
 inet test-inet input
diff --git a/tests/py/ip6/mh.t.payload.ip6 b/tests/py/ip6/mh.t.payload.ip6
index 73bd4226d745..7edde6e8a8ee 100644
--- a/tests/py/ip6/mh.t.payload.ip6
+++ b/tests/py/ip6/mh.t.payload.ip6
@@ -47,8 +47,7 @@ ip6 test-ip6 input
 # mh nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh nexthdr != 33-45
 ip6 test-ip6 input
@@ -84,8 +83,7 @@ ip6 test-ip6 input
 # mh hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh hdrlength != 33-45
 ip6 test-ip6 input
@@ -139,8 +137,7 @@ ip6 test-ip6 input
 # mh reserved 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 135 + 3 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # mh reserved != 33-45
 ip6 test-ip6 input
@@ -176,8 +173,7 @@ ip6 test-ip6 input
 # mh checksum 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 2b @ 135 + 4 => reg 1 ]
-  [ cmp gte reg 1 0x00002100 ]
-  [ cmp lte reg 1 0x00002d00 ]
+  [ range eq reg 1 0x00002100 0x00002d00 ]
 
 # mh checksum != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/redirect.t.payload.ip6 b/tests/py/ip6/redirect.t.payload.ip6
index cfc290137f92..832c51da47a4 100644
--- a/tests/py/ip6/redirect.t.payload.ip6
+++ b/tests/py/ip6/redirect.t.payload.ip6
@@ -166,8 +166,7 @@ ip6 test-ip6 output
 # ip6 daddr fe00::1-fe00::200 udp dport 53 counter redirect
 ip6 test-ip6 output
   [ payload load 16b @ network header + 24 => reg 1 ]
-  [ cmp gte reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 ]
-  [ cmp lte reg 1 0x000000fe 0x00000000 0x00000000 0x00020000 ]
+  [ range eq reg 1 0x000000fe 0x00000000 0x00000000 0x01000000 0x000000fe 0x00000000 0x00000000 0x00020000 ]
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
diff --git a/tests/py/ip6/rt.t.payload.inet b/tests/py/ip6/rt.t.payload.inet
index 864d3114b930..6549ab786a43 100644
--- a/tests/py/ip6/rt.t.payload.inet
+++ b/tests/py/ip6/rt.t.payload.inet
@@ -65,8 +65,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr != 33-45
 inet test-inet input
@@ -114,8 +113,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength != 33-45
 inet test-inet input
@@ -163,8 +161,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt type != 33-45
 inet test-inet input
@@ -212,8 +209,7 @@ inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left != 33-45
 inet test-inet input
diff --git a/tests/py/ip6/rt.t.payload.ip6 b/tests/py/ip6/rt.t.payload.ip6
index c7b52f82dc28..2b40159b749f 100644
--- a/tests/py/ip6/rt.t.payload.ip6
+++ b/tests/py/ip6/rt.t.payload.ip6
@@ -47,8 +47,7 @@ ip6 test-ip6 input
 # rt nexthdr 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 0 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt nexthdr != 33-45
 ip6 test-ip6 input
@@ -84,8 +83,7 @@ ip6 test-ip6 input
 # rt hdrlength 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 1 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt hdrlength != 33-45
 ip6 test-ip6 input
@@ -121,8 +119,7 @@ ip6 test-ip6 input
 # rt type 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt type != 33-45
 ip6 test-ip6 input
@@ -158,8 +155,7 @@ ip6 test-ip6 input
 # rt seg-left 33-45
 ip6 test-ip6 input
   [ exthdr load ipv6 1b @ 43 + 3 => reg 1 ]
-  [ cmp gte reg 1 0x00000021 ]
-  [ cmp lte reg 1 0x0000002d ]
+  [ range eq reg 1 0x00000021 0x0000002d ]
 
 # rt seg-left != 33-45
 ip6 test-ip6 input
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index 66a29672c61b..96a9ba0a3111 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -3,8 +3,7 @@ ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00005000 ]
@@ -16,8 +15,7 @@ ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp gte reg 1 0x00005000 ]
-  [ cmp lte reg 1 0x00005a00 ]
+  [ range eq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
-- 
2.30.2

