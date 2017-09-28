From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/5] Get output under application control
Date: Thu, 28 Sep 2017 17:17:40 +0200
Message-ID: <20170928151745.28426-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35312 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdI1PSY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 11:18:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series introduces struct output_ctx field 'output_fp' and
adjusts the whole code base to use that for regular (e.g. 'list'
command) and debug output.

Patches 1-4 contain preparation changes which I extracted for easier
review. Patch 5 is a modified version of what Eric Leblond sent earlier
(hence why I tagged this whole series as v2). I sent him parts of it
earlier, but didn't get a reply. So I'll just hijack his work and make
it a joint one between him and me.

Patches 1-4 are new ones not present in Eric's v1. Patch 5 contains a
changelog.

Note that with this series applied, the testsuite (including monitor
tests) passes (apart from the unrelated ICMPv6 asymmetry).

Phil Sutter (5):
  rule: Use C99-style initializer in cache_init()
  exthdr: Simplify tcp option printing a bit
  erec_print: Pass output FILE pointer to netlink_dump_expr()
  rule: Refactor chain_print_declaration()
  src: get rid of printf

 include/datatype.h      |   5 +-
 include/expression.h    |   2 +-
 include/netlink.h       |  10 +-
 include/nftables.h      |   6 +
 include/parser.h        |   2 +-
 include/rule.h          |   7 +-
 src/cli.c               |   2 +-
 src/ct.c                |  20 ++--
 src/datatype.c          |  60 +++++-----
 src/erec.c              |   2 +-
 src/evaluate.c          |  22 ++--
 src/expression.c        |  74 ++++++------
 src/exthdr.c            |  21 ++--
 src/fib.c               |  23 ++--
 src/hash.c              |  10 +-
 src/main.c              |  51 ++++++++-
 src/meta.c              |  32 +++---
 src/netlink.c           | 131 ++++++++++-----------
 src/netlink_linearize.c |   2 +-
 src/numgen.c            |   7 +-
 src/parser_bison.y      |   3 +-
 src/payload.c           |  10 +-
 src/rt.c                |   2 +-
 src/rule.c              | 297 +++++++++++++++++++++++++-----------------------
 src/statement.c         | 138 +++++++++++-----------
 25 files changed, 510 insertions(+), 429 deletions(-)

-- 
2.13.1

