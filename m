Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53DAC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 19:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5EDE20659
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 19:55:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T1GkjIuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbfKUTzB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 14:55:01 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45918 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726293AbfKUTzB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 14:55:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574366099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dDP9zZHWWVzhM5nlApK7sPPP8e0+XOdW9eP7EvaEtHM=;
        b=T1GkjIuA/i/7mfNxior4PTCrdOXrU9xsf5H24kNILwSYQIgqaRg3362WgvPzpOr1yJNUtq
        W6Lrz4+zwARMxb/UYzUsW01UN0tONIkZCfyeBozPNmX+PwpXY9wy0W/xmNUMY/ApAqP/e8
        +1dzzlzJF0OI7g5Cl37qR/qm8zRP784=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-Y1mU7YDVP6CxmAmwU_Xv1A-1; Thu, 21 Nov 2019 14:54:56 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 204B11883545;
        Thu, 21 Nov 2019 19:54:54 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AED0C26E43;
        Thu, 21 Nov 2019 19:54:50 +0000 (UTC)
Date:   Thu, 21 Nov 2019 20:54:42 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: Re: [PATCH nf-next 3/8] nf_tables: Add set type for arbitrary
 concatenation of ranges
Message-ID: <20191121205442.5eb3d113@redhat.com>
In-Reply-To: <20191120150609.GB20235@breakpoint.cc>
References: <cover.1574119038.git.sbrivio@redhat.com>
        <6da551247fd90666b0eca00fb4467151389bf1dc.1574119038.git.sbrivio@redhat.com>
        <20191120150609.GB20235@breakpoint.cc>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: Y1mU7YDVP6CxmAmwU_Xv1A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 20 Nov 2019 16:06:09 +0100
Florian Westphal <fw@strlen.de> wrote:

> Stefano Brivio <sbrivio@redhat.com> wrote:
> > +static bool nft_pipapo_lookup(const struct net *net, const struct nft_=
set *set,
> > +=09=09=09      const u32 *key, const struct nft_set_ext **ext)
> > +{
> > +=09struct nft_pipapo *priv =3D nft_set_priv(set);
> > +=09unsigned long *res_map, *fill_map;
> > +=09u8 genmask =3D nft_genmask_cur(net);
> > +=09const u8 *rp =3D (const u8 *)key;
> > +=09struct nft_pipapo_match *m;
> > +=09struct nft_pipapo_field *f;
> > +=09bool map_index;
> > +=09int i;
> > +
> > +=09map_index =3D raw_cpu_read(nft_pipapo_scratch_index); =20
>=20
> I'm afraid this will need local_bh_disable to prevent reentry from
> softirq processing.

I'm afraid you're right and yes, not just this: from here to the point
where we're done using scratch maps or their index. Adding in v2.

Well, at least vectorised versions for (at least) x86, ARM and s390x
won't have any overhead from it as they will already do that with
kernel_fpu_begin()/kernel_neon_begin().

> > +=09rcu_read_lock(); =20
>=20
> All netfilter hooks run inside rcu read section, so this isn't needed.

Dropping in v2.

> > +static int pipapo_realloc_scratch(struct nft_pipapo_match *m,
> > +=09=09=09=09  unsigned long bsize_max)
> > +{
> > +=09int i;
> > +
> > +=09for_each_possible_cpu(i) {
> > +=09=09unsigned long *scratch;
> > +
> > +=09=09scratch =3D kzalloc_node(bsize_max * sizeof(*scratch) * 2,
> > +=09=09=09=09       GFP_KERNEL, cpu_to_node(i));
> > +=09=09if (!scratch)
> > +=09=09=09return -ENOMEM; =20
>=20
> No need to handle partial failures on the other cpu / no rollback?
> AFAICS ->destroy will handle it correctly, i.e. next insertion may
> enter this again and allocate a same-sized chunk, so AFAICS its fine.

There's no need because this is just called on insertion, so the new
scratch maps will be bigger than the previous ones, and if only some
allocations here succeed, that means some CPUs have a bigger allocated
map, but the element is not inserted and the extra room is not used,
because the caller won't update m->bsize_max.

> But still, it looks odd -- perhaps add a comment that there is no need
> to rollback earlier allocs.

Sure, added.

> > +
> > +=09=09kfree(*per_cpu_ptr(m->scratch, i)); =20
>=20
> I was about to ask what would prevent nft_pipapo_lookup() from accessing
> m->scratch.  Its because "m" is the private clone.  Perhaps add a
> comment here to that effect.

I renamed 'm' to 'clone' and updated kerneldoc header, I think it's
even clearer than a comment that way.

> > + * @net:=09Network namespace
> > + * @set:=09nftables API set representation
> > + * @elem:=09nftables API element representation containing key data
> > + * @flags:=09If NFT_SET_ELEM_INTERVAL_END is passed, this is the end e=
lement
> > + * @ext2:=09Filled with pointer to &struct nft_set_ext in inserted ele=
ment
> > + *
> > + * In this set implementation, this functions needs to be called twice=
, with
> > + * start and end element, to obtain a valid entry insertion. Calls to =
this
> > + * function are serialised, so we can store element and key data on th=
e first
> > + * call with start element, and use it on the second call once we get =
the end
> > + * element too. =20
>=20
> What guaranttess this?

Well, the only guarantee that I'm expecting here is that the insert
function is not called concurrently in the same namespace, and as far
as I understand that comes from nf_tables_valid_genid(). However:

> AFAICS userspace could send a single element, with either
> NFT_SET_ELEM_INTERVAL_END, or only the start element.

this is all possible, and:

- for a single element with NFT_SET_ELEM_INTERVAL_END, we'll reuse the
  last 'start' element ever seen, or an all-zero key if no 'start'
  elements were seen at all

- for a single 'start' element, no element is added

If the user chooses to configure firewalling with syzbot, my assumption
is that all we have to do is to avoid crashing or leaking anything.

We could opt to be stricter indeed, by checking that a single netlink
batch contains a corresponding number of start and end elements. This
can't be done by the insert function though, we don't have enough
context there.

A possible solution might be to implement a ->validate() callback
similar to what's done for chains -- or maybe export the context to
insert functions so that we can relate stuff to portid/seq.

Do you think it's worth it? In some sense, this should already be all
consistent and safe.

--=20
Stefano

