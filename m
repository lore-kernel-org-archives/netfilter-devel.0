From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables-nftables PATCH 0/3] NFPROTO_ARP and arp mangle target support (+ one minor fix)
Date: Fri,  6 Sep 2013 10:51:47 +0300
Message-ID: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3IFHvy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 03:51:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset prepares for arptables-nftables to be included so it will use libxtables for its target.

Tomasz Bursztyka (3):
  nft: Fix a minor compilation warning
  libxtables: Add NFPROTO_ARP support for libarpt_* prefixed extensions
  libxtables: Port libarptc mangle target into libxtables

 configure.ac                              |   5 +
 extensions/GNUmakefile.in                 |  52 +++-
 extensions/libarpt_mangle.c               | 388 ++++++++++++++++++++++++++++++
 include/linux/netfilter_arp.h             |  19 ++
 include/linux/netfilter_arp/arp_tables.h  | 204 ++++++++++++++++
 include/linux/netfilter_arp/arpt_mangle.h |  26 ++
 iptables/nft-shared.c                     |   2 +-
 libxtables/xtables.c                      |  14 ++
 8 files changed, 701 insertions(+), 9 deletions(-)
 create mode 100644 extensions/libarpt_mangle.c
 create mode 100644 include/linux/netfilter_arp.h
 create mode 100644 include/linux/netfilter_arp/arp_tables.h
 create mode 100644 include/linux/netfilter_arp/arpt_mangle.h

-- 
1.8.3.2

