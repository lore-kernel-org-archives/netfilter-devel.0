From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Session Initiation Protocol
Date: Mon, 9 Sep 2002 12:38:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020909123838.D3810@sunbeam.de.gnumonks.org>
References: <200209051525.44011.calum.sep02@umtstrial.co.uk> <200209061554.01010.lists@ohlmeier.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nils Ohlmeier <lists@ohlmeier.de>
Content-Disposition: inline
In-Reply-To: <200209061554.01010.lists@ohlmeier.de>; from lists@ohlmeier.de on Fri, Sep 06, 2002 at 03:54:00PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 06, 2002 at 03:54:00PM +0200, Nils Ohlmeier wrote:
> On Thursday 05 September 2002 16:25, Calum wrote:
> > With SIP soon to be huge, especially with 3G phones, is there any work
> > underway to make a sip_masq module, a la FTP, or IRC?
>=20
> As far as i know: no.=20

This is true.  I have this on my TODO list (there are people wanting to
sponsor me for implementing SIP/SDP conntrack+nat) - but I don't have the
time before november/december this year.

> Search the mailinglist for previous discussions about this topic.
> Maybe http://fcpd.berlios.de as an application level gateway approach is=
=20
> inetresting for you.

the problem is that FCP never went beyound the ietf draft, since there is
now a MIDCOM working group trying to design a new protocol.

> If you work in a test lab, you should be aware of the problems:=20
> - domain names in the protocol
> - encryption is possible and makes NAT impossible
> - masquerading the initiation protocol is not enough, because you also ha=
ve
> to masquerade the content protocols (which ever this will be; RTP in most=
=20
> cases).

exactly.  also note that RTP/RTCP need two port numbers next to each other,
which is currently not possible using the newnat API.

> Regards
>    Nils Ohlmeier

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9fHotXaXGVTD0i/8RAhw+AJ91l0mqTBVlaCh1wqq5npOTWlnaxgCcC7aa
lVcsD8dy2Cw6ULhHY1P+hgo=
=5eaI
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
