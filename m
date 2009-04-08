From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: full_cone_nat
Date: Wed, 8 Apr 2009 20:44:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904081546410.7205@blackhole.kfki.hu>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr> <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com> <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu> <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>,<alpine.DEB.2.00.0904072027110.5515@blackhole.kfki.hu>
 <47A7F67C62706041BC49DB7822B1C9DB1D47134141@INOAVREX11.ptin.corpPT.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:51830 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935225AbZDHSoh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:44:37 -0400
In-Reply-To: <47A7F67C62706041BC49DB7822B1C9DB1D47134141@INOAVREX11.ptin.corpPT.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
