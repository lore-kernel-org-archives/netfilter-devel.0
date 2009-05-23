From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 23 May 2009 13:43:07 +0200
Message-ID: <4A17E14B.5040701@netfilter.org>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr> <4A17D45C.6040909@netfilter.org> <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZEWLzN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 07:55:13 -0400
In-Reply-To: <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-05-23 12:47, Pablo Neira Ayuso wrote:
>>> once again, irc snatched this report:
>>>
>>> |2009-05-20T20:56 < Wintre:#Netfilter>
>>> |
>>> |Specifically, when I add a DROP rule to the local firewall, send(2=
)
>>> |starts getting EPERM. The netfilter core code includes
>>> |nf_hook_slow(), which says:
>>> |
>>> | /* Returns 1 if okfn() needs to be executed by the caller,
>>> |  * -EPERM for NF_DROP, 0 otherwise. */
>>> |
>>> |So, this seems kind of crazy to me. I always thought drop was
>>> |supposed to be silent, and changing the return value of send(2),
>>> |well. Bad. Anybody got a link to a discussion of this issue? Or is=
 it
>>> |just a plain old bug?
>>>
>>> I agree with the user here. For now, one had to make use of the
>>> =E2=80=9CSTEAL=E2=80=9D target [1] to get the real silent drop beha=
vior for the
>>> OUTPUT chain. Surely that is not the ideal thing either.
>>> Requesting comments from NF maintainers.
>> I'm curious, what application would need to ignore that error?
>=20
> Well, the problem is that applications do not check for all
> potential errors, just whether there was one or not:
>=20
>  while (there_is_data)
>      if (send(fd, &data[i], len) < 0) {
>          perror("the connection broke, or something we can't fix");
>          break;
>      }

Hm, I see. Then I think that people should fix their applications inste=
ad.

> Sure it feels a bit like the reliance on ext3 update intervals :-)
>=20
>> Returning
>> -EPERM seems to me quite sane to note that the kernel is explicit (v=
ia
>> iptables, for example) not allowing permission to send().
>=20
> Yeah but DROP is perceived by users to be "silently ignore it",
> while the "you don't have permission" is REJECT's job.

But the DROP and REJECT behaviours refer to the packet logic, ie. with
DROP nothing is done, with REJECT we send some explicit packet (like an
ICMP administratively prohibited). That still applies to user-space.

Reporting -EPERM seems to me a good practise to report user-space
applications that the kernel is explicit dropping the packet. Otherwise=
,
while diagnosing problems, people cannot be sure where the packet has
been lost.

I'm more like in favour of forcing people to fix their applications,
they are doing a broken error handling.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
