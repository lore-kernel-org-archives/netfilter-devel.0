Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA44EC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FE660EE9
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343903AbhIYPQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343905AbhIYPQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:10 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBF3C061714
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bjsN0IQTv9YzquYz3+4paTJbcuA6Xj2w94gqgVMkP1Q=; b=s7bD8U7QF/0+52mYky0X7adHDd
        lgnAo+e35LZv/cUhVxqKMcFD+r9ryn4n9L35i9vX/D9zeecbZHHNCvYbT9bSUIkt1C1kPrpaVRDvu
        mO772Do2hx+vSZcsgM1Aw5PCLIXXt0TdSZ5Lc+HxnijwaSrNlUeAQSBM6i8Eh9veM5YU6Zl/zr6ew
        JXaSlJZNGB7k9W5lMHU+7e2NGuqW3WrSwvIFHer2r+PUnBcPhBw5vgDcyFo44RdrrWz6aaxSV1TJg
        AKv0QpLbJGBCN+ZTuT3eiwL6aiTNp98Dw1OGsVnHhozxFqau+POJJX5jx1BuP+nsvp/ClSSw6XgI4
        zKVYWjVA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nm-00Cses-1D; Sat, 25 Sep 2021 16:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 3/6] build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`
Date:   Sat, 25 Sep 2021 16:10:32 +0100
Message-Id: <20210925151035.850310-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210925151035.850310-1-jeremy@azazel.net>
References: <20210925151035.850310-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AM_PROG_LIBTOOL` is superseded by `LT_INIT`, which also accepts options
to control the defaults for creating shared or static libraries.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index c690a92be5fd..3a3af4549162 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,9 +13,8 @@ AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libdl_LIBS])
 
 AC_PROG_CC
-AC_DISABLE_STATIC
 AM_PROG_AR
-AM_PROG_LIBTOOL
+LT_INIT([disable-static])
 AC_PROG_INSTALL
 AC_PROG_LN_S
 AM_PROG_LEX
-- 
2.33.0

