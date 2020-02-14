Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 350A6C35242
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 23:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E411B20848
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 23:06:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBwScsC/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbgBNXGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 18:06:33 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27297 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725955AbgBNXGd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 18:06:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581721592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uSWUosUICrdI54Sd48gaS7Wu7KCcm1bqB2lig1SuJA4=;
        b=ZBwScsC/ekjsdmnolPqhNcbRNJ1aW93PyPYlVHpXdnhZYUnAYSGkhfAVwD/UeJvb/hMUnq
        a5ccjZFq7HgJDXoPQp0YabOxjFGRD7W98Lc1rgf5Z1hEZDabcTcFeaqn9rXcmNw4vH2ZkY
        5Pfvoj4zKB8Fpi2ochJqtx970JuFNXo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-b_o7BQDlNFyiFwfbJ1gZlQ-1; Fri, 14 Feb 2020 18:06:23 -0500
X-MC-Unique: b_o7BQDlNFyiFwfbJ1gZlQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D223800D4E;
        Fri, 14 Feb 2020 23:06:21 +0000 (UTC)
Received: from elisabeth (ovpn-200-54.brq.redhat.com [10.40.200.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBBB75C1C3;
        Fri, 14 Feb 2020 23:06:17 +0000 (UTC)
Date:   Sat, 15 Feb 2020 00:06:01 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v4 5/9] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20200215000601.12ab6626@elisabeth>
In-Reply-To: <20200214204225.dh3ubs67vorh2ail@salvia>
References: <cover.1579647351.git.sbrivio@redhat.com>
        <4e78727d12d54ebd6a6f832585d15f116280dc42.1579647351.git.sbrivio@redhat.com>
        <20200207112308.sqtlvbluujlftqz2@salvia>
        <20200210161047.370582c5@redhat.com>
        <20200214181634.cacy3elfwnankvop@salvia>
        <20200214204213.50b54ed4@redhat.com>
        <20200214204225.dh3ubs67vorh2ail@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 14 Feb 2020 21:42:25 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Fri, Feb 14, 2020 at 08:42:13PM +0100, Stefano Brivio wrote:
> > On Fri, 14 Feb 2020 19:16:34 +0100
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote: =20
> [...]
> > > You refer to a property that says that you can split a range into a
> > > 2*n netmasks IIRC. Do you know what is the worst case when splitting
> > > ranges? =20
> >=20
> > I'm not sure I got your question: that is exactly the worst case, i.e.
> > we can have _up to_ 2 * n netmasks (hence rules) given a range of n
> > bits. There's an additional upper bound on this, given by the address
> > space, but single fields in a concatenation can overlap.
> >=20
> > For example, we can have up to 128 rules for an IPv6 range where at
> > least 64 bits differ between the endpoints, and which would contain
> > 2 ^ 64 addresses. Or, say, the IPv4 range 1.2.3.4 - 255.255.0.2 is
> > expressed by 42 rules.
> >=20
> > By the way, 0.0.0.1 - 255.255.255.254 takes 62 rules, so we can
> > *probably* say it's 2 * n - 2, but I don't have a formal proof for that=
. =20
>=20
> By "splitting" I was actually refering to "expanding", so you're
> replying here to my worst-case range-to-rules expansion question.
>=20
> > I have a couple of ways in mind to get that down to n / 2, but it's not
> > straightforward and it will take me some time (assuming it makes
> > sense). For the n bound, we can introduce negations (proof in
> > literature), and I have some kind of ugly prototype. For the n / 2
> > bound, I'd need some auxiliary data structure to keep insertion
> > invertible. =20
>=20
> OK, so there is room to improve the "rule expansion" logic. I didn't
> spend much time on that front yet.

I wrote some (barely understandable if at all) notes here:
	https://pipapo.lameexcu.se/pipapo/tree/pipapo.c#n271

but I can't guarantee at this stage that it can all be implemented, or
not necessarily in that way. Should you ever (try to) read it, take it
as a rough, buggy draft.

> > In practice, the "average" case is much less, but to define it we would
> > first need to agree on what are the actual components of the
> > multivariate distribution... size and start? Is it a Poisson
> > distribution then? After spending some time on this and disagreeing
> > with myself I'd shyly recommend to skip the topic. :) =20
>=20
> Yes, I agree to stick to something relatively simple and good is just
> fine.
>=20
> > > There is no ipset set like this, but I agree usecase might happen. =20
> >=20
> > Actually, for ipset, a "net,port,net,port" type was proposed
> > (netfilter-devel <20181216213039.399-1-oliver@uptheinter.net>), but when
> > J=C3=B3zsef enquired about the intended use case, none was given. So ma=
ybe
> > this whole "net,net,port,mac" story makes even less sense. =20
>=20
> Would it make sense to you to restrict pipapo to 3 fields until there
> is someone with a usecase for this?

I wouldn't. I'd rather implement the dynamic switch of bucket size if
this is the alternative. I think the current version is rather generic,
doesn't use too much memory, and is also reasonably tested, so I don't
feel like taking working functionality away.

> [...]
> > > The per-cpu scratch index is only required if we cannot fit in the
> > > "result bitmap" into the stack, right? =20
> >=20
> > Right.
> >  =20
> > > Probably up to 256 bytes result bitmap in the stack is reasonable?
> > > That makes 8192 pipapo rules. There will be no need to disable bh and
> > > make use of the percpu scratchpad area in that case. =20
> >=20
> > Right -- the question is whether that would mean yet another
> > implementation for the lookup function. =20
>=20
> This would need another lookup function that can be selected from
> control plane path. The set size and the range-to-rule expansion
> worst-case can tell us if it would fit into the stack. It's would be
> just one extra lookup function for this case, ~80-100 LOC.

Ah, you're right, it's not much. On the other hand, advantages seems to
be:

- dropping the local_bh_{disable,enable}() pair: I can't find numbers
  right now, but the difference in pps between v2 (when Florian pointed
  out it was needed) and v1 wasn't statistically relevant

- avoiding the access to per-cpu allocated areas, here I have
  before/after numbers just for net,mac with 1000 entries on the AVX2
  implementation (AMD 7351, one thread), it didn't look significant,
  3.99Mpps instead of 3.90Mpps. Maybe it would make a difference when
  tested on more threads though (as a reference, same CPU, 10 threads,
  as of v2: 38.02Mpps) or with smaller L2

- memory usage (and how that affects locality on some archs), but if we
  do this for cases with small numbers of entries, it's probably not a
  big difference either

Anyway, I guess it's worth a try -- I'll try to find some time for it.

> > > If adjusting the code to deal with variable length "pipapo word" size
> > > is not too convoluted, then you could just deal with the variable word
> > > size from the insert / delete / get (slow) path and register one
> > > lookup function for the version that is optimized for this pipapo word
> > > size. =20
> >=20
> > Yes, I like this a lot -- we would also need one function to rebuild
> > tables when the word size changes, but that sounds almost trivial.
> > Changes for the slow path are actually rather simple.
> >
> > Still, I start doubting quite heavily that my original worst case is
> > reasonable. If we stick to the one you mentioned, or even something in
> > between, it makes no sense to keep 4-bit buckets. =20
>=20
> OK, then moving to 8-bits will probably remove a bit of code which is
> dealing with "nibbles".

Right now I have:
	 1 file changed, 16 insertions(+), 37 deletions(-)

but okay, I'll give the dynamic switch a try, first.

> > By the way, I went ahead and tried the 8-bit bucket version of the C
> > implementation only, on my usual x86_64 box (one thread, AMD Epyc 7351).
> > I think it's worth it:
> >=20
> >                 4-bit       8-bit
> > net,port
> >  1000 entries   2304165pps  2901299pps
> > port,net
> >  100 entries    4131471pps  4751247pps
> > net6,port
> >  1000 entries   1092557pps  1651037pps
> > port,proto
> >  30000 entries   284147pps   449665pps
> > net6,port,mac
> >  10 entries     2082880pps  2762291pps
> > net6,port,mac,proto
> >  1000 entries    783810pps  1195823pps
> > net,mac
> >  1000 entries   1279122pps  1934003pps =20
>=20
> Assuming the same concatenation type, larger bucket size makes pps
> drop in the C implementation?

Uh, no, they go up with larger buckets, in the figures above we have
+26%, +15%, +51%, +58%, +33%, +53%, +51%.

> > I would now proceed extending this to the AVX2 implementation and (once
> > I finish it) to the NEON one, I actually expect bigger gains there. =20
>=20
> Good. BTW, probably you can add a new NFT_SET_CLASS_JIT class that
> comes becomes NFT_SET_CLASS_O_1 to make the set routine that selects
> the set pick the jit version instead.

It's not exactly JIT though :) it's hand-written assembly. It's coming
up a bit nicer for NEON as I can use compiler intrinsics there.

Maybe I didn't understand your point, but I don't think this is needed.
In 9/9 of v4 I simply had, in nft_pipapo_avx2_estimate():

	if (!boot_cpu_has(X86_FEATURE_AVX2) || !boot_cpu_has(X86_FEATURE_AVX))
		return false;

> > > Probably adding helper function to deal with pipapo words would help
> > > to prepare for such update in the future. There is the ->estimate
> > > function that allows to calculate for the best word size depending on
> > > all the information this gets from the set definition. =20
> >=20
> > Hm, I really think it should be kind of painless to make this dynamic
> > on insertion/deletion. =20
>=20
> OK, good. How would you like to proceed?

Let me give a shot at the dynamic bucket size switching. If that looks
reasonable, I'd proceed extending that to the AVX2 implementation,
finish the NEON implementation including it right away, and prepare a
series. If it doesn't, I'll report back :)

--=20
Stefano

