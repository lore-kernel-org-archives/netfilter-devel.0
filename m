From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4.22-pre9] tcp connection tracking bugfix (fwd)
Date: Fri, 1 Aug 2003 15:50:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030801135059.GG6894@naboo>
References: <Pine.LNX.4.55L.0307311228090.4226@freak.distro.conectiva>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I3tAPq1Rm2pUxvsp"
Cc: "David S. Miller" <davem@redhat.com>,
	Marc-Christian Petersen <m.c.p@wolk-project.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Marcelo Tosatti <marcelo@conectiva.com.br>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55L.0307311228090.4226@freak.distro.conectiva>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--I3tAPq1Rm2pUxvsp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2003 at 12:28:28PM -0300, Marcelo Tosatti wrote:
=20
> Is this OK?

Hi Marcelo, Dave, Marc-Christian.

We've had this discussion over and over again, the last time in October
2002.  My reply at that time was:

http://lists.netfilter.org/pipermail/netfilter-devel/2002-October/009613.ht=
ml

Now since more and more people seem to consider this as a real problem,
I am sort of undecided on what to do.

My preferred solution still is the full TCP window tracking, which I
personally use (and trust) for a very long time - just the original
author still sort-of objects kernel inclusion of his code.  We're going
to discuss this at the netfilter summit (Aug 17 - Aug 20). My goal is to
finally submit that code after the summit.

Dave: If you think it's worth 'fixing' this issue for the following three
weeks, please submit the patch to Marcelo.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--I3tAPq1Rm2pUxvsp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/KnBCXaXGVTD0i/8RAiMsAKC0PHxk87BA5kz4waZeS+T5rCMjQQCfddwc
eRJf+VTvyKIRO6jHzuNfa+Q=
=xSOg
-----END PGP SIGNATURE-----

--I3tAPq1Rm2pUxvsp--
