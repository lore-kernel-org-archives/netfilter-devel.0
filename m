From: Harald Welte <laforge@netfilter.org>
Subject: Re: Apparent Memory Leak
Date: Thu, 6 Mar 2003 12:23:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030306112327.GC25556@sunbeam.de.gnumonks.org>
References: <1046895061.1738.88.camel@thizzy>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Del Winiecki <delw@wildapache.net>
Content-Disposition: inline
In-Reply-To: <1046895061.1738.88.camel@thizzy>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 05, 2003 at 01:11:00PM -0700, Del Winiecki wrote:
> Hi,
> My Linux router using DNAT/SNAT/mangle etc, all works as expected, but
> am seeing what appears to be a memory leak. As traffic increases,
> available ram disappears and never returns. Eventually it begins to page
> applications to disk, and then I have to reboot it. With no network
> traffic, used memory is static.
> I see a bug at RedHat where someone else had the exact same problem.
> Does anyone know of any memory de-allocation problems at the net buffer
> level?

No, we are not aware of such issue.  And there are in fact lots of
people (with large setups, even at universities) using
netfilter/iptables...

=2E.. so if there really is a memory leak, there has to be something
specific about your setup.

> This router handles internet traffic for 2 isp's and 7 company LAN's, so
> moderately complex iptables setup, tbf rate management for some.

2 isp's... but you don't do asymmetric routing?

what is the average number of conntrack entries you have?
does the number of conntrack entries also grow and never shrink?
does /proc/net/ip_conntrack show lots of UNCONFIRMED entries?

> Regards,
> Del W.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Zy+vXaXGVTD0i/8RAgrjAJ9pzcwo51XCiQ5eUrzxUNGIHFvIbgCeJy1T
kcDfWpYhSq6bzV74YM81SMA=
=vVAa
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
