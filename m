From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/7] netfilter: ebtables: CONFIG_COMPAT support
Date: Fri,  5 Feb 2010 02:43:08 +0100
Message-ID: <1265334195-28120-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59372 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756606Ab0BEBoK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:44:10 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello netfilter team,

following patch series adds CONFIG_COMPAT
support to ebtables (unfortunately tested on x86_64 only).

First patches are minor bug fixes/preparation patches,
patch 5 is the main CONFIG_COMPAT hunk, 6 and 7 add CONFIG_COMPAT
support to the targets/matches that need special handling (maybe
I missed some, though).

 include/linux/netfilter/x_tables.h  |    2 +-
 net/bridge/netfilter/ebt_802_3.c    |    2 +-
 net/bridge/netfilter/ebt_arp.c      |    2 +-
 net/bridge/netfilter/ebt_arpreply.c |    2 +-
 net/bridge/netfilter/ebt_dnat.c     |    2 +-
 net/bridge/netfilter/ebt_ip.c       |    2 +-
 net/bridge/netfilter/ebt_ip6.c      |    2 +-
 net/bridge/netfilter/ebt_limit.c    |   18 +-
 net/bridge/netfilter/ebt_log.c      |    2 +-
 net/bridge/netfilter/ebt_mark.c     |   33 +-
 net/bridge/netfilter/ebt_mark_m.c   |   39 ++-
 net/bridge/netfilter/ebt_nflog.c    |    2 +-
 net/bridge/netfilter/ebt_pkttype.c  |    2 +-
 net/bridge/netfilter/ebt_redirect.c |    2 +-
 net/bridge/netfilter/ebt_snat.c     |    2 +-
 net/bridge/netfilter/ebt_stp.c      |    2 +-
 net/bridge/netfilter/ebt_ulog.c     |    2 +-
 net/bridge/netfilter/ebt_vlan.c     |    2 +-
 net/bridge/netfilter/ebtables.c     | 1064 ++++++++++++++++++++++++++++++++---
 net/netfilter/x_tables.c            |    6 +-

Florian Westphal (7):
      netfilter: ebtables: abort if next_offset is too small
      netfilter: ebtables: avoid explicit XT_ALIGN() in match/targets
      netfilter: CONFIG_COMPAT: allow delta to exceed 32767
      netfilter: ebtables: split do_replace into two functions
      netfilter: ebtables: add CONFIG_COMPAT support
      netfilter: ebt_limit: add CONFIG_COMPAT support
      netfilter: ebtables: mark: add CONFIG_COMPAT support
