From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] Follow-up on nft_print() enhancement
Date: Fri, 29 Sep 2017 13:26:20 +0200
Message-ID: <20170929112622.11686-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37572 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751590AbdI2L0o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 07:26:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fixes two spots I forgot to clean up before submitting the patches.

Phil Sutter (2):
  main: Flush output from nft_gmp_print()
  main: Drop stdout hack to expose nft_print() implementation issues

 src/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.13.1

