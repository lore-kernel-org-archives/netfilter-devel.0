From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [netfilter-core] TimeBlock
Date: Wed, 9 Oct 2002 17:07:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009170755.A13233@sunbeam.de.gnumonks.org>
References: <000801c26e96$24999570$1400000a@sneak>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOY+hQj86lETlGFu"
Cc: <coreteam@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ilo Lorusso" <ilo@gmsg.co.za>
Content-Disposition: inline
In-Reply-To: <000801c26e96$24999570$1400000a@sneak>; from ilo@gmsg.co.za on Tue, Oct 08, 2002 at 08:44:21AM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BOY+hQj86lETlGFu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2002 at 08:44:21AM +0200, Ilo Lorusso wrote:
> How does the idea of having time feature included in the DENYoption, so a
> person can DENY Access to curtain resources on based on time.

1) read http://www.netfilter.org/contact.html [this suggestion should have
   gone to netfilter-devel

2) this has been discussed before

3) there are two possibilities of achieving your goal
   a) use crontab to change your ruleset
   b) use the 'time' match from patch-o-matic

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--BOY+hQj86lETlGFu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pEZLXaXGVTD0i/8RApUcAJ9PpZJAqh6vOh6n5QdHIgEgEzaglwCfYVkp
z+Xcg6VaXwp9HI5bmL+RW8U=
=DRVh
-----END PGP SIGNATURE-----

--BOY+hQj86lETlGFu--
