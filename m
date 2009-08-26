From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: netfilter: nf_conntrack: log packets dropped by helpers
Date: Wed, 26 Aug 2009 16:43:34 +0200
Message-ID: <4A954A16.6040803@plouf.fr.eu.org>
References: <4A93D817.4080706@trash.net> <4A94073B.80106@plouf.fr.eu.org> <4A9530C1.50200@trash.net> <alpine.LSU.2.00.0908261503340.32385@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0908261506460.13716@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58165 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZHZOnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:43:35 -0400
In-Reply-To: <alpine.DEB.2.00.0908261506460.13716@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik a =E9crit :
>=20
> I usually say that conntrack is not a policy-decision machine and=20
> therefore should not drop packets.

I strongly agree.

> However, for the protocol helpers I strongly believe if the helper ca=
n't=20
> figure out the protocol elements due to any kind of parser error, the=
n=20
> the packet should be dropped. Otherwise we may open up possible DoS a=
ttack=20
> vectors to sloppy server/client implementations.

As a user, I do not expect packets to be dropped when I just enable
conntrack without loading any filtering rule. Wouldn't it be better (if
possible) to flag these packets so they can be dropped - or not - by
iptables ?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
