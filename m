Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B77DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD5C60F8F
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhJILoa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85250C061755
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=INtzN/vPTA96YTVU6E+it+cAKkILVF+OdqW0LSGaygg=; b=TicB3Qijl25ygazt5E7VsQ57Xr
        ab5G3g0qVDbkuzBBHWPkm6e2GwOuw4aOmo6/2gI8g7F7tOzY3nuA0wLbthBXB4Ri2TiyJrxEsGvU2
        GstcLtOMuBfbhEAXbB3pjUqalONBzc6lq5asbviWwSvJ57VvdSNJjsSUaco/0MJ+lSBSBkrn42EEr
        jqa84X7VJYNKnrb+YiNgpqcZSj9svVnzv5BeNJjhHWCmwSlakFTo4EdAQ3U3X856MxWFWeFeT73MR
        L8piiSXJ5Bi/OEgGBgstvM1S7MKKFoPuryTngM/G5QcSucwLj6kspe224MeFmlP9kGzqgVXxBue/I
        PN2rLg3w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-SS
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 8/9] build: replace `AC_HELP_STRING` with `AS_HELP_STRING`
Date:   Sat,  9 Oct 2021 12:38:38 +0100
Message-Id: <20211009113839.2765382-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009113839.2765382-1-jeremy@azazel.net>
References: <20211009113839.2765382-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AC_HELP_STRING` is obsolete and has been superseded by
`AS_HELP_STRING`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 1dc9bc7847fa..85e49ede6f2d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,7 +24,7 @@ case "$host" in
 esac
 
 AC_ARG_WITH([ipulog],
-  AC_HELP_STRING([--without-ipulog], [don't build libipulog compat library]))
+  AS_HELP_STRING([--without-ipulog], [don't build libipulog compat library]))
 AM_CONDITIONAL([BUILD_IPULOG], [test "x$with_ipulog" != xno])
 
 dnl Dependencies
-- 
2.33.0

