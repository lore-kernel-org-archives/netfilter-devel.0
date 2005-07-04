From: Harald Welte <laforge@netfilter.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 10:59:13 +0200
Message-ID: <20050704085913.GX3186@sunbeam.de.gnumonks.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de> <42C8F151.9080708@tac.ch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3+4FpxPSY/W4B3y"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>, Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42C8F151.9080708@tac.ch>
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


--O3+4FpxPSY/W4B3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 04, 2005 at 10:20:33AM +0200, Roberto Nibali wrote:
> > Do we already have indeterminate log prefix length? I thought we had
> > one, fixed size, no probing neccessary. Am I wrong?
>=20
> No, it's fix. And "probing" can easily be done with a large sized prefix,
> although I'm a bit astonished as to why someone wouldn't know the prefix =
size
> when loading the packet filter ruleset.

I also can't remember that we ever changed the length of that field.

> >>For now, that's the only way an upper-level tool will produce valid
> >>LOG rules in all cases.
> > =20
> > The way to produce valid log rules in all cases, is to keep this
> > fancy long long stuff in user level, and set pointer / index values
> > or whatever small token can be used, for a log prefix in the kernel.
>=20
> This does not work in environments where you need high speed logging since
> having a pointer, or hashmap value, would require an intermediate process=
 to
> translate it into parsable strings again. This is from an
> architectural point of view and from a performance point of view not
> possible, at least not in our environment.

If you care about performance, tou don't do hgh speed logging via
syslog.  I have some numbers comparing LOG with ULOG in multiple setup,
and it's in some cases a factor of 100 ...

OTOTH, ULOG also has a prefix, so the argument remains.  However, I'm
happy if somebody wanted to contribute an ulogd plugin to do that kind
of translation.

And anyways, you can defer such processing until the logs are actually
being analyzed.  It doesn't have to happen at the time where you have
your load spike and just want to get the data to disk.

> It would be a lot more fun to get the connection tracking table filled
> with thousands of entries in less than 2 Minutes, so the monitoring
> system does not have so many spikes.  Customers often ask if the
> system is malfunctioning or down every 5-15 Minutes :).

Sorry, I don't understand what you want to convey....

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--O3+4FpxPSY/W4B3y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCyPphXaXGVTD0i/8RAoauAJ0TmoyAYj37pB1sdCiKl3hS+c4LigCgoqSg
UrveE78JHhnje4PasaGJieM=
=AyBB
-----END PGP SIGNATURE-----

--O3+4FpxPSY/W4B3y--
