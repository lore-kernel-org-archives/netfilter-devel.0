Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7E42AE66
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 20:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741637532; cv=none; b=pX5S6t+ZvoSoMC7A2bUv1RPAI5lLhIRcdQEupYl8vhj4ut1cdQYBZgQZ8xDCeqI9rUhxoYEH8XymB7nN/J+G48fm1cTkqXJ2Xcd24Sp6JLUYyPfDpWH3HRpX3rypLLZun60IpKpn/1WnI6RjN9OxtGUB3rI+KGZYaKyU8m7y2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741637532; c=relaxed/simple;
	bh=m1sv5CpYdWHqDHCJ0/BvWk2NX20N/IhBwY74TuBQr2k=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=VbTBnAzHJvQxWlIdKpFr9up84o97FCYX+h0OwQWxrKew3ISln0pYUtvW5hDl65lxoCbvmP402Fd8QTr6Lb059HBNEgZxlKoG6QO+y7lUMmsallX39tbqqNF9XSrE8npEgPh/nNuJs7l6z4f7CK7VxhmRcFCL4uCsozNOtbaCTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a5KSGTWK; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a5KSGTWK; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a5KSGTWK";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a5KSGTWK"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B9B4560277; Mon, 10 Mar 2025 21:11:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741637519;
	bh=p5Kjsfx3dkoQUe2cOLkW0wMZCQJwWgYKcM9K+v1NRUk=;
	h=From:To:Subject:Date:From;
	b=a5KSGTWKEGrL/QOEku12Jmadlgr7pHcyVPFzxOWCq/dA5LwtYPfgEO0gef77r8NUC
	 Kl9EQ2KGYk0nuZWGHV8Ukm8BNXUdOxM7GYQpvsn45D6domgLLr6SrfpMDKiFX5QWw4
	 ov0R8rLXbsLMFrIVVNe0OzLOePYAG9XMMy6+vgRR0JZAGaTMsmy0jRMUUugKPRtavs
	 9n+zRREZfyOOUurh5KDeEZ0lafoHbnrVtxN2QPNIwmLzd54K8MV3Ux+yacbfQGUhZZ
	 xMQDFXAIPs++CFYH16CO1MsffwTEaX3XqlgmrVYO4n9NfzMwoUy3cvFNlgXgHxCGcf
	 I1CY4iLlXsTcg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3514460272
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 21:11:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741637519;
	bh=p5Kjsfx3dkoQUe2cOLkW0wMZCQJwWgYKcM9K+v1NRUk=;
	h=From:To:Subject:Date:From;
	b=a5KSGTWKEGrL/QOEku12Jmadlgr7pHcyVPFzxOWCq/dA5LwtYPfgEO0gef77r8NUC
	 Kl9EQ2KGYk0nuZWGHV8Ukm8BNXUdOxM7GYQpvsn45D6domgLLr6SrfpMDKiFX5QWw4
	 ov0R8rLXbsLMFrIVVNe0OzLOePYAG9XMMy6+vgRR0JZAGaTMsmy0jRMUUugKPRtavs
	 9n+zRREZfyOOUurh5KDeEZ0lafoHbnrVtxN2QPNIwmLzd54K8MV3Ux+yacbfQGUhZZ
	 xMQDFXAIPs++CFYH16CO1MsffwTEaX3XqlgmrVYO4n9NfzMwoUy3cvFNlgXgHxCGcf
	 I1CY4iLlXsTcg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] netlink_linearize: reduce register waste with non-constant binop expressions
Date: Mon, 10 Mar 2025 21:11:55 +0100
Message-Id: <20250310201155.4151-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Register use is not good with bitwise operations that involve three or
more selectors, eg.

 mark set ip dscp and 0x3 or ct mark or meta mark
  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
  [ ct load mark => reg 2 ]
  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
  [ meta load mark => reg 3 ]		  <--- this could use register 2 instead!
  [ bitwise reg 1 = ( reg 1 | reg 3 ) ]
  [ meta set mark with reg 1 ]

register 3 is use to store meta mark, however, register 2 can be already
use since register 1 already stores the partial result of the bitwise
operation for this expression.

After this fix:

  [ payload load 1b @ network header + 1 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x00000003 ) ^ 0x00000000 ]
  [ ct load mark => reg 2 ]
  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
  [ meta load mark => reg 2 ]            <--- recycle register 2
  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
  [ meta set mark with reg 1 ]

Release source register in bitwise operation given destination register
already stores the partial result of the expression.

Extend tests/py to cover this.

Fixes: 54bfc38c522b ("src: allow binop expressions with variable right-hand operands")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c     |  1 +
 tests/py/any/meta.t         |  2 ++
 tests/py/any/meta.t.json    | 32 ++++++++++++++++++++++++++++++++
 tests/py/any/meta.t.payload |  9 +++++++++
 4 files changed, 44 insertions(+)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index e69d323cdeaf..598ddfab5827 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -778,6 +778,7 @@ static void netlink_gen_bitwise_bool(struct netlink_linearize_ctx *ctx,
 	sreg2 = get_register(ctx, expr->right);
 	netlink_gen_expr(ctx, expr->right, sreg2);
 	netlink_put_register(nle, NFTNL_EXPR_BITWISE_SREG2, sreg2);
+	release_register(ctx, expr->right);
 
 	len = div_round_up(expr->len, BITS_PER_BYTE);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index bd10c56dfe5f..3f0ef121a8c0 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -228,3 +228,5 @@ meta day 7 drop;fail
 meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 };ok
 !map1 typeof vlan id : meta mark;ok
 meta mark set vlan id map @map1;ok
+
+meta mark set meta mark | iif | meta cpu;ok
diff --git a/tests/py/any/meta.t.json b/tests/py/any/meta.t.json
index 676affea4dc6..65590388bb80 100644
--- a/tests/py/any/meta.t.json
+++ b/tests/py/any/meta.t.json
@@ -2818,3 +2818,35 @@
     }
 ]
 
+# meta mark set meta mark | iif | meta cpu
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "meta": {
+                            "key": "mark"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "iif"
+                        }
+                    },
+                    {
+                        "meta": {
+                            "key": "cpu"
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index a037e0673fec..52c3efa84eb5 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -1090,3 +1090,12 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set map1 dreg 1 ]
   [ meta set mark with reg 1 ]
+
+# meta mark set meta mark | iif | meta cpu
+ip test-ip4 input
+  [ meta load mark => reg 1 ]
+  [ meta load iif => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta load cpu => reg 2 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
-- 
2.30.2

