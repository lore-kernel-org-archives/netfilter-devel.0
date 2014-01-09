From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 00/13] netfilter: nf_tables: bug fixes and minor cleanups
Date: Thu,  9 Jan 2014 18:42:30 +0000
Message-ID: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51675 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaAISnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:06 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches fix a couple of bugs related to chain types module
references, chain modification atomicity, chain type module loading
and unloading of modules that are still in use. Detailed descriptions
are in the individual changelogs.

The patches obviously also affect the current -rc, but I think its a bit
late in the release cycle for bigger fixes like this, so I based them
on your nftables.git tree.

Please apply, thanks.


Patrick McHardy (13):
      netfilter: nf_tables: split chain policy validation from actually setting it
      netfilter: nf_tables: restore chain change atomicity
      netfilter: nf_tables: fix check for table overflow
      netfilter: nf_tables: fix chain type module reference handling
      netfilter: nf_tables: add missing module references to chain types
      netfilter: nf_tables: replay request after dropping locks to load chain type
      netfilter: nf_tables: constify chain type definitions and pointers
      netfilter: nf_tables: minor nf_chain_type cleanups
      netfilter: nf_tables: perform flags validation before table allocation
      netfilter: nf_tables: take AF module reference when creating a table
      netfilter: nf_tables: prohibit deletion of a table with existing sets
      netfilter: nf_tables: unininline nft_trace_packet()
      netfilter: nf_tables: rename nft_do_chain_pktinfo() to nft_do_chain()


 include/net/netfilter/nf_tables.h         |  32 +++--
 net/bridge/netfilter/nf_tables_bridge.c   |   7 +-
 net/ipv4/netfilter/nf_tables_arp.c        |   7 +-
 net/ipv4/netfilter/nf_tables_ipv4.c       |   7 +-
 net/ipv4/netfilter/nft_chain_nat_ipv4.c   |  10 +-
 net/ipv4/netfilter/nft_chain_route_ipv4.c |  10 +-
 net/ipv6/netfilter/nf_tables_ipv6.c       |   7 +-
 net/ipv6/netfilter/nft_chain_nat_ipv6.c   |  10 +-
 net/ipv6/netfilter/nft_chain_route_ipv6.c |  10 +-
 net/netfilter/nf_tables_api.c             | 192 ++++++++++++++----------------
 net/netfilter/nf_tables_core.c            |  10 +-
 net/netfilter/nf_tables_inet.c            |   5 +-
 12 files changed, 157 insertions(+), 150 deletions(-)

