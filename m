From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: SNAT own module
Date: Tue, 3 Dec 2002 21:33:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021203203356.GP18270@noir.cb.ac.at>
References: <1038930033.3decd071443b6@wmail-mat.upc.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H14uD12u8nekTETJ"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1038930033.3decd071443b6@wmail-mat.upc.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--H14uD12u8nekTETJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 03, 2002 at 04:40:33PM +0100, Eduard Calvo (B-teljpa) EXP JAN 0=
3 wrote:
>   Hi gurus, =20
hi again :-)

>   What I want to know is if is possible to do this in a raw manner. I mea=
n, I =20
> have an ethernet card (let it be eth0) which IP address 10.0.0.1, which =
=20
> manages the 10.0.0.X network. The problem is that hosts attached to that =
=20
> network don't have to have an IP address on that range.
Now we get to the point. IMHO you are trying to create an unnecessary
complicated structure. The easiest way to solve this is to add another ip(s)
to eth0.

If you are not allowed to do this, you could possibly just add static route=
s.

Anyway, not a netfilter-devel question, slightly growing offtopic.

>   Does anyone know the better way to do this?=20
See above :-)

>                                              Eduard.=20
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
     The three Rs of Microsoft support: Retry, Reboot, Reinstall.

--H14uD12u8nekTETJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE97RU0zogxsPZwLzcRAl2hAKCZs/WkvB3xdfN/c7VRFrKr7Rnt3gCggQI/
5YoCkR4Cm/PK+R4WFrGX4i4=
=IMYR
-----END PGP SIGNATURE-----

--H14uD12u8nekTETJ--
