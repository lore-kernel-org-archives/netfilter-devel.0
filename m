From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Sat, 11 Jan 2003 20:47:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030111194740.GF24488@naboo.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com> <20030106125720.GF9467@sunbeam.de.gnumonks.org> <15897.46884.822054.847738@isis.cs3-inc.com> <20030107185748.GV9467@sunbeam.de.gnumonks.org> <15899.51201.381520.438520@isis.cs3-inc.com> <20030108105646.GH9467@sunbeam.de.gnumonks.org> <15900.41422.812422.110502@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y5rl02BVI9TCfPar"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15900.41422.812422.110502@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Y5rl02BVI9TCfPar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2003 at 02:10:22PM -0800, Don Cohen wrote:
Content-Description: message body text
>  > yes.  If you now would be as friendly to post it as a unified diff
>  > against current patch-o-matic CVS, attached in MIME format?  (And for
>  > posting habits and/or coding style hints there are plenty of examples =
in
>  > the list archives respectively CVS).
>=20
> I've tried to follow directions in NEWPATCHES.
> I don't quite understand, though, where libipt_u32.c belongs.

no, it just belongs into the extensions subdirectory, together with a
=2Eu32-test shellscript (similar to the others...)

> It looks like you want me to download the current patch-o-matic cvs,
> make a copy of it with my 3 patch files, then do a diff.
> But this just contains my 3 patch files, right?

yup, it is a diff which adds 3 files (of which one is again a diff)

> So wouldn't that be the same as putting those files in one directory,
> creating a second directory with empty files of those names and doing
> the diff of those?

yes, it would turn out the same thing, as long as (like in the usual
case) there are no modifications to existing Makefiles, etc.

> Anyhow, see if this is what you wanted:

couple of comments:

1) please include the patch 'netfilter/userspace' or at least
'userspace', so the patch can be applied from the 'root' netfilter
directory. (this is not really important, but usual) (this is not really
important, but usual)

2) please don't include the u32 in extensions/Makefile.  If you do that,
you would also need to put your kernel header file into
userspace/include/linux/...  - but we only do this for stable matches
which are about to be submitted to the kernel soon.  Instead, we use a
conditional compilation mechanism with the '.foo-test' scripts.

Maybe it's a good idea to have a look at some other patches (like the
recently submitted hoplimit (hl) patches as an example.  I didn't need
to describe this into detail so far, everybody just figured..

=2E. but it seems like there is a need for documentation.  If you feel
NEWPATCHES should be extended in some way -> patches are welcome ;)

Thanks again.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--Y5rl02BVI9TCfPar
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+IHTcXaXGVTD0i/8RAhCaAJ9zif6L3WBmO0JLJ8FMpwT6ct736wCcCl9b
F41aV0LagWOG9Kd9IbRclvI=
=fFKp
-----END PGP SIGNATURE-----

--Y5rl02BVI9TCfPar--
