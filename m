From: netfilter@interlinx.bc.ca
Subject: How to create a "persistent" expectation with newnat?
Date: Mon, 24 Feb 2003 00:18:15 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030224051810.GB7523@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s/l3CgOIzMHHjg/5"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--s/l3CgOIzMHHjg/5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am writing (actually 99% done) a conntracker/nat helper pair for
gnutella.  The only part of the protocol it's interested in currently
is allowing for the client behind the iptables box to have incoming
connections to it's listening port.

It works, but with one caveat.  Every time a new incoming (i.e.
related) connection is made, the expectation that allows it is
"reaped" and another incoming connection cannot be made until another
expectation is set up by the conntracker.

What I want to do is when the conntracker sets up the expectation,
tell netfilter not to remove the expectation when a related connection
is successfully made but leave it there allowing for more related
connections.

I currently have my ip_conntrack_helper configured as follows:

    memset(&gnutella_helper, 0, sizeof(struct ip_conntrack_helper));
    gnutella_helper.tuple.src.u.tcp.port =3D htons(6346);
    gnutella_helper.tuple.dst.protonum =3D IPPROTO_TCP;
    gnutella_helper.mask.src.u.tcp.port =3D 0xFFFF;
    gnutella_helper.mask.dst.protonum =3D 0xFFFF;
    gnutella_helper.max_expected =3D 10;
    gnutella_helper.timeout =3D 180;
    gnutella_helper.flags =3D IP_CT_HELPER_F_REUSE_EXPECT;
    gnutella_helper.me =3D ip_conntrack_gnutella;
    gnutella_helper.help =3D help;
    gnutella_helper.name =3D "gnutella";

and my expectation registration as follows:

    expect.tuple =3D ((struct ip_conntrack_tuple)
                    { { 0, { 0 } },
                      { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
                        { htons(exp_gnutella_info->port) },
                        IPPROTO_TCP } });
    expect.mask =3D ((struct ip_conntrack_tuple)
                   { { 0, { 0 } },
                     { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
    expect.expectfn =3D NULL;
    ip_conntrack_expect_related(ct, &expect);

I thought the max_expected =3D 10 would achieve what I want but all I
ever seem to get is one expectation waiting and it goes away as soon
as I get one connection (as observed by both /proc/net/ip_conntrack
and seeing "blocking" rules in the firewall where a connection should
be allowed because of the expectation).

Am I doing something wrong, or is what I want to do ust not doable?

b.

--=20
Brian J. Murrell

--s/l3CgOIzMHHjg/5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+WasSl3EQlGLyuXARAskpAJ4sDzLxbWzHz1XqRmfCMKdsnCaIkgCgg+ri
SEoUD7uYrPh2x1SDlFF3d+8=
=AiPj
-----END PGP SIGNATURE-----

--s/l3CgOIzMHHjg/5--
