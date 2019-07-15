Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E96B3C7618F
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 17:02:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C0D2080A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 17:02:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="VoB6VW7Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730914AbfGORCQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 13:02:16 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.218]:35577 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbfGORCQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 13:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1563210134;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=rVKlGRr2cKc5jqVH0T0O/z2kvd/2FSYB+eCbbWDWA1U=;
        b=VoB6VW7YlkWoirvFeKu4gPmIMKl+v95Ud96tQfkdfdp750KO5Z5q3IxdX15jh6m1RP
        yS1CbkaPzPY2qdwRz8tA7wuRB0+CmYCuejcXVroVYC5n6rSXukF4JZn4XWYFEiuXs5gD
        QPoePXqTgHCOO1HWj8oPdKo31OSRQxoMP+izaug094p3KayUe/9s3rMOV3RGjuNhWXiU
        jnV/O+mnN5i1iQzeNbUADakQF2UJiQcPoDrGB8YJlwpy+oKLktH0pFlbLEHTiLu2N3aJ
        2CJmM5w8UctVZ20aT3xJTEH0V0zxWSHHXRRYDF73CFLgX1PcN4MBkJEOGTnW+boXcmFs
        YJoA==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4iwu00FZDcOZNHDvWoi8D0OGJ+eAjpdjmy19A=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 44.24 AUTH)
        with ESMTPSA id R034b8v6FGx833c
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <netfilter-devel@vger.kernel.org>;
        Mon, 15 Jul 2019 18:59:08 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id B8D39154045
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 18:59:07 +0200 (CEST)
Received: by dynamic.fami-braun.de (fami-braun.de, from userid 1001)
        id 68A6815822E; Mon, 15 Jul 2019 18:59:07 +0200 (CEST)
From:   michael-dev@fami-braun.de
To:     netfilter-devel@vger.kernel.org
Cc:     michael-dev@fami-braun.de
Subject: [PATCHv2] Fix dumping vlan rules
Date:   Mon, 15 Jul 2019 18:59:01 +0200
Message-Id: <20190715165901.14441-1-michael-dev@fami-braun.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: "M. Braun" <michael-dev@fami-braun.de>

Given the following bridge rules:
1. ip protocol icmp accept
2. ether type vlan vlan type ip ip protocol icmp accept

The are currently both dumped by "nft list ruleset" as
1. ip protocol icmp accept
2. ip protocol icmp accept

Though, the netlink code actually is different

bridge filter FORWARD 4
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ immediate reg 0 accept ]

bridge filter FORWARD 5 4
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ immediate reg 0 accept ]

Fix this by avoiding the removal of all vlan statements
in the given example.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 src/payload.c                         | 12 ++++++++++++
 tests/py/bridge/vlan.t                |  2 ++
 tests/py/bridge/vlan.t.payload        | 10 ++++++++++
 tests/py/bridge/vlan.t.payload.netdev | 12 ++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/src/payload.c b/src/payload.c
index 3bf1ecc..905422a 100644
--- a/src/payload.c
+++ b/src/payload.c
@@ -506,6 +506,18 @@ static bool payload_may_dependency_kill(struct payload_dep_ctx *ctx,
 		     dep->left->payload.desc == &proto_ip6) &&
 		    expr->payload.base == PROTO_BASE_TRANSPORT_HDR)
 			return false;
+		/* Do not kill
+		 *  ether type vlan and vlan type ip and ip protocol icmp
+		 * into
+		 *  ip protocol icmp
+		 * as this lacks ether type vlan.
+		 * More generally speaking, do not kill protocol type
+		 * for stacked protocols if we only have protcol type matches.
+		 */
+		if (dep->left->etype == EXPR_PAYLOAD && dep->op == OP_EQ &&
+		    expr->flags & EXPR_F_PROTOCOL &&
+		    expr->payload.base == dep->left->payload.base)
+			return false;
 		break;
 	}
 
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 526d7cc..7a52a50 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -32,6 +32,8 @@ ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53;ok;vlan id 1 ip sadd
 vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3;ok
 vlan id { 1, 2, 4, 100, 4096 };fail
 
+ether type vlan ip protocol 1 accept;ok
+
 # illegal dependencies
 ether type ip vlan id 1;fail
 ether type ip vlan id 1 ip saddr 10.0.0.1;fail
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index cb0e812..bb8925e 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -199,3 +199,13 @@ bridge test-bridge input
   [ cmp gte reg 1 0x00000020 ]
   [ cmp lte reg 1 0x00000060 ]
 
+# ether type vlan ip protocol 1 accept
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ immediate reg 0 accept ]
+
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index c57955e..0a3f90a 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -233,3 +233,15 @@ netdev test-netdev ingress
   [ cmp gte reg 1 0x00000020 ]
   [ cmp lte reg 1 0x00000060 ]
 
+# ether type vlan ip protocol 1 accept
+netdev test-netdev ingress
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ immediate reg 0 accept ]
+
-- 
2.20.1

