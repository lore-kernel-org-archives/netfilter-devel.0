From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] Allow to disable man page output
Date: Tue, 16 Jan 2018 17:38:05 +0100
Message-ID: <20180116163807.13276-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47274 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbeAPQi3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 11:38:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An option to disable man page creating on systems with broken docbook
helps prevent build failures for them.

While preparing above functionality (found in patch 2), I noticed the
rather confusing help entry for debug option and fixed it while being at
it (patch 1).

Phil Sutter (2):
  configure: Fix help text regarding --enable-debug
  configure: Allow to disable man page building

 configure.ac | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

-- 
2.15.1

