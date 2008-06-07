From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 38/50] netfilter: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state
Date: Fri, 06 Jun 2008 18:02:53 -0700
Message-ID: <20080607010627.675115155@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net,
	Dong Wei <dwei.zh@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sous-sol.org ([216.99.217.87]:42573 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760742AbYFGBJe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:34 -0400
Content-Disposition: inline; filename=netfilter-xt_connlimit-fix-accouning-when-receive-rst-packet-in-established-state.patch
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Patrick McHardy <kaber@trash.net>

upstream commit: d2ee3f2c4b1db1320c1efb4dcaceeaf6c7e6c2d3

In xt_connlimit match module, the counter of an IP is decreased when
the TCP packet is go through the chain with ip_conntrack state TW.
Well, it's very natural that the server and client close the socket
with FIN packet. But when the client/server close the socket with RST
packet(using so_linger), the counter for this connection still exsit.
The following patch can fix it which is based on linux-2.6.25.4

Signed-off-by: Dong Wei <dwei.zh@gmail.com>
Acked-by: Jan Engelhardt <jengelh@medozas.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 net/netfilter/xt_connlimit.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -75,7 +75,8 @@ static inline bool already_closed(const 
 	u_int16_t proto = conn->tuplehash[0].tuple.dst.protonum;
 
 	if (proto == IPPROTO_TCP)
-		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
+		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
+		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
 	else
 		return 0;
 }

-- 
