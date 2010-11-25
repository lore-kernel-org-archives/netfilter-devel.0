From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Thu, 25 Nov 2010 14:35:35 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37376 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752328Ab0KYNfh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Nov 2010 08:35:37 -0500
In-Reply-To: <4CEE4B94.8010307@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-11-25 12:42, Pablo Neira Ayuso wrote:
>>
>> nfxt_socket =3D socket(AF_NETLINK, SOCK_RAW, NETFILTER_XTABLES);
>
> This has to go upon nfnetlink as other netfilter subsystems.

Why so? It is not like Netlink protocols were limited to 32 AFAICS.
Also as told, nfnetlink is not fit for parsing netlink messages where
an attribute type appears more than once. If anything, I would look
into genetlink, though that also starts to look like it cannot do
that.

>> The Xtables2 Netlink protocol however encodes each node as a
>> standalone attribute, to be called Flat Encoding, that is
>> appended (a. k. a. =E2=80=9Cchained=E2=80=9D) to the data stream. Th=
is makes it
>> possible to split requests and dumps at a finer level than
>> encapsulation would. Above all, it gets extensions the guarantee
>> to have data blocks of a minimum guaranteed size.
>>
>> Since Netlink messages do have a 32-bit quantity to store the
>> message length, rulesets of roughly up to 4 GB are possibile,
>> which is currently regarded as sufficient. The largest (and
>> meaningful) rulesets seen to date in the industry weighed in at
>> approximately 150 MB.
>
>You can split data into several messages and avoid this limitation.

Netlink may have support for splitting messages, but not really
splitting data. So I am just splitting messages at attribute
boundaries like everyone else.

>> Whereas attribute nesting automatically provided for boundaries,
>> this is realized using a dummy attribute in the chained approach.
>> Certain attributes can start such a flattened nesting, and
>> NFXTA_STOP terminates it.
>
> I don't like this trailing attribute, see below.
>
>> This attribute serves to denote the end of a nesting level as
>> introduced by NFXTA_CHAIN, NFXTA_RULE, NFXTA_MATCH or
>> NFXTA_TARGET. It has no data portion.
>>
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> | nla_len =3D 4                   | nla_type =3D NFXTA_STOP         =
|
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
>It's not a good idea to make assumptions on the order of the TLVs in
>a Netlink message. I mean, you should not assume that NFXTA_STOP
>comes after one specific attribute.

Ordering is a necessary constraint with flat encoding. Furthermore,
rules exhibit order, so even if I were to use encapsulated encoding,
there would be ordering requirements.

The Netlink RFC does not make any statements about what is to follow
nlmsghdr; unless I missed something, it does not mention ordering,
not even attributes at all. So XTNL is free to use what it chooses -
including an nlattr32 that is not compatible with nlattr16.

>> 2.2 Dump error code<sub:nfxta_errno>
>>
>> Once a NLM_F_MULTI dump operation has been started, for example
>> with the NFXTM_CHAIN_DUMP request, Netlink kernel users must
>> always end it successfully with NLMSG_DONE. To convey an error
>> during the dump, Xtables2 will emit a NFXTA_ERRNO attribute into
>> the stream (if it can), emit no further attributes for the
>> request, and cause the dump to stop.
>>
>> 0                   1                   2                   3
>> 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> | nla_len =3D 8                   | nla_type =3D NFXTA_ERRNO        =
|
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> | int errno;                                                    |
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> Isn't nlmsg_err OK for your needs?

You cannot abort a dump from the kernel, which is why nlmsg_err
does not get used.

>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> | nla_len =3D 4 + payload         | nla_type =3D NFXTA_DATA         =
|
>> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>> .                                                               .
>> . e.g. struct xt_hashlimit_info
>
>This is fine during some transition period, but Netlink protocols
>must not encapsulate structures in the payload of their TLVs.

I did not see such a requirement in the Netlink RFC.
Of course it is for existing extensions.

>We can avoid this if structures are splitted into several TLVs. You
>can add new attributes and obsolete old ones.

Yes, but not at this stage. Complete architectural rewrites of
everything at once comes with plenty of problems. Linux evolution has
shown that small incremental reviewable patches are the credo.

Do not worry, I left room in XTNL for attributes upgrades.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
