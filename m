From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables - v2 PATCH 0/2] Fixed chain name and add support for NFTA_CHAIN_NEW_NAME attribute
Date: Thu,  1 Nov 2012 14:20:35 +0200
Message-ID: <1351772437-9015-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:11359 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab2KAMUk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 08:20:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

A rework of "[libnftables - PATCH] chain: Add support for NFTA_CHAIN_NEW_NAME attribute" according to
the change of chain's name which becomes fixed sized.

Tomasz Bursztyka (2):
  chain: Handle fixed sized name
  chain: Add support for NFTA_CHAIN_NEW_NAME attribute

 include/libnftables/chain.h         |  1 +
 include/linux/netfilter/nf_tables.h |  3 +++
 src/chain.c                         | 30 ++++++++++++++++++++++--------
 3 files changed, 26 insertions(+), 8 deletions(-)

-- 
1.7.12.4

