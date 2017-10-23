From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/4] libnftables preparations
Date: Mon, 23 Oct 2017 17:33:15 +0200
Message-ID: <20171023153319.13415-1-phil@nwl.cc>
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60842 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932102AbdJWPdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2017 11:33:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series prepares libnftables libarary split-off by moving
API functions into src/libnftables.c, introducing
include/nftables/nftables.h and enhancing the code by a number of
getters and setters for applications to change configurable parts of
struct nft_ctx without knowledge of that struct's internals.

The 'nft' binary will become the first "demo" user of libnftables and
acts as a reference for library design and usability.

Changes since v1:
- Dropped first patch from series as it was applied already.
- Rearranged changes in remaining patches to become more clear and avoid
  moving header file content back and forth between nftables.h and
  nftables/nftables.h.
- Improved patch descriptions.

Phil Sutter (4):
  libnftables: Move library stuff out of main.c
  libnftables: Introduce nft_ctx_flush_cache()
  cli: Use nft_run_cmd_from_buffer()
  libnftables: Introduce getters and setters for everything

 include/Makefile.am          |   3 +-
 include/cli.h                |   6 +-
 include/nftables.h           |  38 +----
 include/nftables/Makefile.am |   1 +
 include/nftables/nftables.h  |  78 ++++++++++
 src/Makefile.am              |   3 +-
 src/cli.c                    |  24 +--
 src/libnftables.c            | 364 +++++++++++++++++++++++++++++++++++++++++++
 src/main.c                   | 285 +++------------------------------
 src/scanner.l                |   4 +-
 10 files changed, 474 insertions(+), 332 deletions(-)
 create mode 100644 include/nftables/Makefile.am
 create mode 100644 include/nftables/nftables.h
 create mode 100644 src/libnftables.c

-- 
2.13.1

