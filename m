Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0ACC63703
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 00:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLHAIX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 19:08:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiLHAIW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 19:08:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0D1A832
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 16:08:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=S/fNVkQiOTilWvTQxw+LbID/49j+fvxWa7ofLg4OnoQ=; b=d336W/YKNkD5r0pV+5VYWJj7Nw
        3BOacvDK89F6dnQkgLTUvMH6X2svagXJSWM1ryQZ8Pxcda1+IQXVkcbn2yopQiGt/hCDrp9EPCb7L
        xldnA9zf/nbflfCeX27mRnhAhH8uwhRLp3jYTbXoljoU24MNTrb49wNU8qiKvA3n6l9/hadcUyV2M
        TQR5I8+SqNRzjpexxLXQTvebA764H5/UCUKHJUaONm7KvFXnez2OLXr+gpVqevQi/99mEKyplBlma
        Hv7l8GmzWcGksLCsLQEUGj6xiTD6r9qCz2oiMWkkh2Qu3ShgiaSbaLyaFCnaUsygq8BCqEivBXcjV
        4lPeZs1g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p34SZ-0005Pq-FV; Thu, 08 Dec 2022 01:08:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: [libnetfilter_acct PATCH] Makefile: Create LZMA-compressed dist-files
Date:   Thu,  8 Dec 2022 01:08:10 +0100
Message-Id: <20221208000810.15885-1-phil@nwl.cc>
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
index 8f0ee7f72c47b..1d58cde811917 100644
--- a/configure.ac
+++ b/configure.ac
@@ -6,7 +6,7 @@ AC_CANONICAL_HOST
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADERS([config.h])
 
-AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
+AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-xz
 	1.6 subdir-objects])
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
-- 
2.38.0

