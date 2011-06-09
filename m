From: kaber@trash.net
Subject: [PATCH 0/3] netfilter: ecn match fixes and IPv6 capable xtables port
Date: Thu,  9 Jun 2011 14:12:31 +0200
Message-ID: <1307621554-19108-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: eric.dumazet@gmail.com, dave.taht@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37833 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab1FIMMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:12:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches contain two fixes for the ipt_ecn match and an IPv6 capable
xtables port. Nothing particulary exciting in the patches, if noone spots
any problems I'll push the first two patches to net-2.6 and the third one
to net-next-2.6.

iptables patch will follow shortly.

Patrick McHardy (3):
      netfilter: ipt_ecn: fix protocol check in ecn_mt_check()
      netfilter: ipt_ecn: fix inversion for IP header ECN match
      netfilter: xtables: add an IPv6 capable version of the ECN match

 include/linux/netfilter/Kbuild   |    1 +
 include/linux/netfilter/xt_ecn.h |   33 +++++++
 net/ipv4/netfilter/Kconfig       |    9 --
 net/ipv4/netfilter/Makefile      |    1 -
 net/ipv4/netfilter/ipt_ecn.c     |  128 --------------------------
 net/netfilter/Kconfig            |    9 ++
 net/netfilter/Makefile           |    1 +
 net/netfilter/xt_ecn.c           |  187 ++++++++++++++++++++++++++++++++++++++
 8 files changed, 231 insertions(+), 138 deletions(-)
 create mode 100644 include/linux/netfilter/xt_ecn.h
 delete mode 100644 net/ipv4/netfilter/ipt_ecn.c
 create mode 100644 net/netfilter/xt_ecn.c

