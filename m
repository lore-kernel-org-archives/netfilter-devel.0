From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] First attempt at synopsis fixup
Date: Thu, 17 Aug 2017 15:38:58 +0200
Message-ID: <20170817133900.21946-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:50233 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751637AbdHQNjN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 09:39:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The first patch is to be considered a fix and optimization, the second
one is rather experimental and I would like to hear your thoughts about
it (some details as to why I'm not happy with it can be found below it's
commit message).

Phil Sutter (2):
  nft.8: Fix and enhance synopsis section
  nft.8: Make use of synopfragment in synopsis section

 doc/nft.xml | 98 +++++++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 28 deletions(-)

-- 
2.13.1

