Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B7F5C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4330060EB2
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhJ3QES (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhJ3QER (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:04:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE9CC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GT2TjmJDl4TcOLZveIUYgZo/ztZZZfgY4He9strUlyQ=; b=JQowQvB5322dVb/8M0dZVqtjH7
        5FRh51QncAXXPd+F+4xyATSO1fmxyejueXdspS106krP1aUOrOxLSMHCadh27h2VD1H1v6j/5CpaG
        Bc90Of8YRNWseK7duL64InGAQErob1Xt/TMkebNBDeNFYSS9o+8Dquvd7Hy3yW5f/5d4pJHhJuw4O
        PzEqdh6Cei0Hcmd1r55FWXt33WGtV+m8O5xXrmJZLsdFfSDN75P5a/rRxjaMX2CQtKGKvhjBBtlFM
        sp3BhABV+v5mkA6IA8FXDSeO1Pi7LGWSNZZjinaHs6UgZ06fzQaUMQ8V2qiTmHLXfdgL7OPscmkdu
        QX4l07Zg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqng-00AFQk-0W
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 07/13] build: use `dist_man_MANS`
Date:   Sat, 30 Oct 2021 17:01:35 +0100
Message-Id: <20211030160141.1132819-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030160141.1132819-1-jeremy@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
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

