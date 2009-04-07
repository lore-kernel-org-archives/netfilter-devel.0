From: Hugo Miguel Mendes <est-h-mendes@ptinovacao.pt>
Subject: RE: full_cone_nat
Date: Tue, 7 Apr 2009 21:55:10 +0100
Message-ID: <47A7F67C62706041BC49DB7822B1C9DB1D47134141@INOAVREX11.ptin.corpPT.com>
References: <47A7F67C62706041BC49DB7822B1C9DB1D47134138@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071726470.25905@fbirervta.pbzchgretzou.qr>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413C@INOAVREX11.ptin.corpPT.com>,<alpine.LSU.2.00.0904071731200.25905@fbirervta.pbzchgretzou.qr>,<47A7F67C62706041BC49DB7822B1C9DB1D4713413D@INOAVREX11.ptin.corpPT.com>
 <47A7F67C62706041BC49DB7822B1C9DB1D4713413F@INOAVREX11.ptin.corpPT.com>
 <alpine.DEB.2.00.0904072008440.5338@blackhole.kfki.hu>
 <alpine.LSU.2.00.0904072017510.24473@fbirervta.pbzchgretzou.qr>,<alpine.DEB.2.00.0904072027110.5515@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail6.ptinovacao.pt ([194.65.138.99]:45819 "EHLO
	owa.ptinovacao.pt" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761286AbZDGU5z convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2009 16:57:55 -0400
In-Reply-To: <alpine.DEB.2.00.0904072027110.5515@blackhole.kfki.hu>
Content-Language: pt-PT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for the tip :) I hadn't seen your answe in the other mailing lis=
t.
My original question in this mailing list is:

Can you tell me where can I find in the source code the function or fun=
ctions responsible for checking the matching table of active connection=
s present in the file ip_conntrack.

Hugo Mendes
________________________________________
De: Jozsef Kadlecsik [kadlec@blackhole.kfki.hu]
Enviado: ter=E7a-feira, 7 de Abril de 2009 19:32
Para: Jan Engelhardt
Cc: Hugo Miguel Mendes; netfilter-devel@vger.kernel.org
Assunto: RE: full_cone_nat

On Tue, 7 Apr 2009, Jan Engelhardt wrote:

>
> On Tuesday 2009-04-07 20:16, Jozsef Kadlecsik wrote:
> >On Tue, 7 Apr 2009, Hugo Miguel Mendes wrote:
> >
> >> What I mean with Full Cone NAT is the following:
> >>[...]
> >
> >I answered you on Thu, 2 Apr 2009 when you asked the same question o=
n
> >the netfilter mailing list. The answer hasn't changed since then:
> >currently there's no way to create full cone NAT.
> >
> >It might be possible to write a new full cone NAT target by creating
> >wildcard expectations.
>
> Yeah there is a case where cone nat does not quite work. Assuming the=
re
> are the following mappings:
>
> origsrc=3D192.168.17.2 origdst=3D80.10.20.30 replsrc=3D134.98.76.54 r=
epldst=3D80.10.20.30
> origsrc=3D192.168.17.3 origdst=3D80.20.30.40 replsrc=3D134.98.76.54 r=
epldst=3D80.20.30.40
>
> Then there is no way to ambiguously map incoming IP_CT_NEW connection=
s
> for 134.98.76.54 to an origsrc.

Yes, full cone NAT can easily break connections or at least is should
reject the second, overlapping connection for the joy of the user. But =
if
someone insists and want to shoot himself in the foot, then by creating
expectations it might be create full cone NAT.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
