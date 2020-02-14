Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C90C35242
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 19:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA05220873
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 19:42:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YoisqLkF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbgBNTm2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 14:42:28 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56151 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387571AbgBNTm2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 14:42:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581709346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N4Dp1LSmtK328ZwLN4zIMo4lut2zCxodC6uXRS2Lr8M=;
        b=YoisqLkFFvfqSJXtVqv2k+y/vQXREU5Y269BjZSWoVxysHVFwW6XjkliTZTMl8pR99+5LE
        nCmc2GeEsChIZlZ/toWMfYz05qjXv5xQj6JWWH0Dy1LBt5sNj4ATaKBghU+O1VuLF0Lyvm
        EuqKOAUgTjb09UozF2fXOjsubx3DqUw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-204-50BVLYGBPKiIb5EEiSeHvw-1; Fri, 14 Feb 2020 14:42:23 -0500
X-MC-Unique: 50BVLYGBPKiIb5EEiSeHvw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10479107ACCA;
        Fri, 14 Feb 2020 19:42:21 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E6D45DA87;
        Fri, 14 Feb 2020 19:42:18 +0000 (UTC)
Date:   Fri, 14 Feb 2020 20:42:13 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200214204213.50b54ed4@redhat.com>
In-Reply-To: <20200214181634.cacy3elfwnankvop@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
        <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
        <20200207112308.sqtlvbluujlftqz2@salvia>
        <20200210161047.370582c5@redhat.com>
        <20200214181634.cacy3elfwnankvop@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 14 Feb 2020 19:16:34 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Mon, Feb 10, 2020 at 04:10:47PM +0100, Stefano Brivio wrote:
> > On Fri, 7 Feb 2020 12:23:08 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote: =20
> [...]
> > > Did you tests with 8-bits grouping instead of 4-bits? =20
> >=20
> > Yes, at the very beginning, not with the final implementation. It was
> > somewhat faster (on x86_64, I don't remember how much) for small
> > numbers of rules, then I thought we would use too much memory, because:
> >  =20
> > > Assuming a concatenation of 12 bytes (each field 4 bytes, hence 3
> > > fields):
> > >=20
> > > * Using 4-bits groups: the number of buckets is 2^4 =3D 16 multiplied
> > >   by the bucket word (assuming one long word, 8 bytes, 64 pipapo
> > >   rules) is 16 * 8 =3D 128 bytes per group-row in the looking table. =
Then,
> > >   the number of group-rows is 8 given that 32 bits, then 32 / 4 =3D 8
> > >   group-rows.
> > >=20
> > >   8 * 128 bytes =3D 1024 bytes per lookup table.
> > >=20
> > >   Assuming 3 fields, then this is 1024 * 3 =3D 3072 bytes.
> > >=20
> > > * Using 8-bits groups: 2^8 =3D 256, then 256 * 8 =3D 2048 bytes per
> > >   group-row. Then, 32 / 8 =3D 4 group-rows in total.
> > >=20
> > >   4 * 2048 bytes =3D 8192 bytes per lookup table.
> > >=20
> > >   Therefore, 3 * 8192 =3D 24576 bytes. Still rather small.
> > >=20
> > > This is missing the mapping table that links the lookup tables in the
> > > memory counting. And I'm assuming that the number of pipapo rules in
> > > the lookup table fits into 64-bits bucket long word. =20
> >=20
> > ...the (reasonable?) worst case I wanted to cover was two IPv6
> > addresses, one port, one MAC address (in ipset terms
> > "net,net,port,mac"), with 2 ^ 16 unique, non-overlapping entries each
> > (or ranges expanding to that amount of rules), because that's what
> > (single, non-concatenated) ipset "bitmap" types can do. =20
>=20
> I see, so you were considering the worst case. You're assuming each
> element takes exactly one pipapo rule, so it's 2^16 elements, correct?

Yes, right: the ranges I considered would be disjoint and of size one
(single, non-overlapping addresses). I start thinking my worst case is
nowhere close to being reasonable, actually. :)

> You refer to a property that says that you can split a range into a
> 2*n netmasks IIRC. Do you know what is the worst case when splitting
> ranges?

I'm not sure I got your question: that is exactly the worst case, i.e.
we can have _up to_ 2 * n netmasks (hence rules) given a range of n
bits. There's an additional upper bound on this, given by the address
space, but single fields in a concatenation can overlap.

For example, we can have up to 128 rules for an IPv6 range where at
least 64 bits differ between the endpoints, and which would contain
2 ^ 64 addresses. Or, say, the IPv4 range 1.2.3.4 - 255.255.0.2 is
expressed by 42 rules.

By the way, 0.0.0.1 - 255.255.255.254 takes 62 rules, so we can
*probably* say it's 2 * n - 2, but I don't have a formal proof for that.

I have a couple of ways in mind to get that down to n / 2, but it's not
straightforward and it will take me some time (assuming it makes
sense). For the n bound, we can introduce negations (proof in
literature), and I have some kind of ugly prototype. For the n / 2
bound, I'd need some auxiliary data structure to keep insertion
invertible.

In practice, the "average" case is much less, but to define it we would
first need to agree on what are the actual components of the
multivariate distribution... size and start? Is it a Poisson
distribution then? After spending some time on this and disagreeing
with myself I'd shyly recommend to skip the topic. :)

> There is no ipset set like this, but I agree usecase might happen.

Actually, for ipset, a "net,port,net,port" type was proposed
(netfilter-devel <20181216213039.399-1-oliver@uptheinter.net>), but when
J=C3=B3zsef enquired about the intended use case, none was given. So maybe
this whole "net,net,port,mac" story makes even less sense.

> > Also ignoring the mapping table (it's "small"), with 4-bit buckets:
> >=20
> > - for the IPv6 addresses, we have 16 buckets, each 2 ^ 16
> >   bits wide, and 32 groups (128 bits / 4 bits), that is, 8MiB in
> >   total
> >
> > - for the MAC address, 16 buckets, each 2 ^ 16 bits wide, and 12
> >   groups, 1.5MiB
> >
> > - for the port, 16 buckets, each 2 ^ 12 bits wide, 2 groups, 0.25MiB
> >
> > that is, 9.75MiB.
> >=20
> > With 8-bit buckets: we can just multiply everything by 8 (that is,
> > 2 ^ 8 / 2 ^ 4 / 2, because we have 2 ^ (8 - 4) times the buckets, with
> > half the groups), 78MiB. =20
>=20
> Yes, this is large. Compared to a hashtable with 2^16 entries, then
> it's 2^17 hashtable buckets and using struct hlist_head, this is 2
> MBytes. Then, each hlist_node is 16 bytes, so 2^16 * 16 ~=3D 1 MByte.
> That is 3 MBytes if my maths are fine.

Sounds correct to me as well.

> Just telling this to find what could be considered as reasonable
> amount of memory to be consumed. ~10 MBytes is slightly more than, but
> I agree you selected a reasonable worst through this "complex tuple".
>=20
> > And that started feeling like "a lot". However, I'm probably overdoing
> > with the worst case -- this was just to explain what brought me to the
> > 4-bit choice, now I start doubting about it.
> >  =20
> > > Anyway, my understanding is that the more bits you use for grouping,
> > > the larger the lookup table becomes.
> > >=20
> > > Still, both look very small in terms of memory consumption for these
> > > days.
> > >=20
> > > I'm just telling this because the C implementation can probably get
> > > better numbers at the cost of consuming more memory? Probably do this
> > > at some point? =20
> >=20
> > Another topic is the additional amount of cachelines we would use. I
> > don't expect that effect to be visible, but I might be wrong.
> >=20
> > So yes, I think it's definitely worth a try, thanks for the hint! I'll
> > try to look into this soon and test it on a few archs (something with
> > small cachelines, say MIPS r2k, would be worth checking, too).
> >=20
> > We could even consider to dynamically adjust group size depending on
> > the set size, I don't know yet if that gets too convoluted. =20
>=20
> Yes, keeping this maintainable is a good idea.
>=20
> The per-cpu scratch index is only required if we cannot fit in the
> "result bitmap" into the stack, right?

Right.

> Probably up to 256 bytes result bitmap in the stack is reasonable?
> That makes 8192 pipapo rules. There will be no need to disable bh and
> make use of the percpu scratchpad area in that case.

Right -- the question is whether that would mean yet another
implementation for the lookup function.

> If adjusting the code to deal with variable length "pipapo word" size
> is not too convoluted, then you could just deal with the variable word
> size from the insert / delete / get (slow) path and register one
> lookup function for the version that is optimized for this pipapo word
> size.

Yes, I like this a lot -- we would also need one function to rebuild
tables when the word size changes, but that sounds almost trivial.
Changes for the slow path are actually rather simple.

Still, I start doubting quite heavily that my original worst case is
reasonable. If we stick to the one you mentioned, or even something in
between, it makes no sense to keep 4-bit buckets.

By the way, I went ahead and tried the 8-bit bucket version of the C
implementation only, on my usual x86_64 box (one thread, AMD Epyc 7351).
I think it's worth it:

                4-bit       8-bit
net,port
 1000 entries   2304165pps  2901299pps
port,net
 100 entries    4131471pps  4751247pps
net6,port
 1000 entries   1092557pps  1651037pps
port,proto
 30000 entries   284147pps   449665pps
net6,port,mac
 10 entries     2082880pps  2762291pps
net6,port,mac,proto
 1000 entries    783810pps  1195823pps
net,mac
 1000 entries   1279122pps  1934003pps

I would now proceed extending this to the AVX2 implementation and (once
I finish it) to the NEON one, I actually expect bigger gains there.

> Probably adding helper function to deal with pipapo words would help
> to prepare for such update in the future. There is the ->estimate
> function that allows to calculate for the best word size depending on
> all the information this gets from the set definition.

Hm, I really think it should be kind of painless to make this dynamic
on insertion/deletion.

--=20
Stefano

