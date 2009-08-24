From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 08/11] TProxy: allow non-local binds of IPv6 sockets if
 IP_TRANSPARENT is enabled
Date: Mon, 24 Aug 2009 14:48:28 +0200
Message-ID: <5971220e58c9ae7f2477d0a45462ee658fca103d.1251295408.git.bazsi@balabit.hu>
References: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58548 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751977AbZH2Pu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:27 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id DAFA113A227
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:39 +0200 (CEST)
In-Reply-To: <cover.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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


