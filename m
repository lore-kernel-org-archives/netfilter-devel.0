From: Harald Welte <laforge@netfilter.org>
Subject: Re: Problen with transpartent proxy
Date: Sun, 2 Nov 2003 18:27:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031102172736.GG1536@sunbeam.de.gnumonks.org>
References: <1464.192.168.0.240.1067723204.squirrel@192.168.0.1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AnSJTMMZ92c40QA7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pivik@intelserv.kiev.ua
Content-Disposition: inline
In-Reply-To: <1464.192.168.0.240.1067723204.squirrel@192.168.0.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--AnSJTMMZ92c40QA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 01, 2003 at 11:46:44PM +0200, pivik@intelserv.kiev.ua wrote:
> But after I have setup transparent proxy all source addresses changed to
> address of my proxy server :((.

of course.  IT is a _proxy_ after all.  you have two totally seperate
connections, one between browser and proxy, and the other one between
proxy and server.

> iptables  -I OUTPUT -s ! 192.168.0.1  -j LOG
> Show nothing  :(

thos shows outgoing connections between proxy and server

> tcpdump -i eth0 not src host 192.168.0.1

May I assume that eth0 is your 'internal' interface (where the browers
are located)?  Then you see the connection between browser and proxy.

> Show all resuts ok like no transparent squid exists at all?
> What should a do to protocol all sources with IPTABLES + transparent SQUI=
D??

LOG in INPUT.

btw: LOG is _NOT_ meant as an accounting mechanism, since it is way too
slow for logging huge amoounts of packets.  You should look into using
ULOG / ulogd.


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--AnSJTMMZ92c40QA7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pT6IXaXGVTD0i/8RApQoAJ428pa6mX4tvQEx1CCteHmzJi8DAgCfZPco
kUP6moT+cDs8TSme2nHpcyQ=
=vMXa
-----END PGP SIGNATURE-----

--AnSJTMMZ92c40QA7--
