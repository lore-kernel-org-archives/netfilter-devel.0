From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: conntrack h323 reassembly
Date: Sat, 01 May 2010 15:59:27 +0200
Message-ID: <4BDC33BF.2060303@plouf.fr.eu.org>
References: <20100428165541.174eb58e@nehalam> <alpine.LSU.2.01.1004291154450.23971@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Hemminger <shemminger@vyatta.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:53103 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750861Ab0EAN7b (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 May 2010 09:59:31 -0400
In-Reply-To: <alpine.LSU.2.01.1004291154450.23971@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt a =E9crit :
> On Thursday 2010-04-29 01:55, Stephen Hemminger wrote:
>=20
>> It seems that h323 conntrack module can't handle TCP fragments.
>=20
> Fragments should not normally happen, as nf_conntrack loads=20
> nf_defrag.

What about IPv6 fragments ? IIUC the IPv6 conntrack only performs a
"virtual" reassembly. Can and do the conntrack helpers use the virtuall=
y
reassembled datagrams ?

(Although IIUC TCP fragmentation should be very unlikely, as the TCP
layer is informed about the path MTU and should adjust the segment size
accordingly.)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
