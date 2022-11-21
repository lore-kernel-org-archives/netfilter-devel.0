Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B22EC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 22:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiKUW1q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 17:27:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231747AbiKUW1l (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 17:27:41 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C27EDFDB
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 14:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e/q79Yah04wOaP247MrddlCmFY2Dwp3p+Izri27SvTI=; b=K5kbO2+4otUr0R0TlK3E12n/sK
        mo3MQjLfEoYztTnkQ6sMFBBVfx3q6qhFZ5GXFQ9p1Y/GB2yTbCnWQaCbqb3QSAkmBeVkT3TlcAMWm
        175CS2pLk0aisimoM66CH1GGjNOAb7VTxjoG12ZpkxCgEcjWeBQRUd6zyq9NBaKrPxEbyNwN5FScx
        MozahC785Og9KHthASArKoqVwqa+rLSkrSkwMNwQk+ltNBcpHkqyJXfNZNWlgd5VSV2KS2E4fM62K
        nWDNQ+YeKgBWmjKqAXqriyAvbuRi1nduRKQBNe1cS6sZwPooTxSec9vUH62KM6Ke5yjJznHyWiame
        j/7FuWMQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oxFGB-005LgP-Qb
        for netfilter-devel@vger.kernel.org; Mon, 21 Nov 2022 22:27:27 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 00/34] Refactor of the DB output plug-ins
Date:   Mon, 21 Nov 2022 22:25:37 +0000
Message-Id: <20221121222611.3914559-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In his feedback to my last series of clean-up patches at the beginning
of the year, Pablo suggested consolidating some parallel implementations
of the same functionality in the SQL output plug-ins.  I already had
some patches in the works aimed at tidying up the DB API.  This
patch-set is the result.  In addition to the suggested de-duping and
other tidy-ups, I have added prep & exec support in order to convert the
sqlite3 plug-in to the DB API, and updated the MySQL and PostgreSQL 
plug-ins to use it as well (DBI doesn't do prep & exec).

This patch-set is structured as follows.

  * Patches 1-4 are bug-fixes.
  * Patches 5-13 are miscellaneous tidying.
  * Patch 14 does the consolidation Pablo suggested.
  * Patches 15-26 refactor and clean up the common DB API.
  * Patches 27-28 add prep & exec support to the common DB API.
  * Patch 29 converts the MySQL plug-in to use prep & exec.
  * Patch 30-33 tidy up and convert the PostgreSQL plug-in to use prep &
    exec.
  * Patch 34 converts the SQLite plug-in to use the common DB API.

Jeremy Sowden (34):
  ulogd: fix parse-error check
  filter: fix buffer overruns in filter plug-ins
  output: JSON: remove incorrect config value check
  db: fix back-log capacity checks
  build: add checks to configure.ac
  src: remove some trailing white space
  src: remove zero-valued config-key fields
  src: parenthesize config-entry macro arguments
  src: define constructors and destructors consistently
  src: remove `TIME_ERR` macro
  src: remove superfluous casts
  conffile: replace malloc+strcpy with strdup
  output: remove zero-initialized `struct ulogd_plugin` members
  output: de-duplicate allocation of input keys
  db: reorganize source
  db: use consistent integer return values to indicate errors
  db: change return type of two functions to `void`
  db: open-code `_loop_reconnect_db`
  db: improve calculation of sql statement length
  db: refactor configuration
  db: refactor ring-buffer initialization
  db: refactor ring-buffer
  db: refactor backlog
  db: use `struct db_stmt` objects more widely
  db: synchronize access to ring-buffer
  db: avoid cancelling ring-buffer thread
  db, IP2BIN: defer formatting of raw strings
  db: add prep & exec support
  output: mysql: add prep & exec support
  output: pgsql: remove a couple of struct members
  output: pgsql: remove variable-length arrays
  output: pgsql: tidy up `open_db_pgsql` and fix memory leak
  output: pgsql: add prep & exec support
  output: sqlite3: reimplement using the common DB API

 cftest/cftest.c                           |    2 +-
 configure.ac                              |   47 +-
 filter/raw2packet/ulogd_raw2packet_BASE.c |    4 +-
 filter/ulogd_filter_HWHDR.c               |    8 +-
 filter/ulogd_filter_IFINDEX.c             |    4 +-
 filter/ulogd_filter_IP2BIN.c              |   73 +-
 filter/ulogd_filter_IP2HBIN.c             |    4 +-
 filter/ulogd_filter_IP2STR.c              |   10 +-
 filter/ulogd_filter_MARK.c                |    7 +-
 filter/ulogd_filter_PRINTFLOW.c           |    4 +-
 filter/ulogd_filter_PRINTPKT.c            |    4 +-
 filter/ulogd_filter_PWSNIFF.c             |    2 +-
 include/ulogd/db.h                        |  121 +-
 input/flow/ulogd_inpflow_NFCT.c           |   37 +-
 input/packet/ulogd_inppkt_NFLOG.c         |   47 +-
 input/packet/ulogd_inppkt_ULOG.c          |   55 +-
 input/packet/ulogd_inppkt_UNIXSOCK.c      |    5 -
 input/sum/ulogd_inpflow_NFACCT.c          |   15 +-
 libipulog/libipulog.c                     |    2 +-
 libipulog/ulog_test.c                     |    2 +-
 output/dbi/ulogd_output_DBI.c             |  132 +--
 output/ipfix/ulogd_output_IPFIX.c         |   38 +-
 output/mysql/ulogd_output_MYSQL.c         |  257 +++--
 output/pcap/ulogd_output_PCAP.c           |   30 +-
 output/pgsql/ulogd_output_PGSQL.c         |  416 ++++---
 output/sqlite3/ulogd_output_SQLITE3.c     |  480 +++-----
 output/ulogd_output_GPRINT.c              |    7 +-
 output/ulogd_output_GRAPHITE.c            |    9 +-
 output/ulogd_output_JSON.c                |   29 +-
 output/ulogd_output_LOGEMU.c              |    2 -
 output/ulogd_output_NACCT.c               |    5 +-
 output/ulogd_output_OPRINT.c              |    5 +-
 output/ulogd_output_SYSLOG.c              |   16 +-
 output/ulogd_output_XML.c                 |    5 -
 src/conffile.c                            |    4 +-
 src/hash.c                                |    4 +-
 src/ulogd.c                               |   80 +-
 util/db.c                                 | 1244 ++++++++++++++-------
 38 files changed, 1829 insertions(+), 1387 deletions(-)

-- 
2.35.1

