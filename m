From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/4] Memleak fixes and some minor cleanups
Date: Thu, 24 Aug 2017 19:14:09 +0200
Message-ID: <20170824171413.31737-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37857 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753416AbdHXRO0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2017 13:14:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series fixes two sources of memleaks as reported by
valgrind (see patches 1 and 4). Patches 2 and 3 contain some minor
cleanups I found while searching for the leaks.

Phil Sutter (4):
  scanner: Fix for memleak due to unclosed file pointer
  scanner: Fix for wrong parameter type of scanner_destroy()
  scanner: Make use of yylex_init_extra()
  parser: Fix for memleak when commands fail

 include/nftables.h |  2 +-
 include/parser.h   |  2 +-
 src/erec.c         | 11 +++++------
 src/main.c         |  2 +-
 src/parser_bison.y |  2 ++
 src/scanner.l      |  8 ++++----
 6 files changed, 14 insertions(+), 13 deletions(-)

-- 
2.13.1

