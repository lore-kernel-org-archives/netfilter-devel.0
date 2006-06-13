From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 0/2] Specify nf_queue max length from userspace
Date: Tue, 13 Jun 2006 18:56:28 +0200
Message-ID: <1150217788.7164.4.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-fGNY+xUx37QRGDFeH9Yu"
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


--=-fGNY+xUx37QRGDFeH9Yu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

With libnetfilter_queue it was not anymore possible to specify the max
queue length from userspace. All needed framework was already in
nfnetlink_queue code and as queue instance has its own max length, it
was thus possible to specify max length on a per queue basis.

To be able to do so, I've added a new function nfq_set_queue_maxlen to
libnetfilter_queue and done needed modifications in nfnetlink_queue
code.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-fGNY+xUx37QRGDFeH9Yu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBEju48nxA7CdMWjzIRAjGOAJ9Kpzb7eXq1E0tkHECyPzjY6sqX5ACfZQI9
FtdeXw5NRvf3JmDv9YAxRVw=
=5LyR
-----END PGP SIGNATURE-----

--=-fGNY+xUx37QRGDFeH9Yu--
