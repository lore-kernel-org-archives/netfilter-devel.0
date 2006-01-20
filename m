From: Tom Eastep <teastep@shorewall.net>
Subject: Re: new iptables policy match
Date: Fri, 20 Jan 2006 07:54:40 -0800
Message-ID: <200601200754.40865.teastep@shorewall.net>
References: <BAY103-F3EE617C3194F61E05CC5CB2270@phx.gbl>
	<43C616B1.6060101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2616150.4r1aZrcEDi";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43C616B1.6060101@trash.net>
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

--nextPart2616150.4r1aZrcEDi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 12 January 2006 00:43, Patrick McHardy wrote:

>
> Yes, --next is needed only if your policy has multiple elements, like
> "--mode tunnel --tunnel-src 1.2.3.4/32 --next --mode transform". I'll
> fix up the userspace part to reject this incorrect use.

The second of those patches (Revision 6395 -- Move empty policy element che=
ck=20
to also catch last element) has broken compatibility with previous versions=
=20
of policy match.

Previously, the following command succeeded and matched any traffic that is=
 to=20
be subsequently transformed:

gw:~ # iptables -A foo -m policy --pol ipsec --dir out -j ACCEPT
iptables v1.3.4: policy match: empty policy element
Try `iptables -h' or 'iptables --help' for more information.
gw:~ #

Is this incompatibility intentional? If so, I need to change Shorewall=20
accordingly.=20

Thanks,
=2DTom
=2D-=20
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--nextPart2616150.4r1aZrcEDi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD0QfAO/MAbZfjDLIRAgsZAJ490+rxZE2GFQZMAVPZxLuUpJtRigCfXOmt
lwhK6XYnPEL+3a3V+au0cPk=
=yEgQ
-----END PGP SIGNATURE-----

--nextPart2616150.4r1aZrcEDi--
