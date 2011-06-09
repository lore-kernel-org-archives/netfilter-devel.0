From: Jan Engelhardt <jengelh@medozas.de>
Subject: xt_ecn in smaller pieces
Date: Thu,  9 Jun 2011 22:23:52 +0200
Message-ID: <1307651037-20520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57113 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555Ab1FIUX7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 16:23:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Alternate xt_ecn history crafting, whereby the move of the code is explicit,
i.e. will show up in git log --stat -M as such.

===
The following changes since commit b08220bec4daa318a049182dc1cbd395873109cb:

>>>>>>
  netfilter: ipt_ecn: fix inversion for IP header ECN match (2011-06-09 15:20:26 +0200)
<<<<<<
(tacks onto your 2/3)

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
