From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: Problem in using iplimit
Date: Wed, 9 Oct 2002 18:45:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009164526.GF19999@noir.cb.ac.at>
References: <20021009092515.23022.qmail@web13101.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jHP/eq8oeUshSv2p"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20021009092515.23022.qmail@web13101.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jHP/eq8oeUshSv2p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2002 at 05:25:15PM +0800, tin man chan wrote:
> Hi,
hi

> iptables -p tcp --syn --dport 23 -m iplimit --iplimit-above 2 -j REJECT
>=20
> iptables v1.2.7a: no command specified
> Try `iptables -h' or 'iptables --help' for more information.
Of course, you are missing the command (I presume -I, -A or -R) and chain
(probably INPUT or FORWARD).

> Steven Chan
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
           Intel: where Quality is job number 0.9998782345!

--jHP/eq8oeUshSv2p
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pF0lzogxsPZwLzcRAgtBAJ9hpJCl9zZCr5VebPeAVPsF4bYTjQCglGAJ
t/rOyHg+yC/W1tlDEVfOygk=
=zWvL
-----END PGP SIGNATURE-----

--jHP/eq8oeUshSv2p--
