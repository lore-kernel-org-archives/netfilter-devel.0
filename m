Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD79C4320A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA2061165
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhHVQjA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:39:00 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033F4C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 09:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G61pZmWvkV7PSJQk3C4UqwjkyHNyHqlCY5MoHKL5MC8=; b=g4UVRL99bS1r9KP1iuXV0i46T6
        gSZZTesOoKxlPPH18ovHhlnbbmhCwuBTKhrDEaGxBKNIY2sSWP8SieHhzb2HIBADYHPKPlwONEaBO
        cZGnewjoV/Kvx6h6EipAMQ9nJ1+1E1ZIGpfsZMmpRdOZ4BEMUXHQLXcZSc2mkSQ8e3Q1IM7yx0Nj0
        VbfeJbuvoKwSS6rXK2NBXU0gnkak/6nHTe/VDcoorRqfuupz+QAhnVhliE77TLC6g7lifaj25O2tK
        N+zF+9fkbSd7xW+0PE6S54LrV1il7e+jIt1ftibMoAPf1yJtAYoObg7XofhIiINdVvsAmW4v/Qq7S
        eZcNn2Xw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHqUC-008Q2I-3M; Sun, 22 Aug 2021 17:38:16 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     =?UTF-8?q?Grzegorz=20Kuczy=C5=84ski?= 
        <grzegorz.kuczynski@interia.eu>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/8] build: bump minimum supported kernel version from 4.15 to 4.16.
Date:   Sun, 22 Aug 2021 17:35:49 +0100
Message-Id: <20210822163556.693925-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210822163556.693925-1-jeremy@azazel.net>
References: <20210822163556.693925-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The next two commits make use of a function and macro that were
introduced in 4.16.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 76129245f5c1..9705d750750e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,7 +61,7 @@ if test -n "$kbuilddir"; then
 			echo "WARNING: That kernel version is not officially supported yet. Continue at own luck.";
 		elif test "$kmajor" -eq 5 -a "$kminor" -ge 0; then
 			:
-		elif test "$kmajor" -eq 4 -a "$kminor" -ge 15; then
+		elif test "$kmajor" -eq 4 -a "$kminor" -ge 16; then
 			:
 		else
 			echo "WARNING: That kernel version is not officially supported.";
-- 
2.32.0

