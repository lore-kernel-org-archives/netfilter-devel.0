From: "Piotr =?iso-8859-2?Q?Gasid=B3o?=" <quaker@barbara.eu.org>
Subject: [PATCH] ipt_account update
Date: Fri, 27 Aug 2004 17:35:34 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040827153534.GA31119@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-20867-1093620934-0001-2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-20867-1093620934-0001-2
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

New ipt_account version 0.1.17:
- convert ipt_account to use seq_file API
- code cleanup

Attached patch includes patches for both 2.4 and (new) 2.6 kernel tree.
Please apply.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--=_pandora.barbara.ds.polsl.gliwice.pl-20867-1093620934-0001-2
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFBL1TGgEmu6PNADqoRAmFsAKCT5hyChwbraE+DEjjFndI5f16w0ACdFqxk
afi0q+jFRJ/lRBkzCuPTGuY=
=rfZ8
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-20867-1093620934-0001-2--
