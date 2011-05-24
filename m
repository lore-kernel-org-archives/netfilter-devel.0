From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: EXPORT_SYMBOL missing in the kernel?
Date: Tue, 24 May 2011 15:40:51 +0200
Message-ID: <1306244451.3026.42.camel@edumazet-laptop>
References: <4DDBACA6.2060501@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52123 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab1EXNky (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:40:54 -0400
Received: by wya21 with SMTP id 21so4979673wya.19
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 06:40:53 -0700 (PDT)
In-Reply-To: <4DDBACA6.2060501@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 24 mai 2011 =C3=A0 15:03 +0200, Pierre Rondou a =C3=A9crit :
> Hello,
>=20
> I'm a student at the University of Liege, currently developing a NAT6=
4=20
> (see RFC 6146) module for Netfilter.
>=20
> In order to develop this module, I had to use some in-kernel function=
,=20
> such as icmp_send, ip6_output, ip_finish_output, ... and many more.
>=20
> But many of those functions didn't have an "EXPORT_SYMBOL" allowing t=
hem=20
> to be reachable from outside the kernel.
>=20
> So, to be able to use them, I had to copy paste about 1500 lines of=20
> kernel source code (those functions + related functions). This makes =
the=20
> module hardly updatable as all those functions are likely to be updat=
ed.
>=20
> Is there a reason why those functions are not associated with an=20
> "EXPORT_SYMBOL"?

We dont export all possible symbols (each export has a memory cost)

We export one symbol when its needed from a module.

Dont copy/paste code, but add EXPORT_SYMBOL when/if needed.

icmp_send() is for sure already exported (needed in various netfilter
modules)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
