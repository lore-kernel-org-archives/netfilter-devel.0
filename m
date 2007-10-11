From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Thu, 11 Oct 2007 11:13:42 +0200
Message-ID: <470DE946.9090301@plouf.fr.eu.org>
References: <470CA4DF.6000803@oktetlabs.ru> <470DA22F.70807@trash.net> <470DC711.4020701@oktetlabs.ru> <470DCEFF.6030709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Konstantin Ushakov <kostik@oktetlabs.ru>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-234-thursday.dmz.nerim.net ([195.5.254.234]:49574 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756257AbXJKJPq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 05:15:46 -0400
Received: from kraid.nerim.net (smtp-104-thursday.nerim.net [62.4.16.104])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id F1318248D3
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Oct 2007 11:15:40 +0200 (CEST)
In-Reply-To: <470DCEFF.6030709@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

Patrick McHardy a =E9crit :
>=20
> Ah, I see the problem. The route returns unreachable, which
> iptable_mangle translates to NF_DROP. The problem is that
> netfilter itself can't return ENETUNREACH and there is no
> valid output function attached to the dst_entry that would
> send an icmp unreachable. I think the only thing you could
> do is manually call icmp_send(ICMP_DEST_UNREACH) in
> ip_route_me_harder for this case.

What about the REJECT target ?
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
