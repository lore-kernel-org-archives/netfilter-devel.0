From: Gianni Tedesco <gianni@ecsc.co.uk>
Subject: Re: Idea: string replace
Date: 02 Oct 2002 14:44:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1033566290.27036.116.camel@lemsip>
References: <20021001011306.GG16521@noir.cb.ac.at>
	 <20021001072702.GA23302@oknodo.bof.de>
	 <20021001210650.GC22145@noir.cb.ac.at>
	 <20021001233327.GF22145@noir.cb.ac.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rpU/rb5kWKCzEH5Y+GHa"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Surda <shurdeek@panorama.sth.ac.at>
In-Reply-To: <20021001233327.GF22145@noir.cb.ac.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-rpU/rb5kWKCzEH5Y+GHa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2002-10-02 at 00:33, Peter Surda wrote:
> On Tue, Oct 01, 2002 at 11:06:50PM +0200, Peter Surda wrote:
> > > Regarding the "is it difficult" question, that depends on whether you
> > > want to replace with a string of identical length (piece of cake),
> > Actually, I didn't think so far as to use different lengths, somehow I
> > subconsiously assumed it is far from easy. Again, I only need this for =
a very
> > specific purpose (disabling one virus), for which IMHO same-length-repl=
ace is
> > sufficient.
> Ok, so I tried, I tried really hard <g>, and it compiled, and it didn't c=
rash,
> and it seems to behave as expected (the virus attachment arrives or is
> downloaded, but is artifically corrupt and doesn't work). Attached patche=
s
> (one userspace and one kernel) against cvs from end of July.
>=20
> The string match has a new option, --replace-with, that takes one string =
as a
> value. I think the code is straightforward, the checksumming stuff is pas=
ted
> from nat_helper.c (but it doesn't do conntrack of course).

Cool, I'm pretty sure you could pre-compute the checksum differences in
userspace and pass them in the info struct that would save dirtying lots
of CPU caches *too* much. :]

> Please test and report :-). I am sure there are more cool ways to use it =
than
> fighting virii.

Everyone here knows the problem of this approach for virus killing. To
do it right you need to wory about if the virus straddles two packets,
is radix 64 encoded, is using HTTP gzip ecoding, is using SMTP TLS,
never mind the various ptacek/newsham style attacks for TCP etc etc...

That said, I'm sure this will catch 99% of all viruses because they
probably wont straddle two packets, they certainly aren't deliberatly
evasive and they are usually sent via mail APIs which allow little
control that would let you do most of the interesting evasion
techniques.

--=20
// Gianni Tedesco (gianni at ecsc dot co dot uk)
lynx --source www.scaramanga.co.uk/gianni-at-ecsc.asc | gpg --import
8646BE7D: 6D9F 2287 870E A2C9 8F60 3A3C 91B5 7669 8646 BE7D

--=-rpU/rb5kWKCzEH5Y+GHa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQA9mvhSkbV2aYZGvn0RAnjKAJ92sBT9wLZ/PUn7l4juFMgbn+p61gCdHtKo
VfUnnFLiyK2AuYv1Vz3+3A8=
=+c6I
-----END PGP SIGNATURE-----

--=-rpU/rb5kWKCzEH5Y+GHa--
