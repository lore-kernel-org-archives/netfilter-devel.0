Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C660AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiAIL6j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiAIL6i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C289C06173F
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dKhmKjvt0qewk5qLnzhQy4Rj9cYcw8dPPqjlD0GbI1Y=; b=BuQepL5qrpNMkmyuVfLc69wENZ
        YlxgrRFLB2jPsoYqb5MlL8z4XGpMobSc55o/KyNTk5vKIop5BZjdF1kRh0hs081Rga5dT1Ep/uOd1
        AW48Tk7aMFhwR498b2dpcdOQdtXP5q4EwaTqxWPuasJLeXcqlkfiRoiKDwdbZjjsPYLNxkyU0Vn3I
        vt2zzwAV4P1tFmwuBBEUDsBiedzptVTtftIshe8gw8q7FUQtDzYRnZdHEzkzbeVOn+l3LpeCbN+KZ
        a41qPD+G6wsjwK0XgaDoyWiRWkkf9RW9EQpA6AxCYFhKf4A/wIJAuxvglQXAtCv7C0h7cR3RBD3sU
        nEvdWyAA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqK-002BZm-2Q
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 00/10] Add pkg-config support
Date:   Sun,  9 Jan 2022 11:57:43 +0000
Message-Id: <20220109115753.1787915-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A number of third-party libraries have added pkg-config support over the
years.  This patch-set updates configure to make use of it where it is
available.  It also fixes some conflicting option definitions and adds
checks that cause configure to fail if a plugin has been explicitly
requested, but the related third-party library is not available.

Patch 1:      switch from `--with-XXX` to `--enable-XXX` for output
              plugins.
Patches 2-5:  use pkg-config for libdbi, libmysqlclient, libpcap and
              libpq if available.
Patches 6-10: abort configure when an output plugin has been explicitly
              enabled, but the related library is not available.

Changes since v1

  * Better commit messages.
  * Simpler mysql patch: remove the upstream m4 macro calls, and look
    for `mysql_config` the same way we do `pg_config` and `pcap-config`.
  * `AM_CPPFLAGS` fixes for mysql, pcap, and postgresql.
  * `LIBADD` fix for mysql.

Jeremy Sowden (10):
  build: use `--enable-XXX` options for output plugins
  build: use pkg-config for libdbi
  build: use pkg-config or mysql_config for libmysqlclient
  build: use pkg-config or pcap-config for libpcap
  build: use pkg-config or pg_config for libpq
  build: if `--enable-dbi` is `yes`, abort if libdbi is not found
  build: if `--enable-mysql` is `yes`, abort if libmysqlclient is not
    found
  build: if `--enable-pcap` is `yes`, abort if libpcap is not found
  build: if `--enable-pgsql` is `yes`, abort if libpq is not found
  build: if `--enable-sqlite3` is `yes`, abort if libsqlite3 is not
    found

 acinclude.m4             | 351 ---------------------------------------
 configure.ac             | 192 +++++++++++++++++----
 output/dbi/Makefile.am   |   4 +-
 output/mysql/Makefile.am |   4 +-
 output/pcap/Makefile.am  |   2 +
 output/pgsql/Makefile.am |   4 +-
 6 files changed, 165 insertions(+), 392 deletions(-)
 delete mode 100644 acinclude.m4

-- 
2.34.1

