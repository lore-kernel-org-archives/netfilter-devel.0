Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C39C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC7E60F4B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbhJ3QM6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhJ3QM5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:12:57 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049B2C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=on9Mz1qBLf0tJIxHN7ckh4NNpOa1xC195pPpb+Uk/0c=; b=iBCA7vvRO7qubdt/BYLVMs4OFo
        ioaf/SXIWgxe3K+8C0nuQ1yzB/+ohRs6yl2TP+bkGET+RaqG5DKNFaJQPy3+ss7XnlpjK1YW0ufti
        yKQUSBRs9mZe2Ir0GTqzYGpl6GBQlIRc1Zr8lDUXAz6LqObhqFWxw70qAcssXe4Sx1TspiW6uI5G9
        1nTG9dsQAmDVxo72Ux6Duk8bSkIdkFz8fZjsmXk80FVs9NgPMfrQjrzf23wxQyiUJukydupHD2xTa
        1jefFW9OvFYDa5NPPXABUbEA6qOsZNzbkZL39Kl2WG3hwUzfvT1BLLW7iINsOCtRmTkxPb1S2Cwt5
        kC58pdXg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqng-00AFQk-9e
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 10/13] build: update obsolete autoconf macros
Date:   Sat, 30 Oct 2021 17:01:38 +0100
Message-Id: <20211030160141.1132819-11-jeremy@azazel.net>
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

`AC_CONFIG_HEADER` has been superseded by `+AC_CONFIG_HEADERS`.

`AC_PROG_LIBTOOL` has been superseded by `LT_INIT`.

`AC_DISABLE_STATIC` can be replaced by an argument to `LT_INIT`.

`AC_HEADER_STDC` is obsolete.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index f7d6b50c47f5..2dfeee6aa4cb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ AC_INIT([ulogd], [2.0.7])
 AC_PREREQ([2.50])
 AC_CONFIG_AUX_DIR([build-aux])
 AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b subdir-objects])
-AC_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
@@ -14,8 +14,7 @@ dnl Checks for programs.
 AC_PROG_MAKE_SET
 AC_PROG_CC
 AC_PROG_INSTALL
-AC_DISABLE_STATIC
-AC_PROG_LIBTOOL
+LT_INIT([disable_static])
 
 dnl Checks for libraries.
 AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
@@ -23,7 +22,6 @@ AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_HEADER_STDC
 AC_CHECK_HEADERS(fcntl.h unistd.h)
 
 dnl Checks for typedefs, structures, and compiler characteristics.
-- 
2.33.0

