From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nf-failover] ct_sync for Linux 2.6.10
Date: Fri, 14 Jan 2005 11:04:28 +0100
Message-ID: <20050114100427.GJ9070@sunbeam.de.gnumonks.org>
References: <1105399340.2948.29.camel@krak.odu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXr400anF0jyguTS"
Cc: Netfilter-devel list <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Content-Disposition: inline
In-Reply-To: <1105399340.2948.29.camel@krak.odu>
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


--BXr400anF0jyguTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krisztian!

On Tue, Jan 11, 2005 at 12:22:19AM +0100, KOVACS Krisztian wrote:

>   After some more hacking on ct_sync, I've finally committed the Linux
> 2.6 version to a separate branch in the Netfilter SVN repository.=20

Thanks for not further adding to the revision-control-system-multitude
of the netfilter project ;)

More thanks of course for your 2.6.x port and current work.

I have good news for you: It's almost certain that I'll be able to spend
the majority of my time during the next two months on ct_sync and it's
further stabilization and development (esp. towards active-active
setups).

In the next couple of days I'll be writing some kind of 'whitepaper'
with what I have in mind as final development target.

Did you already work on abstracting out the protocol+socket instances
and the new kernel/userspace interface?

Since I'm now joining development again, we should make sure to keep the
svn 2.6 ct_sync branch as up-to-date as possible.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BXr400anF0jyguTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB55krXaXGVTD0i/8RAkrNAJ0XPJCn6DYcHwRow9pJrC03/eT7xACgsqur
4u/Qkk725Wjy9L0D56n/lus=
=l/1z
-----END PGP SIGNATURE-----

--BXr400anF0jyguTS--
