From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 23 May 2009 13:11:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr> <4A17D45C.6040909@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60398 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZEWLLu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 07:11:50 -0400
In-Reply-To: <4A17D45C.6040909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-05-23 12:47, Pablo Neira Ayuso wrote:
>>=20
>> once again, irc snatched this report:
>>=20
>> |2009-05-20T20:56 < Wintre:#Netfilter>
>> |
>> |Specifically, when I add a DROP rule to the local firewall, send(2)
>> |starts getting EPERM. The netfilter core code includes
>> |nf_hook_slow(), which says:
>> |
>> | /* Returns 1 if okfn() needs to be executed by the caller,
>> |  * -EPERM for NF_DROP, 0 otherwise. */
>> |
>> |So, this seems kind of crazy to me. I always thought drop was
>> |supposed to be silent, and changing the return value of send(2),
>> |well. Bad. Anybody got a link to a discussion of this issue? Or is =
it
>> |just a plain old bug?
>>=20
>> I agree with the user here. For now, one had to make use of the
>> =E2=80=9CSTEAL=E2=80=9D target [1] to get the real silent drop behav=
ior for the
>> OUTPUT chain. Surely that is not the ideal thing either.
>> Requesting comments from NF maintainers.
>
>I'm curious, what application would need to ignore that error?

Well, the problem is that applications do not check for all
potential errors, just whether there was one or not:

 while (there_is_data)
     if (send(fd, &data[i], len) < 0) {
         perror("the connection broke, or something we can't fix");
         break;
     }

Sure it feels a bit like the reliance on ext3 update intervals :-)

> Returning
>-EPERM seems to me quite sane to note that the kernel is explicit (via
>iptables, for example) not allowing permission to send().

Yeah but DROP is perceived by users to be "silently ignore it",
while the "you don't have permission" is REJECT's job.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
