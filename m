From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH - v2 - 0/4] NAT expression and IPv6 NAT support
Date: Thu, 15 Nov 2012 14:24:58 +0200
Message-ID: <1352982302-32402-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24236 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767850Ab2KOOZI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:25:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 

same patches as before with modifications applied according to Pablo's comments.
Patch 3 is therefore much simpler.

Tomasz Bursztyka (4):
  nf_tables: Change NFTA_NAT_ attributes to better semantic
    significance
  nf_tables: Split IPv4 NAT into NAT expression and NAT IPv4 chain.
  nf_tables: Add support for IPv6 NAT expression
  nf_tables: Add support for IPv6 NAT chain

 include/linux/netfilter/nf_tables.h     |   9 +-
 net/ipv4/netfilter/Kconfig              |   1 +
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 154 +---------------------
 net/ipv6/netfilter/Kconfig              |   5 +
 net/ipv6/netfilter/Makefile             |   2 +
 net/ipv6/netfilter/nft_chain_nat_ipv6.c | 209 ++++++++++++++++++++++++++++++
 net/netfilter/Kconfig                   |   5 +
 net/netfilter/Makefile                  |   1 +
 net/netfilter/nft_nat.c                 | 220 ++++++++++++++++++++++++++++++++
 9 files changed, 449 insertions(+), 157 deletions(-)
 create mode 100644 net/ipv6/netfilter/nft_chain_nat_ipv6.c
 create mode 100644 net/netfilter/nft_nat.c

-- 
1.8.0

