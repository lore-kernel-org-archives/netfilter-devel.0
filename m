From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 14:33:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229133308.GO7790@sunbeam.de.gnumonks.org>
References: <20040225182828.GP13386@sunbeam.de.gnumonks.org> <20040229101116.GA10012@pcw.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSn4sQg3MnruwCB4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20040229101116.GA10012@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KSn4sQg3MnruwCB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 29, 2004 at 11:11:16AM +0100, Willy TARREAU wrote:
> Hi Harald,
>=20
> Just tested it on top of 2.4.25, like this :
>=20
>     KERNEL_DIR=3D/usr/src/linux-2.4.25-pomng ./runme --batch extra
>=20
> and I got a few problems :
>=20
>   - first, I didn't find how to specify where my iptables sources is
>     installed, so I had to enter it by hand each time I restarted it.
>     I did not find any env variable in the perl code, and I must say
>     that my understanding of perl is, hmmm.. very limited.

I've now introduced the IPTABLES_DIR environment variable (or the
--iptables-path option)

>   - ROUTE and TRACE told me :
>     "unable to find ladd slot in src /usr/src/linux-2.4.25-pomng/./net/ip=
v6/Makefile"
>     I think they wanted to add a line in the Makefile but didn't find
>     the right place to do so.=20

Yes, indeed.  They were in the wrong directory, should be fixed now.

> BTW, is there a way to install a patch only for ipv4 or for ipv6 like bef=
ore ?

no.

>   - I observed usual conflicts :
>     present 'CONNMARK' conflicts with to-be-installed 'connbytes'
>     present 'raw' conflicts with to-be-installed 'conntrack-seqfile'
>     present 'CONNMARK' conflicts with to-be-installed 'conntrack_arefcoun=
t'

yes, that is normal and perfectly ok.

>   - and finally, trying to apply conntrack_locking litterally killed my
>     box in out of memory within a few tens of seconds (I could not even
>     run ps) :

ouch.  That needs to be fixed.  I'll try to reproduce that.

> Cheers,
> Willy

Thanks for your testing so far.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KSn4sQg3MnruwCB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQeoUXaXGVTD0i/8RApH/AJ0Rm80H13VFJ3TtEqJkFwWdaZhIhACeJEEG
byxquKXt+QEobSoUn0HnPfU=
=vT5N
-----END PGP SIGNATURE-----

--KSn4sQg3MnruwCB4--
