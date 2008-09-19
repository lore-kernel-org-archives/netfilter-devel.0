From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xtables-addons: Missing reference operator in xt_ECHO.c
 (for Jan Engelhardt)
Date: Fri, 19 Sep 2008 19:04:14 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809191710550.12563@fbirervta.pbzchgretzou.qr>
References: <48D40B75.2030407@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jiri Moravec <jim.lkml@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42520 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbYISXER (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2008 19:04:17 -0400
In-Reply-To: <48D40B75.2030407@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-09-19 16:28, Jiri Moravec wrote:

>Jan,
>when you prepared commit ab27472eb44b0690f74d542ddb9a972460eceb9a, you=
 probably overlooked some piece of code, because my gcc objects:
>"2.6.26.5-t4/net/netfilter/xtables-addons/xt_ECHO.c:90: warning: passi=
ng argument 1 of =E2=80=98xtnu_ip_route_me_harder=E2=80=99 from incompa=
tible pointer type"

There is more than just that one.
I fixed it up, thanks for reporting!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
