From: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Subject: RE: full_cone_nat
Date: Tue, 21 Apr 2009 17:41:37 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB2248FD9A99@INOAVREX11.ptin.corpPT.com>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com>
 <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu>
 <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>,<alpine.DEB.2.00.0904072027110.5515@blackhole.kfki.hu>
 <47A7F67C62706041BC49DB7822B1C9DB1D47134141@INOAVREX11.ptin.corpPT.com>,<alpine.DEB.2.00.0904081546410.7205@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.ptinovacao.pt ([194.65.138.99]:51230 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705AbZDUQnl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:43:41 -0400
In-Reply-To: <alpine.DEB.2.00.0904081546410.7205@blackhole.kfki.hu>
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I had been on vacation and I have just seen your answer.
Thanks for the help, I'm just going to start reading what you suggested.

Best Regards

Hugo Mendes
___
De: Jozsef Kadlecsik [kadlec@blackhole.kfki.hu]
Enviado: quarta-feira, 8 de Abril de 2009 19:44
Para: Hugo Miguel Mendes
Cc: Jan Engelhardt; netfilter-devel@vger.kernel.org
Assunto: RE: full_cone_nat

On Tue, 7 Apr 2009, Hugo Miguel Mendes wrote:

> Can you tell me where can I find in the source code the function or
> functions responsible for checking the matching table of active
> connections present in the file ip_conntrack.

You should first understand the internals of how netfilter connection
tracking and NAT handle the packets and the connections. You should
probably read the "Netfilter Hacking HOWTO" - it's outdated but still
contains valuable information - and should definitely read the 'Writing
netfilter modules' by Jan. Then you can easily find the relevant parts in
net/netfilter/nf_conntrack_[standalone|core|expect].c and
net/ipv4/netfilter/nf_nat_[standalone|core].c. Of course you should check
out how expectations are created and used looking at the existing
protocol helper modules.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
