From: Jan Engelhardt <jengelh@inai.de>
Subject: Combine two modules
Date: Fri, 14 Sep 2012 03:40:30 +0200
Message-ID: <1347586832-6190-1-git-send-email-jengelh@inai.de>
Cc: davem@davemloft.net, kaber@trash.net,
	netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:46549 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2INBkl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Sep 2012 21:40:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


please review, and if ok merge, this small set of two patches to the
new IPv6 NAT that recently gone in.

thanks,
Jan
===
The following changes since commit b0e61d98c672a9216d72d2d7430f6dc60795002e:

  Merge branch 'master' of git://1984.lsi.us.es/nf-next (2012-09-13 14:24:31 -0400)

are available in the git repository at:


  git://git.inai.de/linux master

for you to fetch changes up to 653e421b28fbf11842c60f9751d9589e95fbbca3:

  net: netfilter: combine ipt_REDIRECT and ip6t_REDIRECT (2012-09-14 02:33:48 +0200)

----------------------------------------------------------------
Jan Engelhardt (2):
      net: netfilter: combine ipt_NETMAP and ip6t_NETMAP
      net: netfilter: combine ipt_REDIRECT and ip6t_REDIRECT

 net/ipv4/netfilter/Kconfig         |   23 ++---
 net/ipv4/netfilter/Makefile        |    2 -
 net/ipv4/netfilter/ipt_NETMAP.c    |  101 -------------------
 net/ipv6/netfilter/Kconfig         |   21 ----
 net/ipv6/netfilter/Makefile        |    2 -
 net/ipv6/netfilter/ip6t_NETMAP.c   |   94 ------------------
 net/ipv6/netfilter/ip6t_REDIRECT.c |   98 -------------------
 net/netfilter/Kconfig              |   21 ++++
 net/netfilter/Makefile             |    2 +
 net/netfilter/xt_NETMAP.c          |  165 +++++++++++++++++++++++++++++++
 net/netfilter/xt_REDIRECT.c        |  190 ++++++++++++++++++++++++++++++++++++
 11 files changed, 388 insertions(+), 331 deletions(-)
 delete mode 100644 net/ipv4/netfilter/ipt_NETMAP.c
 delete mode 100644 net/ipv6/netfilter/ip6t_NETMAP.c
 delete mode 100644 net/ipv6/netfilter/ip6t_REDIRECT.c
 create mode 100644 net/netfilter/xt_NETMAP.c
 create mode 100644 net/netfilter/xt_REDIRECT.c
