From: aton <aton@packetdropped.org>
Subject: bug in libnetfilter_log
Date: Tue, 7 Feb 2006 23:09:39 +0100
Message-ID: <20060207230939.08f0f908.aton@packetdropped.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
	micalg="PGP-SHA1";
	boundary="Signature=_Tue__7_Feb_2006_23_09_39_+0100_fxncDPiUMSdOKW7E"
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

--Signature=_Tue__7_Feb_2006_23_09_39_+0100_fxncDPiUMSdOKW7E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi!

i installed:

- libnfnetlink-0.0.14
- libnetfilter_log-0.0.12=20


the file libnetfilter_log-0.0.12/utils/nfulnl_test.c uses nflog_get_payload=
();

if i just compile it and run it, it will segfault, while returning from cb(=
).
if i comment out the call to nflog_get_payload(), it wont segfault.

so i guess this function call somehow overwrites the return address of the =
cb() function on the stack.=20


i dont understand the nflog_get_payload() code by looking at it, and dont h=
ave time to read into it,=20
so i just wanted to inform the one who wrote it.
please have a look at it, i think this perhaps even could be a security ris=
k?


greetings, aton

--Signature=_Tue__7_Feb_2006_23_09_39_+0100_fxncDPiUMSdOKW7E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD6Rqy3tb8MHRI6dcRAs4eAJ4przUDPtNOaXGKLb5msTO/omQ4sQCeIdk1
uuPhZIt1r3aYpeo2oOUix7Y=
=dT+N
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Feb_2006_23_09_39_+0100_fxncDPiUMSdOKW7E--
