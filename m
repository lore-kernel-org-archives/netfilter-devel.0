From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/7] libnftables preparations
Date: Thu, 19 Oct 2017 10:18:40 +0200
Message-ID: <20171019081847.16171-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:49464 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdJSITi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2017 04:19:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series prepares libnftables libarary split-off by moving
API functions into src/libnftables.c, introducing
include/nftables/nftables.h and enhancing the code by a number of
getters and setters for applications to change configurable parts of
struct nft_ctx without knowledge of that struct's internals.

The 'nft' binary will become the first "demo" user of libnftables and
acts as a reference for library design and usability.

Phil Sutter (7):
  nft_ctx_free: Fix for wrong argument passed to cache_release
  libnftables: Move library stuff out of main.c
  libnftables: Introduce nft_ctx_flush_cache()
  cli: Use nft_run_cmd_from_buffer()
  libnftables: Introduce nft_ctx_set_dry_run()
  libnftables: Provide an API for include path handling
  libnftables: Add remaining getters and setters

 include/Makefile.am          |   3 +-
 include/cli.h                |   6 +-
 include/nftables.h           |  48 +-----
 include/nftables/Makefile.am |   1 +
 include/nftables/nftables.h  |  72 +++++++++
 src/Makefile.am              |   3 +-
 src/cli.c                    |  24 +--
 src/libnftables.c            | 360 +++++++++++++++++++++++++++++++++++++++++++
 src/main.c                   | 285 +++-------------------------------
 src/scanner.l                |   4 +-
 10 files changed, 468 insertions(+), 338 deletions(-)
 create mode 100644 include/nftables/Makefile.am
 create mode 100644 include/nftables/nftables.h
 create mode 100644 src/libnftables.c

-- 
2.13.1

