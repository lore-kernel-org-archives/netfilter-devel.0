From: Harald Welte <laforge@netfilter.org>
Subject: Re: cannot kmalloc nor vmalloc
Date: Tue, 1 Feb 2005 13:59:39 +0100
Message-ID: <20050201125939.GE6878@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.61.0501171957130.8115@maca.fortech.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OAsA6xQjj2jRKPG2"
Cc: netfilter-devel@lists.netfilter.org
To: =?iso-8859-1?B?VG9t4T8=?= Macek <maca02@atlas.cz>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0501171957130.8115@maca.fortech.cz>
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


--OAsA6xQjj2jRKPG2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 17, 2005 at 08:00:55PM +0100, Tom=E1? Macek wrote:
> Hi, I'm just developing a new "match" (like ipt_limit for example) iptabl=
es module under RH FC 2, kernel 2.6.5-1.328.
> If I make a request for about 100 kB of memory in the registered match
> function in my module by means of kmalloc(size, GPF_ATOMIC) and set it
> via memset() to zero, the computer freezes with kernel panic and
> debugging output. Maybe it has not enaugh memory. I tried something
> more and never got more than about 40 kB.

please try to read up some general kernel hacking guide.=20

GFP_ATOMIC is for in-interrupt allocations, and you shouldn't ever need
to allocate very large pieces of memory from within an interrupt anyway.

> I also tried to get large chunk of memory outside the match function,
> just before I register the match - in the __init() of my module, and I
> was able to get more than 100 MB via vmalloc().

yes, because it's not called form interrupt

> How can I get bigger chunk of memory in the interrupt? I will need
> more (about 5-10) chunks of 100 kB memory.

no way.

> Tomas

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--OAsA6xQjj2jRKPG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/307XaXGVTD0i/8RAk4/AJ4wHGhnWHomVFmZ+uI+Bs1J0l30OwCeLkfi
+dC07ANWgStnQeDfZ7RN6mM=
=5dGN
-----END PGP SIGNATURE-----

--OAsA6xQjj2jRKPG2--
