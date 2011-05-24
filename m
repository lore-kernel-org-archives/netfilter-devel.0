From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: icmp_send function broken?
Date: Tue, 24 May 2011 15:26:45 +0200
Message-ID: <1306243605.3026.38.camel@edumazet-laptop>
References: <4DDBAE27.7020502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, evyncke@cisco.com,
	guy.leduc@ulg.ac.be, Cyril Soldani <cyril.soldani@ulg.ac.be>
To: Pierre Rondou <prondou@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54052 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1EXN0s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 09:26:48 -0400
Received: by wwa36 with SMTP id 36so7323167wwa.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2011 06:26:47 -0700 (PDT)
In-Reply-To: <4DDBAE27.7020502@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mardi 24 mai 2011 =C3=A0 15:09 +0200, Pierre Rondou a =C3=A9crit :
> Hello,
>=20
> I'm a student at the University of Liege, currently developing a NAT6=
4=20
> (see RFC 6146) module for Netfilter.
>=20
> I am using the icmp_send() function in my module to send icmp message=
 in=20
> case the packet represent an error (like, TTL exceeded or DEST_UNREAC=
HABLE).
>=20
> But it seems to be broken for me, the dst of the original packet does=
n't=20
> seem to be set.
>=20
> I'm using 2.6.32-5 kernel to developp, but the function itself didn't=
=20
> seem to have been updated in the 2.6.38 kernel.
>=20

You really should use 2.6.39 kernel for your dev...

> The modification I had to apply is to re-execute the routing process =
on=20
> the incoming paquet in order to get the ICMP packet sent:



> instead of the simple
>=20
>     if (!rt)
> //       goto out;
>=20
> Is there an other reason why the rtable of the incoming packet was no=
t set?

It is set by caller.

check ip_rcv_finish()

Also please take a look at commit 64f3b9e203bd06855
net: ip_expire() must revalidate route

[ Since I understand from a prior mail that you maybe queued an skb for
a while for your defrag purpose ]



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
