From: Harald Welte <laforge@gnumonks.org>
Subject: Re: iptables u32 match patch-o-matic (attempt)
Date: Sat, 25 Jan 2003 19:39:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030125183910.GC6907@naboo.de.gnumonks.org>
References: <200212271854.gBRIsf131987@isis.cs3-inc.com> <20030106125720.GF9467@sunbeam.de.gnumonks.org> <15897.46884.822054.847738@isis.cs3-inc.com> <20030107185748.GV9467@sunbeam.de.gnumonks.org> <15899.51201.381520.438520@isis.cs3-inc.com> <20030108105646.GH9467@sunbeam.de.gnumonks.org> <15900.41422.812422.110502@isis.cs3-inc.com> <20030111194740.GF24488@naboo.de.gnumonks.org> <15905.55831.492080.943865@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15905.55831.492080.943865@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2003 at 01:11:51PM -0800, Don Cohen wrote:

> It seems a lot easier to write a match than to package it as a patch!

;) I think this is just a matter of getting used to it.  I understand
that patch-o-matic is a little bit complicated at the first look..

> Perhaps my confusion is related to the fact that I went about this
> whole process in some unexpected way.  I downloaded iptables-1.2.7a
> and patch-o-matic-20020825 in order to look at existing code so I
> could write my match.  Then I added stuff that looked similar to what
> was there and built it.  I begin to think I should have instead
> started with cvs checkout.  I see that contains netfilter/userspace
> whereas I have no such directory.

the netfilter/userspace directory is exactly what is packaged as
iptables-*.tar.bz2 archive.

> What's the difference between the HL's and the hl's, I wonder.

HL is hoplimit target, hl is hoplimit match.

> Whereas NEWPATCHES seems to be meant to tell me what to do.

yup. but I think it's a bit out of date and never was completed.

>  > > I've tried to follow directions in NEWPATCHES.
>  > > I don't quite understand, though, where libipt_u32.c belongs.
>  >=20
>  > no, it just belongs into the extensions subdirectory, together with a
>  > .u32-test shellscript (similar to the others...)
> This suggests that it should be part of what I send you.
> But below you seem to say 3 files, which is what NEWPATCHES seemed
> to indicate, and which is what I did send.

well. You generate those three files, put them in the patch-o-matic
directory and then do a 'diff -Nru' between a clean patch-o-matic and
your modified version.

the patch thus only contains three hooks, adding three files. one of
them is the previously-mentioned patch file to the kernel tree.

>  > > So wouldn't that be the same as putting those files in one directory,
>  > > creating a second directory with empty files of those names and doing
>  > > the diff of those?
>  >=20
>  > yes, it would turn out the same thing, as long as (like in the usual
>  > case) there are no modifications to existing Makefiles, etc.
>  >=20
>  > > Anyhow, see if this is what you wanted:
>  >=20
>  > couple of comments:
>  >=20
>  > 1) please include the patch 'netfilter/userspace' or at least
>  > 'userspace', so the patch can be applied from the 'root' netfilter
>  > directory. (this is not really important, but usual) (this is not real=
ly
>  > important, but usual)
>=20
> Am I correct that the complaint here is that instead of
>  diff -ur u32-empty/u32.patch u32-added/u32.patch
> you wanted something like
>  diff -ur u32-empty/userspace/u32.patch u32-added/userspace/u32.patch
> or
>  diff -ur u32-empty/netfilter/userspace/u32.patch u32-added/netfilter/use=
rspace/u32.patch
> or
>  diff -ur netfilter/userspace/u32.patch netfilter/userspace/u32.patch
> ?

no. I'm really surprised that it seems to be that difficult to explain
in which format the patches are submitted in the ideal case.

And I have the feeling that I would spend more time explaining it in an
email than it actually takes to package the patch in the correct format.

So please just send me anything you have and I will bring it into the
correct format as soon as I have some time left.

> - how should I make u32 ?

add the userspace/extensions/.test-u32 script, similar to=20

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

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+MtnOXaXGVTD0i/8RAiU+AJ4vyAyjBk4zGLrZQzz1kIfF4y/vVgCfSnyt
zG9vVJExb1aRrv5mcc34MoY=
=vWTZ
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
