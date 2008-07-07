From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 00/13: netfilter update
Date: Mon,  7 Jul 2008 14:05:15 +0200 (MEST)
Message-ID: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58364 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbYGGMFR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:05:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

following is a small netfilter update for net-next-2.6, containing some
minor cleanups and typo fixes, the case insensitive search support for the
textsearch API and xtables string match from Joonwoo Park and some net-ns
fixes from Alexey Dobriyan.

Please apply, thanks.


 include/linux/netfilter/xt_string.h    |   15 +++++++++++-
 include/linux/netfilter_ipv6.h         |    4 +++
 include/linux/textsearch.h             |   13 +++++------
 include/net/netfilter/nf_conntrack.h   |    3 +-
 lib/textsearch.c                       |   14 ++++++-----
 lib/ts_bm.c                            |   26 ++++++++++++++++-----
 lib/ts_fsm.c                           |    6 ++++-
 lib/ts_kmp.c                           |   29 +++++++++++++++++------
 net/bridge/netfilter/Kconfig           |    2 +-
 net/ipv4/netfilter/Kconfig             |    3 +-
 net/ipv6/netfilter/ip6table_filter.c   |   31 ++++++++++++++++++-------
 net/ipv6/netfilter/ip6table_security.c |    6 ++--
 net/netfilter/Kconfig                  |    5 +--
 net/netfilter/nf_conntrack_core.c      |    7 +++--
 net/netfilter/nf_conntrack_netlink.c   |    2 +-
 net/netfilter/xt_string.c              |   38 ++++++++++++++++++++++++++++++-
 16 files changed, 150 insertions(+), 54 deletions(-)

Adrian Bunk (1):
      netfilter: cleanup netfilter_ipv6.h userspace header

Alexey Dobriyan (2):
      netfilter: use correct namespace in ip6table_security
      netfilter: ip6table_filter in netns for real

Joonwoo Park (7):
      textsearch: support for case insensitive searching
      textsearch: fix Boyer-Moore text search bug
      textsearch: ts_bm: support case insensitive searching in Boyer-Moore algorithm
      textsearch: ts_kmp: support case insensitive searching in Knuth-Morris-Pratt algorithm
      textsearch: ts_fsm: return error on request for case insensitive search
      textsearch: convert kmalloc + memset to kzalloc
      netfilter: fix string extension for case insensitive pattern matching

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: add allocation flag to nf_conntrack_alloc

Patrick McHardy (1):
      netfilter: ebt_nflog: fix Kconfig typo

Russ Dill (1):
      Get rid of refrences to no longer existant Fast NAT.
