Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9A9C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 505BD6124B
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 15:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343799AbhIYPQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 25 Sep 2021 11:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343903AbhIYPQK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 25 Sep 2021 11:16:10 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97297C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Sep 2021 08:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QLtvRx1E3s+RgVMpjiJQFCM49IkDnZLROy2RpVUYwTo=; b=cfeFpLHiu0ysqVbzH1CIk4MxWK
        wAO1VoqNhUZmia5o8kN5n6IavV5mJSQn8LbjQZZXfBIE5fudpZ9Yx1tz+66ftFpwfzry5qt73umxZ
        2Udr1yUGRLjLDLHbxrTrPn8pShwcMVQ9SsrnJ66AOh9QKz90cU3kRsRo3ao1LSMbYAv24ilObExHJ
        GiAu3/DZoK1gpwwvyCXPouj157knHdQ9Wz4sTPge0K0yXa4d2EhAejmv/fyi6Wcu5020AhvCSGEah
        l/holxWvtfRkPmqmQ9WYC8w+6s7Wtq83dR2Sr9jKCKrUub3jMS1A929yN+sjDN4o8Gjyr01Pjw3Up
        HQqHazZQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mU9Nk-00Cses-1d; Sat, 25 Sep 2021 16:14:28 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [conntrack-tools 0/6] Build fixes
Date:   Sat, 25 Sep 2021 16:10:29 +0100
Message-Id: <20210925151035.850310-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The first three patches contain changes suggested by autoupdate.  Four
and five bring the handling of the yacc- and lex-generated sources more
in line with the automake doc's.  The last one fixes a race in parallel
builds.

Jeremy Sowden (6):
  build: remove commented-out macros from configure.ac
  build: quote AC_INIT arguments
  build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with
    `LT_INIT`
  build: remove yacc-generated header from EXTRA_DIST
  build: clean yacc- and lex-generated files with maintainer-clean
  build: fix dependency-tracking of yacc-generated header

 configure.ac    | 30 ++----------------------------
 src/Makefile.am |  5 ++---
 2 files changed, 4 insertions(+), 31 deletions(-)

-- 
2.33.0

