From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 0/3] xtables-arp fixes + libxt_mangle addition
Date: Thu,  3 Oct 2013 12:52:54 +0300
Message-ID: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:10353 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab3JCJxE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 05:53:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch 1 and 2 fixes 2 issuse (patch 2 is a very minor one).
Patch 3 adds the support of 'mangle' target for xtables-arp through libxtables.

Note: Giuseppe has a patch for nft_arp_parse_meta() also, for a bug in -D as well.

Tomasz Bursztyka (3):
  xtables: arp: Store target entry properly and compare them relevantly
  libxtables: Port libarptc mangle target into libxtables
  xtables: arp: Do not add a useless prefix for afinfo_arp

 extensions/libxt_mangle.c         | 389 ++++++++++++++++++++++++++++++++++++++
 iptables/nft-arp.c                |  44 ++---
 iptables/nft-shared.h             |   4 +-
 iptables/xtables-arp-standalone.c |   2 +-
 iptables/xtables-arp.c            |   8 +-
 5 files changed, 417 insertions(+), 30 deletions(-)
 create mode 100644 extensions/libxt_mangle.c

-- 
1.8.3.2

