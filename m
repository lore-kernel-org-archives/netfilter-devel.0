From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/7] don't check nfattr_parse_nested return value
Date: Sat, 5 Nov 2005 11:27:43 +0100
Message-ID: <20051105102742.GT5594@sunbeam.de.gnumonks.org>
References: <436BA1B0.9010702@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/Dpz40iF3jpiHxF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <436BA1B0.9010702@netfilter.org>
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


--2/Dpz40iF3jpiHxF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 04, 2005 at 07:00:16PM +0100, Pablo Neira wrote:
> nfattr_parse_nested always returns success. So we don't need such
> checking. It's unlikely that nfattr_parse would return something
> different than 0 in the future, if that day comes for whatever reason we
> could get the checking back.

if this is the case, then nfattr_parse() should become a void function.

also, you missed one occurrence of nfattr_parse_nested() in ip_conntrack_tc=
p.c

I'm fixing this up and apply a modified version of this patch.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2/Dpz40iF3jpiHxF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbIkeXaXGVTD0i/8RAt1qAKCAfqFDMv+Vhm8Y4viUmHNiPX12AwCgg4He
82aOCLzYbHLV+Q46GWPTsLc=
=hPKU
-----END PGP SIGNATURE-----

--2/Dpz40iF3jpiHxF--
