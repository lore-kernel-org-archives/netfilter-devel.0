From: Eric Leblond <eric@inl.fr>
Subject: libconntrack usage
Date: Sun, 04 Dec 2005 01:39:42 +0100
Message-ID: <1133656782.17460.11.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-9pxk0Mck/nzJQUboo8z5"
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


--=-9pxk0Mck/nzJQUboo8z5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

INL has develop a daemon (nutrackd) which use the libconntrack. It opens
event handler for DESTROY event and to register the callback it uses :
	nfct_register_callback(cth, update_handler, NULL);
and this work well, our handler is called.

But is still display [DESTROY] on stdout after each message.

By doing :
    nfct_unregister_callback(cth);
    nfct_register_callback(cth, update_handler, NULL);
we manage to suppress the useless message.

Is this a bug or a feature ?

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-9pxk0Mck/nzJQUboo8z5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDkjrOnxA7CdMWjzIRAgz8AKCEYj1Ho1z5i4ozdP5MJmViodBr/gCfSVs4
gLF1KtMkCEulRw4zpUWaoTU=
=I8Le
-----END PGP SIGNATURE-----

--=-9pxk0Mck/nzJQUboo8z5--
