From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@pandora.barbara.eu.org>
Subject: ipt_account match, 0.2.x tree.
Date: Wed, 12 May 2004 22:59:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040512205950.GB21447@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_pandora.barbara.ds.polsl.gliwice.pl-23446-1084395591-0001-2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-23446-1084395591-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I'm proud to present new ipt_account match, version 0.2.2. It's extended
version of ipt_account match present already in patch-o-matic-ng.=20

Features:
- one iptables rule for all hosts in network/netmask
- subviews of large table
- both 32bit and 64bit traffic counters for tcp/udp/icmp/other
- autohiding for rarely updated entries in table
- switchable autosum of all counters
- loading/saving counters (by reading/writting to procfs entries)

Homesite: http://www.barbara.eu.org/~quaker/ipt_account2/
(sorry, it's in polish only, I'm looking for someone who may translate
it, even partialy, into english).

Patch against stable version of patch-o-matic-ng:
http://www.barbara.eu.org/~quaker/ipt_account2/files/ipt_account-patch-o-ma=
tic-ng.diff.gz

Patch against iptables 1.2.9:
http://www.barbara.eu.org/~quaker/ipt_account2/files/ipt_account-iptables.d=
iff.gz

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--=_pandora.barbara.ds.polsl.gliwice.pl-23446-1084395591-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFAopBGgEmu6PNADqoRAruTAJ4xI7K37JsZTTOIOSC2hy4+E1DJJwCeN0tX
echUdzIapNs4Tqlz/KFVXOQ=
=f5CK
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-23446-1084395591-0001-2--
