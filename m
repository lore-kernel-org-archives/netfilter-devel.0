Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1101C4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31A960F55
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbhJILo1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EB12C061764
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PNKEP2UYH6n+LeJji5kBWr1UlH/eNmzrxz+kXRO2tYA=; b=dZVLUkMiSXRkUdb5KWx1OoMo4+
        m01buNwqvUuBiImOVZASIPJuWyBC0J2NJ0LKgwstbgIa2GJzfJqs3NUJwFXrEzTRdEJgrlg5NWNaF
        tRuATp93KJWGqSKrXUvfzqaxrltDATExwWzvWSA1G9so4K8FOasW1PIJ6MfXJ5BVu63IDBwCCRxfK
        Ts+BTMfCtVJ2k2++ixX+UirHjkDac5uEF+2/zDHVjWUsW94AfjY19dAfQWhqcdsdAQGYpFkfUCKKd
        ia09iPQOH2VKTqxyvq74waIqGcsh5JmDjaxhJAd8y5j158ws6cPpIt8vWtxLktvMXKT4W1gUk268b
        8is4/Wjw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-EL
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 3/9] build: fix linker flags for nf-log
Date:   Sat,  9 Oct 2021 12:38:33 +0100
Message-Id: <20211009113839.2765382-4-jeremy@azazel.net>
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

Use pkg-config LIBS variable for libmnl, instead of literal `-lmnl`.
Append `$(LIBNETFILTER_CONNTRACK_LIBS)` to nf_log_LDADD.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 utils/Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/utils/Makefile.am b/utils/Makefile.am
index 4afd91b0756d..39abb3e00af9 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -7,10 +7,10 @@ nfulnl_test_LDADD = ../src/libnetfilter_log.la
 nfulnl_test_LDFLAGS = -dynamic
 
 nf_log_SOURCES = nf-log.c
-nf_log_LDADD = ../src/libnetfilter_log.la -lmnl
+nf_log_LDADD   = ../src/libnetfilter_log.la $(LIBMNL_LIBS)
 nf_log_LDFLAGS = -dynamic
 if BUILD_NFCT
-nf_log_LDFLAGS += $(LIBNETFILTER_CONNTRACK_LIBS)
+nf_log_LDADD += $(LIBNETFILTER_CONNTRACK_LIBS)
 nf_log_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS} -DBUILD_NFCT
 endif
 
-- 
2.33.0

