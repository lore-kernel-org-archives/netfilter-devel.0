From: Axel Thimm <Axel.Thimm@physik.fu-berlin.de>
Subject: pom without rebuilding kernel?
Date: Fri, 10 Oct 2003 15:45:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031010134525.GB7985@puariko.nirvana>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I am thinking how nice it would be (or already is?) to build only the
required kernel modules for a given kernel, without having to rebuild
the kernel itself, like a lot of kernel drivers do (e.g. bttv, lirc,
lm_sensors etc).

Imagine building only the kernel modules, putting them in a folder
like

/lib/modules/`uname -r`/netfilter

adding the following to the top of /etc/modules.conf:

path[toplevel]=3D/lib/modules/`uname -r`/netfilter
path[toplevel]=3D/lib/modules/`uname -r`

and being happy ever after. :)

E.g. are there changes in pom patches to the core of the kernel
sources, or can pom modules be compiled out of the kernel tree?

I suppose that for a certain kernel version and above no hooks/glue to
the core non-modular networking components are required and therefore
such a plan could be followed. But I found no hint in any docu to
netfilter, not even a similar request.

If there is way to do it, or a netfilter developer thinks it is worth
the trouble, I'd rpm-package some modules for RH kernels. :)

Thanks!
--=20
Axel.Thimm@physik.fu-berlin.de

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/hrf1QBVS1GOamfERAsSOAKCRMw11tLURMEjLzCz3w5eXfES1eACeOler
IeICSk2BjgPlAujhqAIA3fU=
=uQ/V
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
