From: Jan Engelhardt <jengelh@medozas.de>
Subject: Xtables cleanup patches
Date: Tue,  3 Nov 2009 19:04:36 +0100
Message-ID: <1257271483-26772-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43219 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZKCSEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:04:39 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



I am posting here already the next round of pullable patches
(that I originally wanted to get in _much_ faster) for review.

This block is mostly cleanups, simplifications. It might be worth
testing these together with the previous set if there are concerns
about speed.

-----
The following changes since commit 7891b6c280d01d52be5ecefe0db79d4b1f671a1e:
  Jan Engelhardt (1):
        netfilter: xtables: generate initial table on-demand

are available in the git repository at:

  git://dev.medozas.de/linux next

Jan Engelhardt (6):
      netfilter: iptables: remove unused function arguments
      netfilter: reduce NF_HOOK by one argument
      netfilter: get rid of the grossness in netfilter.h
      netfilter: xtables: print details on size mismatch
      netfilter: xtables: constify args in compat copying functions
      netfilter: xtables: add const qualifiers

 include/linux/netfilter.h            |   55 +++++++++++---------
 include/linux/netfilter/x_tables.h   |   12 ++--
 net/bridge/netfilter/ebtables.c      |   56 +++++++++++---------
 net/ipv4/netfilter/arp_tables.c      |   73 +++++++++++++++------------
 net/ipv4/netfilter/ip_tables.c       |   92 +++++++++++++++++++---------------
 net/ipv4/netfilter/ipt_ULOG.c        |    4 +-
 net/ipv4/netfilter/iptable_mangle.c  |   10 +---
 net/ipv6/netfilter/ip6_tables.c      |   92 ++++++++++++++++++---------------
 net/ipv6/netfilter/ip6table_mangle.c |   10 +---
 net/netfilter/x_tables.c             |   16 ++++--
 net/netfilter/xt_hashlimit.c         |    4 +-
 net/netfilter/xt_limit.c             |    4 +-
 12 files changed, 232 insertions(+), 196 deletions(-)
