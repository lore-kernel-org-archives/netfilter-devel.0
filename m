From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Passive OS fingerprint matching module update. Dynamic fingerprint loading.
Date: Thu, 25 Sep 2003 23:01:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030925210153.GN5758@sunbeam.de.gnumonks.org>
References: <20030923125746.GL31401@sunbeam.de.gnumonks.org> <20030923200226.5e9c43e2.johnpol@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LJm8egi4vkexsie5"
Cc: netfilter-devel@lists.netfilter.org, quaker@ondraszek.eu.org,
	solt@dns.toxicfilms.tv
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Content-Disposition: inline
In-Reply-To: <20030923200226.5e9c43e2.johnpol@2ka.mipt.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--LJm8egi4vkexsie5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2003 at 08:02:26PM +0400, Evgeniy Polyakov wrote:
=20
> Ok, here is the patch.
> Now we are compatible with OpenBSD, but not with Michal Zalewski :)

Well, I have to admit that I'm not really involved in the 'os
fingerprinting community', so I don't know what might be the better
format (or the more commonly used one).

> P.S. Harald, is it convenient for you to use -p0 when patching or is -p1
> better?

I'd prefer -p1, but I don't really care anyway.

Thanks.

> 	Evgeniy Polyakov

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--LJm8egi4vkexsie5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/c1fBXaXGVTD0i/8RAk7WAJ4yM74TMWSAuYRnLisxakSJ8k+J2wCfVBQ1
6LDhVoONkJg24eYPEMgC6Cw=
=X+8c
-----END PGP SIGNATURE-----

--LJm8egi4vkexsie5--
