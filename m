From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] use correct ipt_physdev.h header in iptables userspace tool
Date: Sun, 2 Nov 2003 11:40:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031102104042.GO1536@sunbeam.de.gnumonks.org>
References: <200310250848.37967.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qse+WBH4guesipZ+"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Dirk Morris <dmorris@metavize.com>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Content-Disposition: inline
In-Reply-To: <200310250848.37967.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qse+WBH4guesipZ+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 25, 2003 at 08:48:37AM +0200, Bart De Schuymer wrote:
> Hi Harald, this just makes the userspace tool use the right 2.6.0-test8
> header file. Remember we broke compatibility to get things working
> on the parisc?

thanks Bart, patch applied (I'm just about to release 1.2.9 final).

We really should have a script to check if the userspace/include/linux
headers are in-sync with a recent kernel tree.

Any volunteers on the netfilter-devel list?

> cheers,
> Bart

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qse+WBH4guesipZ+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pN8qXaXGVTD0i/8RAg6TAJ0RjCCwR44tqOTEu2o4f8NDcJMxggCghAie
vFTR5NbmJZD8YgMHAJIxNok=
=8wU0
-----END PGP SIGNATURE-----

--qse+WBH4guesipZ+--
