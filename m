From: Jan Engelhardt <jengelh@medozas.de>
Subject: ulogd2 build updates
Date: Fri,  5 Nov 2010 19:36:14 +0100
Message-ID: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44387 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0KESga (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 1521d3de58250a9c475995f611bd2cae14741fb2:

  Add helper script pcap2ulog (2010-10-23 11:48:06 +0200)

are available in the git repository at:
  git://dev.medozas.de/ulogd2 master

Jan Engelhardt (9):
      build: move global automake options into configure.ac
      build: remove statements without obvious effect
      build: remove -fPIC flag
      build: remove unused $(all_includes)
      output/LOGEMU: resolve build warning
      build: default to not building static libraries
      build: propagate global CFLAGS
      build: no need for error message in PKG_CHECK_MODULES
      filter/HWHDR: remove redundant sizeof(char)

 Makefile.am                   |    7 +------
 configure.ac                  |   19 +++++++------------
 filter/Makefile.am            |    3 ++-
 filter/raw2packet/Makefile.am |    3 ++-
 filter/ulogd_filter_HWHDR.c   |    2 +-
 input/flow/Makefile.am        |    4 ++--
 input/packet/Makefile.am      |    4 ++--
 libipulog/Makefile.am         |    5 ++---
 output/Makefile.am            |    3 ++-
 output/dbi/Makefile.am        |    3 ++-
 output/mysql/Makefile.am      |    3 ++-
 output/pcap/Makefile.am       |    3 ++-
 output/pgsql/Makefile.am      |    3 ++-
 output/sqlite3/Makefile.am    |    3 ++-
 output/ulogd_output_LOGEMU.c  |    2 +-
 src/Makefile.am               |    3 ++-
 16 files changed, 34 insertions(+), 36 deletions(-)
