Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E632C433E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848DE206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgGKKSx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgGKKSx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:18:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7202C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:18:52 -0700 (PDT)
Received: from localhost ([::1]:59418 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCao-0007Dh-LW; Sat, 11 Jul 2020 12:18:51 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 07/18] nft: Reorder enum nft_table_type
Date:   Sat, 11 Jul 2020 12:18:20 +0200
Message-Id: <20200711101831.29506-8-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This list of table types is used internally only, the actual values
don't matter that much. Reorder them to match the order in which
iptables-legacy-save prints them (if present). As a consequence, entries
in builtin_table array 'xtables_ipv4' are correctly sorted as well.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/iptables/nft.h b/iptables/nft.h
index fd390e7f90765..247255ac9e3c5 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -8,10 +8,10 @@
 #include <libiptc/linux_list.h>
 
 enum nft_table_type {
-	NFT_TABLE_FILTER	= 0,
-	NFT_TABLE_MANGLE,
-	NFT_TABLE_RAW,
+	NFT_TABLE_MANGLE	= 0,
 	NFT_TABLE_SECURITY,
+	NFT_TABLE_RAW,
+	NFT_TABLE_FILTER,
 	NFT_TABLE_NAT,
 };
 #define NFT_TABLE_MAX	(NFT_TABLE_NAT + 1)
-- 
2.27.0

