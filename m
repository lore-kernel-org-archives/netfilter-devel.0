From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables.8 manpage not complete
Date: Mon, 3 Mar 2003 23:38:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030303223844.GO11384@sunbeam.de.gnumonks.org>
References: <200302132039.58656.bdschuym@pandora.be> <20030214072944.GI14794@sunbeam.de.gnumonks.org> <20030218164739.GF445@eychenne.org> <20030303172520.GD11384@sunbeam.de.gnumonks.org> <20030303210134.GA493@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R92lf0Oi2sxyK3LA"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Andras Kis-Szabo <kisza@sch.bme.hu>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?iso-8859-1?Q?Herv=E9?= Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20030303210134.GA493@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--R92lf0Oi2sxyK3LA
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2003 at 10:01:34PM +0100, Herv=E9 Eychenne wrote:
=20
> Yes, you're completely right.  I had checked before replying and had
> noticed that only one was missing... indeed, it was ipt_helper.c...
> But I didn't remember having ever heard about this match before (despite
> my daily read of the devel mailing-list) and a very quick look to the
> code made me consider it as... well, I don't know... a sort of 'dummy'
> module. ;-) Maybe it's because of its very generic nature.
> But I was clearly wrong. Never trust me again, please. :-)

;) no problem.  This was just pointed out by somebody on IRC to whom
I've described the 'helper' match and he told me it is not present in
1.2.7a [but it was just not mentioned in the manpage].

The helper match is _extremely_ ueful.  You can use it for traffic
shaping ftp data connections, which you would otherwise not clearly
catch.. something like=20
'-t mangle -A POSTROUTING -j MARK --set-mark 2 -m helper --helper ftp'
would mark all ftp data connections with 2...

and you can now have different rules for different RELATED packets
according to which helper has marked them RELATED...

> Yesterday I was a loser, now I'm an informer... it's only getting
> worser! ;-)

*lol*

>  Herve
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--R92lf0Oi2sxyK3LA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Y9l0XaXGVTD0i/8RAsS/AJwMwPridb62qJI6i4swtC1yANEbHQCfT0RP
bxcQuLsRtJ9DofYsdp1Vtko=
=bAg7
-----END PGP SIGNATURE-----

--R92lf0Oi2sxyK3LA--
