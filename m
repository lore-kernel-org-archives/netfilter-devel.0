Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9970BC432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 17:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EDDC206E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 17:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfK0RbD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 12:31:03 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39176 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0RbC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 12:31:02 -0500
Received: from localhost ([::1]:52266 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1ia19Z-0003zo-8z; Wed, 27 Nov 2019 18:31:01 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] nft.8: Describe numgen expression
Date:   Wed, 27 Nov 2019 18:30:53 +0100
Message-Id: <20191127173053.23546-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/primary-expression.txt | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 0316a7e1ab8ec..5473d59801f3f 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -397,3 +397,29 @@ ipv4_addr/ipv6_addr
 Destination address of the tunnel|
 ipv4_addr/ipv6_addr
 |=================================
+
+NUMGEN EXPRESSION
+~~~~~~~~~~~~~~~~~
+
+[verse]
+*numgen* {*inc* | *random*} *mod* 'NUM' [ *offset* 'NUM' ]
+
+Create a number generator. The *inc* or *random* keywords control its
+operation mode: In *inc* mode, the last returned value is simply incremented.
+In *random* mode, a new random number is returned. The value after *mod*
+keyword specifies an upper boundary (read: modulus) which is not reached by
+returned numbers. The optional *offset* allows to increment the returned value
+by a fixed offset.
+
+A typical use-case for *numgen* is load-balancing:
+
+.Using numgen expression
+------------------------
+# round-robin between 192.168.10.100 and 192.168.20.200:
+add rule nat prerouting dnat to numgen inc mod 2 map \
+	{ 0 : 192.168.10.100, 1 : 192.168.20.200 }
+
+# probability-based with odd bias using intervals:
+add rule nat prerouting dnat to numgen random mod 10 map \
+        { 0-2 : 192.168.10.100, 3-9 : 192.168.20.200 }
+------------------------
-- 
2.24.0

