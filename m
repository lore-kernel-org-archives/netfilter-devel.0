From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Fri, 22 Oct 2004 12:55:04 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022105504.GC3551@sunbeam.de.gnumonks.org>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cXxibKNEnJOqEg4"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Larsson <alexl@redhat.com>
Content-Disposition: inline
In-Reply-To: <1098214482.6562.125.camel@greebo.homeip.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--7cXxibKNEnJOqEg4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

First of all, let me say that I am much in favour of a conntrack helper
than an ipt_recent-based solution.

> Hmm. I though by setting max_expected to 0 would allow me to get
> multiple expected replies, but i could easily have misread the code. Is
> there no way to expect multiple packets in reply to a single udp
> package?

you just need to re-issue the expectation as soon as it is confirmed by
the first packet (from the expectfn).  If I'm not mistaken, there are
already helpers doing that, although I forgot which ones.

>  Alexander Larsson                                            Red Hat, In=
c=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7cXxibKNEnJOqEg4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBeOcIXaXGVTD0i/8RAnKyAJ9G5+00bGaNNL6zKG4FnakSSSi/LACfeUH8
s5L4ddMikFh/0tfuWqqg49g=
=FP1V
-----END PGP SIGNATURE-----

--7cXxibKNEnJOqEg4--
