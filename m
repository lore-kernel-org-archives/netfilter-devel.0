From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Fw: PROBLEM: PATCH for 2.4.23-pre4 and up hang on one system
Date: Tue, 11 Nov 2003 11:43:17 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031111104317.GZ8206@sunbeam.de.gnumonks.org>
References: <20031110233225.00de7987.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/iGx3h4bc2ZI981g"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20031110233225.00de7987.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/iGx3h4bc2ZI981g
Content-Type: multipart/mixed; boundary="uFO8jlCBh1yRPqfb"
Content-Disposition: inline


--uFO8jlCBh1yRPqfb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 10, 2003 at 11:32:25PM -0800, David S. Miller wrote:
> Please have a look, thanks guys.

Thanks, David.  Marcelo forwarded that message to the netfilter
(non-devel) list, see my reply attached.

I've read and change again and again: The change _is_ correct.  Also, it
is in effect for quite some time, we have it in CVS/patch-o-matic for
more than two months, and lots of people are using patch-o-matic. =20

I also cannot reproduce the bug here, I'm running quite a lot of
post-pre4 systems in such a simple SNAT scenario.

:(

> Begin forwarded message:
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--uFO8jlCBh1yRPqfb
Content-Type: message/rfc822
Content-Disposition: inline

Date: Mon, 10 Nov 2003 18:55:15 +0100
From: Harald Welte <laforge@netfilter.org>
To: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: PROBLEM: PATCH:MORE for 2.4.23-pre4 hang (fwd)
Message-ID: <20031110175515.GS8206@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0311100906250.16790-100000@logos.cnet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TSQPSNmi3T91JED+"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311100906250.16790-100000@logos.cnet>
X-Operating-system: Linux sunbeam 2.6.0-test5-nftest
X-Date: Today is Prickle-Prickle, the 22nd day of The Aftermath in the YOLD 3169
User-Agent: Mutt/1.5.4i


--TSQPSNmi3T91JED+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[moving the discussion to netfilter-devel@lists.netfilter.org]

Hi Marcelo and Beau!

> > Origionally I had catagorized this problem with the startup sequence;
> > the system always seemed to hang when squid was started before
> > mysql, etc. Moving squid near the end of the startup process, I
> > thought the problem was in hand. However, the system (pre9) proved
> > unstable (would not stay up for longer than one day.)
>=20
> > The problem exibits itself with a solid 'hang'; no oops, no dumps,
> > nada.

that's really strange.  I'd suspect a lot of people are running a recent
 >=3D pre5 kernel in a simple SNAT / MASQUERADE scenario, but we haven't
received any bugreports about this so far.  It has also been in our CVS
repository for two months, and was present in out patch-o-matic release
of September 12, 2003.  I'm also running a number of  2.4.23-pre7
kernels as firwalls, with no problem. =20

The particular change between pre3 and pre4 that you reverted was
correct.

The in_range() function is supposed to tell the caller whether a
specific modified tuple (that is srcip/srcport->dstip/dstport tuple) is
within a given NAT range.

The=20
	if (!(mr->range[i].flags & IP_NAT_RANGE_PROTO_SPECIFIED)
	    || proto->in_range(&newtuple, IP_NAT_MANIP_SRC,
			       &mr->range[i].min, &mr->range[i].max))
		return 1;

section does (after the modification) exactly what it is supposed to: =20
- If the range did not contain a per-proto range (i.e. all port numbers
  are allowed to be used), return '1'
- If the range did contain a per-proto range, call the l3 protocol
  helper to see whether it is in range.  If yes, return 1.

> Since my patch was to ip_nat_core.c, I should have mentioned that I use
> NAT via iptables. Here is an the relevant section if my iptables
> startup script:

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TSQPSNmi3T91JED+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/r9EDXaXGVTD0i/8RAsGGAJ4lStLq6pkYFmKCYA5nDyAgr1KTwQCeIeYs
Upst+p0dzPMaFNf0QVd7eeQ=
=Kuop
-----END PGP SIGNATURE-----

--TSQPSNmi3T91JED+--

--uFO8jlCBh1yRPqfb--

--/iGx3h4bc2ZI981g
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/sL1FXaXGVTD0i/8RAtsWAJ0UqM1l5saD8589PmVUfPxPQ3JUyACeJNfh
2t6niIyuCfi8KrgxqobGdLA=
=U2Rv
-----END PGP SIGNATURE-----

--/iGx3h4bc2ZI981g--
