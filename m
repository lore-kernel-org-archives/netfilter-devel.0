From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 6/7] add support for zeroing counters at getting
Date: Sat, 5 Nov 2005 12:16:18 +0100
Message-ID: <20051105111618.GV5594@sunbeam.de.gnumonks.org>
References: <436BA1CA.4020601@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eNjIDde0W37E3OQP"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <436BA1CA.4020601@netfilter.org>
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


--eNjIDde0W37E3OQP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 07:00:42PM +0100, Pablo Neira wrote:
> Add support to zero counters conntrack at getting. Currently we can zero
> all the conntracks via zero and dump, but it could be useful more fine
> grain zeroing.

This misses proper write locking, so we can get corruption with packets
trying to increment the counter meanwhile.

Please try adding write locking, test it, and re-submit.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eNjIDde0W37E3OQP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbJSCXaXGVTD0i/8RAl4IAKChbCU+RbVpCfD50v1voRdCaxj0JACeKwxn
Yh3yghBu2KERei9f1iAv+YM=
=FwHx
-----END PGP SIGNATURE-----

--eNjIDde0W37E3OQP--
