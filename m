From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] IP sets
Date: Tue, 17 Feb 2004 15:19:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040217141946.GK981@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com> <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gLe/sNPhR777EPF"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0402171348210.1089@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--7gLe/sNPhR777EPF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2004 at 02:49:05PM +0100, Martin Josefsson wrote:

> Maybe try __get_free_pages() and fall back to vmalloc() if it fails?
> [...]
> I've been using this in conntrack for some time and it works fine. I
> havn't tried to measure any benefits. One thing I don't do is to increase
> the hashsize if the wanted allocation would be for (2^n)+1 pages (then the
> actual allocation will be for 2^(n+1) pages). Now with the jenkins hash we
> don't have any problems with 2^n hashtable sizes so we could do that.

I think this is a good idea.  Let's wait for ak's reply to my previous
email and decide at that point.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--7gLe/sNPhR777EPF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAMiMBXaXGVTD0i/8RAmaCAKCHe19BpWHwrXCpHfAzR4GHMoQDogCfdqGf
0XMXo5uhY3cI+rnzG9R66JY=
=OIWU
-----END PGP SIGNATURE-----

--7gLe/sNPhR777EPF--
