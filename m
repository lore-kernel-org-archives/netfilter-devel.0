From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] iptables-proc and admin-prohib patches
Date: Wed, 30 Apr 2003 18:33:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430163304.GI685@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0304291007300.32263-700000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5lq+205vWdkqwtk"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Maciej Soltysiak <solt@dns.toxicfilms.tv>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0304291007300.32263-700000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--r5lq+205vWdkqwtk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2003 at 10:40:22AM +0200, Jozsef Kadlecsik wrote:
> Hi Harald,
>=20
> Attached you can find two patches. Please review and if you agree please
> submit them to DaveM for kernel inclusion.
>=20
> The first one is the little bit modified version of 20_iptables-proc.patch
> in pending. The minor fix is the corrected printing of the target
> extensions=20

that's fine with me.

> while the major modification is that I added versioning support to
> tables/matches/targets.

To be honest, I wouldn't call this 'versioning support'.  It just adds a
version number field to the structures that is printed in '/proc/'.

The kind of versioning support we could really need (but which cannot be
added to the 2.4.x architecture without being totally incompatible) is
to have version information in every rule that is loaded from userspace.
The kernel would then reject rules for target versions > than the loaded
target module. Userspace would then need to read the version number and
prepare a structure for an older version.

So without any further convincing arguments, I would rather not want to
include your patch.  It would require patching all existing
targets/matches (to include the version number), and that's a too high
price for the little/limited use.

> The second patch is the admin-prohib.patch by Maciej which adds the
> admin-prohib flag to the REJECT target.
>=20
> We have been wrestling this problem for a long time and Maciej implemented
> my suggestion: simply document the backward incompatibility.

Yes, I will put this in pending (for post-2.4.21)

> With the introduced versioning in the proc patch the user now can check at
> runtime wether the kernel supports the indicated functionality. I think
> this is the utmost we can do about the incompatibility.

I would just skip that part.

> Best regards,
> Jozsef
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--r5lq+205vWdkqwtk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/rAXaXGVTD0i/8RAlmMAJsHKW4WJgkFDj7pI6n4Hl9RZEiCYACfaIEa
AAavXIjCFON6dKjncLf4c9w=
=Wk21
-----END PGP SIGNATURE-----

--r5lq+205vWdkqwtk--
