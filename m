Return-Path: <SRS0=O4lm=UX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23FE4C43613
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 15:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4B520652
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Jun 2019 15:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfFXPMk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 11:12:40 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51234 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727454AbfFXPMk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 11:12:40 -0400
Received: from localhost ([::1]:36092 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hfQe6-0001zV-Pm; Mon, 24 Jun 2019 17:12:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] files: Move netdev-ingress.nft to /etc/nftables as well
Date:   Mon, 24 Jun 2019 17:12:38 +0200
Message-Id: <20190624151238.4869-1-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 13535a3b40b62 ("files: restore base table skeletons") moved
config skeletons back from examples/ to /etc/nftables/ directory, but
ignored the fact that commit 6c9230e79339c ("nftables: rearrange files
and examples") added a new file 'netdev-ingress.nft' which is referenced
from 'all-in-one.nft' as well.

Fixes: 13535a3b40b62 ("files: restore base table skeletons")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 files/nftables/Makefile.am                      | 3 ++-
 files/{examples => nftables}/netdev-ingress.nft | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)
 rename files/{examples => nftables}/netdev-ingress.nft (87%)

diff --git a/files/nftables/Makefile.am b/files/nftables/Makefile.am
index f18156d844e5c..a93b7978f62d4 100644
--- a/files/nftables/Makefile.am
+++ b/files/nftables/Makefile.am
@@ -10,7 +10,8 @@ dist_pkgsysconf_DATA =	all-in-one.nft		\
 			ipv6-filter.nft		\
 			ipv6-mangle.nft		\
 			ipv6-nat.nft		\
-			ipv6-raw.nft
+			ipv6-raw.nft		\
+			netdev-ingress.nft
 
 install-data-hook:
 	${SED} -i 's|@sbindir[@]|${sbindir}/|g' ${DESTDIR}${pkgsysconfdir}/*.nft
diff --git a/files/examples/netdev-ingress.nft b/files/nftables/netdev-ingress.nft
similarity index 87%
rename from files/examples/netdev-ingress.nft
rename to files/nftables/netdev-ingress.nft
index 2585d15493885..9e46b15a7e596 100755
--- a/files/examples/netdev-ingress.nft
+++ b/files/nftables/netdev-ingress.nft
@@ -1,4 +1,4 @@
-#!/usr/sbin/nft -f
+#!@sbindir@nft -f
 
 # mind the NIC, it must exists
 table netdev filter {
-- 
2.21.0

