From: Mathieu Geli <geli@enseirb.fr>
Subject: [nfqueue] libnetfilter_queue python wrapper
Date: Wed, 7 Jun 2006 18:05:31 +0200
Message-ID: <20060607180531.09652ae1@ganymede>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Signature_Wed__7_Jun_2006_18_05_31_+0200_cuB3czeffgog2s5/";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: plucas@plucas.org
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

--Signature_Wed__7_Jun_2006_18_05_31_+0200_cuB3czeffgog2s5/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

If anyone is interested I adapted Neale Pickett's ipqueue code for the
libnfnetlink/libnetfilter_queue API. That's called nfqueue. I know the
code is far from perfect and will be glad to receive comments.

You can download it here [1]. I recommend using scapy [2] and
uncommenting the specific lines in the test file.

Cheers

[1] http://mathieu.geli.free.fr/code/nfqueue.tar.gz
[2] http://www.secdev.org/projects/scapy/

--=20
Mathieu GELI

--Signature_Wed__7_Jun_2006_18_05_31_+0200_cuB3czeffgog2s5/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEhvlissGp32GWAFwRArpOAJ9QUvwyQH+ybrER+HmMYdvf4MVTkACgoI8j
zMFCdv/TPPPU38oPRPIv3lw=
=65hZ
-----END PGP SIGNATURE-----

--Signature_Wed__7_Jun_2006_18_05_31_+0200_cuB3czeffgog2s5/--
