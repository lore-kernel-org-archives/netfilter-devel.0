From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 09:25:54 +0100
Message-ID: <4CEF6F12.7080601@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32963 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab0KZI0B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 03:26:01 -0500
In-Reply-To: <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/11/10 22:46, Jan Engelhardt wrote:
>=20
> On Thursday 2010-11-25 15:21, Pablo Neira Ayuso wrote:
>=20
>> On 25/11/10 14:35, Jan Engelhardt wrote:
>>>
>>> On Thursday 2010-11-25 12:42, Pablo Neira Ayuso wrote:
>>>>>
>>>>> nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);
>>>>
>>>> This has to go upon nfnetlink as other netfilter subsystems.
>>>
>>> Why so? It is not like Netlink protocols were limited to 32 AFAICS.
>>> Also as told, nfnetlink is not fit for parsing netlink messages whe=
re
>>> an attribute type appears more than once. If anything, I would look
>>> into genetlink, though that also starts to look like it cannot do
>>> that.
>>
>> All netfilter subsystems must go over nfnetlink, dot.
>=20
> Sorry, I don't quite buy that argument just yet. There ought to be so=
me=20
> technical arguments that justify the use of an extra layer like=20
> nfnetlink =E2=80=94 other than the version field in struct nfgenmsg.

It's a design argument, so it's indeed technical. Nfnetlink provides
multiplexation upon one of the Netlink busses for our netfilter
subsystems. It was introduced a bit before GeNetlink into the Linux
kernel tree although it was already out-of-tree for quite some time
before it was applied.

> In fact, why don't we just use genetlink for new code instead?

Genetlink is similar. The main difference is that the ID family number
and multicast groups for each subsystem is not fixed, it's registered i=
n
runtime. This means that you have to make the "family name resolution",
ie. to send a message to resolve the ID family number and multicast
groups before doing any operation.

Another reason is consistency, it's a good idea to use the mechanism
that other netfilter subsystems already use.

>> BTW, I didn't look at your protocol in deep yet but I'd suggest the=20
>> following basis to rework it: one netlink message, one rule operatio=
n.
>=20
> I can agree with that suggestion, so I will be doing that.

Great, this approach requires more memory because you spend one netlink
header for every rule, but the cost is worth since it provides flexibil=
ity.

>> Because the Netlink RFC doesn't make any statement, it doesn't mean=20
>> that you can make assumptions.
>=20
> On the other extreme, Perl5 has shown that, when there is no full
> specification, the code fills in. As it stands, af_netlink.c does
> support attribute ordering :-)

I agree, it would be great to have some more specifications. However, 1=
)
someone would have to like doing that, and 2) Linux kernel evolves so
quick that documenting aspects remains a daunting task. Anyway, I don't
throw the towel on documentation, actually I'd like to do that.

You are quite prolific in writing documentation, let me know if you are
interested if I write some drafts, in case that you want to
contribute/review. Or let me know if you decide to write something, I'd
be pleased to contribute of course.

>> What error can cause a dump from the kernel to be aborted? If we rea=
lly need
>> this, the point would be to add it to netlink instead of introducing=
 some
>> ad-hoc facility.
>=20
> Some memory needs to be allocated and stored, right before=20
> netlink_dump_start is called. It cannot be stored however, because=20
> nlk->cb->cb_args is inaccessible from outside of the dump function. S=
o=20
> the lookup and allocation is currently done inside the dump function=20
> during its first iteration, and can return ENOENT, EINVAL, ENOMEM and=
=20
> all that.

What is that initial data handling in dumps for?

>> Again, the RFC is a useless argument for this, look for a better one=
=2E=20
>> Encapsulating structures into TLVs is a *really bad practise* since =
you=20
>> have to stick to the structure layout, which is indeed the problem t=
hat=20
>> we have faced in iptables for 10 years, and that many other interfac=
es=20
>> in the Linux kernel have.
>=20
> And yet, when Dave was presented with two alternating proposals for=20
> 64-bit interface counters, he preferred to have struct rtnl_link_stat=
s64=20
> used for IFLA_STATS64 rather than one-attribute-per-entity.
>=20
> Something is rotten in the state of net/. ;-)

If Dave decides that, it's because he's sure that such structure will
suffer any changes in the future. This assumption has been proven to be
wrong in iptables, since matches/targets may be extended in a backward
compatible way to include new features.

>> Supporting the encapsulation of the structure during some time (duri=
ng the
>> transition) may be OK, but it's definitely not the way to go in the =
long run.
>> Moreover, if we support Netlink on the wire in the future, you'll
>> have problems with encapsulated structures.
>=20
> Future, yes. Requiring doing that now =E2=80=94 increasing the patch =
queue depth=20
> and time-to-kernel =E2=80=94 is not productive. A developer's (digita=
l) health=20
> is downed by todo lists, and replenished by successful merges/patch=20
> application.

Indeed, I understand that it will be a lot of work to split every singl=
e
structure for the first patchset. For that reason, I support the idea o=
f
encapsulating structures in the short run. We can later split them.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
