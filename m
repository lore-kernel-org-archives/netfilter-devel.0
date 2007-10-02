From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 03/13] Allow binding to non-local addresses if IP_TRANSPARENT
	is set
Date: Tue, 02 Oct 2007 22:41:15 +0200
Message-ID: <20071002204115.11052.26660.stgit@nessa.odu>
References: <20071002203942.11052.7303.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:51315 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818AbXJBUlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:41:17 -0400
Received: from nessa.odu ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JPA00722XE6QH80@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 22:39:43 +0200 (CEST)
In-reply-to: <20071002203942.11052.7303.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Setting IP_TRANSPARENT is not really useful without allowing non-local
binds for the socket. To make user-space code simpler we allow these bi=
nds
even if IP_TRANSPARENT is set but IP_FREEBIND is not.

Signed-off-by: T=C3=B3th L=C3=A1szl=C3=B3 Attila <panther@balabit.hu>
Acked-by: Patrick McHardy <kaber@trash.net>
---

 net/ipv4/af_inet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index e681034..90344db 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -448,7 +448,7 @@ int inet_bind(struct socket *sock, struct sockaddr =
*uaddr, int addr_len)
 	 */
 	err =3D -EADDRNOTAVAIL;
 	if (!sysctl_ip_nonlocal_bind &&
-	    !inet->freebind &&
+	    !(inet->freebind || inet->transparent) &&
 	    addr->sin_addr.s_addr !=3D INADDR_ANY &&
 	    chk_addr_ret !=3D RTN_LOCAL &&
 	    chk_addr_ret !=3D RTN_MULTICAST &&

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
