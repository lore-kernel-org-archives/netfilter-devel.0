From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RESEND] [PATCH] Additional Check to Unclean module
Date: Tue, 14 Jan 2003 20:55:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030114195523.GH18686@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.21.0208062014170.20336-200000@dns.toxicfilms.tv> <Pine.LNX.4.21.0208081943090.6794-200000@dns.toxicfilms.tv> <20030114163725.GD18686@sunbeam.de.gnumonks.org> <20030114170531.GE18686@sunbeam.de.gnumonks.org> <Pine.LNX.4.51.0301141954130.1451@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aYDVKSzuImP48n7V"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.51.0301141954130.1451@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--aYDVKSzuImP48n7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2003 at 07:55:27PM +0100, Maciej Soltysiak wrote:
> > erm, no need for this patch.  The IP version is already checked in the
> > core IPv4 stack, and ip_tables would never receive a non-ipv4 packet
> > anyway.
> Yes, routers and hosts should discard it silently. But it would if the
> packet originated from the host.

well, if the local host's IP stack sends packets with wrong ip version,
there is something really odd going on.  So the only use would be
matching broken packets sent by a privileged local process over a raw
socket.  I don't think that is reason enough to include this check into
ipt_unclean (and have it perform a bogus check for every other packet).

> I had matches of these packets and logged them.
> But that was 6months ago, or so. I would have to check that again.

There was no code change with regard to this behaviour, so I doubt there
was any difference now.

> Maciej

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--aYDVKSzuImP48n7V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+JGsrXaXGVTD0i/8RAop4AJ9Rgr+Y19FJFLVgpXYoo7hF4PTqkQCgouK7
tLGiQake3Y0LCcosq1ITMxk=
=UaFv
-----END PGP SIGNATURE-----

--aYDVKSzuImP48n7V--
