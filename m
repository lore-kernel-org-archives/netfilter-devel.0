From: Jan Engelhardt <jengelh@medozas.de>
Subject: xt_ecn, with descriptions
Date: Tue, 27 Dec 2011 19:57:48 +0100
Message-ID: <1325012273-11779-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:35710 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385Ab1L0S5z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 13:57:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit c5e1fd8ccae09f574d6f978c90c2b968ee29030c:

  Merge branch 'nf-next' of git://1984.lsi.us.es/net-next (2011-12-25 02:21:45 -0500)

are available in the git repository at:

  git://dev.medozas.de/linux xtecn

Jan Engelhardt (3):
      netfilter: xtables: move ipt_ecn to xt_ecn
      netfilter: xtables: give xt_ecn its own name
      netfilter: xtables: collapse conditions in xt_ecn

Patrick McHardy (1):
      netfilter: xtables: add an IPv6 capable version of the ECN match

 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_ecn.h       |   35 ++++++
 include/linux/netfilter_ipv4/ipt_ecn.h |   38 ++-----
 net/ipv4/netfilter/Kconfig             |   10 +-
 net/ipv4/netfilter/Makefile            |    1 -
 net/ipv4/netfilter/ipt_ecn.c           |  127 ----------------------
 net/netfilter/Kconfig                  |    9 ++
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_ecn.c                 |  179 ++++++++++++++++++++++++++++++++
 9 files changed, 239 insertions(+), 162 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ecn.h
 delete mode 100644 net/ipv4/netfilter/ipt_ecn.c
 create mode 100644 net/netfilter/xt_ecn.c
