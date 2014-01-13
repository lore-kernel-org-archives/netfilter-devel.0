From: Jan Engelhardt <jengelh@inai.de>
Subject: nftables: improve build system
Date: Mon, 13 Jan 2014 10:07:47 +0100
Message-ID: <1389604070-12068-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:56795 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaAMJHw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:07:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit b566123b9b60aff8ef21dfa7b21f817261236b1d:

  nftables: drop hard coded install using root user owner and group (2014-01-13 06:36:45 +0000)

are available in the git repository at:

  git://git.inai.de/nftables master

for you to fetch changes up to 54f180f8d762259d6fe5f671e5b19cf9a5a9b683:

  build: use automake and pkgconfig (2014-01-13 10:04:35 +0100)

----------------------------------------------------------------
Jan Engelhardt (3):
      build: remove unused checks
      build: rename conflicting parser.h instances
      build: use automake and pkgconfig

 .gitignore                      |  17 +--
 Makefile.am                     |   7 ++
 Makefile.defs.in                |  40 ------
 Makefile.in                     |   5 -
 Makefile.rules.in               |  89 -------------
 configure.ac                    |  70 ++++-------
 doc/Makefile.am                 |  14 +++
 doc/Makefile.in                 |  20 ---
 files/Makefile.am               |   6 +
 files/Makefile.in               |   4 -
 install-sh                      | 269 ----------------------------------------
 src/.gitignore                  |   4 +-
 src/Makefile.am                 |  25 ++++
 src/Makefile.in                 |  30 -----
 src/cli.c                       |   1 +
 src/erec.c                      |   1 +
 src/main.c                      |   1 +
 src/{parser.y => parser_impl.y} |   2 +-
 src/scanner.l                   |   2 +-
 19 files changed, 91 insertions(+), 516 deletions(-)
 create mode 100644 Makefile.am
 delete mode 100644 Makefile.defs.in
 delete mode 100644 Makefile.in
 delete mode 100644 Makefile.rules.in
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in
 create mode 100644 files/Makefile.am
 delete mode 100644 files/Makefile.in
 delete mode 100755 install-sh
 create mode 100644 src/Makefile.am
 delete mode 100644 src/Makefile.in
 rename src/{parser.y => parser_impl.y} (99%)
