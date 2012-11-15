From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next:nf_tables-experiments PATCH 0/4] NAT expression and IPv6 NAT support
Date: Thu, 15 Nov 2012 11:15:48 +0200
Message-ID: <1352970952-3447-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1854 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435Ab2KOJP5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:15:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here 4 patches to set up NAT expression and related IPvx chains.
It's an adaptation of existing code (splitting nft_chain_ipv4_nat.c and taking code from ip6tables_nat.c),
that's why I kept former Copyrights even in the new modules created.

In nft_nat.c, I used memcpy() on ipv6 data, let me know if there is a better way (though I guess gcc optimizes it).

Please review,

Tomasz Bursztyka (4):
  nf_tables: Change NFTA_NAT_ attributes to better semantic
    significance
  nf_tables: Split IPv4 NAT into NAT expression and NAT IPv4 chain
  nf_tables: Add support for IPv6 NAT expression
  nf_tables: Add support for IPv6 NAT chain

 include/linux/netfilter/nf_tables.h     |  10 +-
 net/ipv4/netfilter/Kconfig              |   1 +
 net/ipv4/netfilter/nft_chain_nat_ipv4.c | 158 +-------------------
 net/ipv6/netfilter/Kconfig              |   5 +
 net/ipv6/netfilter/Makefile             |   2 +
 net/ipv6/netfilter/nft_chain_nat_ipv6.c | 213 +++++++++++++++++++++++++++
 net/netfilter/Kconfig                   |   5 +
 net/netfilter/Makefile                  |   1 +
 net/netfilter/nft_nat.c                 | 248 ++++++++++++++++++++++++++++++++
 9 files changed, 486 insertions(+), 157 deletions(-)
 create mode 100644 net/ipv6/netfilter/nft_chain_nat_ipv6.c
 create mode 100644 net/netfilter/nft_nat.c

-- 
1.8.0

