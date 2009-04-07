From: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Subject: RE: full_cone_nat
Date: Tue, 7 Apr 2009 16:44:36 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.ptinovacao.pt ([194.65.138.99]:24336 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770AbZDGPq2 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:46:28 -0400
In-Reply-To: <47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

What I mean with Full Cone NAT is the following:

1. A packet is sent from a machine in the LAN from Address1:port100 to =
a machine in the WAN with Address3:port200, the NAT converts the local =
Address1:port100 to Address2:port100 which is the address assigned to t=
he home router by the ISP. So this packet is sent with source: Address2=
:port100 and destination: Address3:port200.
2. The packet received by the machine in the WAN in 1) is processed and=
 then the answer comes from a different machine with a different addres=
s but using the same ports. So the response packet is sent by Address4:=
port200 to Address2:port100. So this packet has source: Address4:port20=
0 and destination: Address2:port100.
3. When the home router receives the response packet it has to ignore t=
he sending address in the matching table, so that all traffic received =
in Address2:port100 is simply forward to Address1:port100. This is just=
 a Full Cone NAT.

I have read some tutorials about iptables and the only way I have found=
 to do this is make rule that forwards all traffic that arrives in Addr=
ess2:port100 to Address1:port100. This does the work for just one machi=
ne on the LAN which has a static ip and will always contact the same ma=
chine on the WAN.
What I really want to do is implement a Full Cone NAT in which a packet=
 sent from Address1:port100 which is translated to Address2:port100 by =
the NAT and goes to Address3:port200, activates port100 in the home rou=
ter so that any packets arriving in port100 will be forwarded to Addres=
s1:por100. And this would just work for any number of machines.

Best Regards

Hugo Mendes
________________________________________
De: netfilter-devel-owner@vger.kernel.org [netfilter-devel-owner@vger.k=
ernel.org] Em Nome De Hugo Miguel Mendes
Enviado: ter=E7a-feira, 7 de Abril de 2009 16:32
Para: Jan Engelhardt
Cc: netfilter-devel@vger.kernel.org
Assunto: RE: full_cone_nat

As long as I know iptables is port-restricted NAT, how can you do full =
cone nat on that?

Hugo Mendes
________________________________________
De: jengelh@sovereign.computergmbh.de [jengelh@sovereign.computergmbh.d=
e] Em Nome De Jan Engelhardt [jengelh@medozas.de]
Enviado: ter=E7a-feira, 7 de Abril de 2009 16:31
Para: Hugo Miguel Mendes
Cc: netfilter-devel@vger.kernel.org
Assunto: RE: full_cone_nat

On Tuesday 2009-04-07 17:28, Hugo Miguel Mendes wrote:

>What do you mean with "Another?"


You can already do full cone with Netfilter.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
