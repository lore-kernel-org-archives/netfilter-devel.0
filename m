From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Subject: Interesting failure with RPC state tracker
Date: 21 May 2003 17:58:55 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053554334.2072.50.camel@pc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VoqriTGiPNgHhVEvCQ2O"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-VoqriTGiPNgHhVEvCQ2O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have been trying to get NFS to work through Netfilter with the rpc
mdoule in p-o-m/extra.

I have finally gotten it to work successfully, but the struggle I had
getting it to work had an interesting outcome.

The reason my initial attempts failed is because the RPC tracking module
depends on intercepting GETPORT calls and opening expectations on the
assumption that if a client asks for the port for a given service on a
given server, it will want to connect to it.

The problem that this causes with Linux's "mount" command is that the
mount command (in util-linux) does a RPC portmap "DUMP" (tcp:111 on the
server) just like "rpcinfo -p" does.  It then extracts the port number
from there.

If you put a rule in the filter to block access to the portmapper's TCP
port on the server, the above process fails and then normal RPC
processing continues, with a GETPORT call to determine the port number.

Thots?

b.

--=20
Brian J. Murrell <netfilter@interlinx.bc.ca>

--=-VoqriTGiPNgHhVEvCQ2O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQA+y/ael3EQlGLyuXARAnrsAJ9hPQAHkW9u9kT0tLaJWdgJnjoyJACeP6j6
QhOe4HJJM38dynriWsqMTlc=
=u+GG
-----END PGP SIGNATURE-----

--=-VoqriTGiPNgHhVEvCQ2O--
