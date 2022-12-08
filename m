Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4136C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiLHAMx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLHAMw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:12:52 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C6C43859
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=00eoPsIx5Z9mO2WrrVytoRPL9KPJVm5b6TmOxHRwRDw=; b=ci1SOHxIlAnJpKGW0wjDpbZCdM
        spBVyCDkfw9KjrhaUAzE0kaa6Rhu8Z9BYh2rRIotkOVQlh01aFjRINXbhxE925w19Bpq3ViDZeJUy
        T4qszmqM0OhFtsZtgc/eopXPlAi64u3gx0VMSroAdXsy0IhX0ybkTlOiGO4c+cudDtPEX0sDEgGRU
        eYWPpGiOnpS6zFyo7hGnGqSX1OJANVBgKToVkxo4wEGKSNrp6IxjaihZH4vajEjtJEjlXMconsiTL
        5+yvV6nLIO4odgF3jULCpbgPcJam93pVxdylHIqz/mi5Xu4BFtC7WZbmkOWpZenbLnZLmj7XDuHqG
        jPyWtaSg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34Wv-0005TF-4y; Thu, 08 Dec 2022 01:12:49 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [conntrack-tools PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:12:40 +0100
Message-Id: <20221208001240.20745-1-phil@nwl.cc>
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
index f26189ae4b1b9..01e6027c4622c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@ AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
-	tar-pax no-dist-gzip dist-bzip2 1.6])
+	tar-pax no-dist-gzip dist-xz 1.6])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-- 
2.38.0

