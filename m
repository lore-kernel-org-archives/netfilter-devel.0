From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4] netfilter: nf_tables: dynamic set updates
Date: Sun,  5 Apr 2015 14:41:04 +0200
Message-ID: <1428237668-31789-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57770 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbDEMlL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 08:41:11 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches contain a small bug fix for set selection with
timeouts, as well as support for dynamic set updates.

A new "dynset" expression type is added to dynamically add or update
set elements. The name is not my first choice, however due to clashes
with the regular set attributes simply "set" wasn't possible.
Userspace exposes this in a nicer fashion.

As preparation, set size accounting is changed to use an atomic_t
for the number of elements to avoid races, additionally set bindings
are changed to not assume every binding is related to a lookup or map
operation.

Please apply, thanks!


Patrick McHardy (4):
  netfilter: nf_tables: fix set selection when timeouts are requested
  netfilter: nf_tables: prepare set element accounting for async updates
  netfilter: nf_tables: support different set binding types
  netfilter: nf_tables: add support for dynamic set updates

 include/net/netfilter/nf_tables.h        |  23 +++-
 include/net/netfilter/nf_tables_core.h   |   3 +
 include/uapi/linux/netfilter/nf_tables.h |  27 ++++
 net/netfilter/Makefile                   |   2 +-
 net/netfilter/nf_tables_api.c            |  44 ++++---
 net/netfilter/nf_tables_core.c           |   7 +
 net/netfilter/nft_dynset.c               | 218 +++++++++++++++++++++++++++++++
 net/netfilter/nft_hash.c                 |  40 +++++-
 net/netfilter/nft_lookup.c               |   2 +
 9 files changed, 345 insertions(+), 21 deletions(-)
 create mode 100644 net/netfilter/nft_dynset.c

-- 
2.1.0

