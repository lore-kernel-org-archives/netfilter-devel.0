From: Harald Welte <laforge@netfilter.org>
Subject: Re: condition and 2.6
Date: Sun, 29 Feb 2004 21:56:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229205626.GN15558@sunbeam.de.gnumonks.org>
References: <200402290210.35962.lists@egidy.de> <20040229110711.GJ7790@sunbeam.de.gnumonks.org> <200402291528.01679.lists@egidy.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ig5MTpp3LwprTX9"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: gerd@egidy.de
Content-Disposition: inline
In-Reply-To: <200402291528.01679.lists@egidy.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3ig5MTpp3LwprTX9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 29, 2004 at 03:28:01PM +0100, Gerd v. Egidy wrote:
> > This comment is meant as:
> >
> > "Since nobody provided us with a 2.6.x port yet, and I have very limited
> > time for such porting, and I personnaly dislike the condition match
> > anyway, I marked it as 2.4.x only - since the 2.4.x patch doesn't work
> > for 2.6.x"
>=20
> Thank you for the clarification.
>=20
> > > What do you dislike? Is it the idea or the implementation? Do you kno=
w of
> > > any bugs or possible problems in the code - especially with 2.6?
> >
> > The idea of having /proc files control how the ruleset behaves.  This is
> > an ugly kludge for our less-than-optimal ruleset change performance.
> > Apart from that I cannot really see why this has to be solved in the
> > kernel and not by some userspace daemon that updates the ruleset
> > whenever a change is needed.
>=20
> I don't mind that much about ruleset change speed. The different conditio=
ns=20
> for my firewall are changed by different scripts and I can't make sure th=
at=20
> only one is running at a time. So I fear a race like this:

Sorry, but I have a different view on this.  Problems that can be solved
in userspace (like mutual exclusion of certain scripts running at the
same time) should be implemented in userspace, rather than pushing
kludges into the kernel.

> As far as I understand the libiptc code, the result will be that the chan=
ges=20
> done by program 1 will be lost. Is that correct or have I misunderstood t=
he=20
> code?

No, this is true.

> The condition module offers a lot more atomicity and I can be sure that t=
wo=20
> scripts don't interfere with each other.

While I understand this application, I doubt that this rectifies the
race-prone uglyness of something like ipt_condition.

Why don't you just use a lock file in all your scripts?  Create the lock
file before you access iptables, and remove it after it has been
accessed.  This kind of file-based locking works since good old UUCP
times.

> Kind regards,
> Gerd

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3ig5MTpp3LwprTX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQlH6XaXGVTD0i/8RAql+AJ0fLduibxyI6p0TwPwxwUu+l9ogrwCbBMp5
/clIe4YGGh19jUmMqi2de84=
=kQUj
-----END PGP SIGNATURE-----

--3ig5MTpp3LwprTX9--
