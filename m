From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: xt_TCPMSS target dropping SYN packets with data: suggested mod
Date: Thu, 16 Jul 2009 13:17:21 +0200
Message-ID: <4A5F0C41.5030101@plouf.fr.eu.org>
References: <873dce860907090641n31254e30g48886aefbbc6474e@mail.gmail.com>	 <4A5DF7DD.2050908@trash.net> <873dce860907160015n6a37715x10aae10249ece994@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Luca Pesce <pesce.luca@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:58165 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZGPL2b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:28:31 -0400
In-Reply-To: <873dce860907160015n6a37715x10aae10249ece994@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Luca Pesce a =E9crit :
>=20
>> It doesn't seem like a very useful feature,
>> considering all the stacks supporting syn cookies.
>=20
> Did you mean that syn cookies would drop that SYN with data anyway?

When the receiver has SYN cookies enabled, it replies to a SYN with a=20
SYN-ACK as usual, but does not keep any state for it. Instead the state=
=20
is stored in the ISN (used as a "cookie") of the SYN-ACK and will come=20
back in the final ACK of the 3-way handshake. Not keeping state means=20
that any data contained in the first SYN segment are discarded.

> Or that MSS mangling itself would harm syn cookies tecniques?

I don't see why.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
