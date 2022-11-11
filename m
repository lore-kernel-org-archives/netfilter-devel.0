Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC60C433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 17:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiKKRcp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 12:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiKKRcn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 12:32:43 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072AC5CD09
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 09:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rxffTHT5NX9TchA9RUKC43tTPcbNjDunTWNjQ01kuaE=; b=JWTFh1tFo/IByU3rqojGIriVZr
        RZwoJVjOZsmUcOa0NIdtQUfEODs1wABsVNDrxfqKB86ZL0GbE1U8op5TspeARbdo/P7TZ97Q95Ys1
        nH4z/a9A3/3Hd9sG4/ax/rxJ3F57JpVS8v0uKB4k6IEgjgHb/TMGz0BSZCNTagodXQBxQEccdqQKc
        SmP7ah5OovkPlZiFuD889iPvivkp2uRpGeKPlDQ2rBs7QUuxXufLAR4LE8Lex/N0qZj3tR9fOaa5P
        nPhwsJ8GcyoUe/4PayRusfU0sgPwrwh+CPSvHwK+Z0DziQrdHdT3LMfXWJgqLwuO++VrTaiTo2Px0
        jHbu5tXA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1otXtR-0006FW-DL; Fri, 11 Nov 2022 18:32:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 0/3] xt: Implement dump and restore support
Date:   Fri, 11 Nov 2022 18:32:18 +0100
Message-Id: <20221111173221.23631-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If nft can't translate a compat expression, dump it in a format that can
be restored later without losing data, thereby keeping the ruleset
intact.

Patch 1 is preparation (more or less), patch 2 has the gory details and
patch 3 is a minor code refactoring that's almost unrelated.

Phil Sutter (3):
  xt: Delay libxtables access until translation
  xt: Implement dump and restore support
  xt: Put match/target translation into own functions

 configure.ac              |  12 +-
 doc/libnftables-json.adoc |  15 +-
 doc/statements.txt        |  17 +++
 include/base64.h          |  17 +++
 include/json.h            |   2 +
 include/parser.h          |   1 +
 include/statement.h       |   9 +-
 include/xt.h              |   4 +
 src/Makefile.am           |   3 +-
 src/base64.c              | 170 +++++++++++++++++++++
 src/evaluate.c            |   1 +
 src/json.c                |  25 ++-
 src/netlink_linearize.c   |  32 ++++
 src/parser_bison.y        |  28 ++++
 src/parser_json.c         |  36 +++++
 src/scanner.l             |  14 ++
 src/statement.c           |   1 +
 src/xt.c                  | 313 ++++++++++++++++++++++----------------
 18 files changed, 554 insertions(+), 146 deletions(-)
 create mode 100644 include/base64.h
 create mode 100644 src/base64.c

-- 
2.38.0

