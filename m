From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Fri, 17 Jul 2009 11:46:06 +0200
Message-ID: <4A60485E.6010503@plouf.fr.eu.org>
References: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>	 <4A5DF7DD.2050908@trash.net>	 <873dce860907160015n6a37715x10aae10249ece994@mail.gmail.com>	 <4A5F0C41.5030101@plouf.fr.eu.org> <873dce860907170044v45353d01sd5f0c5305e9ffdb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:60930 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934304AbZGQJqN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:46:13 -0400
In-Reply-To: <873dce860907170044v45353d01sd5f0c5305e9ffdb8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Luca Pesce a =E9crit :
>=20
> Ok, so if the receiver is using syn cookies, the data in the SYN woul=
d
> be discarded, and that is fine.

Actually I don't know whether the data are discared or the whole SYN=20
packet is. My feeling is that the receiver should not ACK a discarded=20
segment, so the whole SYN packet should be discarded, maybe rejected=20
with a RST.

> But the current implementation of TCPMSS target is dropping the
> whole syn packet (if it is carrying any payload), so the receiver is
> not receiving the syn

I think this behaviour is wrong. As a general rule, I think that=20
matches, targets or conntrack should not drop packets implicitly. If a=20
target cannot handle the packet, just leave it unmodified (and possibly=
=20
log a warning).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
