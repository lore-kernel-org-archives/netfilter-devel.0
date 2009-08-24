From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 09/13] TProxy: allow non-local binds of IPv6 sockets if
 IP_TRANSPARENT is enabled
Date: Mon, 24 Aug 2009 14:48:28 +0200
Message-ID: <1253548005.12519.9.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
---
 net/ipv6/af_inet6.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index caa0278..5fa0f44 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -338,7 +338,7 @@ int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 			 */
 			v4addr = LOOPBACK4_IPV6;
 			if (!(addr_type & IPV6_ADDR_MULTICAST))	{
-				if (!ipv6_chk_addr(net, &addr->sin6_addr,
+				if (!inet->transparent && !ipv6_chk_addr(net, &addr->sin6_addr,
 						   dev, 0)) {
 					if (dev)
 						dev_put(dev);
-- 
1.6.0.4

