From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Netfilter Module for NAT IVI available
Date: Wed, 25 May 2011 15:16:43 +0200
Message-ID: <1306329404.2820.18.camel@edumazet-laptop>
References: <4DC1FACC.4080204@gmail.com>
	 <1306248975.3026.47.camel@edumazet-laptop> <4DDBD2F1.3020704@gmail.com>
	 <1306252554.3026.66.camel@edumazet-laptop> <4DDCFD42.3010708@gmail.com>
	 <BANLkTinofP5BhXpCJB6z18yBbiN3H0N=vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pierre Rondou <prondou@gmail.com>, behave@ietf.org, v6ops@ietf.org,
	netfilter-devel@vger.kernel.org, guy.leduc@ulg.ac.be,
	evyncke@cisco.com, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37013 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757902Ab1EYNQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:16:49 -0400
Received: by wwa36 with SMTP id 36so8467775wwa.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2011 06:16:48 -0700 (PDT)
In-Reply-To: <BANLkTinofP5BhXpCJB6z18yBbiN3H0N=vw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 25 mai 2011 =C3=A0 15:09 +0200, Maciej =C5=BBenczykowski a =
=C3=A9crit :
> Not that I've really been following the thread.
> But I think that this sort of functionality should most likely be
> developed as a virtual (tun/tap/veth/sit) style tunnel-like device.
>=20
> You would use ipv4/ipv6 routing in the normal kernel to direct traffi=
c
> out this virtual interface, and immediately ipv6/ipv4 traffic would
> come back out of it.
>=20
> This should allow all the rest of the kernel (including connection
> tracking) to function normally - although of course every connection
> would be registered in an unrelated way twice (once as v4, once as
> v6).
>=20
> I think this has nice 'black box' semantics.

CERNET doc refers to  : http://linux.ivi2.org/

With an implementation for linux-2.6.18 : http://linux.ivi2.org/impl/

This seems enough to me, and not intrusive.

Pierre, you really should discuss why a netfilter module is needed at
all. Maybe you have a pdf or some slides somewhere (no code, but formal
discussion) ?



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
