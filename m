Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE66C63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:10:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLHAK6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLHAKx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:10:53 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238A68BD2B
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:10:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pYEecpsegv2gxCZQmYhKnZ+HH87CTKh1HKUiy3SxUn4=; b=Qkp125l47I2tJcyM8tIYaBYepT
        gLoXnVuzGeCB9+TtuTSkhpAhBvw9JSK54WIjN0FQ/FdTnIrDqfu4vX/Lk5YeQq1ksppL9TzDZUZlf
        t/9WGPclfCmwPkzn/3GeMXxq74TmJ7eVCmFCPJqQBX5dZ/SeU8LqT94lpOZGsD78LFFGcfqclxYIv
        gEOOA6NjRm5aJnE8MXa8UhqEnZ5zsezgToYZmN0N+OYeZwXV5yXt3RZWmpoKPlNBlKTDuEhpY9LAN
        qXOWu75G9YT8bfNZXD5KNXs7SI9yHFPgesOBuYSlpk/3JssMeYzwiThW+sGX0b/8b8ZF8juwKMBIB
        dgyCMlwA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34V0-0005SS-He; Thu, 08 Dec 2022 01:10:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [libnetfilter_conntrack PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:10:41 +0100
Message-Id: <20221208001041.18594-1-phil@nwl.cc>
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
index 9ae6cc6c742d1..5cc06996ca4b5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,7 +7,7 @@ AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
-	tar-pax no-dist-gzip dist-bzip2 1.6])
+	tar-pax no-dist-gzip dist-xz 1.6])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 dnl kernel style compile messages
-- 
2.38.0

