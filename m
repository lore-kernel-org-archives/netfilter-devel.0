Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECBDC433FE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7860611EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 16:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbhKFQw4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbhKFQws (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 12:52:48 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D343C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 09:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=znaYHs9POnhH62pjmd1lxm1JG4FPo6rxacBlSi9ssZg=; b=KlZ4sP3ZrbmGYp+fQuXseLF5kS
        CsgBoXbaZrHqpx71gOrlSnyAD4N5KI8bYDXFpamCj2e2WQS+kjgZdkeTe6wzK72KtxgwD7oMsGtpO
        Bg6K9MvRMXoS8a8QpeM+DcRopbqYY9uGRS6a63RtezvOXtuQjVkuA8bgSCi8Vz6B/cl1r8CO7KJOe
        lNXukUb8Gju7QBE89LsU6DCY1AeEL2B3pMARDCZlQvliT9iBVpgXUvekMO+WWsDCx0Y8WuqD8lO2o
        Aw65yCWWnBlujvXNEytXg8ononZPFTu6mysg02lVImCgmkgbGWyAOTnk/awfL1LhFEjEMRz6V/dkg
        32GafUIA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtI-004m1E-SP
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 00/27] Compiler Warning Fixes
Date:   Sat,  6 Nov 2021 16:49:26 +0000
Message-Id: <20211106164953.130024-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch-set fixes all the warnings reported by gcc 11.

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
Patches 27 removes some superfluous preprocessor macros.

Changes since v1:

  * patch 13: stat of socket removed;
  * patch 15: `struct iphdr` pointer removed;
  * patch 27 is new.

Jeremy Sowden (27):
  include: add format attribute to __ulogd_log declaration
  ulog: remove empty log-line
  ulog: fix order of log arguments
  ulog: correct log specifiers
  output: IPFIX: correct format-specifiers
  jhash: add "fall through" comments to switch cases
  db: add missing `break` to switch-case
  filter: HWHDR: replace `switch` with `if`
  filter: HWHDR: re-order KEY_RAW_MAC checks
  filter: HWHDR: remove zero-initialization of MAC type
  Replace malloc+memset with calloc
  filter: PWSNIFF: replace malloc+strncpy with strndup
  input: UNIXSOCK: remove stat of socket-path
  input: UNIXSOCK: fix possible truncation of socket path
  input: UNIXSOCK: prevent unaligned pointer access
  output: DBI: fix deprecation warnings
  output: DBI: fix string truncation warnings
  output: MYSQL: Fix string truncation warning
  output: PGSQL: Fix string truncation warning
  output: SQLITE3: Fix string truncation warnings and possible buffer
    overruns
  output: SQLITE3: catch errors creating SQL statement
  util: db: fix possible string truncation
  output: JSON: fix output of GMT offset
  output: JSON: fix printf truncation warnings
  output: JSON: optimize appending of newline to output
  output: JSON: fix possible truncation of socket path
  output: IPFIX: remove attribute macros

 filter/ulogd_filter_HWHDR.c           | 54 ++++++++++++-------------
 filter/ulogd_filter_PWSNIFF.c         | 18 ++++-----
 include/ulogd/jhash.h                 | 24 +++++------
 include/ulogd/ulogd.h                 |  8 +---
 input/packet/ulogd_inppkt_UNIXSOCK.c  | 51 +++++++++++------------
 output/dbi/ulogd_output_DBI.c         | 58 ++++++++++++---------------
 output/ipfix/ipfix.c                  |  6 +--
 output/ipfix/ipfix.h                  |  8 ++--
 output/ipfix/ulogd_output_IPFIX.c     |  7 ++--
 output/mysql/ulogd_output_MYSQL.c     | 19 ++++-----
 output/pgsql/ulogd_output_PGSQL.c     | 19 ++++-----
 output/sqlite3/ulogd_output_SQLITE3.c | 58 +++++++++++++--------------
 output/ulogd_output_JSON.c            | 42 ++++++++++---------
 src/ulogd.c                           |  6 +--
 util/db.c                             | 24 +++++------
 15 files changed, 185 insertions(+), 217 deletions(-)

-- 
2.33.0

