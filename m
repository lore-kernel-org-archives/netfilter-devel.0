From: Harald Welte <laforge@netfilter.org>
Subject: Re: Huge impact of the conntrack mechanism on routing performance
	(30% with a single conntrack entry)
Date: Wed, 12 Apr 2006 10:43:05 +0200
Message-ID: <20060412084305.GO31616@sunbeam.de.gnumonks.org>
References: <20060409211031.97319.qmail@web38408.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jnYfR+Q8IWTs8BNa"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eddy Kvetny <eddy.linux@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20060409211031.97319.qmail@web38408.mail.mud.yahoo.com>
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


--jnYfR+Q8IWTs8BNa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 09, 2006 at 02:10:31PM -0700, Eddy Kvetny wrote:

> I would appreciate if someone could explain this "well
> understood" :-) thing to me. How come such an overhead
> for a single entry in the conntrack table ? After
> putting it to the table this entry is hashed and later
> is supposed to be find very quickly. What am I missing
> here ?

You are probably missing that the hashtable lookup is quite expensive,
as well as referencing multiple cacheline worth of data (i.e. producing
a number of more data cache misses per packet).

Also, the connection tracking entry needs to be updated with every
packet (new timeout, tcp state changes), and you need to look way deeper
into the packet than just for routing (additional instruction cycles,
additional data cache misses).=20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--jnYfR+Q8IWTs8BNa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEPL2ZXaXGVTD0i/8RAnHfAJ4gwKndnA2GQdo/nUKdrViiRxKHSwCfQjJI
vaNnc33SHpe411evj5mWKxY=
=1K1u
-----END PGP SIGNATURE-----

--jnYfR+Q8IWTs8BNa--
