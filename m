From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 25 Nov 2010 22:46:29 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33754 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311Ab0KYVqa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:46:30 -0500
In-Reply-To: <4CEE70CE.60502@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-11-25 15:21, Pablo Neira Ayuso wrote:

> On 25/11/10 14:35, Jan Engelhardt wrote:
>>
>> On Thursday 2010-11-25 12:42, Pablo Neira Ayuso wrote:
>>>>
>>>> nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);
>>>
>>> This has to go upon nfnetlink as other netfilter subsystems.
>>
>> Why so? It is not like Netlink protocols were limited to 32 AFAICS.
>> Also as told, nfnetlink is not fit for parsing netlink messages wher=
e
>> an attribute type appears more than once. If anything, I would look
>> into genetlink, though that also starts to look like it cannot do
>> that.
>
>All netfilter subsystems must go over nfnetlink, dot.

Sorry, I don't quite buy that argument just yet. There ought to be some=
=20
technical arguments that justify the use of an extra layer like=20
nfnetlink=C2=A0=E2=80=94 other than the version field in struct nfgenms=
g.

In fact, why don't we just use genetlink for new code instead?


>BTW, I didn't look at your protocol in deep yet but I'd suggest the=20
>following basis to rework it: one netlink message, one rule operation.

I can agree with that suggestion, so I will be doing that.


>Because the Netlink RFC doesn't make any statement, it doesn't mean=20
>that you can make assumptions.

On the other extreme, Perl5 has shown that, when there is no full
specification, the code fills in. As it stands, af_netlink.c does
support attribute ordering :-)


>What error can cause a dump from the kernel to be aborted? If we reall=
y need
>this, the point would be to add it to netlink instead of introducing s=
ome
>ad-hoc facility.

Some memory needs to be allocated and stored, right before=20
netlink_dump_start is called. It cannot be stored however, because=20
nlk->cb->cb_args is inaccessible from outside of the dump function. So=20
the lookup and allocation is currently done inside the dump function=20
during its first iteration, and can return ENOENT, EINVAL, ENOMEM and=20
all that.


>Again, the RFC is a useless argument for this, look for a better one.=20
>Encapsulating structures into TLVs is a *really bad practise* since yo=
u=20
>have to stick to the structure layout, which is indeed the problem tha=
t=20
>we have faced in iptables for 10 years, and that many other interfaces=
=20
>in the Linux kernel have.

And yet, when Dave was presented with two alternating proposals for=20
64-bit interface counters, he preferred to have struct rtnl_link_stats6=
4=20
used for IFLA_STATS64 rather than one-attribute-per-entity.

Something is rotten in the state of net/. ;-)


>Supporting the encapsulation of the structure during some time (during=
 the
>transition) may be OK, but it's definitely not the way to go in the lo=
ng run.
>Moreover, if we support Netlink on the wire in the future, you'll
>have problems with encapsulated structures.

=46uture, yes. Requiring doing that now=C2=A0=E2=80=94 increasing the p=
atch queue depth=20
and time-to-kernel=C2=A0=E2=80=94 is not productive. A developer's (dig=
ital) health=20
is downed by todo lists, and replenished by successful merges/patch=20
application.


thanks,
Jan
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
