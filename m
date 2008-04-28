From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Tue, 29 Apr 2008 00:06:40 +0200 (MEST)
Message-ID: <20080428220643.18270.24909.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33383 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbYD1WGm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:06:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these three patches fix (again) skb_over_panic caused by netfilter queueing,
a namespace leak when reading /proc/net/xxx_tables_names and incorrect error
handling in the TCPOPTSTRIP target.

Please apply, thanks.


 net/ipv4/netfilter/ip_queue.c   |    5 ++---
 net/ipv6/netfilter/ip6_queue.c  |    5 ++---
 net/netfilter/nfnetlink_queue.c |    5 ++---
 net/netfilter/x_tables.c        |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c  |    2 +-
 5 files changed, 8 insertions(+), 11 deletions(-)

Arnaud Ebalard (1):
      [NETFILTER]: {nfnetlink,ip,ip6}_queue: fix skb_over_panic when enlarging packets

Pavel Emelyanov (1):
      [NETFILTER]: x_tables: fix net namespace leak when reading /proc/net/xxx_tables_names

Roel Kluin (1):
      [NETFILTER]: xt_TCPOPTSTRIP: signed tcphoff for	ipv6_skip_exthdr() retval
