From: Harald Welte <laforge@netfilter.org>
Subject: Re: 2.6.11 corrupting FTP session
Date: Fri, 1 Apr 2005 08:02:49 +0200
Message-ID: <20050401060249.GI19835@sunbeam.de.gnumonks.org>
References: <1111176664.423b35d80b351@webmail.conectcor.com.br>
	<423DA1FB.6030209@trash.net>
	<1111341503.423db9bfcffb7@webmail.conectcor.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S66JdqtemGhvbcZP"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michel Pereira <michel@michel.eti.br>
Content-Disposition: inline
In-Reply-To: <1111341503.423db9bfcffb7@webmail.conectcor.com.br>
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


--S66JdqtemGhvbcZP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 20, 2005 at 02:58:23PM -0300, Michel Pereira wrote:
> Quoting Patrick McHardy <kaber@trash.net>:
> > What is your setup (NAT rules, network topology between client and
> > server)?
>=20
>    Firewall (a) -> Server on DMZ. (NAT of internal network connections)
>    Firewall (b) -> Internal Network (without NAT of connections)
>=20
>    b - iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
>    b - iptables -A FORWARD -s myip -d 0/0 -m state --state NEW -j ACCEPT
>=20
>    a - iptables -t nat -A PREROUTING -p TCP -s 0/0 -d 200.162.38.71 --dpo=
rt 21
> -j DNAT --to IPonDMZ

this sounds pretty straight forward, still i can't reproduce the problem
at all. which ftp server and client are you using?

I suppose both firewalls have loaded ip_conntrack_ftp, and 'b' has
ip_nat_ftp ?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--S66JdqtemGhvbcZP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOQJXaXGVTD0i/8RAtjpAJ9iUeI+31NRwpTLKhBl2rKixgaO1ACdFJs/
PIZoEf1ObC/OcFRICg9jV1o=
=hMzY
-----END PGP SIGNATURE-----

--S66JdqtemGhvbcZP--
