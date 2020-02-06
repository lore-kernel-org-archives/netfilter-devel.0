Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15170C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 11:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E67C5214AF
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 11:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBFLib (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:38:31 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48846 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbgBFLib (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 06:38:31 -0500
Received: from localhost ([::1]:33704 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1izfUL-00067Y-8y; Thu, 06 Feb 2020 12:38:29 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 1/2] doc: nft.8: Mention wildcard interface matching
Date:   Thu,  6 Feb 2020 12:38:27 +0100
Message-Id: <20200206113828.7306-1-phil@nwl.cc>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Special meaning of asterisk in interface names wasn't described
anywhere.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 doc/primary-expression.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index 94eccc20241a2..b15df015e5484 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -36,6 +36,13 @@ add such a rule, it will stop matching if the interface gets renamed and it
 will match again in case interface gets deleted and later a new interface
 with the same name is created.
 
+Like with iptables, wildcard matching on interface name prefixes is available for
+*iifname* and *oifname* matches by appending an asterisk (*) character. Note
+however that unlike iptables, nftables does not accept interface names
+consisting of the wildcard character only - users are supposed to just skip
+those always matching expressions. In order to match on literal asterisk
+character at end of interface name, one may escape it using backslash (\).
+
 .Meta expression types
 [options="header"]
 |==================
-- 
2.24.1

