Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3DC9C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EB8160F4B
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhJILoZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:25 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4AAC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5CriOq0J6xj420fUVCtJusmJWAyD2rYdd14eZRkMCQw=; b=ry6Fm2a5sCK8uiv++jf3HuqqsO
        H4/tJJbn2CkbVLsgNmt/kFhW/KlH7ozZIFaEbPfOPJIi7l18UrakXs89tugzE4njEt52PUgOIC9KD
        8p8JibH2RPjHXyjVxnLYSX8ZElVClJALHHtcSeiESGen9HYixEVPaSOscdejDIsg/2M65Ywh1qB0p
        Gx6XkWzIobZfsfjgu9vOfWwa01GYoBhB60awqdI+6arfpvaQSbrq5v3NROeF/L07uV1o3OA69RMZM
        uRFxmDAfQSHGgZaOIl7FEqqRiZwSmJeJxGW5EJlRiMoxKzcMKcPFsCWBTQhk9k8hrkEpho77sw2UH
        SZi9UwWA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-2g
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 0/8] Build fixes
Date:   Sat,  9 Oct 2021 12:38:30 +0100
Message-Id: <20211009113839.2765382-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

An assortment of autotools and pkg-config updates.

Jeremy Sowden (9):
  build: correct pkg-config dependency configuration
  build: add pkg-config configuration for libipulog
  build: fix linker flags for nf-log
  build: move dependency CFLAGS variables out of `AM_CPPFLAGS`
  build: remove superfluous .la when linking ulog_test
  build: remove `-dynamic` when linking check progs
  build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with
    `LT_INIT`
  build: replace `AC_HELP_STRING` with `AS_HELP_STRING`
  Add Emacs artefacts to .gitignore

 .gitignore                       |  3 +++
 Make_global.am                   |  2 +-
 Makefile.am                      |  2 +-
 configure.ac                     | 23 +++++++++++++++--------
 libnetfilter_log.pc.in           |  6 +++---
 libnetfilter_log_libipulog.pc.in | 16 ++++++++++++++++
 src/Makefile.am                  | 18 ++++++++++--------
 utils/Makefile.am                | 14 ++++++--------
 8 files changed, 55 insertions(+), 29 deletions(-)
 create mode 100644 libnetfilter_log_libipulog.pc.in

-- 
2.33.0

