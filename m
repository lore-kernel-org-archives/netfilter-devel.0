From: Harald Welte <laforge@netfilter.org>
Subject: Re: Traffic limitation with iptables
Date: Wed, 23 Jul 2003 14:16:38 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030723121638.GN3733@naboo>
References: <20030722200706.43891e40.epv_xemul@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8884J15jRwcBTvu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xemul <epv_xemul@mail.ru>
Content-Disposition: inline
In-Reply-To: <20030722200706.43891e40.epv_xemul@mail.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--n8884J15jRwcBTvu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 22, 2003 at 08:07:06PM +0400, Xemul wrote:
> Hi.
> I wanna solve such a problem:
> When I see that byte counter on some chain reaches or exceedes any fixed
> value - then IMMEDIATELY insert into that cahin new first rule (e.g. -j
> DROP) or delete some rules from any other chain. Or more abstract - how
> can can discover that byte counter is higher than smth without
> "polling" chains?

you might want to look for the quota match.

btw, this is more a user than a develoment question!
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--n8884J15jRwcBTvu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/HnylXaXGVTD0i/8RAhYEAJ9rUAeZF1TAywcL8pw4khMzl0aZNgCeISbj
G8Ukd0rGE13z1VV0Y0wg10I=
=YWyX
-----END PGP SIGNATURE-----

--n8884J15jRwcBTvu--
