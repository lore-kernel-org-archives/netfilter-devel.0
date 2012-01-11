From: Richard Weinberger <richard@nod.at>
Subject: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 02:32:48 +0100
Message-ID: <4F0CE6C0.6080900@nod.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0322B81B7E3F56E67DCF899F"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2AKBcw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:32:52 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0322B81B7E3F56E67DCF899F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi!

I always thought that checkentry()/destroy() are being called upon rule i=
nsertion/deletion.
So I assumed that this command sequence prints three times "test_tg_check=
" and then three times
"test_tg_destroy". But it's not the case.

$ iptables -A INPUT -j TEST
$ iptables -A INPUT -j TEST
$ iptables -A INPUT -j TEST
$ iptables -D INPUT -j TEST
$ iptables -D INPUT -j TEST
$ iptables -D INPUT -j TEST

This is the real output:
(On 3.2.0-rc6)

[90330.168306] test_tg_destroy
[90330.171099] test_tg_destroy
[90330.173901] test_tg_destroy
[90343.768654] test_tg_check
[90345.773073] test_tg_check
[90345.775691] test_tg_check
[90345.778330] test_tg_destroy
[90347.782798] test_tg_check
[90347.785417] test_tg_check
[90347.788044] test_tg_check
[90347.790663] test_tg_destroy
[90347.793454] test_tg_destroy
[90372.581020] test_tg_check
[90372.583639] test_tg_check
[90372.586275] test_tg_destroy
[90372.589059] test_tg_destroy
[90372.591843] test_tg_destroy
[90374.596452] test_tg_check
[90374.599080] test_tg_destroy
[90374.601875] test_tg_destroy
[90376.606409] test_tg_destroy

How comes that?
Is there a way to detect the insertion/removal of a rule using my TEST ta=
rget?

The comments in x_tables.h are not really helpful.
        /* Called when user tries to insert an entry of this type:
           hook_mask is a bitmask of hooks from which it can be
           called. */
        /* Should return 0 on success or an error code otherwise (-Exxxx)=
=2E */
        int (*checkentry)(const struct xt_tgchk_param *);

        /* Called when entry of this type deleted. */
        void (*destroy)(const struct xt_tgdtor_param *);

Thanks,
//richard

P.s: The TEST target is attached.

---
static unsigned int
test_tg(struct sk_buff *skb, const struct xt_action_param *par)
{
        return XT_CONTINUE;
}

static int test_tg_check(const struct xt_tgchk_param *par)
{
        printk(KERN_ERR "test_tg_check\n");
        return 0;
}

static void test_tg_destroy(const struct xt_tgdtor_param *par)
{
        printk(KERN_ERR "test_tg_destroy\n");
}

static struct xt_target test_tg_reg __read_mostly =3D {
        .name           =3D "TEST",
        .family         =3D NFPROTO_IPV4,
        .target         =3D test_tg,
        .targetsize     =3D 0,
        .checkentry     =3D test_tg_check,
        .destroy        =3D test_tg_destroy,
        .me             =3D THIS_MODULE,
};

static void __exit test_exit(void)
{
        xt_unregister_target(&test_tg_reg);
}
module_exit(test_exit);

static int __init test_init(void)
{
        return xt_register_target(&test_tg_reg);
}
module_init(test_init);


--------------enig0322B81B7E3F56E67DCF899F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPDObBAAoJEN9758yqZn9elDYIAJ7oST+tJdpyj1oQtXjt20yo
1ACRfUT5xueTfozEt0znYdQhzZ929B8gcxBeNH3K60g+0RIZX3qDTh6wtJM6OwPz
0yEh+y0IRywRxKO9lXaS1zQyZHmQpys0lMgOYUidWzUxpt0EAtrlfptuyjhPO80M
DYc21ZWgRvrUiVq8Gh8CuUSZ80EJgbw/ChPdG9QSA2ik/NDmoCpdAelOUPgG7AFS
WqHyrXfYZK3Ka0GSEvG8IaU+7f5u+x58YlSPqmRhxz0aflgsICriSREHpsLV2kXn
7BjS3h+9tv+7YHFZOdnUzD4+SrUYSU9VXx3X+n7eewHZD70W7mJBctGr2PQ0iA8=
=+w4m
-----END PGP SIGNATURE-----

--------------enig0322B81B7E3F56E67DCF899F--
