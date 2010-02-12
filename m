From: Jan Engelhardt <jengelh@medozas.de>
Subject: ip_tables: foreachs and reentrancy
Date: Fri, 12 Feb 2010 11:20:37 +0100
Message-ID: <1265970044-19518-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51355 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0BLKUs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 05:20:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


the next patch group following the previous cleanups is this one.

The macros were really ugly (you could not easily tell where the
argument list that was passed to the real function started), so
I took the freedom to remodel these based upon the excellent ideas
from linux/list.h. It seems to have turned out well, there is much
less argument passing.

The reentrancy patch title should speak for itself.


The following changes since commit 05c7a108fdbd2ebbc357a78597646c111f8ebc62:
  Jan Engelhardt (1):
        netfilter: xtables: add const qualifiers

are available in the git repository at:

  git://dev.medozas.de/linux master-d30b8f5

Jan Engelhardt (6):
      netfilter: xtables: replace XT_ENTRY_ITERATE macro
      netfilter: xtables: optimize call flow around xt_entry_foreach
      netfilter: xtables: replace XT_MATCH_ITERATE macro
      netfilter: xtables: optimize call flow around xt_ematch_foreach
      netfilter: xtables: reduce arguments to translate_table
      netfilter: xtables2: make ip_tables reentrant

 include/linux/netfilter/x_tables.h        |   24 ++
 include/linux/netfilter_arp/arp_tables.h  |   10 +-
 include/linux/netfilter_ipv4/ip_tables.h  |   15 +-
 include/linux/netfilter_ipv6/ip6_tables.h |   14 +-
 net/ipv4/netfilter/arp_tables.c           |  307 ++++++++----------
 net/ipv4/netfilter/ip_tables.c            |  501 ++++++++++++++---------------
 net/ipv6/netfilter/ip6_tables.c           |  492 ++++++++++++++---------------
 net/netfilter/x_tables.c                  |   79 +++++
 net/netfilter/xt_TCPMSS.c                 |   12 +-
 9 files changed, 741 insertions(+), 713 deletions(-)
