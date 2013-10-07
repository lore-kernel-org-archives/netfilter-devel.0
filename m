From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables kernel - PATCH 0/2] Minor API fixes (mostly documentation)
Date: Mon,  7 Oct 2013 12:57:58 +0300
Message-ID: <1381139880-20311-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237Ab3JGJ6F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:58:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2 quick patches to:
- update the netlink api documentation
- fix a minor issue around nla_policy for chain

Tomasz Bursztyka (2):
  netfilter: nf_tables: Update uapi nftables netlink header documentation
  netfilter: nf_tables: Fix the netlink attributes policy for chain

 include/uapi/linux/netfilter/nf_tables.h | 89 ++++++++++++++++++++++++++++++--
 net/netfilter/nf_tables_api.c            |  3 +-
 2 files changed, 86 insertions(+), 6 deletions(-)

-- 
1.8.3.2

