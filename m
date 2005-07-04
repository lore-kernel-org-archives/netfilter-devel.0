From: Harald Welte <laforge@netfilter.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 11:53:51 +0200
Message-ID: <20050704095351.GZ3186@sunbeam.de.gnumonks.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de> <42C8F151.9080708@tac.ch>
	<20050704085913.GX3186@sunbeam.de.gnumonks.org>
	<42C900DA.5040906@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KbRlJ7rsgYPVCYDX"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42C900DA.5040906@tac.ch>
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


--KbRlJ7rsgYPVCYDX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2005 at 11:26:50AM +0200, Roberto Nibali wrote:
> > And anyways, you can defer such processing until the logs are actually
> > being analyzed.  It doesn't have to happen at the time where you have
> > your load spike and just want to get the data to disk.
>=20
> True to a certain extent.
>=20
> The problem is that a lot of different software systems have to be integr=
ated
> and we cannot afford or don't have access to all code to change all backe=
nd
> logic to do this.=20

Well, to be honest I'm happy that I can say - to a certain extend: I
don't care abou your particular setup and it's political/organizational
erstrictions ;)  [don't get me wrong, please].

As always, I think we should provide some infrastructure and let people
use it how they want.  We can try to be flexible, but we cannot optimize
ever possible setup.

Your particular setup would need something like a proxy that does the
interpretation before it ends up at the centralized logging server.
Alternatively you could store the hostname of the firewall and make the
interpretation of such a prefix local to that host.  Now you certainly
can come up with a reason why you can't do that.  And I can frankly
repeat: well, that's your problem ;)  Technically it is possible...

Cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KbRlJ7rsgYPVCYDX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCyQcvXaXGVTD0i/8RAiWoAJ9S6bc25c2XeBMWk4paPtZ9ZAIFYQCfZGKb
pnLi5xZVgz0l+p47+avqCi4=
=ldKT
-----END PGP SIGNATURE-----

--KbRlJ7rsgYPVCYDX--
