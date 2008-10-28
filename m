From: Patrick McHardy <kaber@trash.net>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Tue, 28 Oct 2008 18:40:17 +0100
Message-ID: <49074E81.6010207@trash.net>
References: <rlujt5-k63.ln1@tux.abusar.org.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37370 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYJ1RkU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:40:20 -0400
In-Reply-To: <rlujt5-k63.ln1@tux.abusar.org.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

D=E2niel Fraga wrote:
> 	Since Linux kernel 2.6.25, I get stalled connections and when it hap=
pens, I have this on the log:
>=20
> Oct 28 13:39:22 tux vmunix: 1:3e:79:01:fe:b2:80 R=3D9.6.. S=3D9.6.. E=
=3D9
> O=3Dx0PE=3Dx0TL6 D410POOUPST10 P=3D41 E=3D7
>=20
> 	It seems that are missing chars here.
>=20
> 	A bug?

Seems likely. Is that an SMP machine? Its possible that the ringbuffer
simply overflows before the logging daemon gets a chance to capture it,
but that should only cause truncated lines.

What do your logging rules that might be responsible for this look like=
?

> 	Ps: in fact this issue seems to be much more complex than this. Ther=
e's a huge thread we=20
> talked about those stalled connections, but we are unable to discover=
 what causes this, so I opened=20
> this bug report:
>=20
> http://bugzilla.kernel.org/show_bug.cgi?id=3D11588
>=20
> 	At least if netfilter developers could figure it out why the above l=
og line happens, maybe we=20
> could trace this bug and solve it.

I can't see anything in that report that would ring a bell.
Are you using any of the more unusual networking features,
like QoS, policy routing etc?

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
