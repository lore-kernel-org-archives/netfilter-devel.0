From: Jan Engelhardt <jengelh@inai.de>
Subject: nftables: use automake & pkgconfig
Date: Sun, 20 Oct 2013 16:48:08 +0200
Message-ID: <1382280491-9921-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:39129 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3JTOsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:48:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 2855909e46f4646f137a96892bd5c465fa1193f8:

  src: fix return code (2013-10-17 11:08:40 +0200)

are available in the git repository at:

  git://git.inai.de/nftables master

for you to fetch changes up to af2a890f6fa39d09240b85811a430b51b88a866e:

  build: use automake and pkgconfig (2013-10-20 16:36:53 +0200)

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
 src/Makefile.am                 |  24 ++++
 src/Makefile.in                 |  30 -----
 src/cli.c                       |   1 +
 src/erec.c                      |   1 +
 src/main.c                      |   1 +
 src/{parser.y => parser_impl.y} |   2 +-
 src/scanner.l                   |   2 +-
 19 files changed, 90 insertions(+), 516 deletions(-)
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
