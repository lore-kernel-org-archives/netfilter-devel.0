From: =?windows-1252?q?R=E9mi_Denis-Courmont?= <rdenis@simphalempin.com>
Subject: Re: lib_RTPPROXY module
Date: Wed, 27 Jun 2007 21:57:27 +0300
Message-ID: <200706272157.30448@auguste.remlab.net>
References: <002901c7b8e9$7f806480$1401a8c0@nyala>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5801919.fCLcYRYy4e";
	protocol="application/pgp-signature"; micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Tomas Mandys" <tomas.mandys@2p.cz>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <002901c7b8e9$7f806480$1401a8c0@nyala>
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

--nextPart5801919.fCLcYRYy4e
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le mercredi 27 juin 2007, Tomas Mandys a =E9crit :
> Hi,
> so I've finally "finished" work on RTPPROXY module, it seems it works
> now for kernel 2.6.17.8.
(...)
> http://www.2p.cz/tmp/netfilter-rtpproxy.tgz.

 "RTP proxy is vulnerable for a while when is waiting for data to learn
  source address. We can decrease probability by reasonable learning
  timeout."

I disagree here. Do the math, or run the attack tests yourself, it takes=20
quite little bandwidth to denial (and hijack calls from)=20
a "promiscuous" RTP proxy, even with randomized ports numbers within a=20
large port range. 12 or even 14 bits of entropy are seldom acceptable.

Like it or not, the only "safe" ways to run SIP behind NATs requires=20
either, encryption (e.g. SRTP), some NAT traversal mechanism on the=20
clients (e.g. ICE) or an ALG within the client's own NAT.

Regards,

=2D-=20
R=E9mi Denis-Courmont
http://www.remlab.net/

--nextPart5801919.fCLcYRYy4e
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkaCsxoACgkQw+xtvt1tEr0/nwCgsRrCOeclLO+3urU5Noad4XWx
Yp8AoJqRRnTez9d4xNnoEA5UlS8YcA+0
=dYqd
-----END PGP SIGNATURE-----

--nextPart5801919.fCLcYRYy4e--
