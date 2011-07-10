From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables patches 20110710
Date: Sun, 10 Jul 2011 20:22:12 +0200
Message-ID: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58431 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1GJSWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 795ea2e8d4d9f01a606d0d7aac22572801e06989:

  Merge branch 'master' of git://dev.medozas.de/iptables (2011-07-05 15:16:05 +0200)

are available in the git repository at:

  git://dev.medozas.de/iptables master

Jan Engelhardt (6):
      libxtables: properly reject empty hostnames
      libxtables: ignore whitespace in the multiaddress argument parser
      option: remove last traces of intrapositional negation
      libxtables: set clone's initial data to NULL
      libxt_conntrack: restore network-byte order for v1,v2
      libxt_conntrack: move more data into the xt_option_entry

 extensions/libxt_SET.c       |    9 -----
 extensions/libxt_conntrack.c |   54 +++++++++++++++++++++++-------
 extensions/libxt_rateest.c   |   13 -------
 extensions/libxt_sctp.c      |    4 --
 extensions/libxt_set.c       |    4 --
 extensions/libxt_tcp.c       |    5 ---
 include/xtables.h.in         |    2 -
 iptables/ip6tables.c         |    5 ---
 iptables/iptables.c          |    5 ---
 iptables/xtables.c           |   76 +++++++++++++-----------------------------
 10 files changed, 65 insertions(+), 112 deletions(-)
