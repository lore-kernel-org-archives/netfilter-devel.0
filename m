From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: iptables: memory allocation problem
Date: Sat, 20 Dec 2003 13:30:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1071923429.24067.76.camel@tux.rsn.bth.se>
References: <20031216182959.GA1216@eychenne.org>
	 <20031220121218.GA1370@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mt7zQweQKey40vNGqblY"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20031220121218.GA1370@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-mt7zQweQKey40vNGqblY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-12-20 at 13:12, Herve Eychenne wrote:

> Well, anyway, as conntrack listing locks conntrack state, don't you
> think we should definitely provide a way to read ip_conntrack_count
> through /proc/sys/net/ipv4/netfilter/ip_conntrack_count ? (aka
> "Yet Another Oneliner Patch For Patch-O-Matic")

Just a quick response before I vanish for some christmas vacation.

Look at extra/ctstat.patch*
Apply it and download the util, it will give you what you want and more.

--=20
/Martin

--=-mt7zQweQKey40vNGqblY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/5EDkWm2vlfa207ERAoKCAJ4rK8vVYvSB5BE384UgHwWbNx4EiACbBUQ/
0vWxiFsO9+Z+4pH/wMQwitA=
=1wFA
-----END PGP SIGNATURE-----

--=-mt7zQweQKey40vNGqblY--
