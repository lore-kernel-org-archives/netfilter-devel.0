From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Utilization of Multi-core hardware by Netfilter
Date: Tue, 22 Jun 2010 18:33:51 +0200
Message-ID: <1277224431.3057.600.camel@edumazet-laptop>
References: <AANLkTik76jQGjSbpXUo29e_75fUV_m8uQxLqEpW9jte5@mail.gmail.com>
	 <alpine.LSU.2.01.1006221801230.1731@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48465 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab0FVQd6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:33:58 -0400
Received: by wyi11 with SMTP id 11so9871wyi.19
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Jun 2010 09:33:55 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1006221801230.1731@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 22 juin 2010 =C3=A0 18:01 +0200, Jan Engelhardt a =C3=A9crit :
> On Tuesday 2010-06-22 16:38, Anand Raj Manickam wrote:
>=20
> >Hi,
> >I am  pumping data at a connection rate of 6000 connections per seco=
nd
> > on  a Dual Core CPU .
> >But CPU 0 is the one which is always occupied  upto 100% and CPU 1 i=
s
> >always 98-100% idle  and after CPU0 reaches 100% connections starts =
to
> >fail.
> >Any pointers other than RPS/RFS  to load balance the CPU utilization=
 ?
> >I m using linux-2.6.26 kernel .
>=20
> It's not in 2.6.26.

I believe Anand was aware of this RFS/RPS thing not available in
2.6.26 ;)

Anand, if you have two NICS, you can try to irq affine each NIC to each
CPU.

Other than that, you could try a multi queue NIC and fairly recent
kernel.

2.6.26 has a lot of bottlenecks, I am not sure trying to use your two
cores will actually help.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
