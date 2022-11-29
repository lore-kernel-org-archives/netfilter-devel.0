Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A1F1C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Nov 2022 21:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbiK2VsD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Nov 2022 16:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237027AbiK2VsC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2022 16:48:02 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9AA63CD6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2022 13:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CzOe79PpCXy+p3jLfMiODo1XRr/UsoNFba+YBtrkiQ8=; b=I3//5+8P0/u8YVlWC3RPYdao6Y
        8U9LShyaeUgD0/wTpPbdRYq8KfGXDEzzO/Cr6OP1Jmf6tZfj2SjcG7rj+ZBYgQ56TAnIdBIncvL5p
        pIbo6miO004kyIAZ0ndh5SvsZGBe07wQw0p80Kf2NX+bzpWe66aLaxe2s7MJ+aJeqlNyYtmv8glCl
        CSxgX4Hf8ufzHRUeg6GF00RNABi2tzvsVaaf93A+GfMUVrtHqbAR/+C1a9mn/ctisOMcg8x4p45mq
        r9fT2glCNqF047DniLH7KhwLbD6TRZkhne/mv7DWHzSHqZxEplKmrZP/6lCADPLRhBfeJePencUXB
        rYxdwv/g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p08SI-00DjQp-EF
        for netfilter-devel@vger.kernel.org; Tue, 29 Nov 2022 21:47:54 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v2 v2 00/34] Refactor of the DB output plug-ins
Date:   Tue, 29 Nov 2022 21:47:15 +0000
Message-Id: <20221129214749.247878-1-jeremy@azazel.net>
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

Changes since v1:

  * The bug-fix in patch 2 was incomplete (cf.
    https://bugzilla.netfilter.org/show_bug.cgi?id=890)

Jeremy Sowden (34):
  ulogd: fix parse-error check
  filter: fix buffer sizes in filter plug-ins
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
 filter/ulogd_filter_IP2BIN.c              |   75 +-
 filter/ulogd_filter_IP2HBIN.c             |    6 +-
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
 output/pgsql/ulogd_output_PGSQL.c         |  426 ++++---
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
 38 files changed, 1836 insertions(+), 1394 deletions(-)

-- 
2.35.1

