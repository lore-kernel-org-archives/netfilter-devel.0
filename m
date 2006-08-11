From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Bug (minor) in ip_tables.c?
Date: Thu, 10 Aug 2006 19:54:23 -0600
Message-ID: <44DBE34F.8080902@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1B36F0738D443AFD0E611EC2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1B36F0738D443AFD0E611EC2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

In init() in ip_tables.c, if nf_register_sockopt() fails, then the
function returns failure without unregistering the targets and matches
that it provides.  To correct this, init() should be changed to
something like this:

static int __init ip_tables_init(void)
{
	int ret;

	xt_proto_init(AF_INET);

	/* Noone else will be downing sem now, so we won't sleep */
	xt_register_target(&ipt_standard_target);
	xt_register_target(&ipt_error_target);
	xt_register_match(&icmp_matchstruct);

	/* Register setsockopt */
	ret =3D nf_register_sockopt(&ipt_sockopts);
	if (ret < 0) {
		duprintf("Unable to register sockopts.\n");
                goto failure_sockopt;
	}

	printk("ip_tables: (C) 2000-2006 Netfilter Core Team\n");
	return 0;

failure_sockopt:
	xt_unregister_match(AF_INET, &icmp_matchstruct);
	xt_unregister_target(AF_INET, &ipt_error_target);
	xt_unregister_target(AF_INET, &ipt_standard_target);
	xt_proto_fini(AF_INET);

        return ret;
}


Rennie deGraaf


--------------enig1B36F0738D443AFD0E611EC2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE2+NUIvU5mZP08HERAjlrAJ9cA7cuQIDgDzMRzaF6MgYk8aaIqQCfWvJD
wfu7jDJkkS23o/HXskt5/GY=
=ssJ8
-----END PGP SIGNATURE-----

--------------enig1B36F0738D443AFD0E611EC2--
