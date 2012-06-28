From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 0/3] Nfnetlink and ipset fixes
Date: Thu, 28 Jun 2012 15:57:46 +0300
Message-ID: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab2F1M6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:58:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The 2 first patches fixes the same issue, but in 2 different place.

Patch 1:

So here is how the issue can be reprocuced:
Create a netlink message, targeting ipset subsystem. And send a command on id 0 (IPSET_CMD_NONE):
This will lead to a crash on line 188 of nfnetlink.c since nc->call is NULL (so you get a NULL dereference).

Or Patch 2:

Same issue.
It fixes ipset to handle the IPSET_CMD_NONE, return -EOPNOTSUPP.

Patch 3:

While doing patch 1 I figured out rcu_read_unlock() is not called in case nla_parse() error, so it fixes it.

Br,

Tomasz Bursztyka (3):
  nfnetlink: Check callbacks before using those in nfnetlink_rcv_msg
  ipset: Handle properly an IPSET_CMD_NONE
  nfnetlink: Unlock a previously locked rcu_read in nfnetlink_rcv_msg

 net/netfilter/ipset/ip_set_core.c |   12 ++++++++++++
 net/netfilter/nfnetlink.c         |    8 ++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

-- 
1.7.8.6

