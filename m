From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [net-next PATCH 05/16] Conditionally enable transparent flow flag	when
 connecting
Date: Wed, 01 Oct 2008 16:24:31 +0200
Message-ID: <20081001142431.4893.36455.stgit@este>
References: <20081001142431.4893.48078.stgit@este>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:53158 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135AbYJAPZa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Oct 2008 11:25:30 -0400
In-reply-to: <20081001142431.4893.48078.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set FLOWI_FLAG_ANYSRC in flowi->flags if the socket has the
transparent socket option set. This way we selectively enable certain
connections with non-local source addresses to be routed.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/net/route.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 31d1485..4e8cae0 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -27,7 +27,7 @@
 #include <net/dst.h>
 #include <net/inetpeer.h>
 #include <net/flow.h>
-#include <net/sock.h>
+#include <net/inet_sock.h>
 #include <linux/in_route.h>
 #include <linux/rtnetlink.h>
 #include <linux/route.h>
@@ -161,6 +161,10 @@ static inline int ip_route_connect(struct rtable **rp, __be32 dst,
 
 	int err;
 	struct net *net = sock_net(sk);
+
+	if (inet_sk(sk)->transparent)
+		fl.flags |= FLOWI_FLAG_ANYSRC;
+
 	if (!dst || !src) {
 		err = __ip_route_output_key(net, rp, &fl);
 		if (err)


