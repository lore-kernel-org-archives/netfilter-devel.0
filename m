From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 0/4] A round of covscan indicated fixes
Date: Tue, 30 Aug 2016 19:39:48 +0200
Message-ID: <1472578792-2991-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35963 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932809AbcH3RkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 13:40:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As for libnftnl, this series aims at fixing a number of issues
identified by covscan. And again, due to my limited overview of the
code-base, some of them might as well be invalid although I tried to
verify the issues as best as I can.

Changes since v1:
- Rebased onto current upstream master.
- Reviewed and improved every patch (for details see each patch's
  changelog).

Phil Sutter (4):
  evaluate: Fix datalen checks in expr_evaluate_string()
  netlink_delinearize: Avoid potential null pointer deref
  stmt_evaluate_reset: Have a generic fix for missing network context
  evaluate: Avoid undefined behaviour in concat_subtype_id()

 src/evaluate.c            | 12 +++++++-----
 src/netlink_delinearize.c |  6 ++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

-- 
2.8.2

