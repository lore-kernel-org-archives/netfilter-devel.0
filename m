Return-Path: <SRS0=UyK1=SE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF34C4360F
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0C08E20883
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Apr 2019 13:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729309AbfDBNgw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Apr 2019 09:36:52 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42164 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbfDBNgw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Apr 2019 09:36:52 -0400
Received: from localhost ([::1]:55254 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hBJat-0004EN-H8; Tue, 02 Apr 2019 15:36:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] man: nft.8: Add minimal description of (v)map statements
Date:   Tue,  2 Apr 2019 15:36:42 +0200
Message-Id: <20190402133642.6422-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Although quite useful, these were missing in man page. Content loosely
based on wiki documentation.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/statements.txt | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/doc/statements.txt b/doc/statements.txt
index 0687f53f83076..754040bca20d7 100644
--- a/doc/statements.txt
+++ b/doc/statements.txt
@@ -564,3 +564,37 @@ nft list set ip filter blackhole
 # manually add two addresses to the set:
 nft add element filter blackhole { 10.2.3.4, 10.23.1.42 }
 -----------------------------------------------
+
+MAP STATEMENT
+~~~~~~~~~~~~~
+The map statement is used to lookup data based on some specific input key.
+
+[verse]
+'expression' *map* *{* 'key' *:* 'value' [*,* 'key' *:* 'value' ...] *}*
+
+.Using the map statement
+------------------------
+# select DNAT target based on TCP dport:
+# connections to port 80 are redirected to 192.168.1.100,
+# connections to port 8888 are redirected to 192.168.1.101
+nft add rule ip nat prerouting dnat tcp dport map { 80 : 192.168.1.100, 8888 : 192.168.1.101 }
+
+# source address based SNAT:
+# packets from net 192.168.1.0/24 will appear as originating from 10.0.0.1,
+# packets from net 192.168.2.0/24 will appear as originating from 10.0.0.2
+nft add rule ip nat postrouting snat to ip saddr map { 192.168.1.0/24 : 10.0.0.1, 192.168.2.0/24 : 10.0.0.2 }
+------------------------
+
+VMAP STATEMENT
+~~~~~~~~~~~~~~
+The verdict map (vmap) statement works analogous to the map statement, but
+contains verdicts as values.
+
+[verse]
+'expression' *vmap* *{* 'key' *:* 'verdict' [*,* 'key' *:* 'verdict' ...] *}*
+
+.Using the vmap statement
+-------------------------
+# jump to different chains depending on layer 4 protocol type:
+nft add rule ip filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain , icmp : jump icmp-chain }
+------------------------
-- 
2.21.0

