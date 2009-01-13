From: Jan Engelhardt <jengelh@medozas.de>
Subject: Fwd: iptables-1.4.1-1.4.2 change "Warn about use of DROP in nat
 table"
Date: Tue, 13 Jan 2009 10:13:13 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901131012390.7823@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59238 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967AbZAMJNQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:13:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 959B71C00DB2F
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2009 10:13:13 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---------- Forwarded message ----------
Date: Mon, 12 Jan 2009 21:35:44
=46rom: Marek Kierdelewicz <marek@koba.pl>
To: jengelh
Subject: iptables-1.4.1-1.4.2 change "Warn about use of DROP in nat tab=
le"

Hello,

Is there any particular reason for removing DROP target from nat table?
Some people may be using this functionality (like me). Access
control for lan clients on my routers is done in PREROUTING chain of na=
t
table in following way (in great simplification):
- DNAT to infoHost:infoPort1 tcp packets to port 80 from IP/MAC pair in
ipset INFO-GRP1
- RETURN packets from IP/MAC pair in ipset
- DNAT tcp packets to port 80 to infoHost:infoPort2
- DROP rest of the packets

I know DROPping in nat table isn't perfect (doesn't filterout already
established "connections"), but it should be less cpu-intensive as it's
done for the first packet of a "connection". Removing DROP from nat
table would force me use DROPs in filter table. Wouldn't it be a bit
more cpu-intensive?

Anyway thanks for the warning :-).

Regards,
--=20
Marek Kierdelewicz
Kierownik Dzia=C5=82u System=C3=B3w Sieciowych, KoBa
Manager of Network Systems Department, KoBa
tel. (85) 7406466; fax. (85) 7406467
e-mail: admin@koba.pl

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
