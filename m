From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: [netfilter-core] Mangle table rules are not taken into account
 in preliminary routing decision
Date: Mon, 15 Oct 2007 17:01:17 +0200
Message-ID: <471380BD.7020904@plouf.fr.eu.org>
References: <470CA4DF.6000803@oktetlabs.ru> <470DA22F.70807@trash.net> <470DC711.4020701@oktetlabs.ru> <470DCEFF.6030709@trash.net> <470DE946.9090301@plouf.fr.eu.org> <4713751D.6080309@oktetlabs.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-dmz-231-monday.dmz.nerim.net ([195.5.254.231]:56786 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753084AbXJOPDW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:03:22 -0400
Received: from mallaury.nerim.net (smtp-101-monday.noc.nerim.net [62.4.17.101])
	by kellthuzad.dmz.nerim.net (Postfix) with ESMTP id C729125E70
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2007 17:03:13 +0200 (CEST)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by mallaury.nerim.net (Postfix) with ESMTP id 4BBBB4F3F5
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Oct 2007 17:01:08 +0200 (CEST)
In-Reply-To: <4713751D.6080309@oktetlabs.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Konstantin Ushakov a =E9crit :
>>
>>What about the REJECT target ?
>=20
> Correct me if I'm mistaken, but REJECT target is only valid in filter
> table.

Correct.

> But the packet does not reach filter table because of reasons
> described by Patric (as we DROP it after mangle).

Im meant to use the REJECT target /instead of/ an "unreachable" routing=
=20
rule.

Remove
ip rule add from all fwmark 0xb lookup 99 unreachable prio 40000

And add
iptables -t filter -A OUTPUT -m mark --mark 0xb \
   -j REJECT --rejected-with icmp-net-unreachable
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
