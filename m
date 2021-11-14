Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7B3C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB8C603E5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235918AbhKNORw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbhKNORw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:17:52 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1849C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pfwn6kKS4nRhw5/CI/7ddcIrwcQMX0JLwFGSwKsq4zs=; b=AENC7GvChFSIzhWEnXWsitImtc
        VB8jMEoyCWJzT8rwdVibJGzpOCTrdSfMXkWNkAbAxvuVccln0d2RVWyvFxixM/9JUDMv/0dP1acLE
        kGO1r6RNCOKqpPELiwpi4GAnEgiFKyTq2qLWAyM0cIqJjVNskw7i576Fgo6cv0YDYRiTRuYqdJDXO
        ZF6d3UEiLul/eRfCtGIJ6eg3wW7XILt3VMnrtxGIF7n77LiOEtBq+he9j/y9muBGD3atOghl/ECMy
        Ue6W2YVT4EaQ5MdVnGJLWZVaJSH7VOfd2FcHd+QnUTMKzBhX5czq+1BIaIOLQEH7N6yD9rO99VNJ4
        zdhYpjyA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4G-00Cdsh-Gi
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 11/16] build: use correct automake variable for library dependencies
Date:   Sun, 14 Nov 2021 14:00:53 +0000
Message-Id: <20211114140058.752394-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A couple of library dependencies are specified in `_LDFLAGS` variables.
They are supposed to be specified in `_LIBADD` variables.  Move them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 input/flow/Makefile.am   | 3 ++-
 input/packet/Makefile.am | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/input/flow/Makefile.am b/input/flow/Makefile.am
index fc95bdb85af8..a556b4e4cb90 100644
--- a/input/flow/Makefile.am
+++ b/input/flow/Makefile.am
@@ -5,4 +5,5 @@ AM_CPPFLAGS += ${LIBNETFILTER_CONNTRACK_CFLAGS}
 pkglib_LTLIBRARIES = ulogd_inpflow_NFCT.la
 
 ulogd_inpflow_NFCT_la_SOURCES = ulogd_inpflow_NFCT.c
-ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
+ulogd_inpflow_NFCT_la_LDFLAGS = -avoid-version -module
+ulogd_inpflow_NFCT_la_LIBADD  = $(LIBNETFILTER_CONNTRACK_LIBS)
diff --git a/input/packet/Makefile.am b/input/packet/Makefile.am
index 5c95e0576e00..3aa01112084e 100644
--- a/input/packet/Makefile.am
+++ b/input/packet/Makefile.am
@@ -19,5 +19,6 @@ if BUILD_NFLOG
 pkglib_LTLIBRARIES += ulogd_inppkt_NFLOG.la
 
 ulogd_inppkt_NFLOG_la_SOURCES = ulogd_inppkt_NFLOG.c
-ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_LOG_LIBS)
+ulogd_inppkt_NFLOG_la_LDFLAGS = -avoid-version -module
+ulogd_inppkt_NFLOG_la_LIBADD  = $(LIBNETFILTER_LOG_LIBS)
 endif
-- 
2.33.0

