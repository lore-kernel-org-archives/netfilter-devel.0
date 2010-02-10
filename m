From: Jan Engelhardt <jengelh@medozas.de>
Subject: Code cleanups
Date: Wed, 10 Feb 2010 18:39:00 +0100
Message-ID: <1265823547-10358-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57293 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab0BJRjO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:39:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


the next patch pack is mostly about cleanups, and there is one
commit for improving debug a little.
Pull URL will be posted once the previous request has been
merged, but I am already posting them now for review.



The following changes since commit e3eaa9910b380530cfd2c0670fcd3f627674da8a:
  Jan Engelhardt (1):
        netfilter: xtables: generate initial table on-demand

are available in the git repository at:

  . master2

Jan Engelhardt (6):
      netfilter: iptables: remove unused function arguments
      netfilter: reduce NF_HOOK by one argument
      netfilter: get rid of the grossness in netfilter.h
      netfilter: xtables: print details on size mismatch
      netfilter: xtables: constify args in compat copying functions
      netfilter: xtables: add const qualifiers

 include/linux/netfilter.h            |   55 +++++++++++---------
 include/linux/netfilter/x_tables.h   |   12 ++--
 net/bridge/netfilter/ebtables.c      |   59 ++++++++++++----------
 net/ipv4/netfilter/arp_tables.c      |   73 +++++++++++++++------------
 net/ipv4/netfilter/ip_tables.c       |   92 +++++++++++++++++++---------------
 net/ipv4/netfilter/ipt_ULOG.c        |    4 +-
 net/ipv4/netfilter/iptable_mangle.c  |   10 +---
 net/ipv6/netfilter/ip6_tables.c      |   92 ++++++++++++++++++---------------
 net/ipv6/netfilter/ip6table_mangle.c |   10 +---
 net/netfilter/x_tables.c             |   16 ++++--
 net/netfilter/xt_hashlimit.c         |    4 +-
 net/netfilter/xt_limit.c             |    4 +-
 12 files changed, 233 insertions(+), 198 deletions(-)
