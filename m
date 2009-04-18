From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ulogd2 commit
Date: Sat, 18 Apr 2009 14:05:56 +0200
Message-ID: <49E9C224.6060606@netfilter.org>
References: <49E85F6D.9030008@netfilter.org>	 <1240053470.10215.16.camel@ice-age>  <49E9BCFD.80102@netfilter.org> <1240055885.10215.27.camel@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Pierre Chifflier <chifflier@inl.fr>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbZDRMGF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 08:06:05 -0400
In-Reply-To: <1240055885.10215.27.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
>=20
> Le samedi 18 avril 2009 =E0 13:43 +0200, Pablo Neira Ayuso a =E9crit =
:
>> Eric Leblond wrote:
>>> Hi,
>>>
>>> Le vendredi 17 avril 2009 =E0 12:52 +0200, Pablo Neira Ayuso a =E9c=
rit :
>=20
> ...
>=20
>> 1) Looking at my ulogd2 installation, this exports a lot of header f=
iles
>> for external use:
>>
>> $ ls /usr/include/ulogd/
>> common.h    hash.h            jhash.h      linux_rbtree.h  timer.h
>> conffile.h  ipfix_protocol.h  linuxlist.h  slist.h         ulogd.h
>>
>> Sorry, but this is a bit nasty. If this patch aims to allow compilin=
g
>> external ulogd2 module,  please make public only the basic functions
>> (register, unregister, ...) in one header public file called ulogd.h=
 or
>> something like that. But not exporting all those jhash.h, linux_rbtr=
ee.h
>> and so on.
>=20
> Your point is correct...
>=20
>> 2) Related to the previous point, if we make public some API, we'll =
have
>> to get attached to them to ensure backward compatibility. If we supp=
ort
>> external modules, we'll have to engage to not changing the exported =
API,
>> otherwise people may complain about breakages of their external modu=
les.
>> All those files that you have exported means quite a lot APIs that w=
e'll
>> have to get attached to.
>=20
>=20
> This is not what I was trying to do. The only goal was compilation
> outside of tree. Target was not to provide a complete and fixed plugi=
n
> infrastructure. In this case, a clean and stable API is really needed=
=2E=20

Yes, but that compilation needs those header files to compile because i=
t
will use functions that are implemented in ulogd2, right? Otherwise, I
don't see the point of making them all public.

>> I have my concerns with regards to this patch from both the technica=
l
>> approach and the new policy that it introduces.
>=20
> I agree for a revert of this commit. I can push it if you want.

Please, go ahead. Thanks Eric.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
