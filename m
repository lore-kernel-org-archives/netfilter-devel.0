From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 0/5] autotools conversion
Date: Thu,  6 Nov 2014 19:25:44 +0100
Message-ID: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbaKFSYK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:24:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I found some time to work on the autotools support. Initial patches
were posted by Jan dal Molin here:

http://marc.info/?l=netfilter-devel&m=140632527026257&w=2

Those were a good start to address this, but I wanted to introduce
these changes incrementally by avoiding bisectability breakage
between patches. Moreover, this changeset included quite a lot of
changes in configure.ac among other things that this patchset avoids.

Note that doc/ and files/ were not converted yet, so those are currently
disabled. Feel free to send patches to complete that or I'll finish
it once I find time to work on this again.

I have pushed this to this branch:

http://git.netfilter.org/nftables/log/?h=autotools

Please, review and test. Thanks.

Pablo Neira Ayuso (5):
  build: use PKG_CHECK_MODULES to check for libmnl and libnftnl
  build: use AC_PROG_YACC and AM_PROG_LEX
  rename parser.y to parser_bison.y
  include: add cli.h
  build: autotools conversion

 .gitignore                       |   10 +-
 Make_global.am                   |   10 ++
 Makefile.am                      |    5 +
 Makefile.defs.in                 |   42 ------
 Makefile.in                      |    5 -
 Makefile.rules.in                |   96 --------------
 configure.ac                     |   49 ++++---
 include/cli.h                    |   18 +++
 include/nftables.h               |   14 +-
 install-sh                       |  269 --------------------------------------
 m4/.gitignore                    |    2 +
 src/Makefile.am                  |   41 ++++++
 src/Makefile.in                  |   33 -----
 src/cli.c                        |    2 +
 src/erec.c                       |    1 +
 src/main.c                       |    1 +
 src/{parser.y => parser_bison.y} |    3 +-
 src/scanner.l                    |    3 +-
 18 files changed, 122 insertions(+), 482 deletions(-)
 create mode 100644 Make_global.am
 create mode 100644 Makefile.am
 delete mode 100644 Makefile.defs.in
 delete mode 100644 Makefile.in
 delete mode 100644 Makefile.rules.in
 create mode 100644 include/cli.h
 delete mode 100755 install-sh
 create mode 100644 m4/.gitignore
 create mode 100644 src/Makefile.am
 delete mode 100644 src/Makefile.in
 rename src/{parser.y => parser_bison.y} (99%)

-- 
1.7.10.4

