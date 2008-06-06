From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 02/03: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state
Date: Fri,  6 Jun 2008 19:18:43 +0200 (MEST)
Message-ID: <20080606171841.28097.93005.sendpatchset@localhost.localdomain>
References: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	davem@davemloft.net
To: stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51321 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbYFFRSo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:18:44 -0400
In-Reply-To: <20080606171839.28097.47793.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state

Upstream commit d2ee3f2c4b1db1320c1efb4dcaceeaf6c7e6c2d3:

In xt_connlimit match module, the counter of an IP is decreased when
the TCP packet is go through the chain with ip_conntrack state TW.
Well, it's very natural that the server and client close the socket
with FIN packet. But when the client/server close the socket with RST
packet(using so_linger), the counter for this connection still exsit.
The following patch can fix it which is based on linux-2.6.25.4

Signed-off-by: Dong Wei <dwei.zh@gmail.com>
Acked-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 8a39ae5d24374801df08b7aa634ca03080e6b72a
tree 66e43bc28fbc61a0f8a39ca848dfe19d20eb930f
parent d025d91021895314ce10cc0ab8e0f627dc1a12fa
author Dong Wei <dwei.zh@gmail.com> Fri, 06 Jun 2008 19:07:37 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 06 Jun 2008 19:07:37 +0200

 net/netfilter/xt_connlimit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 3b01119..1692338 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -75,7 +75,8 @@ static inline bool already_closed(const struct nf_conn *conn)
 	u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
 
 	if (proto == IPPROTO_TCP)
-		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
+		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
+		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
 	else
 		return 0;
 }
