From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: [gpel@mpex.net: multiple ports in ip_nat_irc]
Date: Sat, 12 Oct 2002 15:29:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012132935.GY26033@noir.cb.ac.at>
References: <20021012144115.Z13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fKfh0xY2eB01Z/0V"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20021012144115.Z13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fKfh0xY2eB01Z/0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 12, 2002 at 02:41:15PM +0200, Harald Welte wrote:
> Whenever I enter the ports command say ports=3D6666 it will fail saying i=
t=20
> can't register the port, however I input it as part of an array port
> ports[0] =3D 6666; ports[1] =3D 6667; etc. it works.
How about passing this parameter to ip_conntrack_irc and not ip_nat_irc? I
must admit I don't understand how you are supposed to use it after looking =
at
the source.

> - Gregor
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
                            rm -f /bin/laden

--fKfh0xY2eB01Z/0V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qCO+zogxsPZwLzcRAjBXAJ44/73ogii7R/97wWk+u/jzb66BiwCfeSbO
NOPyl8cPadAs5u7peKM7I00=
=UUjN
-----END PGP SIGNATURE-----

--fKfh0xY2eB01Z/0V--
