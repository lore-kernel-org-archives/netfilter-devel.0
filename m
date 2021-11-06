Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16FCC4167B
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B038C610E9
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:18:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbhKFQU4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234532AbhKFQUy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:20:54 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF7EC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GT2TjmJDl4TcOLZveIUYgZo/ztZZZfgY4He9strUlyQ=; b=IyWMydx20QTnlimOO+u6bZx3Mf
        nVt04Hc/2g72DBFe+TM+/+a2Y4RMO1Nh4SJ6BjnIsxNNIWPfy3ycaTwpUazod9nem4/o7OjXYAcRT
        +1ZkU3NjH/iyOEi5BYjSoncyw8TWVOqUi+rrsS6tFlKEchg50ZVJu9zMBjTsNLUi3Qag4LXX7BRcn
        i8wqw6WkgbEkgl1jSqNL0p1hRp6eX5hNkQgnHjYpFHzV0ry9986zkmGci8jWpx/WdRcpe7fJor1CG
        Zop59ZxFlUkEEO72AF1Y7KHA5OfyzUPftVpnPvuo4UQPU1WwWFO/ihzrA3lWH0yhZtMSlAwq/bLqB
        QDSJemaw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOOQ-004loO-VO
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:18:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 07/12] build: use `dist_man_MANS`
Date:   Sat,  6 Nov 2021 16:17:54 +0000
Message-Id: <20211106161759.128364-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106161759.128364-1-jeremy@azazel.net>
References: <20211106161759.128364-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 838d6ec29156..60cf8c6c595f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -2,9 +2,9 @@ ACLOCAL_AMFLAGS = -I m4
 
 SUBDIRS = include libipulog src input filter output
 
-man_MANS = ulogd.8
+dist_man_MANS = ulogd.8
 
-EXTRA_DIST = $(man_MANS) ulogd.conf.in doc
+EXTRA_DIST = ulogd.conf.in doc
 
 noinst_DATA = ulogd.conf
 
-- 
2.33.0

