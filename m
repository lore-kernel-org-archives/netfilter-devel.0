From: Harald Welte <laforge@netfilter.org>
Subject: Re: Experimental RTSP modules
Date: Fri, 23 May 2003 21:58:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523195843.GQ3077@sunbeam.de.gnumonks.org>
References: <20030406033532.GA23082@home.tig-grr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gmhhrsDozM2n+uz5"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Tom Marshall <tommy@home.tig-grr.com>
Content-Disposition: inline
In-Reply-To: <20030406033532.GA23082@home.tig-grr.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gmhhrsDozM2n+uz5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 05, 2003 at 07:35:32PM -0800, Tom Marshall wrote:
> Please note this is an experimental module.  It works for me.  It may work
> for you, it may panic your kernel, or it may just sit there using ram.

great news. If you could convert it to patch-o-matic format, I'm happy
to include it!

>  * Handle multiple SETUP messages in a single packet.
>  * Un-mangle client_port on return trip.

Any progress so far?

>  * IPv6 modules

ipv6 is not supported by conntrack or NAT, so I guess that's going to be
hard to support :)  This is has been discussed quite a number of times
on the devel list.

> Hints for implementing IPv6 conntrack and nat modules especially apprecia=
ted
> (why are there no IRC or FTP modules for IPv6?)

see above...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gmhhrsDozM2n+uz5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zn1zXaXGVTD0i/8RAvtiAJ4qomwl4Nueea3CvVSAhbJkl0abOgCeNjS7
3R/PbAbmncZdRvsxnXjYO6w=
=3WQI
-----END PGP SIGNATURE-----

--gmhhrsDozM2n+uz5--
