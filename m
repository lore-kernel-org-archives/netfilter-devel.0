Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEC4C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 11:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95CA922310
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 11:50:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SkCsTY4x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfKTLuI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:50:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37857 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727619AbfKTLuI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 06:50:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574250606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=74SkTJe7BBji724fANxEaRt0+bpIfQS4HuTygIThi1s=;
        b=SkCsTY4xUE1ZvP/zT9ea+0y8nz4xR0lOyFKQvZLUPPyjP14I4xvBAQaOF/JgxeyKTKLU1A
        PYL6UpMc7U84SAIPcxaY18aXlhFRso7SKOdj6D9xxw1LjuaPtavY7NU+5JHQTfECOSkNQC
        ZJXc8Evt+MvzZjv06bLRNlV5oSN915A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-HN7EgokuOWaq8V5-y3kWvA-1; Wed, 20 Nov 2019 06:50:03 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5EA9D1883521;
        Wed, 20 Nov 2019 11:50:02 +0000 (UTC)
Received: from localhost (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0233E3DA7;
        Wed, 20 Nov 2019 11:49:59 +0000 (UTC)
Date:   Wed, 20 Nov 2019 12:49:54 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?UTF-8?B?SsOzenNlZg==?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>
Subject: Re: [PATCH nft 2/3] src: Add support for concatenated set ranges
Message-ID: <20191120124954.0740a1a5@redhat.com>
In-Reply-To: <20191119221238.GF8016@orbyte.nwl.cc>
References: <20191119010712.39316-1-sbrivio@redhat.com>
        <20191119010712.39316-3-sbrivio@redhat.com>
        <20191119221238.GF8016@orbyte.nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: HN7EgokuOWaq8V5-y3kWvA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, 19 Nov 2019 23:12:38 +0100
Phil Sutter <phil@nwl.cc> wrote:

> Hi,
>=20
> On Tue, Nov 19, 2019 at 02:07:11AM +0100, Stefano Brivio wrote:
> [...]
> > diff --git a/src/netlink.c b/src/netlink.c
> > index 7306e358..b8bfd199 100644
> > --- a/src/netlink.c
> > +++ b/src/netlink.c =20
> [...]
> > @@ -199,10 +210,39 @@ static void netlink_gen_concat_data(const struct =
expr *expr,
> >  =09=09memset(data, 0, sizeof(data));
> >  =09=09offset =3D 0;
> >  =09=09list_for_each_entry(i, &expr->expressions, list) {
> > -=09=09=09assert(i->etype =3D=3D EXPR_VALUE);
> > -=09=09=09mpz_export_data(data + offset, i->value, i->byteorder,
> > -=09=09=09=09=09div_round_up(i->len, BITS_PER_BYTE));
> > -=09=09=09offset +=3D netlink_padded_len(i->len) / BITS_PER_BYTE;
> > +=09=09=09if (i->etype =3D=3D EXPR_RANGE) {
> > +=09=09=09=09const struct expr *e;
> > +
> > +=09=09=09=09if (is_range_end)
> > +=09=09=09=09=09e =3D i->right;
> > +=09=09=09=09else
> > +=09=09=09=09=09e =3D i->left;
> > +
> > +=09=09=09=09offset +=3D netlink_export_pad(data + offset,
> > +=09=09=09=09=09=09=09     e->value, e);
> > +=09=09=09} else if (i->etype =3D=3D EXPR_PREFIX) {
> > +=09=09=09=09if (is_range_end) {
> > +=09=09=09=09=09mpz_t v;
> > +
> > +=09=09=09=09=09mpz_init_bitmask(v, i->len -
> > +=09=09=09=09=09=09=09    i->prefix_len);
> > +=09=09=09=09=09mpz_add(v, i->prefix->value, v);
> > +=09=09=09=09=09offset +=3D netlink_export_pad(data +
> > +=09=09=09=09=09=09=09=09     offset,
> > +=09=09=09=09=09=09=09=09     v, i); =20
>=20
> Given the right-alignment, maybe introduce __netlink_gen_concat_data()
> to contain the loop body?

While at it, I would also drop the if (1) that makes this function not
so pretty. It was introduced by 53fc2c7a7998 ("netlink: move data
related functions to netlink.c") where data was turned from a allocated
buffer to VLA, but I don't see a reason why we can't do:

=09unsigned int len =3D expr->len / BITS_PER_BYTE, offset =3D 0;
=09unsigned char data[len];

So, the whole thing would look like (together with the other change
you suggest):

--
static int netlink_gen_concat_data_expr(const struct expr *i,
=09=09=09=09=09unsigned char *data)
{
=09if (i->etype =3D=3D EXPR_RANGE) {
=09=09const struct expr *e;

=09=09if (i->flags & EXPR_F_INTERVAL_END)
=09=09=09e =3D i->right;
=09=09else
=09=09=09e =3D i->left;

=09=09return netlink_export_pad(data, e->value, e);
=09}

=09if (i->etype =3D=3D EXPR_PREFIX) {
=09=09if (i->flags & EXPR_F_INTERVAL_END) {
=09=09=09int count;
=09=09=09mpz_t v;

=09=09=09mpz_init_bitmask(v, i->len - i->prefix_len);
=09=09=09mpz_add(v, i->prefix->value, v);
=09=09=09count =3D netlink_export_pad(data, v, i);
=09=09=09mpz_clear(v);
=09=09=09return count;
=09=09}

=09=09return netlink_export_pad(data, i->prefix->value, i);
=09}

=09assert(i->etype =3D=3D EXPR_VALUE);

=09return netlink_export_pad(data, i->value, i);
}

static void netlink_gen_concat_data(const struct expr *expr,
=09=09=09=09    struct nft_data_linearize *nld)
{
=09unsigned int len =3D expr->len / BITS_PER_BYTE, offset =3D 0;
=09unsigned char data[len];
=09const struct expr *i;

=09memset(data, 0, len);

=09list_for_each_entry(i, &expr->expressions, list)
=09=09offset +=3D netlink_gen_concat_data_expr(i, data + offset);

=09memcpy(nld->value, data, len);
=09nld->len =3D len;
}
--

Is that better?

>=20
> > +=09=09=09=09=09mpz_clear(v);
> > +=09=09=09=09=09continue;
> > +=09=09=09=09}
> > +
> > +=09=09=09=09offset +=3D netlink_export_pad(data + offset,
> > +=09=09=09=09=09=09=09     i->prefix->value,
> > +=09=09=09=09=09=09=09     i);
> > +=09=09=09} else {
> > +=09=09=09=09assert(i->etype =3D=3D EXPR_VALUE);
> > +
> > +=09=09=09=09offset +=3D netlink_export_pad(data + offset,
> > +=09=09=09=09=09=09=09     i->value, i);
> > +=09=09=09}
> >  =09=09}
> > =20
> >  =09=09memcpy(nld->value, data, len);
> > @@ -247,13 +287,14 @@ static void netlink_gen_verdict(const struct expr=
 *expr,
> >  =09}
> >  }
> > =20
> > -void netlink_gen_data(const struct expr *expr, struct nft_data_lineari=
ze *data)
> > +void netlink_gen_data(const struct expr *expr, struct nft_data_lineari=
ze *data,
> > +=09=09      int end) =20
>=20
> s/end/is_range_end/ for consistency?

Oops, yes, it had 'is_range_end' in the prototype but not here.
Probably dropping this anyway.

> >  {
> >  =09switch (expr->etype) {
> >  =09case EXPR_VALUE:
> >  =09=09return netlink_gen_constant_data(expr, data);
> >  =09case EXPR_CONCAT:
> > -=09=09return netlink_gen_concat_data(expr, data);
> > +=09=09return netlink_gen_concat_data(expr, data, end);
> >  =09case EXPR_VERDICT:
> >  =09=09return netlink_gen_verdict(expr, data);
> >  =09default:
> > @@ -712,8 +753,14 @@ void alloc_setelem_cache(const struct expr *set, s=
truct nftnl_set *nls)
> >  =09const struct expr *expr;
> > =20
> >  =09list_for_each_entry(expr, &set->expressions, list) {
> > -=09=09nlse =3D alloc_nftnl_setelem(set, expr);
> > +=09=09nlse =3D alloc_nftnl_setelem(set, expr, 0);
> >  =09=09nftnl_set_elem_add(nls, nlse);
> > +
> > +=09=09if (set->set_flags & NFT_SET_SUBKEY) {
> > +=09=09=09nlse =3D alloc_nftnl_setelem(set, expr, 1);
> > +=09=09=09nftnl_set_elem_add(nls, nlse);
> > +=09=09}
> > + =20
>=20
> Can't we drop 'const' from expr declaration and temporarily set
> EXPR_F_INTERVAL_END to carry the is_interval_end bit or does that mess
> up set element creation?

No, it actually works nicely, I simply didn't think of that.

> What I don't like about your code is how it adds an expression-type
> specific parameter to netlink_gen_data which is supposed to be
> type-agnostic. Avoiding this would also shrink this patch quite a bit.

Indeed, I also didn't like that, thanks for the tip. I'm changing this
in v2.

> [...]
> > diff --git a/src/parser_bison.y b/src/parser_bison.y
> > index 3f283256..2b718971 100644
> > --- a/src/parser_bison.y
> > +++ b/src/parser_bison.y =20
> [...]
> > @@ -3941,7 +3940,24 @@ basic_rhs_expr=09=09:=09inclusive_or_rhs_expr
> >  =09=09=09;
> > =20
> >  concat_rhs_expr=09=09:=09basic_rhs_expr
> > -=09=09=09|=09concat_rhs_expr=09DOT=09basic_rhs_expr
> > +=09=09=09|=09multiton_rhs_expr
> > +=09=09=09|=09concat_rhs_expr=09=09DOT=09multiton_rhs_expr
> > +=09=09=09{
> > +=09=09=09=09if ($$->etype !=3D EXPR_CONCAT) {
> > +=09=09=09=09=09$$ =3D concat_expr_alloc(&@$);
> > +=09=09=09=09=09compound_expr_add($$, $1);
> > +=09=09=09=09} else {
> > +=09=09=09=09=09struct location rhs[] =3D {
> > +=09=09=09=09=09=09[1]=09=3D @2,
> > +=09=09=09=09=09=09[2]=09=3D @3,
> > +=09=09=09=09=09};
> > +=09=09=09=09=09location_update(&$3->location, rhs, 2);
> > +=09=09=09=09=09$$ =3D $1;
> > +=09=09=09=09=09$$->location =3D @$;
> > +=09=09=09=09}
> > +=09=09=09=09compound_expr_add($$, $3);
> > +=09=09=09}
> > +=09=09=09|=09concat_rhs_expr=09=09DOT=09basic_rhs_expr =20
>=20
> So this is the fifth copy of the same piece of code. :(
>=20
> Isn't there a better way to solve that?

I couldn't think of any.

> If not, we could at least introduce a function compound_expr_alloc_or_add=
().

Right, added. The only ugly aspect is that we also need to update the
location of $3 here, and I don't think we should export
location_update() from parser_bison.y, so this function needs to be in
parser_byson.y itself, I guess.

> [...]
> > diff --git a/src/rule.c b/src/rule.c
> > index 4abc13c9..377781b1 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c =20
> [...]
> > @@ -1618,15 +1620,15 @@ static int do_command_insert(struct netlink_ctx=
 *ctx, struct cmd *cmd)
> > =20
> >  static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd=
)
> >  {
> > -=09struct handle *h =3D &cmd->handle;
> >  =09struct expr *expr =3D cmd->expr;
> > +=09struct handle *h =3D &cmd->handle; =20
>=20
> Unrelated change?

Oops.

> >  =09struct table *table;
> >  =09struct set *set;
> > =20
> >  =09table =3D table_lookup(h, &ctx->nft->cache);
> >  =09set =3D set_lookup(table, h->set.name);
> > =20
> > -=09if (set->flags & NFT_SET_INTERVAL &&
> > +=09if (set->flags & NFT_SET_INTERVAL && !(set->flags & NFT_SET_SUBKEY)=
 && =20
>=20
> Maybe introduce set_is_non_concat_range() or something? Maybe even a
> macro, it's just about:
>=20
> | return set->flags & (NFT_SET_INTERVAL | NFT_SET_SUBKEY) =3D=3D NFT_SET_=
INTERVAL;

I'm adding that as static inline together with the other set_is_*()
functions in rule.h, it looks consistent.

> [...]
> > diff --git a/src/segtree.c b/src/segtree.c
> > index 9f1eecc0..e49576bc 100644
> > --- a/src/segtree.c
> > +++ b/src/segtree.c =20
> [...]
> > @@ -823,6 +828,9 @@ static int expr_value_cmp(const void *p1, const voi=
d *p2)
> >  =09struct expr *e2 =3D *(void * const *)p2;
> >  =09int ret;
> > =20
> > +=09if (expr_value(e1)->etype =3D=3D EXPR_CONCAT)
> > +=09=09return -1;
> > + =20
>=20
> Funny how misleading expr_value()'s name is. ;)
>=20
> [...]
> > +/* Given start and end elements of a range, check if it can be represe=
nted as
> > + * a single netmask, and if so, how long, by returning a zero or posit=
ive value.
> > + */
> > +static int range_mask_len(mpz_t start, mpz_t end, unsigned int len)
> > +{
> > +=09unsigned int step =3D 0, i;
> > +=09mpz_t base, tmp;
> > +=09int masks =3D 0;
> > +
> > +=09mpz_init_set_ui(base, mpz_get_ui(start));
> > +
> > +=09while (mpz_cmp(base, end) <=3D 0) {
> > +=09=09step =3D 0;
> > +=09=09while (!mpz_tstbit(base, step)) {
> > +=09=09=09mpz_init_set_ui(tmp, mpz_get_ui(base));
> > +=09=09=09for (i =3D 0; i <=3D step; i++)
> > +=09=09=09=09mpz_setbit(tmp, i);
> > +=09=09=09if (mpz_cmp(tmp, end) > 0) {
> > +=09=09=09=09mpz_clear(tmp);
> > +=09=09=09=09break;
> > +=09=09=09}
> > +=09=09=09mpz_clear(tmp);
> > +
> > +=09=09=09step++;
> > +
> > +=09=09=09if (step >=3D len)
> > +=09=09=09=09goto out;
> > +=09=09}
> > +
> > +=09=09if (masks++)
> > +=09=09=09goto out;
> > +
> > +=09=09mpz_add_ui(base, base, 1 << step);
> > +=09}
> > +
> > +out:
> > +=09mpz_clear(base);
> > +
> > +=09if (masks > 1)
> > +=09=09return -1;
> > +=09return len - step;
> > +} =20
>=20
> I don't understand this algorithm.

It basically does the same thing as the function you wrote below, but
instead of shifting 'start' and 'end', 'step' is increased, and set
onto them, so that at every iteration we have the resulting mask
available in 'base'.

That's not actually needed here, though. It's a left-over from a
previous idea of generating composing netmasks in nftables rather than
in the set. I'll switch to the "obvious" implementation.

> Intuitively, I would just:
>=20
> | int tmp =3D len;
> | while (start !=3D end && !(start & 1) && (end & 1) && tmp) {
> |=09start >>=3D 1;
> |=09end >>=3D 1;
> |=09tmp--;
> | }
> | return (tmp && start =3D=3D end) ? len - tmp : -1;
>=20
> Is that slow when dealing with gmp?

I don't think so, it also avoid copies and allocations, while shifting
and setting bits have comparable complexities. I'd go with the gmp
version of this.

--=20
Stefano

