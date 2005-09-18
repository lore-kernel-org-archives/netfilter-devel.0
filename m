From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] NETFILTER: New PPTP helper
Date: Sun, 18 Sep 2005 15:28:37 +0200
Message-ID: <20050918132837.GI8413@sunbeam.de.gnumonks.org>
References: <20050915145406.GC17121@rama.de.gnumonks.org>
	<4329F94E.4060107@trash.net>
	<20050916091548.GO5034@sunbeam.de.gnumonks.org>
	<20050916.154556.116608678.davem@davemloft.net>
	<20050916225131.GS8413@sunbeam.de.gnumonks.org>
	<432C443C.5010101@trash.net> <432C563D.7050607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hix8K3b8kRbLLbv+"
Cc: netfilter-devel@lists.netfilter.org,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <432C563D.7050607@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Hix8K3b8kRbLLbv+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Patrkick, thanks for your comments.

On Sat, Sep 17, 2005 at 07:45:33PM +0200, Patrick McHardy wrote:
> Following are my remaining suggestions. Mostly really minor things.
>=20
> First, wouldn't it make sense to make ip_{conntrack,nat}_proto_gre
> usable without pptp as well?

That's how all helpers up to kernel 2.6.12 looked like.  However,  you
cannot track GRE without some higher-level module. The reason is that
GRE (if at all) uses a single KEY instead of source destination port.

In netfilter-speak, the "key" is part of tuple.dst.u, and if
pkt_to_tuple() has to resolve the full tuple.  Without some higher level
module (such as pptp) telling the GRE tracking code which key belongs to
the key in the opposite direction, there is no way it could work.

Since a lot of GRE applications (such as ip-over-gre) don't even use the
optional key, you're back to the good old "generic" conntrack, and you
can't distinguish multiple sessions between two IP's.

Since for PPTP the "four modules" approach caused many user problems,
and there was no other sensible use of the GRE code in sight, I dropped
that idea.

> diff --git a/net/ipv4/netfilter/ip_conntrack_helper_pptp.c=20
> b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
> new file mode 100644
> --- /dev/null
> +++ b/net/ipv4/netfilter/ip_conntrack_helper_pptp.c
>=20
> I would prefer the name ip_conntrack_pptp.c for consisteny with
> other helpers. Same for ip_nat_helper_pptp.c.

AFAIK, that's not possible, since the resulting module is called
ip_conntrack_pptp.ko , but it is a multi-object module.  Again, this
change was only introduced in the 2.6.13 version when gre and pptp files
were linked together for a single kernel module.

I don't think that consistency in soucre file naming is a valid reason
to abandon this combination, though.

And if at all, I would argue that the existing code is inconsistently
named and that we should introduce _helper into the existing ones [like
we have _proto for protocoks] ;)

> +static int timeout_ct_or_exp(const struct ip_conntrack_tuple *t)
> +{
> +    struct ip_conntrack_tuple_hash *h;
> +    struct ip_conntrack_expect *exp;
> +
> +    DEBUGP("trying to timeout ct or exp for tuple ");
> +    DUMP_TUPLE(t);
> +
> +    h =3D __ip_conntrack_find(t, NULL);
> +    if (h)  {
> +        struct ip_conntrack *sibling =3D tuplehash_to_ctrack(h);
> +        DEBUGP("setting timeout of conntrack %p to 0\n", sibling);
> +        sibling->proto.gre.timeout =3D 0;
> +        sibling->proto.gre.stream_timeout =3D 0;
> +        /* refresh_acct will not modify counters if skb =3D=3D NULL */
> +        ip_ct_refresh_acct(sibling, 0, NULL, 0);
>=20
> The regular way of doing this (del_timer, call ct->timeout.function)
> seems cleaner too me.

ok, no problem with that. I thought it was better to not expose
conntrack details into the helper, but I'll change it.
=20
> +/* timeout GRE data connections */
> +static int pptp_timeout_related(struct ip_conntrack *ct)
>=20
> The return value of this function isn't used, so timeout_ct_or_exp and
> itself can be made void.=20

Ok, old versions of the code presumably used that value, that's probably
the reason why it returns something.  I've resolved it now.

> The name also seems a bit misleading since it wants to destroy related
> conntracks and is not used in any function dealing with timouts - how
> about pptp_destroy_related()?

Well, it sets the timeout to zero.  So the name refers to the verbal
form "to timeout the connection".  But I'm happy to rename it.

> +EXPORT_SYMBOL(ip_pptp_lock);
>=20
> This export is not used.

ok, removed

> diff --git a/net/ipv4/netfilter/ip_conntrack_pptp_priv.h=20
> b/net/ipv4/netfilter/ip_conntrack_pptp_priv.h
> new file mode 100644
> --- /dev/null
> +++ b/net/ipv4/netfilter/ip_conntrack_pptp_priv.h
> +@@ -0,0 +1,24 @@
> +#ifndef _IP_CT_PPTP_PRIV_H
> +#define _IP_CT_PPTP_PRIV_H
> +
> +/* PptpControlMessageType names */
> +static const char *strMName[] =3D {
>=20
> This should go in the pptp helper itself.

It's used from both the conntrack and the NAT helper - and only
conditional to #defining some DEBUG value.   That's why it's in a
separate header file.  The only way to avoid that would be to
conditionally EXPORT_SYMBOL() it from the conntrack helper, which is
what I did now in the git tree.

> +int
> +ip_ct_gre_keymap_add(struct ip_conntrack *ct,
> +             struct ip_conntrack_tuple *t, int reply)
> +{
> +    struct ip_ct_gre_keymap *km, *old;
> +
> +    if (!ct->helper || strcmp(ct->helper->name, "pptp")) {
> +        DEBUGP("refusing to add GRE keymap to non-pptp session\n");
> +        return -1;
> +    }
> +
> +    km =3D kmalloc(sizeof(*km), GFP_ATOMIC);
> +    if (!km)
> +        return -1;
> +
> +    /* initializing list head should be sufficient */
> +    memset(km, 0, sizeof(*km));
>=20
> The comment doesn't match the code.

exactly, thats why there is a comment.  It should be sufficient, but
when I wrote the code I wanted to be sure. Maybe I should be prefixed
with "FIXME:".  Anyway, I'll check if list initialization is really
enough, and then either do it or use kzalloc()

As it turned out, initialization is not needed for the whole structure.

> +    memcpy(&km->tuple, t, sizeof(*t));
> +
> +    if (!reply) {
> +        if (ct->help.ct_pptp_info.keymap_orig) {
> +            kfree(km);
> +
> +            /* check whether it's a retransmission */
> +            old =3D LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
> +                    struct ip_ct_gre_keymap *, t);
> +            if (old =3D=3D ct->help.ct_pptp_info.keymap_orig) {
> +                DEBUGP("retransmission\n");
> +                return 0;
> +            }
> +
> +            DEBUGP("trying to override keymap_orig for ct %p\n",
> +                ct);
> +            return -2;
>=20
> All users only check for <=3D 0, using -1 or -EEXIST or something seems
> cleaner than using magic values.

ack.

>=20
> +        }
> +        ct->help.ct_pptp_info.keymap_orig =3D km;
> +    } else {
> +        if (ct->help.ct_pptp_info.keymap_reply) {
> +            kfree(km);
> +
> +            /* check whether it's a retransmission */
> +            old =3D LIST_FIND(&gre_keymap_list, gre_key_cmpfn,
> +                    struct ip_ct_gre_keymap *, t);
> +            if (old =3D=3D ct->help.ct_pptp_info.keymap_reply) {
> +                DEBUGP("retransmission\n");
> +                return 0;
> +            }
> +
> +            DEBUGP("trying to override keymap_reply for ct %p\n",
> +                ct);
> +            return -2;
> +        }
> +        ct->help.ct_pptp_info.keymap_reply =3D km;
>=20
> It looks like the above blocks could be merged by using a pointer
> to ct->help.ct_pptp_info.keymap_{orig,reply}. Memory allocation
> can then be moved below the "if (!reply)" block.

ack.

>=20
> +void __exit ip_ct_proto_gre_fini(void)
> +{
> +    struct list_head *pos, *n;
> +
> +    /* delete all keymap entries */
> +    write_lock_bh(&ip_ct_gre_lock);
> +    list_for_each_safe(pos, n, &gre_keymap_list) {
> +        DEBUGP("deleting keymap %p at module unload time\n", pos);
> +        list_del(pos);
> +        kfree(pos);
>=20
> break;
>=20
> +    }
> +    write_unlock_bh(&ip_ct_gre_lock);


Why would you want to have a break statement?  We really want to iterate
over the list and delete all (for some strange reason) not yet kfree'd
keymaps at module unload time.

I originally added the code during development to notify me of (and
clean up) any keymap memory leaks.   I don't know of any such leaks
being left for quite some time, so we could make the whole block #ifdef
DEBUG_PPTP.   However, it doesn't hurt to make sure by leaving it in.
What do you think?

> +/* generate unique tuple ... */
> +static int +gre_unique_tuple(struct ip_conntrack_tuple *tuple,
> +         const struct ip_nat_range *range,
> +         enum ip_nat_manip_type maniptype,
> +         const struct ip_conntrack *conntrack)
> +{
> +    u_int32_t min, i, range_size;
> +    u_int16_t key =3D 0, *keyptr;
>=20
> How about using the same static u_int16_t key trick used in
> the other NAT helpers to increase chances of finding an unused
> tuple at the first try?

Sure. The PPTP code predates that trick by a couple of years, and I
forgot to add it later on.

The resulting code is now in my netfilter-2.6.14 tree.  I'll submit
later today.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Hix8K3b8kRbLLbv+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDLWuFXaXGVTD0i/8RAsYmAJ4x3HBtGNsYY5lgiWCk4Xdp5IdpBgCfXlrg
rXdE3cHXDIgeuYGzx0OFkR0=
=wDha
-----END PGP SIGNATURE-----

--Hix8K3b8kRbLLbv+--
