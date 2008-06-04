From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: xt_connlimit: fix accouning when receive RST packet
 in ESTABLISHED state
Date: Wed, 04 Jun 2008 18:17:52 +0200
Message-ID: <4846C030.6080707@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020605000908090201040203"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45685 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbYFDQRz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:17:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020605000908090201040203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two netfilter fixes for 2.6.26, fixing connection
accounting of closed connections in the iptables connlimit module
and inconsistent locking in IPv6 conntrack defragmentation.

I'll also send both patches to -stable.


--------------020605000908090201040203
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: xt_connlimit: fix accouning when receive RST packet in ESTABLISHED state

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
commit df31d38473b31c8c18449419fbe9af219f3579f3
tree 93b5d2ee26d6531053453d28007ec42b056a9fde
parent 3446b9d57edd0b96a89715fef222879e4919a115
author Dong Wei <dwei.zh@gmail.com> Mon, 02 Jun 2008 16:47:27 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Jun 2008 16:47:27 +0200

 net/netfilter/xt_connlimit.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 2e89a00..70907f6 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -73,7 +73,8 @@ connlimit_iphash6(const union nf_inet_addr *addr,
 static inline bool already_closed(const struct nf_conn *conn)
 {
 	if (nf_ct_protonum(conn) == IPPROTO_TCP)
-		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT;
+		return conn->proto.tcp.state == TCP_CONNTRACK_TIME_WAIT ||
+		       conn->proto.tcp.state == TCP_CONNTRACK_CLOSE;
 	else
 		return 0;
 }

--------------020605000908090201040203--
