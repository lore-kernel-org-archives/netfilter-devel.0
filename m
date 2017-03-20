From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] Some fixes for nested sets
Date: Mon, 20 Mar 2017 17:38:54 +0100
Message-ID: <20170320163856.6064-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:45145 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755376AbdCTRCu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 13:02:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series fixes a number of issues with nested anonymous sets.

Phil Sutter (2):
  evaluate: set: Allow for set elems to be sets
  evaluate: set: Fix nested set merge size adjustment

 src/evaluate.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

-- 
2.11.0

