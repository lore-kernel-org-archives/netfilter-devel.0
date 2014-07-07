From: Giorgio Dal Molin <giorgio.nicole@arcor.de>
Subject: [PATCH 0/7] patches for an autotooled version of 'nftables'.
Date: Mon,  7 Jul 2014 12:15:37 +0159
Message-ID: <1404728169-7899-1-git-send-email-giorgio.nicole@arcor.de>
Cc: root <giorgio.nicole@rocor.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:54441 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752622AbaGGKQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:16:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: root <giorgio.nicole@rocor.de>

Hi,

I'm sending a couple of patches to add autotools support to the 'nftables' project.

I would like to have some feedback on it and eventually see the patches
merged on the main 'nftables' repo.

The patches are based on the version 0.3 of nftable:

commit id: ae73759150652213029718ecfa3017fa28e879c1

upstream.

The whole changes are divided in different commits for the sake of clarity
and documentation but it's not really possible to build any of the tree states
in between, only the last 'autotool conversion: ...' state is usable.

Target of these patches is a sw package that is easier to configure, cross-compile,
build in parallel also from a different build directory, and that supports
creating release tar archives.

One of my tests was to create a release distribution from there:

# cd /tmp
# mkdir nft_build
# cd nft_build
# /tmp/nftable-0.3_autotooled/autogen.sh
# /tmp/nftable-0.3_autotooled/configure
# make distcheck

The 'distcheck' target tries to configure/build/locally-install the package and if it's all
right it produces a tar archive with all that's needed for a release.

giorgio


Giorgio (5):
  autotool conversion: use pkg-config to find 'libmnl', libnftnl' and
    'ncurses'.
  autotool conversion: converted the subdir. 'src/'
  autotool conversion: Converted the support for the 'doc/' subdir.
  autotools conversion: commit the rest of the configure.ac changes.
  autotool conversion: updated the files .gitignore

root (2):
  autotool conversion: autotools support for the subdir.
    'files/nftables'.
  autotools conversion: include the header 'config.h' in every C source
    file.

 .gitignore                   |   19 +-
 autogen.sh                   |   10 +-
 configure.ac                 |  135 ++-
 doc/Makefile.am              |   12 +
 doc/Makefile.in              |   20 -
 files/nftables/Makefile.am   |   13 +
 files/nftables/bridge-filter |    2 +-
 files/nftables/inet-filter   |    2 +-
 files/nftables/ipv4-filter   |    2 +-
 files/nftables/ipv4-mangle   |    2 +-
 files/nftables/ipv4-nat      |    2 +-
 files/nftables/ipv6-filter   |    2 +-
 files/nftables/ipv6-mangle   |    2 +-
 files/nftables/ipv6-nat      |    2 +-
 m4/ax_lib_readlibe.m4        |  107 ++
 src/.gitignore               |    4 +-
 src/Makefile.am              |   45 +
 src/Makefile.in              |   31 -
 src/cli.c                    |    3 +
 src/ct.c                     |    3 +
 src/datatype.c               |    3 +
 src/erec.c                   |    3 +
 src/evaluate.c               |    3 +
 src/expression.c             |    3 +
 src/exthdr.c                 |    3 +
 src/gmputil.c                |    3 +
 src/main.c                   |    3 +
 src/meta.c                   |    3 +
 src/mnl.c                    |    3 +
 src/netlink.c                |    3 +
 src/netlink_delinearize.c    |    3 +
 src/netlink_linearize.c      |    3 +
 src/parser.y                 | 2251 ------------------------------------------
 src/payload.c                |    3 +
 src/proto.c                  |    3 +
 src/rbtree.c                 |    3 +
 src/rule.c                   |    3 +
 src/scanner.l                |    3 +-
 src/segtree.c                |    3 +
 src/statement.c              |    3 +
 src/utils.c                  |    3 +
 src/yacc_parser.y            | 2251 ++++++++++++++++++++++++++++++++++++++++++
 42 files changed, 2610 insertions(+), 2370 deletions(-)
 create mode 100644 doc/Makefile.am
 delete mode 100644 doc/Makefile.in
 create mode 100644 files/nftables/Makefile.am
 create mode 100644 m4/ax_lib_readlibe.m4
 create mode 100644 src/Makefile.am
 delete mode 100644 src/Makefile.in
 delete mode 100644 src/parser.y
 create mode 100644 src/yacc_parser.y

-- 
2.0.1

