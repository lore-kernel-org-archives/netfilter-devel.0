From: Jiri Moravec <jim.lkml@gmail.com>
Subject: [PATCH] xtables-addons: Missing reference operator in xt_ECHO.c (for
 Jan Engelhardt)
Date: Fri, 19 Sep 2008 22:28:37 +0200
Message-ID: <48D40B75.2030407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.iwebs.cz ([78.156.136.15]:52058 "EHLO smtp2.iwebs.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbYISVBH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:01:07 -0400
Received: from [192.168.1.16] (unknown [78.156.136.66])
	by smtp2.iwebs.cz (Postfix) with ESMTP id 28FD344A153
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Sep 2008 15:28:27 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan,
when you prepared commit ab27472eb44b0690f74d542ddb9a972460eceb9a, you =
probably overlooked some piece of code, because my gcc objects:
"2.6.26.5-t4/net/netfilter/xtables-addons/xt_ECHO.c:90: warning: passin=
g argument 1 of =E2=80=98xtnu_ip_route_me_harder=E2=80=99 from incompat=
ible pointer type"

diff -Nupr old/extensions/xt_ECHO.c new/extensions/xt_ECHO.c
--- old/extensions/xt_ECHO.c	2008-09-19 19:04:37.000000000 +0200
+++ new/extensions/xt_ECHO.c	2008-09-19 19:05:00.000000000 +0200
@@ -87,7 +87,7 @@ static unsigned int echo_tg4(struct sk_b
 	dst_hold(oldskb->dst);
 	newskb->dst =3D oldskb->dst;
=20
-	if (ip_route_me_harder(newskb, addr_type) < 0)
+	if (ip_route_me_harder(&newskb, addr_type) < 0)
 		goto free_nskb;
=20
 	newip->ttl        =3D dst_metric(newskb->dst, RTAX_HOPLIMIT);
--



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
