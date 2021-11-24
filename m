Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469F9C4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhKXW2D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:28:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343906AbhKXW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:28:00 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AAAFC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/MHHq8yiPUfhaeKMX1x6b1vr81sJAV3m57juT964SYg=; b=gOXgzf24VwUrZdg6sYibEKQ8KD
        v3eBMzQbxwyUIYiCKMVdIa0r44086ACbgqsnjkb5oxx2oN1Q4QONCNBre7pEwAnJ7IyDTXhHsT3L5
        DK/pkl4QAAt4wgvzetDWQ9uiJWd6wroO5sEa8wq5SkrTenjajWRnkzhexcRyUZAvk5eIEXs1/dLdq
        Kzg7yceDGKccu7UL4dAIFtHbsM3wAOWoIPcQLWewcgKXRdPLqaQIf6fG8gYxkXtLjcDivyr3ooeG8
        XsMQXRG8R8JHuz5qDS11WonsHjmLkDbkTqDYDVzMSLgxlGwuGQiLRMgbIsRQhO0XSn5UvpndoHrjJ
        SWH/Z4ZQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h6-00563U-6A
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:48 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 00/32] Fixes for compiler warnings
Date:   Wed, 24 Nov 2021 22:23:55 +0000
Message-Id: <20211124222444.2597311-1-jeremy@azazel.net>
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

Most of the warnings concern fall-throughs in switches, possibly
problematic uses of functions like `strncpy` and `strncat` and possible
truncation of output by `sprintf` and its siblings.

Some of the patches fix bugs revealed by warnings, some tweak code to
avoid warnings, others fix or improve things I noticed while looking at
the warnings.

Changes since v2:

  * the first four patches of v2 have been merged;
  * some of the v2 patches have been broken up into more, smaller parts;
  * more detailed commit messages;
  * patches 14 and 17 are new.

Changes since v1:

  * patch 13: stat of socket removed;
  * patch 15: `struct iphdr` pointer removed;
  * patch 27 is new.

Jeremy Sowden (32):
  jhash: add "fall through" comments to switch cases
  db: add missing `break` to switch case
  filter: HWHDR: simplify flow-control
  filter: HWHDR: re-order KEY_RAW_MAC checks
  filter: HWHDR: remove zero-initialization of MAC type
  Replace malloc+memset with calloc
  filter: PWSNIFF: replace malloc+strncpy with strndup
  input: UNIXSOCK: remove stat of socket-path
  input: UNIXSOCK: fix possible truncation of socket path
  input: UNIXSOCK: prevent unaligned pointer access
  output: DBI: fix deprecation warnings
  output: DBI: improve mapping of DB columns to input-keys
  output: DBI: fix NUL-termination of escaped SQL string
  output: DBI: fix configuration of DB connection
  output: MYSQL: improve mapping of DB columns to input-keys
  output: PGSQL: improve mapping of DB columns to input-keys
  output: PGSQL: fix non-`connstring` configuration of DB connection
  output: SQLITE3: fix possible buffer overruns
  output: SQLITE3: fix memory-leak in error-handling
  output: SQLITE3: improve formatting of insert statement
  output: SQLITE3: improve mapping of DB columns to fields
  output: SQLITE3: improve mapping of fields to DB columns
  output: SQLITE3: catch errors creating SQL statement
  db: improve formatting of insert statement
  db: improve mapping of input-keys to DB columns
  db: simplify initialization of ring-buffer
  output: JSON: fix output of GMT offset
  output: JSON: increase time-stamp buffer size
  output: JSON: fix possible leak in error-handling.
  output: JSON: optimize appending of newline to output
  output: JSON: fix possible truncation of socket path
  output: IPFIX: remove compiler attribute macros

 filter/ulogd_filter_HWHDR.c           | 54 ++++++++---------
 filter/ulogd_filter_PWSNIFF.c         | 18 +++---
 include/ulogd/jhash.h                 | 24 ++++----
 include/ulogd/ulogd.h                 |  5 --
 input/packet/ulogd_inppkt_UNIXSOCK.c  | 46 +++++++--------
 output/dbi/ulogd_output_DBI.c         | 84 +++++++++++++--------------
 output/ipfix/ipfix.c                  |  6 +-
 output/ipfix/ipfix.h                  |  8 +--
 output/mysql/ulogd_output_MYSQL.c     | 20 +++----
 output/pgsql/ulogd_output_PGSQL.c     | 64 ++++++++------------
 output/sqlite3/ulogd_output_SQLITE3.c | 71 +++++++++++-----------
 output/ulogd_output_JSON.c            | 45 +++++++-------
 src/ulogd.c                           |  3 +-
 util/db.c                             | 36 ++++++------
 14 files changed, 223 insertions(+), 261 deletions(-)

-- 
2.33.0

