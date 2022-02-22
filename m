Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3A4C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 00:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiBVABU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 19:01:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232434AbiBVABU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 19:01:20 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9CC4A24584
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 16:00:54 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CC2A064370
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Feb 2022 00:59:54 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] examples: compile with `make check' and add AM_CPPFLAGS
Date:   Tue, 22 Feb 2022 01:00:49 +0100
Message-Id: <20220222000049.303303-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Compile examples via `make check' like libnftnl does. Use AM_CPPFLAGS to
specify local headers via -I.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 examples/Makefile.am | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/examples/Makefile.am b/examples/Makefile.am
index c972170d3fdc..3b8b0b6708dc 100644
--- a/examples/Makefile.am
+++ b/examples/Makefile.am
@@ -1,4 +1,6 @@
-noinst_PROGRAMS	= nft-buffer		\
+check_PROGRAMS	= nft-buffer		\
 		  nft-json-file
 
+AM_CPPFLAGS = -I$(top_srcdir)/include
+
 LDADD = $(top_builddir)/src/libnftables.la
-- 
2.30.2

