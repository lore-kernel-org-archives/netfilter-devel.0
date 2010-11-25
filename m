From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 25 Nov 2010 15:21:02 +0100
Message-ID: <4CEE70CE.60502@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35538 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266Ab0KYOU0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:20:26 -0500
In-Reply-To: <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/11/10 14:35, Jan Engelhardt wrote:
>
> On Thursday 2010-11-25 12:42, Pablo Neira Ayuso wrote:
>>>
>>> nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);
>>
>> This has to go upon nfnetlink as other netfilter subsystems.
>
> Why so? It is not like Netlink protocols were limited to 32 AFAICS.
> Also as told, nfnetlink is not fit for parsing netlink messages where
> an attribute type appears more than once. If anything, I would look
> into genetlink, though that also starts to look like it cannot do
> that.

All netfilter subsystems must go over nfnetlink, dot.

If you are repeating the same attribute in one message, it means that=20
you have to split your data into several messages.

>>> The Xtables2 Netlink protocol however encodes each node as a
>>> standalone attribute, to be called Flat Encoding, that is
>>> appended (a. k. a. =E2=80=9Cchained=E2=80=9D) to the data stream. T=
his makes it
>>> possible to split requests and dumps at a finer level than
>>> encapsulation would. Above all, it gets extensions the guarantee
>>> to have data blocks of a minimum guaranteed size.
>>>
>>> Since Netlink messages do have a 32-bit quantity to store the
>>> message length, rulesets of roughly up to 4 GB are possibile,
>>> which is currently regarded as sufficient. The largest (and
>>> meaningful) rulesets seen to date in the industry weighed in at
>>> approximately 150 MB.
>>
>> You can split data into several messages and avoid this limitation.
>
> Netlink may have support for splitting messages, but not really
> splitting data. So I am just splitting messages at attribute
> boundaries like everyone else.
>
>>> Whereas attribute nesting automatically provided for boundaries,
>>> this is realized using a dummy attribute in the chained approach.
>>> Certain attributes can start such a flattened nesting, and
>>> NFXTA_STOP terminates it.
>>
>> I don't like this trailing attribute, see below.
>>
>>> This attribute serves to denote the end of a nesting level as
>>> introduced by NFXTA_CHAIN, NFXTA_RULE, NFXTA_MATCH or
>>> NFXTA_TARGET. It has no data portion.
>>>
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP        =
 |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>
>> It's not a good idea to make assumptions on the order of the TLVs in
>> a Netlink message. I mean, you should not assume that NFXTA_STOP
>> comes after one specific attribute.
>
> Ordering is a necessary constraint with flat encoding. Furthermore,
> rules exhibit order, so even if I were to use encapsulated encoding,
> there would be ordering requirements.
>
> The Netlink RFC does not make any statements about what is to follow
> nlmsghdr; unless I missed something, it does not mention ordering,
> not even attributes at all. So XTNL is free to use what it chooses -
> including an nlattr32 that is not compatible with nlattr16.

Because the Netlink RFC doesn't make any statement, it doesn't mean tha=
t=20
you can make assumptions. Moreover, that RFC doesn't cover everything i=
n=20
Netlink, that document requires lots of updates or way more RFCs to=20
specify lots of undocumented Netlink aspects.

BTW, you may want to read this:
http://1984.lsi.us.es/~pablo/docs/spae.pdf

It still misses lots of aspects, including this, but we've got some mor=
e=20
new documentation at least. It's not a RFC, it aims to be a tutorial.

>>> 2.2 Dump error code<sub:nfxta_errno>
>>>
>>> Once a NLM_F_MULTI dump operation has been started, for example
>>> with the NFXTM_CHAIN_DUMP request, Netlink kernel users must
>>> always end it successfully with NLMSG_DONE. To convey an error
>>> during the dump, Xtables2 will emit a NFXTA_ERRNO attribute into
>>> the stream (if it can), emit no further attributes for the
>>> request, and cause the dump to stop.
>>>
>>> 0                   1                   2                   3
>>> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> | nla_len =3D 8                   | nla_type =3D NFXTA_ERRNO       =
 |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> | int errno;                                                    |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>
>> Isn't nlmsg_err OK for your needs?
>
> You cannot abort a dump from the kernel, which is why nlmsg_err
> does not get used.

What error can cause a dump from the kernel to be aborted? If we really=
=20
need this, the point would be to add it to netlink instead of=20
introducing some ad-hoc facility.

>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA        =
 |
>>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>>> .                                                               .
>>> . e.g. struct xt_hashlimit_info
>>
>> This is fine during some transition period, but Netlink protocols
>> must not encapsulate structures in the payload of their TLVs.
>
> I did not see such a requirement in the Netlink RFC.
> Of course it is for existing extensions.

Again, the RFC is a useless argument for this, look for a better one.=20
Encapsulating structures into TLVs is a *really bad practise* since you=
=20
have to stick to the structure layout, which is indeed the problem that=
=20
we have faced in iptables for 10 years, and that many other interfaces=20
in the Linux kernel have.

Supporting the encapsulation of the structure during some time (during=20
the transition) may be OK, but it's definitely not the way to go in the=
=20
long run.

Remember that the revision field in iptables is a workaround, and the=20
result in quite dirty code. The aim at that time we add it was to find=20
some temporary solution until we could provide an extensible interface=20
for iptables.

Moreover, if we support Netlink on the wire in the future, you'll have=20
problems with encapsulated structures.

>> We can avoid this if structures are splitted into several TLVs. You
>> can add new attributes and obsolete old ones.
>
> Yes, but not at this stage. Complete architectural rewrites of
> everything at once comes with plenty of problems. Linux evolution has
> shown that small incremental reviewable patches are the credo.
>
> Do not worry, I left room in XTNL for attributes upgrades.

BTW, I didn't look at your protocol in deep yet but I'd suggest the=20
following basis to rework it: one netlink message, one rule operation.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
