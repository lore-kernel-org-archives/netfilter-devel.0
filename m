From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: nf_tables: restore context during destruction
Date: Fri,  7 Mar 2014 19:08:28 +0100
Message-ID: <1394215713-32049-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39698 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbaCGSIf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:08:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches restore the context during expression destruction
in order to restore notifications for anonmyous set destruction and get
rid of some unnecessary members in the expressions' private structures.

Additionally they contain a couple of related minor cleanups.

Please apply.


Patrick McHardy (5):
      netfilter: nf_tables: clean up nf_tables_trans_add() argument order
      netfilter: nf_tables: restore context for expression destructors
      netfilter: nf_tables: restore notifications for anonymous set destruction
      netfilter: nft_ct: remove family from struct nft_ct
      netfilter: nft_nat: fix family validation

 include/net/netfilter/nf_tables.h | 13 ++++-------
 net/netfilter/nf_tables_api.c     | 45 +++++++++++++++++++--------------------
 net/netfilter/nft_compat.c        |  4 ++--
 net/netfilter/nft_ct.c            | 12 ++++-------
 net/netfilter/nft_immediate.c     |  3 ++-
 net/netfilter/nft_log.c           |  3 ++-
 net/netfilter/nft_lookup.c        |  5 +++--
 net/netfilter/nft_nat.c           | 22 +++++++++----------
 8 files changed, 49 insertions(+), 58 deletions(-)

