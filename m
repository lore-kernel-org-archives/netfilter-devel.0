From: Harald Welte <laforge@netfilter.org>
Subject: Re: netfilter performance question
Date: Fri, 1 Apr 2005 08:18:42 +0200
Message-ID: <20050401061842.GK19835@sunbeam.de.gnumonks.org>
References: <20050322122438.C70026@imperator.sieradz.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yLaBmHMi4cq+C/u4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcin Szczepaniak <szczepan@sieradz.info>
Content-Disposition: inline
In-Reply-To: <20050322122438.C70026@imperator.sieradz.info>
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


--yLaBmHMi4cq+C/u4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 22, 2005 at 12:42:53PM +0000, Marcin Szczepaniak wrote:
> I've tested two configurations of kernel (i am using 2.6 kernel tree):
> first - no netfilter enabled - my device was able to bridge 70 Mbit of
> traffic.  second - netfilter compiled in, but no rules applied -
> traffic is only 20 Mbit :( Adding some test rules has minor affect to
> traffic. Simply existence of netfiler makes maximal possible traffic
> to be equal one third of that when only routing exists in kernel.

what are you referring to as 'existance of netfilter'.   netfilter is
something different than iptables.

If you want to nail this down, please check

1) performance with CONFIG_NETFILER =3D=3D n
2) performance with CONFIG_NETFILTER =3D=3D y but CONFIG_IP_NF_IPTABLES =3D=
=3D n
3) performance with an empty module attached to the netfilter hook, i.e.
   something that registers to all five hooks and returns NF_ACCEPT
4) performanec with CONFIG_NETFILTER =3D=3D y, CONFIG_IP_NF_IPTABLES =3D=3D=
 y
   and CONFIG_IP_NF_FILTER =3D=3Dy, but no rules loaded.

Please send the numbers to netfilter-devel and Cc me personally.

> 2. Is it possible to use only ebtables, without netfilter ?

ebtables is based on netfilter, but not on iptables.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yLaBmHMi4cq+C/u4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCTOfCXaXGVTD0i/8RAg3zAJ9hEShD6IRsjY7wI0vHy7oce1VoxACeK7fr
RUnq4+visR5F23JW6A5vgfU=
=Q36Q
-----END PGP SIGNATURE-----

--yLaBmHMi4cq+C/u4--
