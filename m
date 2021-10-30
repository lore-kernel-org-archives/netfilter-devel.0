Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED595C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B7B60F93
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhJ3QrH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhJ3QrG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:47:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E17C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:44:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=noLnrR5kaSdgDAlN01Ak+XD5otRtlVus/1xolOhhrbw=; b=d8RUVCWlE1vGT3zrgwZXcvBFFK
        YVxj/WP3kPqdgNi6CTyHidXu1u7grWwKGepLwwz7+rOePYFbRgSJANSbfUk70sqpxdyi0BJam+Mq7
        tBvuIiBstJ8aRcs5trTpD/PTR68WRulrmUAMe339cl2DaoJBL0tXZo/hr0abZnSWD1d5M/04t5GAk
        +olzlNz1owTAIh0XQPDcyS1AkMTntuckYXw3EnlyNwllHqUy0u1Froy2+7CW7hXxZfAipcDqfpxbT
        EUB/k4HncV9l93BJMKabBFjagfgiOa9Uk4BcemIh7zvhGnnpjrCTpazAF30eK9jGs5P1oklqZtARS
        nTArPf8A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrT7-00AFgT-Uw
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:33 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 00/26] Compiler Warning Fixes
Date:   Sat, 30 Oct 2021 17:44:06 +0100
Message-Id: <20211030164432.1140896-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Patch 1 adds the `format` GCC attribute to ulogd_log.
Patches 2-5 fix the format errors revealed by the patch 1.
Patches 6-8 fix fall-through warnings.
Patches 9-10 are flow-control improvements related to patch 8.
Patch 11 replaces malloc+memset with calloc.
Patches 12-14 fix string-truncation warnings.
Patch 15 fixes a possible unaligned pointer access.
Patch 16 fixes DBI deprecation warnings.
Patches 17-20 fix more truncation warnings.
Patch 21 adds error-checking to sqlite SQL preparation.
Patches 22-26 fix more truncation and format warnings.

Jeremy Sowden (26):
  include: add format attribute to __ulogd_log declaration
  ulog: remove empty log-line
  ulog: fix order of log arguments
  ulog: correct log specifiers
  output: IPFIX: correct format-specifiers.
  jhash: add "fall through" comments to switch cases.
  db: add missing `break` to switch-case.
  filter: HWHDR: replace `switch` with `if`.
  filter: HWHDR: re-order KEY_RAW_MAC checks.
  filter: HWHDR: remove zero-initialization of MAC type.
  Replace malloc+memset with calloc
  filter: PWSNIFF: replace malloc+strncpy with strndup.
  input: UNIXSOCK: stat socket-path first before creating the socket.
  input: UNIXSOCK: fix possible truncation of socket path
  input: UNIXSOCK: prevent unaligned pointer access.
  output: DBI: fix deprecation warnings.
  output: DBI: fix string truncation warnings
  output: MYSQL: Fix string truncation warning
  output: PGSQL: Fix string truncation warning
  output: SQLITE3: Fix string truncation warnings and possible buffer
    overruns.
  output: SQLITE3: catch errors creating SQL statement
  util: db: fix possible string truncation.
  output: JSON: fix output of GMT offset.
  output: JSON: fix printf truncation warnings.
  output: JSON: optimize appending of newline to output.
  output: JSON: fix possible truncation of socket path

 filter/ulogd_filter_HWHDR.c           | 54 +++++++++++-------------
 filter/ulogd_filter_PWSNIFF.c         | 26 ++++++------
 include/ulogd/jhash.h                 | 24 +++++------
 include/ulogd/ulogd.h                 |  3 +-
 input/packet/ulogd_inppkt_UNIXSOCK.c  | 55 +++++++++++++-----------
 output/dbi/ulogd_output_DBI.c         | 60 ++++++++++++---------------
 output/ipfix/ipfix.c                  |  4 +-
 output/ipfix/ulogd_output_IPFIX.c     |  7 ++--
 output/mysql/ulogd_output_MYSQL.c     | 19 ++++-----
 output/pgsql/ulogd_output_PGSQL.c     | 19 ++++-----
 output/sqlite3/ulogd_output_SQLITE3.c | 58 +++++++++++++-------------
 output/ulogd_output_JSON.c            | 42 ++++++++++---------
 src/ulogd.c                           |  6 +--
 util/db.c                             | 24 +++++------
 14 files changed, 192 insertions(+), 209 deletions(-)

-- 
2.33.0

