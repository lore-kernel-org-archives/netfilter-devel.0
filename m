From: Andrew Beverley <andy@andybev.com>
Subject: Re: help with conntrack
Date: Wed, 12 Sep 2012 20:27:30 +0100
Message-ID: <1347478050.2349.202.camel@andrew-desktop>
References: <CAOSBYzdLo=A9VApP-BsbQ_Hi8c_NOkS00GUEAjU8X85o+vEy_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Miguel Alejandro =?ISO-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:43914 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2ILThy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Sep 2012 15:37:54 -0400
In-Reply-To: <CAOSBYzdLo=A9VApP-BsbQ_Hi8c_NOkS00GUEAjU8X85o+vEy_A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2012-09-11 at 23:08 -0500, Miguel Alejandro Gonz=C3=A1lez wrote=
:
> Hello
>=20
> I'm making a netfilter module and I need to have interaction with
> conntrack, as I understand conntrack is a hash table of all connectio=
ns
> IPv4 and IPv6. I basically need to know how to do lookups, insertions=
 an
> deletions, can you tell me how do this? If you can give me some
> documentation or code to see how conntrack works and how to achieve w=
hat I
> need to do, that would be great

The "Writing Netfilter Modules" should help you (see part II):
http://inai.de/documents/Netfilter_Modules.pdf

Of course, there's also libnetfilter_conntrack which includes some good
examples, although it's a userspace library.

Andy


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
