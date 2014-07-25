From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 0/8] patches for an autotooled version of 'nftables'.
Date: Fri, 25 Jul 2014 23:52:51 +0159
Message-ID: <1406325204-23648-1-git-send-email-giorgio.nicole@arcor.de>
References: <20140725171646.GA5718@salvia>
Cc: Giorgio Dal Molin <giorgio.nicole@arcor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:53212 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbaGYVy2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 17:54:28 -0400
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net [151.189.8.85])
	by mx.arcor.de (Postfix) with ESMTP id 635F15A604
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2014 23:54:26 +0200 (CEST)
In-Reply-To: <20140725171646.GA5718@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The patches are based on the upstream commit id:

b1a348208a9e5749860a95ceb0307fc16f2edb7f

and add support for the autotools to nftables.

The whole changes are divided in different commits for the sake of clarity
and documentation but it's not really possible to build any of the tree states
in between, only the last 'autotool conversion: ...' state is usable.

giorgio

Giorgio Dal Molin (2):
  autotool conversion: converted the subdir. 'src/'
  autotool conversion: updated the files .gitignore

Giorgio Dal Molin (4):
  autotool conversion: use pkg-config to find 'libmnl', libnftnl' and
    'ncurses'.
  autotools conversion: include the header 'config.h' in every C source
    file.
  autotool conversion: Converted the support for the 'doc/' subdir.
  autotools conversion: commit the rest of the configure.ac changes.

Giorgio Dal Molin (2):
  autotool conversion: Added some required files, removed some unneeded.
  autotool conversion: autotools support for the subdir.
    'files/nftables'.

 .gitignore                          |  19 ++-
 AUTHORS                             |   0
 ChangeLog                           |   0
 Makefile.am                         |   3 +
 Makefile.defs.in                    |  42 ------
 Makefile.in                         |   5 -
 Makefile.rules.in                   |  96 -------------
 NEWS                                |   0
 README                              |  61 ++++++++
 autogen.sh                          |  10 +-
 configure.ac                        | 133 +++++++++++-------
 doc/Makefile.am                     |  10 ++
 doc/Makefile.in                     |  20 ---
 files/Makefile.am                   |   1 +
 files/Makefile.in                   |   5 -
 files/nftables/Makefile.am          |  13 ++
 files/nftables/bridge-filter        |   2 +-
 files/nftables/inet-filter          |   2 +-
 files/nftables/ipv4-filter          |   2 +-
 files/nftables/ipv4-mangle          |   2 +-
 files/nftables/ipv4-nat             |   2 +-
 files/nftables/ipv6-filter          |   2 +-
 files/nftables/ipv6-mangle          |   2 +-
 files/nftables/ipv6-nat             |   2 +-
 include/Makefile.am                 |  21 +++
 include/linux/Makefile.am           |   7 +
 include/linux/netfilter/Makefile.am |   4 +
 install-sh                          | 269 ------------------------------------
 m4/ax_lib_readlibe.m4               | 107 ++++++++++++++
 src/.gitignore                      |   4 +-
 src/Makefile.am                     |  44 ++++++
 src/Makefile.in                     |  31 -----
 src/cli.c                           |   2 +
 src/ct.c                            |   2 +
 src/datatype.c                      |   2 +
 src/erec.c                          |   2 +
 src/evaluate.c                      |   2 +
 src/expression.c                    |   2 +
 src/exthdr.c                        |   2 +
 src/gmputil.c                       |   2 +
 src/main.c                          |   2 +
 src/meta.c                          |   2 +
 src/mnl.c                           |   2 +
 src/netlink.c                       |   2 +
 src/netlink_delinearize.c           |   2 +
 src/netlink_linearize.c             |   2 +
 src/payload.c                       |   2 +
 src/proto.c                         |   2 +
 src/rbtree.c                        |   2 +
 src/rule.c                          |   2 +
 src/scanner.l                       |   3 +-
 src/segtree.c                       |   2 +
 src/statement.c                     |   2 +
 src/utils.c                         |   2 +
 src/{parser.y => yacc_parser.y}     |   4 +-
 55 files changed, 432 insertions(+), 538 deletions(-)
 create mode 100644 AUTHORS
 create mode 100644 ChangeLog
 create mode 100644 Makefile.am
 delete mode 100644 Makefile.defs.in
 delete mode 100644 Makefile.in
 delete mode 100644 Makefile.rules.in
 create mode 100644 NEWS
 create mode 100644 README
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in
 create mode 100644 files/Makefile.am
 delete mode 100644 files/Makefile.in
 create mode 100644 files/nftables/Makefile.am
 create mode 100644 include/Makefile.am
 create mode 100644 include/linux/Makefile.am
 create mode 100644 include/linux/netfilter/Makefile.am
 delete mode 100755 install-sh
 create mode 100644 m4/ax_lib_readlibe.m4
 create mode 100644 src/Makefile.am
 delete mode 100644 src/Makefile.in
 rename src/{parser.y => yacc_parser.y} (99%)

-- 
2.0.3

