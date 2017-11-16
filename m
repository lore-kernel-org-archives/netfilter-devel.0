From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 0/2] Review code regarding output_fp
Date: Thu, 16 Nov 2017 09:06:27 +0100
Message-ID: <20171116080629.30564-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59730 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754569AbdKPIGl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 03:06:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Grepping the code for 'stdout' revealed two places where
application-defined output_fp is ignored and instead direct printing to
stdout happens: One is 'nft export' output, the other is 'nft monitor'
output if JSON output was chosen. This series fixes both.

Phil Sutter (2):
  Make 'nft export' respect output_fp
  monitor: Make JSON output respect output_fp

 src/netlink.c | 38 ++++++++++++++++++--------------------
 src/rule.c    |  9 +++++++--
 2 files changed, 25 insertions(+), 22 deletions(-)

-- 
2.13.1

