From: Harald Welte <laforge@netfilter.org>
Subject: Re: RFC: conntrack hash function comparison II
Date: Wed, 26 Feb 2003 18:18:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226171820.GF8883@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.33.0301201113510.17671-100000@blackhole.kfki.hu> <Pine.LNX.4.33.0302191233330.10818-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0302191233330.10818-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2003 at 12:40:56PM +0100, Jozsef Kadlecsik wrote:
> Hi,
>=20
> I have finished my second try to compare the candidate hash functions for
> conntrack. The very short summary of my findings:

Great news.  I cannot say how much I appreciate somebody spending all
this time with the statistical analysis of those algorithms.

I trust your judgement and am willing to sacrifice the 'randomness' idea
of abcde in favor of not having to rehash with the jenkins2b.

> All the graphs and results can be found at
> http://www.kfki.hu/~kadlec/sw/netfilter/ct2

btw, what do you think of putting the cttest (and the raw testing data)
into the netfilter CVS repository?   This can be useful if available to
all interested developers via the usual 'distribution channel'
(netfilter.org site).

I have now added a seperate 'netfilter-testing' repository to CVS for
this purpose (and future testing tools, like a new testsuite)

It would also be helpful to have the webpages on the netfilter.org
project site or at least have them linked (whichever you prefer).=20

Maybe we should have a 'developers corner' on the homepage for stuff
like this.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XPbcXaXGVTD0i/8RAtxxAJwJPqiosFdnwc9DQghPfXYF4pHhoACaAmfS
ve6+x76dpU79WJxLNU8cr8c=
=xQRn
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
