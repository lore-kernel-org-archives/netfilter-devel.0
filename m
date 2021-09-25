Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB0F8C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B638610F7
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343905AbhIYPQN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343907AbhIYPQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:10 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28F2C061740
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7d+dVLHru3bYtBwY2VQhGaZGSLuFH8qfG73VheZtpqQ=; b=YFMIi/WGci6/ckTjeqm30UGVdv
        kesif9VozR01i3V4Zt8JA0xph7TACTFtuGApZa9ER6SBP8vfexg5Z8H5yvxqbli3cTAu54zEcaxfK
        2cKFKELDqthVyjojldClzflzTPLDxqZY8xoa8tlKlN+rRWA51RuU7fRHFB4QOfUOkYR2JKPqLkXtf
        MeRksPdW2WflULW+TY9NbD06YFHGJsY9FuFWAADOyTJpUGtnD9DfxzuDAA6br5ocgFbrao8Y/rmYV
        rZpF/+YAHL/4QyqSmbtd7nB3EXC7If3xg+pIIQvsgIFikH32hPctxksJuTiiT4lL6yvH0NUnTb7L0
        UHdVIgBw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nm-00Cses-Ka; Sat, 25 Sep 2021 16:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 4/6] build: remove yacc-generated header from EXTRA_DIST
Date:   Sat, 25 Sep 2021 16:10:33 +0100
Message-Id: <20210925151035.850310-5-jeremy@azazel.net>
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

Automake generates yacc and lex output files and includes them in
distributions as a matter of course.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/Makefile.am | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 2e66ee96b709..75b16a7b6f35 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -77,5 +77,3 @@ conntrackd_LDADD += ${LIBSYSTEMD_LIBS}
 endif
 
 conntrackd_LDFLAGS = -export-dynamic
-
-EXTRA_DIST = read_config_yy.h
-- 
2.33.0

