From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Mon, 13 Feb 2006 12:13:34 +0100
Message-ID: <20060213111334.GR4601@sunbeam.de.gnumonks.org>
References: <43EFF176.3070505@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eu9PQ+LfZADlAtIa"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <43EFF176.3070505@netfilter.org>
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


--Eu9PQ+LfZADlAtIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 13, 2006 at 03:39:50AM +0100, Pablo Neira Ayuso wrote:
> [CTNETLINK] Fix expectaction mask dumping

Thanks, Pablo.  This patch looks fine to me.  One cosmetic comment
though:

> Besides, this modification introduces the attribute CTA_IP_L3NUM.

Please call it CTA_L3NUM or something like that.  Nobody says that we
will always and only deal with protocols that are called IP[vX].

If nobody else has any other comments, I suggest you resubmit with this
requested change, and I'll apply and push to davem for net-2.6.17

Thanks!
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Eu9PQ+LfZADlAtIa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8GneXaXGVTD0i/8RAqooAJsEOTOENTpFMiwvkTOIKZbw9XmWxACfVycS
k4bjCP/7NoKvbaOBG3Sh2Ys=
=tYPp
-----END PGP SIGNATURE-----

--Eu9PQ+LfZADlAtIa--
