From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: RE: full_cone_nat
Date: Tue, 7 Apr 2009 20:32:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904072027110.5515@blackhole.kfki.hu>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr> <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com> <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu> <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:45364 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbZDGScZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2009 14:32:25 -0400
In-Reply-To: <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 7 Apr 2009, Jan Engelhardt wrote:

> 
> On Tuesday 2009-04-07 20:16, Jozsef Kadlecsik wrote:
> >On Tue, 7 Apr 2009, Hugo Miguel Mendes wrote:
> >
> >> What I mean with Full Cone NAT is the following:
> >>[...]
> >
> >I answered you on Thu, 2 Apr 2009 when you asked the same question on
> >the netfilter mailing list. The answer hasn't changed since then: 
> >currently there's no way to create full cone NAT.
> >
> >It might be possible to write a new full cone NAT target by creating 
> >wildcard expectations.
> 
> Yeah there is a case where cone nat does not quite work. Assuming there
> are the following mappings:
> 
> origsrc=192.168.17.2 origdst=80.10.20.30 replsrc=134.98.76.54 repldst=80.10.20.30
> origsrc=192.168.17.3 origdst=80.20.30.40 replsrc=134.98.76.54 repldst=80.20.30.40
> 
> Then there is no way to ambiguously map incoming IP_CT_NEW connections
> for 134.98.76.54 to an origsrc.

Yes, full cone NAT can easily break connections or at least is should 
reject the second, overlapping connection for the joy of the user. But if 
someone insists and want to shoot himself in the foot, then by creating 
expectations it might be create full cone NAT.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
