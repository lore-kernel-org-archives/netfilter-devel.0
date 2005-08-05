From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Drop expectation refcount after unlinking expectation
Date: Fri, 5 Aug 2005 15:08:03 +0200
Message-ID: <20050805130803.GI4245@rama.de.gnumonks.org>
References: <42F2B507.8070207@eurodev.net> <42F342B8.7010001@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3U8TY7m7wOx7RL1F"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42F342B8.7010001@trash.net>
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


--3U8TY7m7wOx7RL1F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 05, 2005 at 12:43:04PM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> > This fixes the problem although I think that there's something wrong
> > with current refcounting. Every time an expectation is created, the
> > refcount of the master conntrack is incremented. Then, if the master
> > conntrack is destroyed, say the timeout has expired,
> > ip_ct_remove_expectation will be called. So firstly, all expectations
> > linked to such conntrack are destroyed and then the conntrack itself.
> > OK, my question is: why do we need to increase the master conntrack
> > refcount for expectations, if they are always killed first? Actually I
> > think that the master conntrack refcount should be increased once the
> > expectation is confirmed but not in ip_conntrack_expect_alloc.
>=20
> Only outstanding expectations are removed by remove_expectations().
> The fullfilled ones need the reference for stuff like
> ip_nat_follow_master.

So Pablo's argument stil upholds... in theory it would be sufficient to
increase the master refcount when expectation is fulfilled(confirmed)
instead of allocation time.  Or am I missing something?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3U8TY7m7wOx7RL1F
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC82SzXaXGVTD0i/8RAspfAKCK8jUL+LUCtb1x057ZdUpmMa9GbgCeKPKW
kqkqYa9BdGBdpKEXN/m/pvA=
=LWXW
-----END PGP SIGNATURE-----

--3U8TY7m7wOx7RL1F--
