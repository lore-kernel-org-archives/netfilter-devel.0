From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: full_cone_nat
Date: Tue, 7 Apr 2009 20:16:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr> <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:34182 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbZDGSQW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:16:22 -0400
In-Reply-To: <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 7 Apr 2009, Hugo Miguel Mendes wrote:

> What I mean with Full Cone NAT is the following:
> 
> 1. A packet is sent from a machine in the LAN from Address1:port100 to a 
> machine in the WAN with Address3:port200, the NAT converts the local 
> Address1:port100 to Address2:port100 which is the address assigned to 
> the home router by the ISP. So this packet is sent with source: 
> Address2:port100 and destination: Address3:port200.
> 2. The packet received by the machine in the WAN in 1) is processed and 
> then the answer comes from a different machine with a different address 
> but using the same ports. So the response packet is sent by 
> Address4:port200 to Address2:port100. So this packet has source: 
> Address4:port200 and destination: Address2:port100.
> 3. When the home router receives the response packet it has to ignore 
> the sending address in the matching table, so that all traffic received 
> in Address2:port100 is simply forward to Address1:port100. This is just 
> a Full Cone NAT.

I answered you on Thu, 2 Apr 2009 when you asked the same question on
the netfilter mailing list. The answer hasn't changed since then: 
currently there's no way to create full cone NAT.

It might be possible to write a new full cone NAT target by creating 
wildcard expectations.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
