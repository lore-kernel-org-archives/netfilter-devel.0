From: Harald Welte <laforge@netfilter.org>
Subject: Re: License of libiptc
Date: Thu, 19 Aug 2004 13:53:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819115300.GS3921@sunbeam.de.gnumonks.org>
References: <05FEBCD8-ED29-11D8-9EB5-000A95678CE8@norad.org> <20040819110805.GK3921@sunbeam.de.gnumonks.org> <508E4607-F1D1-11D8-B9D0-000A95678CE8@norad.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yY6OajYROBmoEVZC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stefan Arentz <stefan.arentz@norad.org>
Content-Disposition: inline
In-Reply-To: <508E4607-F1D1-11D8-B9D0-000A95678CE8@norad.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yY6OajYROBmoEVZC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 19, 2004 at 01:17:10PM +0200, Stefan Arentz wrote:

> Is it ok use system("iptables ...") to talk to iptables from non-GPL=20
> software?

yes, of course.

> One thing I just wrote is a module that allows you to control=20
> ip_conntrack's records. Through a simple /proc interface I can now=20
> flush records belonging to a certain tuple.

ctnetlink was developed exactly for this kind of operation (and is
already used by commercial vendors such as Astaro).

> Now this obviously has to be GPLd, which is no problem and we will=20
> comply to that, but what I was thinking, maybe it is useful to put this=
=20
> in a more generic ipconntrackctl command. There have been many requests=
=20
> on this and other mailing lists about wanting more control over=20
> ipconntrack (mostly about manually flushing records), and this could be=
=20
> a simple and effective solution.

No, ctnetlink is the way to go.  But we're happy if you want to write
ipconntrackctl that uses ctnetlink as backend interface to conntrack :)

>  S.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yY6OajYROBmoEVZC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJJScXaXGVTD0i/8RAuACAJ9OR5GhOD72l59eZqWMm6UGbf55wgCffrrn
v0t6wK50CXOjVp9wkpPhGsE=
=assj
-----END PGP SIGNATURE-----

--yY6OajYROBmoEVZC--
