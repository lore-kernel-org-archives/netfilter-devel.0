From: Clifford Wolf <clifford@clifford.at>
Subject: Re: [PATCH] ipset type "expire"
Date: Thu, 19 May 2005 16:40:25 +0200
Message-ID: <20050519144025.GJ6159@clifford.at>
References: <20050519132414.GH6159@clifford.at>
	<Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CNK/L7dwKXQ4Ub8J"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0505191553010.12421@blackhole.kfki.hu>
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


--CNK/L7dwKXQ4Ub8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 19, 2005 at 04:06:17PM +0200, Jozsef Kadlecsik wrote:
> | A new set type called 'iptree' (inspired and triggered by Clifford
> | Wolf) added, which makes possible to store IP addresses which
> | automatically time out. Please note, this is an initial new feature with
> | some hardcoded parameter (like the frequency of garbage collection) and
> | thus may change in the future.

oh, great! so please forget about my prev mail then.. ;-)

yours,
 - clifford

--
ocaml graphics.cma <( echo 'open Graphics;;open_graph " 640x480"let
complex_mul(a,b)(c,d)=3D(a*.c-.b*.d,a*.d+.b*.c)let complex_add(a,b)(c
,d)=3D(a+.c,b+.d);;let rec mandel c n=3Dif n>0 then let z=3Dmandel c(n-1)
in complex_add(complex_mul z z)c else (0.0,0.0);; for x=3D0 to 640 do
for y=3D0 to 480 do let c=3D((float_of_int(x-450))/.200.0,(float_of_int
(y-240))/.200.0) in let cabs2(a,b)=3D(a*.a)+.(b*.b)in if cabs2(mandel
c 50)<4.0 then plot x y done done;;read_line()' )
=20
Press CTRL-ALT-DEL now for an IQ test.
=20

--CNK/L7dwKXQ4Ub8J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFCjKVZPNIEsfpKDdERAhaTAKDTKWDL7CtlkqMogi8OLIXCQsbyjwCfb9+M
i0FCFIfKp+MeF9cuUTqFgdc=
=2veb
-----END PGP SIGNATURE-----

--CNK/L7dwKXQ4Ub8J--
