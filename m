From: Harald Welte <laforge@netfilter.org>
Subject: Re: sparc64 kernel, netfilter-20021115, iptables-1.2.7a - conntra ck issue with expecting related connections, FTP
Date: Mon, 3 Mar 2003 09:02:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303080208.GD1067@sunbeam.de.gnumonks.org>
References: <771F217D7A4AF84494632457889470A412D77A@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EP0wieDxd4TSJjHq"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Poon <Chris.Poon@TELUS.COM>
Content-Disposition: inline
In-Reply-To: <771F217D7A4AF84494632457889470A412D77A@bcmsg011.corp.ads>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EP0wieDxd4TSJjHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2003 at 04:48:58PM -0700, Chris Poon wrote:

> Again, I feel that this might be strictly a 64 bit kernel issue as I'm
> sure if the conntrack for related connection didn't work for 32 bit
> kernels, I would have found a lot more discussion about it (which I
> found none so far). And I don't think this is strictly with FTP
> connection tracking either, but rather connection tracking for related
> connection in general under a 64 bit kernel.

I haven't found the time yet to reproduce this on my Ultra5, but I've at
least added it to bugzilla for not loosing track of this issue.

See https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D59

> Thanks...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--EP0wieDxd4TSJjHq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+YwwAXaXGVTD0i/8RAiC3AJ0WXz5eRwWY9/y9wva5dMtJsqmMFACbB64E
bn4gRn6tKJcSzVyOczRV1gk=
=4kVA
-----END PGP SIGNATURE-----

--EP0wieDxd4TSJjHq--
