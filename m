From: Harald Welte <laforge@netfilter.org>
Subject: Re: New standalone nat helper module which help function is never called
Date: Mon, 17 Nov 2003 23:31:30 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031117223129.GF5075@sunbeam.de.gnumonks.org>
References: <20031117174829.711e2e82.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cz6wLo+OExbGG7q/"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: tuXit <tuxit@netcourrier.com>
Content-Disposition: inline
In-Reply-To: <20031117174829.711e2e82.tuxit@netcourrier.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cz6wLo+OExbGG7q/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2003 at 05:48:29PM +0100, tuXit wrote:

> In the end, I insmod my module (which is marked as unused), and the logs =
show
> that it is properly registered. I said in iptables to accept the packets
> from/toward the NNTP port (119), and I also said to masquerade from one
> network to the other. When trying to contact the NNTP server on the other
> network from a client machine in the first network and using the machine =
on
> which I inserted the module as gate, the help function of my module is ne=
ver
> called. There must be something I forgot, or I wrongly understood, but af=
ter
> having read several times the kernel hacking guide and searched inside th=
is
> mailing-list archive, I can't find any reason.
>=20
> I somebody has an idea about it, I would be glad to know it :)

if you could send us the current code, it woulde be easier to figure out
what's going on.

> Thanks in advance,
> tuXit.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cz6wLo+OExbGG7q/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/uUxBXaXGVTD0i/8RAqusAJsGhQdWoP6xis7gBVrfo9NI+Gw5KACggYif
fW84h/FsbB8s1azbXvQ9fX0=
=kJat
-----END PGP SIGNATURE-----

--cz6wLo+OExbGG7q/--
