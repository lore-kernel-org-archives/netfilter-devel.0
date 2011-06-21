From: Jan Engelhardt <jengelh@medozas.de>
Subject: Pending fixes, global var reduction
Date: Tue, 21 Jun 2011 17:53:27 +0200
Message-ID: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40638 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab1FUPxi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 3b7a22b44d74b9b05d5e4b0529ebf72c49dcbff5:

  doc: document IPv6 TOS mangling bug in old Linux kernels (2011-06-17 05:46:22 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (7):
      doc: include matches/targets in manpage again
      libipt_LOG: fix ignoring all but last flags
      libxt_RATEEST: use guided option parser
      iptables: consolidate target/match init call
      extensions: support for per-extension instance "global" variable space
      libxt_rateest: abolish global variables
      libxt_RATEEST: abolish global variables

 extensions/libip6t_LOG.c   |   10 ++--
 extensions/libipt_LOG.c    |   10 ++--
 extensions/libxt_RATEEST.c |  107 ++++++++++++++++----------------------------
 extensions/libxt_rateest.c |   12 +----
 include/xtables.h.in       |   18 ++++++-
 iptables/Makefile.am       |    4 +-
 iptables/ip6tables.c       |    9 +---
 iptables/iptables.c        |   10 ++---
 iptables/xshared.c         |   33 +++++++++++++-
 iptables/xshared.h         |    2 +
 iptables/xtoptions.c       |    4 ++
 tests/options-most.rules   |    2 +
 12 files changed, 115 insertions(+), 106 deletions(-)
