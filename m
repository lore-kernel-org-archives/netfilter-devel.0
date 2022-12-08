Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52649C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLHAOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:14:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiLHAOc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:14:32 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4295E8BD2B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=C9pvu99JLA9hcix+X6FOUmrocqXB+LEvSoSDYoQDSwA=; b=h5gVNtBLAyEJMkSW3jUc8zO40r
        ZjyHQvkFx2et2a7xqOlu8dBI0K/QrWTLIRY4OwgcMjgtI249wgaV/u57luodq8e+xtSmXyZVgNf3S
        C6sRiOC0DLAeUPf36b9YGV4rlCT1n81zkttpZs0EE5/poYkWd+Ln2JjpZ7sgyVGM2aHtcsjmMss+a
        Fv9xnnI37Sx3pEhuHfTm0UFBaEd9QdLAVq62XInBFrFl/xUzCArMSaDBGpLwJQleQcd7rx/HzISDC
        W8GHw8CVTBIZaWOb/p+w3toJHpYX8AJGRlK5n0BaVnPmrk+ZpWi8ygczhHy6dWHdHTlMAAShyvJ+4
        Sq29LyQw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34YW-0005Up-MS; Thu, 08 Dec 2022 01:14:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [nfacct PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:14:19 +0100
Message-Id: <20221208001419.22374-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use a more modern alternative to bzip2.

Suggested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 08c11757c339c..ead69c7501f4d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT(nfacct, 1.0.2, pablo@netfilter.org)
 AC_CANONICAL_HOST
 
 AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects no-dist-gzip dist-xz 1.6])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
2.38.0

