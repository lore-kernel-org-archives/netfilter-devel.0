From: Tom Eastep <teastep@shorewall.net>
Subject: Re: TCPMSS is not restricted to mangle table
Date: Sun, 4 Dec 2005 16:55:54 -0800
Message-ID: <200512041656.08736.teastep@shorewall.net>
References: <4393895D.1020106@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1904693.xITBCiksZf";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4393895D.1020106@trash.net>
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

--nextPart1904693.xITBCiksZf
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 04 December 2005 16:27, Patrick McHardy wrote:
> I just noticed the TCPMSS target is not restricted to the
> mangle table. Any opinions about whether we should change
> this, perhaps with a warning period?

You are aware that the iptables man page includes an example of the TCPMSS=
=20
target being used in the filter table?=20

=2DTom
=2D-=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--nextPart1904693.xITBCiksZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDk5AoO/MAbZfjDLIRAmZcAJ40x6EgrMkfq/Y518Z1H9j5ryzaxQCfZzFW
shiHH4345Wn79v22H5EVjng=
=Zhyi
-----END PGP SIGNATURE-----

--nextPart1904693.xITBCiksZf--
