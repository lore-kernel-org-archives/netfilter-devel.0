From: Harald Welte <laforge@netfilter.org>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error
Date: Sun, 21 Sep 2003 16:45:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921144557.GB22223@sunbeam.de.gnumonks.org>
References: <3F69CFF6.1060505@wp.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: c0g <c0g@wp.pl>
Content-Disposition: inline
In-Reply-To: <3F69CFF6.1060505@wp.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2003 at 05:32:06PM +0200, c0g wrote:
=20
> Hi
> I'm getting lots of these errors. I read in ip_conntrack_core.c it
> should "never happen" (so it's kind of assertion). Why does this
> assertion fail?

Indeed.  It seems like you have fragmens inside connection tracking.
However, all packets are defragmented before connection tracking
happens.

Can you please tell us more about your setup?  Something special with
regard to networking?  Tunnels? IPSec?

Maybe you can add a printk to print out the address information (or use
DUMP_TUPLE on the tuple) of the packet... maybe this way you can
identify where it came from (through which interface[s], processing,
=2E..).


> c0g@wp.pl

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbmlXaXGVTD0i/8RAjrjAJ4xV0xgqb3Zx9xEZc0udL0dzv1MgwCgsKN2
uHUx1dz3oJqxlAHd/AEavJg=
=0pdP
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
