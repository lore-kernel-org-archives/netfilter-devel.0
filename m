From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nftables 0/7] ct helper set support
Date: Wed, 15 Mar 2017 16:01:04 +0100
Message-ID: <20170315150111.18477-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46440 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752182AbdCOPAz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 11:00:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

v2, with updated syntax to force type and protocol keywords
into same statement, i.e.

ct helper ftp-standard {
  type "ftp" protocol tcp
}

I also cleaned up the changes to bison (reuse family_spec_explicit)
and added a test for an invalid helper (l3proto ip6 in ip table).

 doc/nft.xml                         |   76 +++++++++++++++++
 include/ct.h                        |    1 
 include/linux/netfilter/nf_tables.h |   12 ++
 include/rule.h                      |   12 ++
 src/ct.c                            |   10 ++
 src/evaluate.c                      |   37 +++++---
 src/netlink.c                       |   16 +++
 src/parser_bison.y                  |  156 +++++++++++++++++++++++++++++++++++-
 src/rule.c                          |   45 ++++++++++
 src/statement.c                     |   10 ++
 tests/py/ip/objects.t               |    5 +
 tests/py/ip/objects.t.payload       |   14 +++
 tests/py/nft-test.py                |   28 +++++-
 13 files changed, 399 insertions(+), 23 deletions(-)
