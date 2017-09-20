From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 0/2] Document nfnl_osf utility
Date: Wed, 20 Sep 2017 18:54:07 +0200
Message-ID: <20170920165409.11456-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41430 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750938AbdITQyV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 12:54:21 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series fixes nfnl_osf help output a bit and introduces a (short)
man page.

Phil Sutter (2):
  utils: nfnl_osf: Fix synopsis in help text
  utils: Add a man page for nfnl_osf

 configure.ac        |  3 ++-
 utils/.gitignore    |  1 +
 utils/Makefile.am   |  4 ++++
 utils/nfnl_osf.8.in | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 utils/nfnl_osf.c    |  2 +-
 5 files changed, 75 insertions(+), 2 deletions(-)
 create mode 100644 utils/nfnl_osf.8.in

-- 
2.13.1

