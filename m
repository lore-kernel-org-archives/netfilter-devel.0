From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Re: ip_rt_bug in mangle/OUTPUT
Date: Thu, 24 May 2007 15:22:23 -0600
Message-ID: <4656020F.2060607@cpsc.ucalgary.ca>
References: <4654AE59.3090506@cpsc.ucalgary.ca> <4655D083.8070309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig4CD3B8B4A7CFFA257D3D2369"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4655D083.8070309@trash.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4CD3B8B4A7CFFA257D3D2369
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Rennie deGraaf wrote:
>> I seem to be getting the error message
>>     ip_rt_bug: 10.1.1.1 -> 10.0.1.2, ?
>> whenever I attempt to send a packet with a non-local source IP address=

>> (my local IP address is 10.0.1.2) from libipq in mangle/OUTPUT.  I hav=
e
>> observed this behaviour under Linux kernels 2.6.20.7 and
>> 2.6.18-1.2257.fc5smp (Fedora Core 5), and iptables versions 1.3.5 and
>> 1.3.7.
>=20
> If you don't need the rerouting to be happen (you only change the
> source address and don't use routing rules based on that) you can
> simply return NF_STOP instead of NF_ACCEPT. It will do exactly
> the same thing but avoid rerouting.

Thanks; that did the trick.

Rennie deGraaf


--------------enig4CD3B8B4A7CFFA257D3D2369
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGVgISIvU5mZP08HERAv3bAJ0c1L3NOB5eY+9Iselh9JTBzqyjowCggvIt
u/d5WOBuJMVAK9RwjG23Psc=
=833h
-----END PGP SIGNATURE-----

--------------enig4CD3B8B4A7CFFA257D3D2369--
