Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEC08C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 12:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4AB61073
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 12:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhKLM6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 07:58:11 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57888 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234899AbhKLM6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 07:58:10 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BCBEE605C6
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 13:53:16 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: remove netdev coverage in ip/ip_tcp.t
Date:   Fri, 12 Nov 2021 13:55:13 +0100
Message-Id: <20211112125513.577663-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The following tests shows a warning in the netdev family:

ip/ip_tcp.t: WARNING: line 9: 'add rule netdev test-netdev ingress ip protocol tcp tcp dport 22': 'tcp dport 22' mismatches 'ip protocol 6 tcp dport 22'

'ip protocol tcp' can be removed in the ip family, but not in netdev.

This test is specific of the ip family, remove the netdev lines.

Fixes: 510c4fad7e78 ("src: Support netdev egress hook")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ip_tcp.t                |  3 -
 tests/py/ip/ip_tcp.t.payload.netdev | 93 -----------------------------
 2 files changed, 96 deletions(-)
 delete mode 100644 tests/py/ip/ip_tcp.t.payload.netdev

diff --git a/tests/py/ip/ip_tcp.t b/tests/py/ip/ip_tcp.t
index 646b0ca50207..ff398aa6c4c3 100644
--- a/tests/py/ip/ip_tcp.t
+++ b/tests/py/ip/ip_tcp.t
@@ -1,9 +1,6 @@
 :input;type filter hook input priority 0
-:ingress;type filter hook ingress device lo priority 0
-:egress;type filter hook egress device lo priority 0
 
 *ip;test-ip;input
-*netdev;test-netdev;ingress,egress
 
 # can remove ip dependency -- its redundant in ip family
 ip protocol tcp tcp dport 22;ok;tcp dport 22
diff --git a/tests/py/ip/ip_tcp.t.payload.netdev b/tests/py/ip/ip_tcp.t.payload.netdev
deleted file mode 100644
index 74dc1195aeb0..000000000000
--- a/tests/py/ip/ip_tcp.t.payload.netdev
+++ /dev/null
@@ -1,93 +0,0 @@
-# ip protocol tcp tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev egress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev egress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev ingress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-# ip protocol tcp meta mark set 1 tcp dport 22
-netdev test-netdev egress 
-  [ meta load protocol => reg 1 ]
-  [ cmp eq reg 1 0x00000008 ]
-  [ payload load 1b @ network header + 9 => reg 1 ]
-  [ cmp eq reg 1 0x00000006 ]
-  [ immediate reg 1 0x00000001 ]
-  [ meta set mark with reg 1 ]
-  [ payload load 2b @ transport header + 2 => reg 1 ]
-  [ cmp eq reg 1 0x00001600 ]
-
-- 
2.30.2

