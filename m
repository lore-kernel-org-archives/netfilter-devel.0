From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/6] A bunch of man page enhancements
Date: Thu, 10 Aug 2017 19:29:14 +0200
Message-ID: <20170810172920.14893-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37379 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752598AbdHJR3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Aug 2017 13:29:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series should resolve nfbz#1093.

Many thanks to Florian for his patient explanations of base chain types
and hooks.

Phil Sutter (6):
  nft.8: Document operations on ruleset
  nft.8: Describe conntrack types
  nft.8: Review reject statement description
  nft.8: Add note about supported hooks for bridge family
  nft.8: Describe base chain details
  nft.8: Complete short description of arp family

 doc/nft.xml | 733 +++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 647 insertions(+), 86 deletions(-)

-- 
2.13.1

