From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] Need your help
Date: Thu, 11 Dec 2003 17:09:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211160919.GI15606@sunbeam.de.gnumonks.org>
References: <38751.212.39.69.1.1071154312.squirrel@mail.bnt.bg>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u/L2/WlOHZg+YGU4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stefan Stoyanov <stef@bnt.bg>
Content-Disposition: inline
In-Reply-To: <38751.212.39.69.1.1071154312.squirrel@mail.bnt.bg>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--u/L2/WlOHZg+YGU4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2003 at 04:51:52PM +0200, Stefan Stoyanov wrote:
> Hi Coreteam!!!!
>=20
> Before a week I precompile my kernel with iptables-1.2.9.Today on my
> /var/log/syslog and on my console i see the following message:

Please contact netfilter-devel, in accordance with http://netfilter.org/con=
tact.html

> Dec 11 16:47:25 mail kernel: LIST_DELETE: ip_nat_core.c:90
> `&info->bysource'(c3dc5484) not in &bysource[hs].
> Dec 11 16:47:25 mail kernel: LIST_DELETE: ip_nat_core.c:91
> `&info->byipsproto'(c3dc5490) not in &byipsproto[hp].
> Dec 11 16:47:26 mail kernel: LIST_DELETE: ip_nat_core.c:90
> `&info->bysource'(dc56aa84) not in &bysource[hs].
> Dec 11 16:47:26 mail kernel: LIST_DELETE: ip_nat_core.c:91
> `&info->byipsproto'(dc56aa90) not in &byipsproto[hp].
> Dec 11 16:47:27 mail kernel: LIST_DELETE: ip_nat_core.c:90
> `&info->bysource'(dc56aa84) not in &bysource[hs].
> Dec 11 16:47:27 mail kernel: LIST_DELETE: ip_nat_core.c:91
> `&info->byipsproto'(dc56aa90) not in &byipsproto[hp].
> Dec 11 16:47:28 mail kernel: LIST_DELETE: ip_nat_core.c:90
> `&info->bysource'(c3dc5304) not in &bysource[hs].
> Dec 11 16:47:28 mail kernel: LIST_DELETE: ip_nat_core.c:91
> `&info->byipsproto'(c3dc5310) not in &byipsproto[hp].
>=20
>=20
>=20
> One of the modules where loaded in my linux is iptable_nat and ip_conntra=
ck.
> When I remove iptable_nat the message stoped, can you help me about that?
> My kernel is 2.4.23.

plain 2.4.23 source?  In my case, the line numbers of ip_nat_core.c
don't seem to match what you are describing above.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--u/L2/WlOHZg+YGU4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2JavXaXGVTD0i/8RAoLuAKCklqNMs3efl/u+l5nOGjsEZr3mhgCffRog
xzBuZD4ri554s2sZjt5I5Fs=
=uG1j
-----END PGP SIGNATURE-----

--u/L2/WlOHZg+YGU4--
