From: Harald Welte <laforge@gnumonks.org>
Subject: Re: nat/redirect question
Date: Thu, 26 Sep 2002 14:16:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020926141605.E3810@sunbeam.de.gnumonks.org>
References: <20020926105958.GB423@alfred.one2one-networks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C3NEYcg1qxklHzEM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jesper L. Nielsen" <jln@one2one-networks.com>
Content-Disposition: inline
In-Reply-To: <20020926105958.GB423@alfred.one2one-networks.com>; from jln@one2one-networks.com on Thu, Sep 26, 2002 at 12:59:58PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--C3NEYcg1qxklHzEM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2002 at 12:59:58PM +0200, Jesper L. Nielsen wrote:
> Hello Harald.
>=20
> I've been puzzling around with netfilter for quite a while now,
> debugging and digging into the code. Now I wish to write my own little
> thing for the NAT table.
>=20
> The idea is to make a NAT helper that is bound to incoming port 80. The
> helper should be able to parse the packages containing HTTP requests,
> and upon seing af defined host, lets say 'slashdot.org' it should be
> able to redirect this trafic to a different port (eg. port 8000).=20
>  So normal traffic flows by into port 80, but upon a HTTP request
> containing the line: 'Host: slashdot.org', it should be sent to port
> 8000, which could be a different HTTP server, listening on port 8000.

how do you want to do that?

you cannot have a couple of packets pass, and then at a certain point
within the TCP stream start redirecting packets to other hosts/sockets/...

At the time you see the ULR (http get request), the tcp connectin is
established, the full handshake has completed, window scaling/ecn/... has b=
een
negotiated, etc.

The only solution for your problem seems to be a transparent proxy which=20
redirects part of the traffic, and passes on all other traffic.

> Thank you
> Jesper L. Nielsen

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--C3NEYcg1qxklHzEM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9kvqFXaXGVTD0i/8RAh1eAKCvck4ytW7mNcKBZjkS254DrlZHwgCgnPf0
DoXWhI+CJwsz2HhoxErfovY=
=ZwWX
-----END PGP SIGNATURE-----

--C3NEYcg1qxklHzEM--
