From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: nf_tables: set timeout support
Date: Thu, 26 Mar 2015 12:39:35 +0000
Message-ID: <1427373580-19310-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58129 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbCZMjn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2015 08:39:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches add support for set timeouts. Sets can have a default
timeout value that can be overriden by element specific timeouts.

Removal of expired elements will usually be performed by a garbage
collector for two reasons: avoiding an excessive number of timers
and because data deinit has to happen in process context.

The first two patches add the required netlink attributes, parsing,
dump etc. A set of GC helper functions for batched RCU element
destruction is added in patch three, some synchronization helpers
to avoid races between async GC and netlink insertion and removal
of elements are added in patch four.

Following patches will use this infrastrucure to support set updates
from the packet classification path for dynamic sets and dynamic
flow state maintenance.

Please apply, thanks!


Patrick McHardy (5):
  netfilter: nf_tables: add set timeout API support
  netfilter: nf_tables: add set element timeout support
  netfilter: nf_tables: add set garbage collection helpers
  netfilter: nf_tables: add GC synchronization helpers
  netfilter: nft_hash: add support for timeouts

 include/net/netfilter/nf_tables.h        | 125 +++++++++++++++++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h |  10 +++
 net/netfilter/nf_tables_api.c            | 110 +++++++++++++++++++++++++--
 net/netfilter/nft_hash.c                 |  80 +++++++++++++++++++-
 4 files changed, 316 insertions(+), 9 deletions(-)

-- 
2.1.0

