From: Axel Thimm <Axel.Thimm@physik.fu-berlin.de>
Subject: Re: pom without rebuilding kernel?
Date: Fri, 17 Oct 2003 14:24:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031017122425.GB18504@puariko.nirvana>
References: <20031010134525.GB7985@puariko.nirvana> <Pine.LNX.4.44.0310112210540.14382-100000@filer.marasystems.com> <20031010134525.GB7985@puariko.nirvana> <20031011192044.GT13456@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Resent-Message-Id: <200310200038.h9K0cTgf011586@puariko.nirvana>
To: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310112210540.14382-100000@filer.marasystems.com> <20031011192044.GT13456@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 11, 2003 at 09:20:44PM +0200, Harald Welte wrote:
> On Fri, Oct 10, 2003 at 03:45:25PM +0200, Axel Thimm wrote:
> > E.g. are there changes in pom patches to the core of the kernel
> > sources, or can pom modules be compiled out of the kernel tree?
>=20
> in very rare cases the core network stack needs to be modified.  all
> other patches don't really require to rebuild the kernel.

How can I identify those patches? Most of the patching happens in
net/<protocol>/netfilter and include/linux/netfilter_<protocol>. Are
those patches safe for building out of the tree (w/o full kernel
rebuilds)?

> > If there is way to do it, or a netfilter developer thinks it is worth
> > the trouble, I'd rpm-package some modules for RH kernels. :)
>=20
> no, I am strictly opposing binary distribution.  At least not as an
> official part of the project.  Feel free to provide them at a
> different place, but I just think it's too dangerous (and not really
> necessarry).

I am already maintaining some kernel module rpms as well as some
non-modularizable patches to RH kernel on atrpms. I am having requests
to add some netfilter modules (notably the TARPIT and H323 patches),
and I was considering of packaging (parts of) pom as drop in kernel
module replacements or enchancements.

> patch-o-matic is for potentially unstable or not generally useful code.
> If people want to use some of it, they should understand enough and be
> able to compile them on their own.
> =20
> Bugfixes shouldn't be in patch-o-matic anyway, we've had a long
> discussion about that at the netfilter workshop.  This will change when
> the new (2.6 compatible) patch-o-matic will be put in place.  I'm
> working on that now, doing some perl coding for the first time in the
> last couple of years ;)

On Sat, Oct 11, 2003 at 10:14:54PM +0200, Henrik Nordstrom wrote:
> If you extract the module sources from the pom patches you can in most
> cases compile the modules out of the kernel tree if you like, assuming you
> have the correct kernel headers in place for the exact kernel binary you
> are using (this is a rather tricky part when trying to compile modules to
> a distro binary kernel)

Here is what I did to get a working H232 kernel module, is this sane
(seems to work for these modules at least)? Thanks.

# Create copies of subparts from the unchanged kernel tree to ./linux
for x in Makefile Documentation/Configure.help include/linux/netfilter_ipv4=
 include/linux/netfilter_ipv6 net/ipv4/netfilter net/ipv6/netfilter; do
  mkdir -p linux/`dirname $x`
  cp -a %{kernelsrcdir}/$x linux/`dirname $x`
done

# Patch the copy
KERNEL_DIR=3Dlinux ./runme --batch extra/h323-conntrack-nat.patch

cd linux
%patch0 -p1 -b .lockhelp
cd ..

make -C %{kernelsrcdir} SUBDIRS=3D`pwd`/linux/net/ipv4/netfilter dep
make -C %{kernelsrcdir} SUBDIRS=3D`pwd`/linux/net/ipv4/netfilter modules CO=
NFIG_IP_NF_H323=3Dm CONFIG_IP_NF_NAT_H323=3Dm "CPPFLAGS=3D-D__KERNEL__ -I`p=
wd`/linux/include -I\$(HPATH)"
make -C %{kernelsrcdir} SUBDIRS=3D`pwd`/linux/net/ipv4/netfilter INSTALL_MO=
D_PATH=3D$RPM_BUILD_ROOT MOD_DESTDIR=3D../netfilter/ipv4/netfilter modules_=
install CONFIG_IP_NF_H323=3Dm CONFIG_IP_NF_NAT_H323=3Dm

Unfortunately the make dep step is writing to the orginal kernel tree,
but i couldn't find a better solution.
--=20
Axel.Thimm@physik.fu-berlin.de

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/j994QBVS1GOamfERAl9SAKCDmL9MPDLiHOabZ7pDFE5daRVIBACggsDT
i6eHvw9B06/j5DpqrGK3yGQ=
=lAyC
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
