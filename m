From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@pandora.barbara.eu.org>
Subject: Re: ip accounting
Date: Fri, 21 May 2004 11:15:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040521091534.GA17812@pandora.barbara.eu.org>
References: <40ACAFDA.7497.4A56EAD@localhost> <200405201604.46581.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_pandora.barbara.ds.polsl.gliwice.pl-27406-1085155637-0001-2"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200405201604.46581.thomas.jarosch@intra2net.com>
Resent-Message-Id: <E1BRCYN-000640-KE@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-27406-1085155637-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On czw, 20/05, 04:04:46, Thomas Jarosch wrote:
> Hello Toholj,
>=20
> > I heard that there was a discussion about "accounting based on ip addre=
ss
> > upl/dnl". If that's right, could someone send me the whole story?
>=20
> There are currently four ways to do traffic account:
> (...)
> 2. Use the ipt_account match from here:
> http://www.barbara.eu.org/~quaker/ipt_account/
> (Wasn't there an english version somewhere?)

Please use ipt_account, 0.2.x tree. It can be found here:
http://www.barbara.eu.org/~quaker/ipt_account2/

English documentation:
http://www.barbara.eu.org/~quaker/ipt_account2/english/mini-howto.txt

ipt_account version 0.2.x will be soon submitted to netfilter cvs,
replacing old one (version 0.1.x).

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--=_pandora.barbara.ds.polsl.gliwice.pl-27406-1085155637-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFArci2gEmu6PNADqoRAjw2AKCQuST3BF9Or/h2eejWdLwnF5IY5QCbBnYO
vOgjhdhKL9buVipoY1u4Ib8=
=jRn3
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-27406-1085155637-0001-2--
