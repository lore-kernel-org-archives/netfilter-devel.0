From: Daniel Mack <daniel@zonque.org>
Subject: [PATCH nf-next 0/3] netfilter: socket lookup function refactoring, cgroup match fixes
Date: Wed, 17 Jun 2015 02:08:09 +0200
Message-ID: <1434499692-9832-1-git-send-email-daniel@zonque.org>
Cc: fw@strlen.de, daniel@iogearbox.net, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org, Daniel Mack <daniel@zonque.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:39580 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbbFQARc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 20:17:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series is based on work done by Daniel Borkmann a little while ago:

  http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/56877

I addressed the feedback from that thread and factored out the socket
lookup code into own modules, one for ipv4, one for ipv6. These modules
are now selected in kbuild by code that uses it.

Also, a patch was added to fix nft_meta cgroup match rules in a similar
fashion as it's now done for xt_cgroup.

Feedback welcome!

Thanks,
Daniel


Daniel Borkmann (1):
  netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN sk lookups

Daniel Mack (2):
  netfilter: factor out helpers from xt_socket into separate modules
  netfilter: nft_meta: fix cgroup socket lookups

 include/linux/netfilter_ipv4.h    |   6 +
 include/linux/netfilter_ipv6.h    |   5 +
 net/ipv4/netfilter/Makefile       |   3 +
 net/ipv4/netfilter/nf_sock_ipv4.c | 169 +++++++++++++++++++++++
 net/ipv6/netfilter/Makefile       |   3 +
 net/ipv6/netfilter/nf_sock_ipv6.c | 152 +++++++++++++++++++++
 net/netfilter/Kconfig             |  12 ++
 net/netfilter/nft_meta.c          |  35 ++++-
 net/netfilter/xt_cgroup.c         |  95 ++++++++++---
 net/netfilter/xt_socket.c         | 278 ++------------------------------------
 10 files changed, 467 insertions(+), 291 deletions(-)
 create mode 100644 net/ipv4/netfilter/nf_sock_ipv4.c
 create mode 100644 net/ipv6/netfilter/nf_sock_ipv6.c

-- 
2.4.0

