From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] sparc64 compatibility netfilter patches
Date: Thu, 2 Jan 2003 09:57:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030102085734.GL9467@sunbeam.de.gnumonks.org>
References: <20030101171654.B25870@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Cc: netfilter-devel@lists.netfilter.org,
	"David S . Miller" <davem@redhat.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
Content-Disposition: inline
In-Reply-To: <20030101171654.B25870@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 01, 2003 at 05:16:54PM +0100, Laszlo Valko wrote:
> Hi all!
>=20
> Here are two patches to make netfilter "more" usable on sparc64
> platforms with 32-bit user-space.

Thanks a lot for this valuable contribution!

> The first one is a workaround for the not-so-nice idea of passing
> a user-space pointer in a structure for setsockopt. The patch makes
> the netfilter counters working.

Unfortunately we will never get netfilter-specific code into the
sys_sparc32.c file (and we also really don't want it to be there).

Is there no solution which only touches iptables userspace and kernel
code? (net/ipv4/netfilter/* as well as libiptc.c in userspace)?

> Please review, comment, etc.
>=20
> Laszlo
> email: <valko@linux.karinthy.hu>
>=20
>=20
> PS: the first patch is the best I can imagine without changing the way
> of data exchange (maybe putting the counters struct at the end of struct
> ipt_replace, after the entries, with offset pointers like struct ipt_entry
> uses with target_offset and next_offset?), even though it results in
> HORRIBLE amount of copying for EVERY iptables change command.

I understand... but still... putting netfilter code into the sparc64
architecture dependent syscall code sounds like a bigger hack to me.

btw: I think we can spare DaveM from further discussions on this topic,
I will inform him as soon as we have found a final solution to the
issue.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+E/7+XaXGVTD0i/8RAlyEAKCvyI0tuH0cN21MtCifAFBGXyeVmACfWv+h
gKPDeW8+rsAC3m8qJS1/uCk=
=U4Yn
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
