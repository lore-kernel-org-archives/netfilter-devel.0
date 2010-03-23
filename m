From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Tue, 23 Mar 2010 18:21:33 +0100
Message-ID: <1269364893.2983.296.camel@edumazet-laptop>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>
	 <4BA8DAC5.6050002@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52402 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab0CWRVi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:21:38 -0400
Received: by gyg8 with SMTP id 8so3285335gyg.19
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Mar 2010 10:21:37 -0700 (PDT)
In-Reply-To: <4BA8DAC5.6050002@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 23 mars 2010 =C3=A0 16:14 +0100, Jorrit Kronjee a =C3=A9crit :
>  =20
> Patrick,
>=20
> Although these are good suggestions, I really need to be able to limi=
t
> per destination. The receiving network is a /15 which means I have to
> use something like a hashtable to keep track of destination IP
> addresses. Neither rateest or limit can do that. OTOH, that's also th=
e
> only thing I need. This would make a low-cost ISP-grade DDoS filter,
> which is why I'm interested in it.
>=20
> The bug you're referring to is this one, I think:=20
> http://bugzilla.netfilter.org/show_bug.cgi?id=3D523 but I'm not entir=
ely
> sure if that is related to my problems.
>=20
> Is there any way I can figure out why ifconfig is reporting dropped
> packets?
>=20
> Thanks for all the help so far!
>=20

Could you post more information about your machine ?

cat /proc/interrupts

If running a recent kernel, a "perf top" would be useful

Maybe RPS will help your setup  (included in net-next-2.?6 tree)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
