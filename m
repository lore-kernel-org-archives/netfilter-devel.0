From: Bas van Sisseren <bas@quarantainenet.nl>
Subject: Re: [PATCH] ipt_REDIRECT: only change dest-ip if not local ip
Date: Fri, 16 Jul 2010 17:21:54 +0200
Message-ID: <4C407912.7050500@quarantainenet.nl>
References: <4C402DBD.3010007@quarantainenet.nl> <4C40539A.6080607@plouf.fr.eu.org> <4C405D50.6020306@quarantainenet.nl> <4C4074FF.8080308@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.quarantaine.net ([217.114.102.88]:56182 "EHLO
	main.qone.quarantainenet.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965749Ab0GPPV7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Jul 2010 11:21:59 -0400
In-Reply-To: <4C4074FF.8080308@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/07/10 17:04, Pascal Hambourg wrote:
> Bas van Sisseren a =E9crit :
>>
>> On 16/07/10 14:42, Pascal Hambourg wrote:
>>>
>>> 2) I wonder whether it is really useful. The purpose of REDIRECT is=
 to
>>> make sure a packet is redirected to the local machine itself withou=
t the
>>> need to care about the machine's address (just as MASQUERADE). If y=
ou
>>> don't want to change the destination address or need finer control =
over
>>> it, I believe DNAT can be used instead. Can you provide a use case =
?
>>
>> It's a honeypot system with advanced routing and a lot of ip-address=
es. The
>> honeypot is running as non-root, which complicates usage of ports < =
1024.
>> The REDIRECT rule helps us to redirect the connection to higher
>> port-numbers. With REDIRECT, we can request the original dst ip:port=
 with
>> the SO_ORIG_DST sockopt. With DNAT the SO_ORIG_DST is not available.
>=20
> Do you mean SO_ORIGINAL_DST ? I'm surprised it does not work with DNA=
T.
> AFAICS, it uses data from the connection tracking, and it does not
> matter how the NAT mapping was created.

Yes, that's the one. I have to admit I did these experiments before the
netfilter module shuffle (somewhere around the 2.6.18 kernel). I'll hav=
e
another look at it.


>>> 3) Why restrict only to the addresses attached to the receiving
>>> interface ? Why not extend to any address attached to a host's
>>> interface, or even any local address (such as the whole 127.0.0.0/8
>>> prefix) ?
>>
>> I don't see any use for that. :-)
>=20
> Well, I think it would be more consistent with the Linux "weak" host
> model (all local addresses belong globally to the host instead of a
> single interface) ; we want to redirect a packet to the local host, s=
o
> if the original destination address is already a local address, we do=
n't
> need to change it.

Ah, you've got a point there.


--=20
Bas van Sisseren <bas@quarantainenet.nl>
Quarantainenet
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
