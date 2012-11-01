From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nf-next/nf_tables-experiments - v2 PATCH 0/4] fixed chain name, chain rename and rule replacement
Date: Thu,  1 Nov 2012 13:38:29 +0200
Message-ID: <1351769913-5851-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53694 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932187Ab2KALih (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:38:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here a second version of the previous patchset, now taking care of chain's name issue. The name is fixed,
same size as in iptables.

About an alternative, it could be possible to store a variable chain name in a separate allocated memory,
kept in hash table: not the chain object itself, just the name. The key would be the chain's object pointer.
At least, from execution point of view it would not affect anything since the name is necessary only for
the user. The only issue is the memory occupied by such hash table.

I was looking quickly at the linux helpers, could not find a hashtable/map api, is there any? If so, I could
try this idea of names stored like that.

Tomasz Bursztyka (4):
  nf_tables: Change chain's name to be fixed sized
  nf_tables: Add missing policy for NFTA_CHAIN_USE
  nf_tables: Add support for changing users chain's name
  nf_tables: Add support for replacing a rule by another one.

 include/linux/netfilter/nf_tables.h |  3 ++
 include/net/netfilter/nf_tables.h   |  2 +-
 net/netfilter/nf_tables_api.c       | 87 +++++++++++++++++++++++++++++++------
 3 files changed, 77 insertions(+), 15 deletions(-)

-- 
1.7.12.4

