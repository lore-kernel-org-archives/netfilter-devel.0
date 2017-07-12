From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/4] monitor: Fix printing of range elements in named sets
Date: Wed, 12 Jul 2017 14:36:54 +0200
Message-ID: <20170712123658.25363-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39307 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755283AbdGLMh3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:37:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As agreed upon with Arturo at NFWS, here is my version of the same fix
for side-by-side comparison.

This series allows 'nft monitor' to correctly reassemble ranges before
printing them, also in the case of half-open ranges (used when a range
spans to the end of the spectrum).

To fix the zero segment problem, the last patch in this series has to
retrieve the parsed set element from dummyset. For convenience, I
created list_last_entry() macro and compound_expr_last() as shown in
patches 2 and 3.

Phil Sutter (4):
  monitor: Fix printing of range elements in named sets
  list: Introduce list_last_entry
  expression: Introduce compound_expr_last
  monitor: Ignore ranges' zero segment

 include/expression.h |  1 +
 include/list.h       | 11 ++++++++
 src/expression.c     |  7 +++++
 src/netlink.c        | 80 +++++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 95 insertions(+), 4 deletions(-)

-- 
2.13.1

