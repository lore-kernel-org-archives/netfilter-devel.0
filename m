From: Harald Welte <laforge@netfilter.org>
Subject: Re: Will netfilter patches be submitted to kernel base?
Date: Tue, 24 Jun 2003 18:04:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624160433.GQ2645@sunbeam.de.gnumonks.org>
References: <OKEKIACJCGNKMLKPKIIKEENFCOAA.gcote@transat-tech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVQ1RKc6+nLPB5pT"
Cc: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gary Cote <gcote@transat-tech.com>
Content-Disposition: inline
In-Reply-To: <OKEKIACJCGNKMLKPKIIKEENFCOAA.gcote@transat-tech.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BVQ1RKc6+nLPB5pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2003 at 02:48:44PM -0500, Gary Cote wrote:
>=20
> Can anyone brief me on whether there's any sort of master
> plan to submit the netfilter patches into the kernel base?

sure, we are constantly submitting patches to the 2.4.x and 2.5.x
kernels.

> And further, whether there's any thought to back porting=20
> them to 2.4.x? If effort is the limiting factor, then my
> company may be sufficiently motivated to cough up some
> free time.

Which ones are you talking about?  2.5.x work is mostly eliminating
skb_linearize() from all parts of netfilter/iptables.  Apart from that,
almost all our patches are for 2.4.x

> I'm specifically interested in the pptp-conntrack-nat patch.
> I noticed that the patch modifies ip_conntrack_core.c and
> ip_nat_core.c. Aside from what appear to be debug statements,
> it looks like a net change of *two* lines of code. The rest of
> the patch consists of new files.

yes.  Th reason for not submitting it is not one of it being instable or
affecting too many other subsystems.  The main reasons are:

- still doesn't support multiple calls in one session
- some people seem to have DNAT problems
- it expands the ip_conntrack_tuple by at least 4 to 8 bytes, which
  is quite some penalty, considering there are two  tuples in every=20
  connection tracking entry

> Would it be possible to get only those small changes into the=20
> kernel base? Then, we'd be able to build the GRE/PPTP helpers=20
> as loadable modules and not have to patch the kernel.

You cannot just put those two lines into the kernel, since they require
the respective header files.  And they increade the tuple size, see
above.

> We're something of a value-added reseller. We bundle our system
> software within a linux workstation. We've so far managed to run=20
> our product on off-the-shelf distros and would prefer not to get
> into the business of building, shipping, and maintaining custom
> kernels.

I can understand that position, but you have to understand that we have=20
different motivations for putting code into the linux kernel.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BVQ1RKc6+nLPB5pT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++HaRXaXGVTD0i/8RAlcCAKCg3pDrU3sx88a1JQeaUrnmu+Q+5wCfcyXw
x2aag5axJZpiLvVhxEHJVeQ=
=/6f4
-----END PGP SIGNATURE-----

--BVQ1RKc6+nLPB5pT--
