From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: "Proper" way to transparent proxy?
Date: Wed, 9 Oct 2002 22:28:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009202829.GF23068@noir.cb.ac.at>
References: <3DA48D59.7060109@secureinteriors.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zi0sgQQBxRFxMTsj"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <3DA48D59.7060109@secureinteriors.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Zi0sgQQBxRFxMTsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 09, 2002 at 04:11:05PM -0400, Kevin White wrote:
> What we had on IPFilter was a "redirect" rule that redirected all=20
> connections to external hosts on this specific port to a specific port=20
> on the firewall machine, where a proxy program was waiting for it.  We=20
> then used IPFilter system calls to retreive where the connection was=20
> heading.
This is exactly how it works on linux, you redirect (or reroute+redirect if=
 on
different machines), accept the connection and call a sysctl to find out re=
al
destination. As for examples, there are several open source transparent
proxies:
- squid
- tircproxy
- jftpgw

> Kevin
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
                    "Where do you want to go to die?"

--Zi0sgQQBxRFxMTsj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pJFtzogxsPZwLzcRApmhAJ9yBAFco8tfBWa984smQ+40JVWcUgCfX7GV
GblOWhPTJhDiDw90T2eLYrc=
=yh5m
-----END PGP SIGNATURE-----

--Zi0sgQQBxRFxMTsj--
