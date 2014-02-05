From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: nf_tables fixes
Date: Wed,  5 Feb 2014 15:03:34 +0000
Message-ID: <1391612619-30347-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57601 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaBEPDw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 10:03:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches fix a couple of bugs in nf_tables:

- potential NULL pointer dereference when dumping sets
- missing NFT_CT_L3PROTOCOL key in ct expression validation
- the module dependency issues we've discussed

Please note, the last patch is *not* a new feature but part of the
fix since NFPROTO_INET was previously also handled by nft_reject.
I just put it into a seperate patch for easier review.

Please apply, thanks.


Patrick McHardy (5):
      netfilter: nf_tables: fix potential oops when dumping sets
      netfilter: nft_ct: fix missing NFT_CT_L3PROTOCOL key in validity checks
      netfilter: nf_tables: add AF specific expression support
      netfilter: nft_reject: split up reject module into IPv4 and IPv6 specifc parts
      netfilter: nf_tables: add reject module for NFPROTO_INET


 include/net/netfilter/nf_tables.h    |  5 ++
 net/ipv4/netfilter/Kconfig           |  5 ++
 net/ipv4/netfilter/Makefile          |  1 +
 net/ipv4/netfilter/nft_reject_ipv4.c | 75 ++++++++++++++++++++++++++++++
 net/ipv6/netfilter/Kconfig           |  5 ++
 net/ipv6/netfilter/Makefile          |  1 +
 net/ipv6/netfilter/nft_reject_ipv6.c | 76 ++++++++++++++++++++++++++++++
 net/netfilter/Kconfig                |  6 ++-
 net/netfilter/Makefile               |  1 +
 net/netfilter/nf_tables_api.c        | 30 ++++++++----
 net/netfilter/nft_ct.c               |  1 +
 net/netfilter/nft_reject.c           | 89 ++++--------------------------------
 net/netfilter/nft_reject_inet.c      | 63 +++++++++++++++++++++++++
 13 files changed, 268 insertions(+), 90 deletions(-)
