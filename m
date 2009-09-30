From: Nils Rennebarth <Nils.Rennebarth@web.de>
Subject: How to add data to connection tracker
Date: Wed, 30 Sep 2009 12:29:27 +0200
Message-ID: <845389504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:43911 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZI3K3Z convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2009 06:29:25 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id CBC0C61C1133
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2009 12:29:28 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am developing a netfilter target extension synproxy, that will work s=
imilar to the openbsd pf synproxy,
i.e. it will (if a synflood to the destination address is detected) blo=
ck the syn packet and answer with a
syn cookie. If a correct ACK to the cookie is found it will send the sy=
n packet to the actual server, intercepts the
reply and then pass packets in both directions, only translating sequen=
ce numbers. The extension could
then be used on a firewall to protect systems behind it from synflood a=
ttacks.

I need to store some additional data to a connection in the connection =
tracker. Although infrastructure to do that
appears to be in place, I could not find an obvious way to do that. I *=
did* read the kernel source and already know
how to write and register a new netfilter extension.

Btw, the netfilter hacking howto appears to be thoroughly outdated. I m=
anaged to find http://jengelh.medozas.de/documents/Netfilter_Modules.pd=
f which helped a lot, but not in this particular area.
______________________________________________________
GRATIS f=FCr alle WEB.DE-Nutzer: Die maxdome Movie-FLAT!
Jetzt freischalten unter http://movieflat.web.de

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
