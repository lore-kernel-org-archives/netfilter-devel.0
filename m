From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and NAT helper
Date: Thu, 5 May 2005 09:52:58 +0200
Message-ID: <20050505075258.GM30482@sunbeam.de.gnumonks.org>
References: <4279291E.2060103@nit.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jHwcxWEthkc1rt9P"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Lukasz Kosewski <lkosewsk@nit.ca>
Content-Disposition: inline
In-Reply-To: <4279291E.2060103@nit.ca>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--jHwcxWEthkc1rt9P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 04, 2005 at 03:57:18PM -0400, Lukasz Kosewski wrote:

> The problem I have is that in 2.6.11, there no longer exists a 'union=20
> ip_conntrack_nat_help' in include/linux/netfilter_ipv4/ip_conntrack.h,
> to which the PPTP/NAT patches make changes.  While I can simply change
> the patches such that they ignore this, I am not certain whether or
> not this is intended, or whether I will be losing some functionality.

please read the netfilter-devel archive.  I get asked this question at
least ten times a week:

There is no pptp/gre conntrack and nat helper for 2.6.11+, since this
kernel version contains a redesigned infrastructure for such helpers.

At this time, I see very limited chance that this new infrastructure is
sufficient enough to actually implement the same functionality.  A
straight 1:1 port ist definitely not possible.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jHwcxWEthkc1rt9P
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCedDaXaXGVTD0i/8RAoKxAJ4hm9+/nJ/hzvuq1k+Brilsu5XRkwCglhdd
KWmnZP5+Qn1AjY2/rc6ZpCk=
=EuZY
-----END PGP SIGNATURE-----

--jHwcxWEthkc1rt9P--
