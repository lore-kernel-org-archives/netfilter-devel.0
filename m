From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables-addons 1.32/ipset-GENL 5.2
Date: Thu, 6 Jan 2011 04:21:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101060322370.28915@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101040456270.11091@obet.zrqbmnf.qr> <4D2524DB.8090408@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36474 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1AFDVs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:21:48 -0500
In-Reply-To: <4D2524DB.8090408@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-01-06 03:11, Pablo Neira Ayuso wrote:
>On 04/01/11 05:14, Jan Engelhardt wrote:
>> '=E3=81=A1=E3=82=8F
>>=20
>> So a few people had been asking on whether ipset 5.x will be bundled=
=20
>> along with Xtables-addons. Naturally this is a difficult question=20
>> because ipset-5 wants a kernel patch. But yes, it is included as of =
Xt-a=20
>> 1.32 (just out).
>>=20
>> It has been augmented to not require the patch anymore, by moving it=
=20
>> over from nfnetlink (booo) to genetlink which does not depend on sta=
tic=20
>> numbers, though you will need at least Linux 2.6.35 for this GENL=20
>> variant in both compilation and at runtime.
>
>Not depending of static numbers is a good thing to me because it makes
>the whole user-space simpler since: a) you don't have to send a messag=
e
>to perform the initial family ID lookup and b) you don't have to
>subscribe to genl control events (which is required since the the
>floating family number may change if the module is unloaded).

Sounds like genl could benefit from a pinning mechanism; rather than
just using CTRL_CMD_GETFAMILY, a CTRL_CMD_GETIT would use
module_get(genl_ops->owner) to grab the module, with the reverse
being a CTRL_CMD_PUTBACK, which is then also implicit on closing the
nl socket.

>> (As such, ipset-5 is deactivated by default in Xt-a 1.32 and needs t=
o be=20
>> turned on in mconfig.)
>>=20
>> Xt-a files at the usual place.
>>=20
>> The plain genl patch to ipset-5 can be found as a commit at=20
>> git://dev.medozas.de/ipset in the "genl" branch. It has received a r=
un=20
>> through the testsuite (as far as it went until ospf), and I take tha=
t as=20
>> an indication that proxying the protocol onto genl was successful.
>
>This is going to confuse everyone. Since ipset-5 will be submitted int=
o
>mainline soon, some distributors may start packaging the user-space ge=
nl
>binaries.

Some distributors also package kernels patched with random things.

=46alls under the well-known answer field of "those who have no clue
should not touch it".

Not providing a tarball, not providing a diff, stowing away the code
in git, and stowing it away in a non-default branch as is done with
ipset-genl keeps out the worst offenders.

Getting involved in NF packages in major distros works proactively
against incompatible or rotten package submissions.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
