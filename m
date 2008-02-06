From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter fixes
Date: Wed,  6 Feb 2008 14:33:59 +0100 (MET)
Message-ID: <20080206133359.15303.62098.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54112 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761925AbYBFNeB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 08:34:01 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

These patches fix a couple of bugs in netfilter: a bug in ct_extend,
causing invalid memory accesses when DNATing a connection to a port
using a connection tracking helper, the TCP connection reopening bug,
causing slowdowns by dropping connection reopening attempts, and
a typo and missing #include in xt_iprange.

Please apply, thanks.


 include/net/netfilter/nf_conntrack_extend.h |    2 +-
 net/ipv4/netfilter/nf_nat_core.c            |    6 ++--
 net/netfilter/nf_conntrack_extend.c         |    3 +-
 net/netfilter/nf_conntrack_proto_tcp.c      |   32 +++++++++++++++++++++-----
 net/netfilter/xt_iprange.c                  |    3 +-
 5 files changed, 34 insertions(+), 12 deletions(-)

Jan Engelhardt (1):
      [NETFILTER]: xt_iprange: add missing #include

Jozsef Kadlecsik (1):
      [NETFILTER]: nf_conntrack: TCP conntrack reopening fix

Patrick McHardy (2):
      [NETFILTER]: nf_conntrack: fix ct_extend ->move operation
      [NETFILTER]: xt_iprange: fix typo in address family
