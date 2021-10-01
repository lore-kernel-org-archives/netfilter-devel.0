Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92619C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78D79619F8
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Oct 2021 17:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbhJARrY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhJARrX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 13:47:23 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD15C061775
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Oct 2021 10:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+xxHYrElmh87SRZkPTXXk1VW0QMjjj+6mCW9qHprG5E=; b=NqQ77BpVaqhure5983r/Mx/uJx
        h9qDCn7Hu0dMwXBYZV8fjVUrPQYfBAQmfWEJX6Mt+p1do8HAZAebUSLARwq4FqzLFbW1JQ4lEuQtt
        BuxwU+d9HE/HoYWy4NnBwNAO8x4gwnQZvxx9AbTwnGlkAMCh939pyz0H61NAxoTYuWOApeoMlgzv3
        uMw04JfHdze9dVemywrJfTMokQtYWLJlATIsAsU+4vHvHPCE4kySaaCPwnZ6Y3KO6ZbobWXJXuQ9G
        B9+K6P8NvCeSgrL9UU05HHbnn0hO4eESht2ZwqTLZtdchRf0e58Ee8Fz9OOne7mA8TghJwEoUL4uj
        LNddPfMA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mWMbH-002RLP-Gd; Fri, 01 Oct 2021 18:45:35 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kyle Bowman <kbowman@cloudflare.com>,
        Alex Forster <aforster@cloudflare.com>,
        Cloudflare Kernel Team <kernel-team@cloudflare.com>
Subject: [PATCH iptables v2 7/8] build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`
Date:   Fri,  1 Oct 2021 18:41:41 +0100
Message-Id: <20211001174142.1267726-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211001174142.1267726-1-jeremy@azazel.net>
References: <20211001174142.1267726-1-jeremy@azazel.net>
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
index 00ae60c5cfa1..86c67194825f 100644
--- a/configure.ac
+++ b/configure.ac
@@ -12,9 +12,8 @@ AC_PROG_INSTALL
 AM_INIT_AUTOMAKE([-Wall])
 AC_PROG_CC
 AM_PROG_CC_C_O
-AC_DISABLE_STATIC
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
-AM_PROG_LIBTOOL
+LT_INIT([disable-static])
 
 AC_ARG_WITH([kernel],
 	AS_HELP_STRING([--with-kernel=PATH],
-- 
2.33.0

