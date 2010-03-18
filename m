From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: struct optimization, print changes
Date: Thu, 18 Mar 2010 15:09:42 +0100
Message-ID: <1268921390-30296-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37310 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab0CROJy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:09:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

here is a small mixed bag. struct optimization, using the established
pr_ print functions. Please review.


The following changes since commit 115bc8f2874078e6ac78d88652a91b58447d5f4d:
  Jan Engelhardt (1):
        netfilter: xtables: resort osf kconfig text

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (7):
      netfilter: xtables: make use of caller family rather than match family
      netfilter: update documentation fields of x_tables.h
      netfilter: xtables: remove almost-unused xt_match_param.data member
      netfilter: xtables: reduce holes in struct xt_target
      netfilter: xtables: do not print any messages on ENOMEM
      netfilter: xtables: replace custom duprintf with pr_debug
      netfilter: xt extensions: use pr_<level>

 include/linux/netfilter/x_tables.h |   15 +++++++++------
 net/bridge/netfilter/ebt_ulog.c    |    7 ++-----
 net/ipv4/netfilter/ipt_ah.c        |   18 ++++++------------
 net/ipv6/netfilter/ip6t_hbh.c      |    9 ++++++---
 net/ipv6/netfilter/ip6t_mh.c       |   11 +++--------
 net/netfilter/x_tables.c           |   12 +++---------
 net/netfilter/xt_CONNSECMARK.c     |   13 ++++++-------
 net/netfilter/xt_DSCP.c            |    4 ++--
 net/netfilter/xt_HL.c              |   10 ++++------
 net/netfilter/xt_LED.c             |   14 +++++---------
 net/netfilter/xt_SECMARK.c         |   20 ++++++++++----------
 net/netfilter/xt_TCPMSS.c          |   18 +++++++++---------
 net/netfilter/xt_cluster.c         |   11 ++++++-----
 net/netfilter/xt_connbytes.c       |    5 +++--
 net/netfilter/xt_connlimit.c       |    5 +++--
 net/netfilter/xt_connmark.c        |    8 ++++----
 net/netfilter/xt_conntrack.c       |    6 +++---
 net/netfilter/xt_dscp.c            |    6 +++---
 net/netfilter/xt_esp.c             |   18 ++++++------------
 net/netfilter/xt_hashlimit.c       |   36 +++++++++++++++---------------------
 net/netfilter/xt_helper.c          |    6 +++---
 net/netfilter/xt_hl.c              |   12 ------------
 net/netfilter/xt_limit.c           |    6 +++---
 net/netfilter/xt_multiport.c       |   16 +++++-----------
 net/netfilter/xt_osf.c             |    8 ++++----
 net/netfilter/xt_physdev.c         |    8 ++++----
 net/netfilter/xt_policy.c          |   17 +++++++----------
 net/netfilter/xt_recent.c          |   12 ++++++------
 net/netfilter/xt_sctp.c            |   29 +++++++++++++----------------
 net/netfilter/xt_state.c           |    8 ++++----
 net/netfilter/xt_statistic.c       |    4 +---
 net/netfilter/xt_tcpudp.c          |   16 +++++-----------
 32 files changed, 163 insertions(+), 225 deletions(-)
