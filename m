From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Is libiptc responsible for any memory leak?
Date: Tue, 7 Jan 2003 18:17:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030107171745.GM1353@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.43.0301071139010.282-100000@abodh.pesit.deeproot.co.in>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rpGc+ACYPE+RMC+Z"
Cc: netfilter-devel@lists.netfilter.org, leonardo@opalsoft.net
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Narendra Prabhu. B" <naren@deeproot.co.in>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.43.0301071139010.282-100000@abodh.pesit.deeproot.co.in>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rpGc+ACYPE+RMC+Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2003 at 12:10:39PM +0530, Narendra Prabhu. B wrote:

> Are the developers aware of this?

Please read the archives, and you will find out

- libiptc was never meant to be a public interface
  [unfortunately there still is no alternative to calling the iptables
  command]
- thus libiptc was developed for one-shot applications like iptables,
  and memory leaks were never considered harmful
- but we of course happily accept contributed fixes :)

> Regards,
> Narendra.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--rpGc+ACYPE+RMC+Z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Gwu5XaXGVTD0i/8RAghcAKCBhRaJ1+5OY19+N7oipmoyMG0VwwCfU9CR
8bu0zKY4YCDJScCKILkizJc=
=PWaY
-----END PGP SIGNATURE-----

--rpGc+ACYPE+RMC+Z--
