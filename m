From: Harald Welte <laforge@gnumonks.org>
Subject: Re: missing ipt_unclean support in 2.6test5
Date: Mon, 15 Sep 2003 11:52:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030915095204.GC777@obroa-skai.de.gnumonks.org>
References: <20030914200347.GA811@baryon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bu8it7iiRSEf40bY"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: garde@benben.com
Content-Disposition: inline
In-Reply-To: <20030914200347.GA811@baryon>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Bu8it7iiRSEf40bY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 14, 2003 at 10:03:47PM +0200, garde@benben.com wrote:
> Hi Harald,
>=20
> I just saw ipt_unclean matching support was removed from the 2.6 tree, is=
 there a place I can find=20
> some background on the reason behind this? Couldn't find anything on
> the lkml or google that provided a better reason than "we feel it's a
> rather insecure part of the netfilter code".

What more background do you want to have?  The netfilter coreteam has
made this decision at the recent netfilter developer conference, because
we think it is a dangerous match.

Filtering like the unclean match can easily introduce
forwards-comaptibility problems.  Just look what happened when the ECN
bits in the ip and tcp header had been defined for congestion
notification by the IETF: suddenly everybody sending packets adhering to
this new standard was unable to reach any machine/network protected by a
netfilter/iptables firewall that used the unclean match.

We just want to make sure that this doesn't ever happen again.  We were
unable to remove ipt_unclean in 2.4.x because of compatibility reasons.
But now in 2.6 it is easy to have it removed.

> Michiel v/d Garde
> Operations Engineer
> MarketXS.com BV

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--Bu8it7iiRSEf40bY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/ZYvDXaXGVTD0i/8RAt9uAJ9Zqd0bg3+JMyk9I+1S74Y0HUMe/ACggNXd
nJtt79IPTSzoK9rudJcVU0E=
=ryZ6
-----END PGP SIGNATURE-----

--Bu8it7iiRSEf40bY--
