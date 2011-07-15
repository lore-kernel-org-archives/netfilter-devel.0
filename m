From: =?ISO-8859-1?Q?Fran=E7ois?= Delawarde
	<fdelawarde@wirelessmundi.com>
Subject: Re: Bug#631945: HFSC warning issue
Date: Fri, 15 Jul 2011 12:57:46 +0200
Message-ID: <1310727466.9924.6.camel@luna.madrid.commsmundi.com>
References: <1310376412.8036.134.camel@luna.madrid.commsmundi.com>
	 <4E1AE4F1.6030905@ziu.info>	<4E1AE88F.803@ziu.info>
	 <CAAJ8s-RGocriAycZv4cjkKGd2mwGF1UH_-uyi+fbwdeUhvMk7g@mail.gmail.com>
	 <4E1CD88E.4030107@ziu.info>
Reply-To: fdelawarde@wirelessmundi.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: 00bormoj@gmail.com, 631945@bugs.debian.org,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Michal Soltys <soltys@ziu.info>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.wirelessmundi.com ([91.121.102.180]:34639 "EHLO
	mail.wirelessmundi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab1GOK5t convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jul 2011 06:57:49 -0400
In-Reply-To: <4E1CD88E.4030107@ziu.info>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2011-07-13 at 01:28 +0200, Michal Soltys wrote:=20
> That warning that gets triggered when next_time =3D=3D 0 in
> hfsc_schedule_watchdog() implies, that hfsc_dequeue() tried to dequeu=
e a
> packet, but no leaf had anything eligible for scheduling (realtime
> criterion) and linksharing was upperlimited.
>=20
> Now if there IS something to dequeue, then I don't see how next_time
> could possibly be zero - that would mean there's no packet to schedul=
e
> at all. But if that happened, then hfsc_dequeue() would simply exit a=
t
> the very beginning due to: if (sch->q.qlen =3D=3D 0) .
>=20
> So it does look weird (like if something external messed with hfsc's
> qlen) ...

Could it be related with setting a custom device qlen with iproute (wil=
d
guess)?=20

> Also note - the changes to sch_hfsc.c were pretty minimal since the l=
ast
> kernel that worked for you. You might be searching for something else=
 ...

Any idea where we could start searching?

Is there any configuration we could try (with upperlimits maybe?) that
could help identify or workaround this problem?

Thanks,
=46ran=C3=A7ois.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
