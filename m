From: Harald Welte <laforge@netfilter.org>
Subject: Re: Add rule (ipt_entry?) from kernel space
Date: Sat, 31 May 2003 19:14:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030531171414.GZ29312@sunbeam.de.gnumonks.org>
References: <1054189927.1273.18.camel@branwen.winters-ca.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yC91f7qSViS67v3c"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Titus Winters <titus@cs.ucr.edu>
Content-Disposition: inline
In-Reply-To: <1054189927.1273.18.camel@branwen.winters-ca.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yC91f7qSViS67v3c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2003 at 11:32:07PM -0700, Titus Winters wrote:
> I'm working on a project that requires me to have a rule added by a
> kernel module.  Well, I'm flexible on that requirement.  I need to add a
> rule from both a setsockopt call and from a Match extension.  In any
> case, I'm fairly stumped as to how I go about this.  My current
> understanding of how the userspace iptables program works is that it
> creates all the ipt_entries in one contiguous memory segment and then
> the kernel side memcopies that for itself.  Is it best (or even safe) to
> just add to the end of that glob (or kmalloc more space and copy that
> glob over with more stuff at the end)?  Once added, is there any trick
> to removal?
>=20
> Any help would be appreciated, an example would be glorious.

This question has been asked several times on this mailinglist before.
We do not support ruleset changes from within the kernel, there is
absolutely _no_ code in the kernel for this.

> Thanks,
> -Titus Winters

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yC91f7qSViS67v3c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+2OLmXaXGVTD0i/8RAiPJAJ4zRbpnw3klsxjRPw9wZcubgTJcmgCfTuqt
e/KLjNS1q+RlQx2kfE0q9lA=
=/QXy
-----END PGP SIGNATURE-----

--yC91f7qSViS67v3c--
