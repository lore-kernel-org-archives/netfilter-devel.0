From: Jan Engelhardt <jengelh@medozas.de>
Subject: libnetfilter_conntrack: build improvements
Date: Fri, 31 Dec 2010 00:41:38 +0100
Message-ID: <1293752503-13178-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43755 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0L3Xlo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:41:44 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit e6ba25eb57957e6634d5e7cec539b1d6e4204b27:

  Merge branch 'master' of git://dev.medozas.de/libnetfilter_conntrack (2010-12-21 20:25:32 +0100)

are available in the git repository at:

  git://dev.medozas.de/libnetfilter_conntrack master

Jan Engelhardt (4):
      build: remove unused LIBTOOL_DEPS
      build: use -Wall across the entire source
      utils: resolve compiler warnings
      qa: resolve compiler warnings

 Make_global.am                  |    1 +
 configure.ac                    |    2 --
 qa/test_api.c                   |    9 +++++----
 qa/test_filter.c                |    6 +++++-
 src/Makefile.am                 |    2 --
 src/conntrack/Makefile.am       |    2 --
 src/expect/Makefile.am          |    2 --
 utils/conntrack_create.c        |    4 +++-
 utils/conntrack_create_nat.c    |    4 +++-
 utils/conntrack_delete.c        |    4 +++-
 utils/conntrack_dump.c          |    4 ++--
 utils/conntrack_events.c        |    6 ++----
 utils/conntrack_filter.c        |    7 +++----
 utils/conntrack_flush.c         |    4 ++--
 utils/conntrack_get.c           |    4 +++-
 utils/conntrack_grp_create.c    |    4 +++-
 utils/conntrack_master.c        |    4 +++-
 utils/conntrack_update.c        |    4 +++-
 utils/ctexp_events.c            |    1 +
 utils/expect_create.c           |    4 +++-
 utils/expect_create_userspace.c |    4 +++-
 utils/expect_delete.c           |    4 +++-
 utils/expect_dump.c             |    3 ++-
 utils/expect_events.c           |    3 ++-
 utils/expect_flush.c            |    3 ++-
 utils/expect_get.c              |    4 +++-
 26 files changed, 60 insertions(+), 39 deletions(-)
