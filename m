From: Harald Welte <laforge@netfilter.org>
Subject: Re: writing a fragmentation-needed patch
Date: Mon, 31 Mar 2003 17:31:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331153155.GC28962@sunbeam.de.gnumonks.org>
References: <3E85D60D.7040304@rtij.nl> <20030330093514.GA1098@oknodo.bof.de> <3E86C399.7020209@rtij.nl> <20030331122654.GM7718@sunbeam.de.gnumonks.org> <3E885A67.3010100@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tqI+Z3u+9OQ7kwn0"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <3E885A67.3010100@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tqI+Z3u+9OQ7kwn0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 05:10:31PM +0200, Martijn Lievaart wrote:

> I see the point and had I remembered this beforehand I would have=20
> created a seperate target. I still may, but the solution I have now=20
> works for me. Effectively you are saying that the fake-source patch=20
> should also not have been in pom as it changes the userspace<->kernel=20
> interface?

the fake-source patch will never be submitted to the kernel.  It can,
however, remain in something else than base/pending/submitted of
patch-o-matic.

> OTOH, there could be an "incompatible" part of pom, for useful, but=20
> backwards incompatible changes. Just make clear that these are optional=
=20
> patches that will not make it into the kernel and need both a patched=20
> kernel and userspace. This is probably not the major goal of pom, but it=
=20
> could be a convenient repository for such patches.

yes. I think we should merge this 'incompatible' with 'userspace'

> I'll have a look at the this aproach, but effectively this would just be=
=20
> a clone of libipt_REJECT with minor changes. Also it probably should not=
=20
> do the tcp-reset thingy as that is not ICMP (or think of a better=20
> name.... hmmmm, REJECT, no that is taken ;^>).=20

sure, TCP RST has no relation to ICMP. So just forget about it in the
ICMP target.

> It would give a chance to encode all the icmp error messages. Maybe
> DENY would be a better name although this would create major confusion
> for newbies.

DENY used to be the name for DROP in ipchains/ipfwadm, so this will
certainly caus confisuion.

> But for me it is not all that important in the end. I have a patched=20
> kernel that does what I want, patch will not make pom, ok, I publish it=
=20
> somewhere else for those that want it. If I feel like it, I will have a=
=20
> look at a FRAGNEEDED and/or DENY/ICMP/Whatever target.
>=20
> BTW, there does not seem to be an existing match for the DF-bit? Hmmm=20
> more work to do. :-)

sure, we're always open for contributions.

> Martijn Lievaart

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tqI+Z3u+9OQ7kwn0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iF9rXaXGVTD0i/8RAq+6AJ9vCOxjyMEwEjtdrlLxfUuYKPMK+wCbBrrA
5mZHO5kdxeheBHayz/PgG/c=
=RnMN
-----END PGP SIGNATURE-----

--tqI+Z3u+9OQ7kwn0--
