From: Peter Surda <shurdeek@panorama.sth.ac.at>
Subject: Re: Forced SNAT in PREROUTING
Date: Fri, 29 Nov 2002 18:54:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021129175428.GI6400@noir.cb.ac.at>
References: <1038590746.3de7a31a50736@wmail-mat.upc.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <1038590746.3de7a31a50736@wmail-mat.upc.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2002 at 06:25:46PM +0100, Eduard Calvo (B-teljpa) EXP JAN 0=
3 wrote:
>   Hi gurus,=20
Hi,

>   All I have to do is to allow the target SNAT to be called in the PREROU=
TING=20
> chain.
Actually, I am also interested in something like this. More precisely, I wo=
uld
like to match a packet after doing SNAT, but currently AFAIK this is not
possible, after you do a -j SNAT (or -j SAME), the packet leaves all tables
and all chains.

Why? It would allow very easy loadbalancing if you have more lines. You sim=
ply
SNAT/SAME to more addresses and then ROUTE to a specific interface. Now if =
you
SNAT/SAME, the packet can't be matched anymore and there is no way to do
ROUTE. And as you just have been in POSTROUTING, you can't reroute from
userspace anymore.

>                                     Eduard Calvo.=20
Bye,

Peter Surda (Shurdeek) <shurdeek@panorama.sth.ac.at>, ICQ 10236103, +436505=
122023

--
               I believe the technical term is "Oops!"

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE956nTzogxsPZwLzcRAvabAJkBvQAPEdLHc5VvdrdjNpbhzUCY/QCfUc/4
1TBoqJOWGrQlEo4ycIW7Ck4=
=gDdr
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
