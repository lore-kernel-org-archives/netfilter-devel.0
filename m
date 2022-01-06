Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B5CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244111AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiAFVKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58044C061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xAu7d1n3LKSiNY3vr109qPjKOXx/J47EJuVux5d+owY=; b=on3HSvAkKYAgni9n+08fEcZkWB
        vhM1JP7Lu9Xmi0D1SHN1ywghev2jCQR4tcQ5+0qk59Y3jFINz4m6JI/LDJpPYz94uSTQtrPCixdG3
        IGzPf9blSKw00PndwaezYkcqyznOjRd/+l8u9CzfWVOBViEoh6lnXEQgTi53Wg5p0IhlOmBTa02QC
        1Uu2m0oPXV9vUFarrO0a6bWfN5BVsNAS2r2egX+94Rv9PuY3DMVDIAHgnhGhbilzNxMUcrzIHJfp8
        uaVVK0ljFiVkrd3bMEC9nWZBFttjp3hIMs++bWmtq1x6an8BeNEIp36nfbtQcOFIlpDa+ILiJJzYU
        FAke8HSw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1N-00H0N6-Nq
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 00/10] Add pkg-config support
Date:   Thu,  6 Jan 2022 21:09:27 +0000
Message-Id: <20220106210937.1676554-1-jeremy@azazel.net>
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
years.  This patch-set updates configure to make use it where it is
available.  It also fixes some conflicting option definitions and adds
patches that causes configure to fail if a plugin has been explicitly
requested but the related third-party library is not available.

Patch 1:      switch from `--with-blah` to `--enable-blah` for output
              plugins.
Patches 2-5:  use pkg-config for libdbi, mysql, libpcap and libpq if
              available.
Patches 6-10: abort configure when an output plugin has been explicitly
              enabled, but the related library is not available.

Jeremy Sowden (10):
  build: use `--enable-blah` flags for output plugins
  build: use pkg-config for libdbi
  build: use pkg-config or upstream M4 for mysql
  build: use pkg-config or pcap-config for libpcap
  build: use pkg-config for libpq if available
  build: if `--enable-dbi` is `yes` abort if DBI is not found
  build: if `--enable-mysql` is `yes` abort if MySQL is not found
  build: if `--enable-pcap` is `yes` abort if libpcap is not found
  build: if `--enable-pgsql` is `yes` abort if libpq is not found
  build: if `--enable-sqlite3` is `yes` abort if libsqlite3 is not found

 acinclude.m4             | 351 ---------------------------------------
 configure.ac             | 192 +++++++++++++++++----
 output/dbi/Makefile.am   |   4 +-
 output/pgsql/Makefile.am |   4 +-
 4 files changed, 161 insertions(+), 390 deletions(-)
 delete mode 100644 acinclude.m4

-- 
2.34.1

