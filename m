From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Wed, 22 Jun 2005 14:15:10 +0200
Message-ID: <20050622121509.GG4551@obroa-skai.de.gnumonks.org>
References: <876ef97a0506201904a05582a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82evfD9Ogz2JrdWZ"
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a0506201904a05582a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--82evfD9Ogz2JrdWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 20, 2005 at 10:04:15PM -0400, Tobias DiPasquale wrote:
> Harald et al,
>=20
> Tonight I installed 2.6.12 and iptables 1.3.1 on my Gentoo box, both
> from pristine sources. Two problems:
>=20
> 1. I had to copy in the ipt_CLUSTERIP.h kernel header from 2.6.12 into
> iptables-1.3.1/include/linux/netfilter_ipv4 for the
> libipt_CLUSTERIP.so library to have to same targinfosize as the kernel
> module. Before that, I was getting the following error:

this should never happen.  iptables always prefers
$KERNEL_DIR/include/linux/netfilter_ipv4 above its local copy.  Are you
sure KERNEL_DIR was set correctly while compiling iptables?


> 2. I installed this rule just to test things out:
>=20
> iptables -A INPUT -d 192.168.1.3 -i eth0 -p tcp --dport 3000 -j
> CLUSTERIP --new --hashmode sourceip-sourceport --clustermac
> 01:23:45:67:89:AB --total-nodes 2 --local-node 1
>=20
> I then tried to remove it (I didn't update iptables rules again since
> then) by switching the -A to a -D and that failed. I tried all sorts
> of combinations of the arguments to -j CLUSTERIP but they all failed.
> Eventually, I was forced to remove the rule by using the iptables rule
> # (e.g. iptables -D INPUT 10). I feel that this is in error, but I've
> seen at least two patches to CLUSTERIP that claim to fix rule
> deletion. Am I doing something wrong?

it is an error.  I will investigate any patches / fixes that have been
sent to the list.

> Anyway, I'm glad that you can now update the node lists dynamically
> now. This makes it usable.=20

At which point was this not possible?  Or am I missing something?

> I'm planning on writing a userspace driver for this module to make at
> least the Win2K3 NLB functionality available to Linux users.

I am not familiar with that functionality, can you give me a pointer?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--82evfD9Ogz2JrdWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCuVZNXaXGVTD0i/8RArvUAJ9ORLbPWWwm8yxuzL6bT2/64kIWXACgn1KG
ZBQC3iKwMG5tG8aGWvjIWaY=
=cWEC
-----END PGP SIGNATURE-----

--82evfD9Ogz2JrdWZ--
