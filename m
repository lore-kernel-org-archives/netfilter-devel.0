Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC2CC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C21E0206A1
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 13:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NOIIj4ew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgGCNjD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 09:39:03 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24617 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726262AbgGCNjC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 09:39:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593783540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oDPMoCT0nXP6ldjBHJgN8KyewtTb/jZzME7n1t3Cfv0=;
        b=NOIIj4eweMgRO4bf5cehBlDKG6C2iJg85ZmpmpLYTN4hmjUbelQ25r3FGk3hikF/2v4I5G
        UHmR3wNnvhjpU8hDKmPS5HEY9GnEvZwVHcjGK045g1C6s8DQArihK7YJbY6xN/Ibj4TQji
        v0wQQy5ybrgksx+63+Gv53Le6cEOr5g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-0jnMYJhNMNa-aA35B7TMfQ-1; Fri, 03 Jul 2020 09:38:44 -0400
X-MC-Unique: 0jnMYJhNMNa-aA35B7TMfQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 265741054F8B;
        Fri,  3 Jul 2020 13:38:38 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 921AB6FEF4;
        Fri,  3 Jul 2020 13:38:35 +0000 (UTC)
Date:   Fri, 3 Jul 2020 15:38:27 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Jozsef Kadlecsik <kadlec@netfilter.org>
Cc:     Timo Sigurdsson <public_timo.s@silentcreek.de>,
        netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: Moving from ipset to nftables: Sets not ready for prime time
 yet?
Message-ID: <20200703153827.2b8974a2@elisabeth>
In-Reply-To: <alpine.DEB.2.22.394.2007031200050.9015@blackhole.kfki.hu>
References: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
        <20200703112809.72eb94bf@elisabeth>
        <alpine.DEB.2.22.394.2007031200050.9015@blackhole.kfki.hu>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi J=C3=B3zsef,

On Fri, 3 Jul 2020 12:24:03 +0200 (CEST)
Jozsef Kadlecsik <kadlec@netfilter.org> wrote:

> On Fri, 3 Jul 2020, Stefano Brivio wrote:
>=20
> > On Fri,  3 Jul 2020 00:30:10 +0200 (CEST)
> > "Timo Sigurdsson" <public_timo.s@silentcreek.de> wrote:
> >  =20
> > > Another issue I stumbled upon was that auto-merge may actually
> > > generate wrong/incomplete intervals if you have multiple 'add
> > > element' statements within an nftables script file. I consider this a
> > > serious issue if you can't be sure whether the addresses or intervals
> > > you add to a set actually end up in the set. I reported this here
> > > [2]. The workaround for it is - again - to add all addresses in a
> > > single statement. =20
> >=20
> > Practically speaking I think it's a bug, but I can't find a formal,
> > complete definition of automerge, so one can also say it "adds items up
> > to and including the first conflicting one", and there you go, it's
> > working as intended.
> >=20
> > In general, when we discussed this "automerge" feature for
> > multi-dimensional sets in nftables (not your case, but I aimed at
> > consistency), I thought it was a mistake to introduce it altogether,
> > because it's hard to define it and whatever definition one comes up
> > with might not match what some users think. Consider this example:
> >=20
> > # ipset create s hash:net,net
> > # ipset add s 10.0.1.1/30,192.168.1.1/24
> > # ipset add s 10.0.0.1/24,172.16.0.1
> > # ipset list s
> > [...]
> > Members:
> > 10.0.1.0/30,192.168.1.0/24
> > 10.0.0.0/24,172.16.0.1
> >=20
> > good, ipset has no notion of automerge, so it won't try to do anything
> > bad here: the set of address pairs denoted by <10.0.1.1/30, =20
> > 192.168.1.1/24> is disjoint from the set of address pairs denoted by =20
> > <10.0.0.1/24, 172.16.0.1>. Then:
> >=20
> > # ipset add s 10.0.0.1/16,192.168.0.0/16
> > # ipset list s
> > [...]
> > Members:
> > 10.0.1.0/30,192.168.1.0/24
> > 10.0.0.0/16,192.168.0.0/16
> > 10.0.0.0/24,172.16.0.1
> >=20
> > and, as expected with ipset, we have entirely overlapping entries added
> > to the set. Is that a problem? Not really, ipset doesn't support maps,
> > so it doesn't matter which entry is actually matched. =20
>=20
> Actually, the flags, extensions (nomatch, timeout, skbinfo, etc.) in ipse=
t=20
> are some kind of mappings and do matter which entry is matched and which=
=20
> flags, extensions are applied to the matching packets.

Oh, I didn't consider that.

> Therefore the matching in the net kind of sets follow a strict ordering:=
=20
> most specific match wins and in the case of multiple dimensions (like=20
> net,net above) it goes from left to right to find the best most specific=
=20
> match.

And I didn't know about this either. Well, this looks a bit arbitrary
to me, also because there's no such thing as hash:port,net, so forcing
the left-to-right precedence won't cover all the possible cases anyway.

In nftables, as sets now support an arbitrary number of dimensions, in
an arbitrary order, that would require an explicit evaluation ordering,
which is actually not too hard to implement. I just doubt the usage
would be practical.

> > # nft add table t
> > # nft add set t s '{ type ipv4_addr . ipv4_addr; flags interval ; }'
> > # nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
> > # nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
> > # nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
> > # nft list ruleset
> > table ip t {
> > 	set s {
> > 		type ipv4_addr . ipv4_addr
> > 		flags interval
> > 		elements =3D { 10.0.1.0/30 . 192.168.1.0/24,
> > 			     10.0.0.0/24 . 172.16.0.1,
> > 			     10.0.0.0/16 . 192.168.0.0/16 }
> > 	}
> > }
> >=20
> > also fine: the least generic entry is added first, so it matches first.
> > Let's try to reorder the insertions:
> >=20
> > # nft add element t s '{ 10.0.0.1/16 . 192.168.0.0/16 }'
> > # nft add element t s '{ 10.0.0.1/24 . 172.16.0.1 }'
> > # nft add element t s '{ 10.0.1.1/30 . 192.168.1.1/24 }'
> > Error: Could not process rule: File exists
> > add element t s { 10.0.1.1/30 . 192.168.1.1/24 }
> > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >=20
> > ...because that entry would never match anything: it's inserted after a
> > more generic one that already covers it completely, and we'd like to
> > tell the user that it doesn't make sense. =20
>=20
> I think sets should not store information about which order the entries=20
> were added. That should totally be indifferent. The input of the sets may=
=20
> come from countless sources and if the order of adding the entries matter=
s=20
> then a preordering is required, which is sometimes non-trivial.

As it comes for free, I think it's nice to leave this possibility open
for simple combinations. It doesn't introduce any ambiguity. It's not
an usage I would recommend anyway, but I don't see the harm.

> > Now, this is pretty much the only advantage of not allowing overlaps:
> > telling the user that some insertion doesn't make sense, and thus it
> > was probably not what the user wanted to do. =20
>=20
> This makes also impossible to make exceptions in the sets in nftables -=20
> with the "nomatch" flag in ipset one can easily create exceptions in=20
> intentionally overlapping entries (in whatever deep nestings) in a single=
=20
> set. In practice it comes quite handy to say
>=20
> ipset create access_to_servers hash:ip,port,net
> ipset add access_to_servers your_ssh_server,22,x.y.z.0/24
> ipset add access_to_servers your_ssh_server,22,x.y.z.32/27 nomatch
> ...
>=20
> and exclude access to some parts of a given subnet.
>=20
> However, the internals of the sets in nftables are totally different from=
=20
> ipset, so I'm pretty sure it's absolutely not trivial (and sometimes=20
> impossible) to provide exactly the same behaviour.

It's actually kind of trivial for nft_set_pipapo, for nft_set_hash it
doesn't apply (it doesn't implement intervals), and I'm not sure about
nft_set_rbtree right now.

However, does this really provide any value compared to having a
separate set for exceptions matched earlier in a chain?

If it really does, I think it could and should be done in userspace by
splitting the intervals. The kernel back-ends shouldn't be overloaded
with complexity that doesn't *need* to live there, and no matter what,
this is going to have a performance impact on the lookup (it should be
doable to avoid an explicit branch for this, but we can't avoid
fetching more bits per element).

Ideally, I would even like to drop the need for timeout and validity
checks as part of the lookup, because they are quite heavy (fetching
the 'extension' pointer, branches, etc.). It involves some internal API
refactoring and is actually on my motionless to-do list, but too far
from the surface to have any practical value.

--=20
Stefano

