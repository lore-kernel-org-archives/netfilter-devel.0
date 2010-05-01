From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack h323 reassembly
Date: Sat, 01 May 2010 18:27:43 +0200
Message-ID: <4BDC567F.8080608@trash.net>
References: <20100428165541.174eb58e@nehalam> <alpine.LSU.2.01.1004291154450.23971@obet.zrqbmnf.qr> <4BDC33BF.2060303@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Stephen Hemminger <shemminger@vyatta.com>,
	netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47541 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab0EAQ1p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 May 2010 12:27:45 -0400
In-Reply-To: <4BDC33BF.2060303@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pascal Hambourg wrote:
> Jan Engelhardt a =E9crit :
>> On Thursday 2010-04-29 01:55, Stephen Hemminger wrote:
>>
>>> It seems that h323 conntrack module can't handle TCP fragments.
>> Fragments should not normally happen, as nf_conntrack loads=20
>> nf_defrag.
>=20
> What about IPv6 fragments ? IIUC the IPv6 conntrack only performs a
> "virtual" reassembly. Can and do the conntrack helpers use the virtua=
lly
> reassembled datagrams ?
>=20
> (Although IIUC TCP fragmentation should be very unlikely, as the TCP
> layer is informed about the path MTU and should adjust the segment si=
ze
> accordingly.)

Yes, the "virtual" reassembled packet is also passed to the helpers.
The message is most likely a false positive caused by non-H.323 traffic=
=2E
I'll switch it to pr_debug().

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
