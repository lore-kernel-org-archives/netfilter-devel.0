From: Harald Welte <laforge@gnumonks.org>
Subject: Re: init_conntrack oops :-(
Date: Mon, 10 Feb 2003 11:35:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210103537.GW24861@sunbeam.de.gnumonks.org>
References: <003c01c2ce73$55c30400$0c0110ac@nap.nikolaev.ua>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lsrIB+s628ok5gC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Oleg A Chernov <oleg.chernov@nap.nikolaev.ua>
Content-Disposition: inline
In-Reply-To: <003c01c2ce73$55c30400$0c0110ac@nap.nikolaev.ua>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0lsrIB+s628ok5gC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2003 at 08:37:07AM +0200, Oleg A Chernov wrote:
> Hello,
> I have Debian router with 2.4.18 kernel compiled myself from debian sourc=
es
> with gcc 2.95.4 with the following options:

can you plase submit this to http://bugzilla.netfilter.org/ ?

Thanks.

> If any advanced information is required, I'll provide it and I will be ve=
ry
> grateful if someone helps me with this problem.

We are not aware of this problem.  A couple of further questions (please
include answers to your bugzilla post):

- did you apply any patches (netfilter related or not) to the 2.4.18
  kernel?
- do you have any kind of 'special' setup (tunnelling, freeswan,
  ip_queue, ...)?
- do you have any idea how to reproduce your problem?

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--0lsrIB+s628ok5gC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+R4B5XaXGVTD0i/8RAs0cAKCnJxyIo8Q3F/u5iXOEt+mX1IVkvACeMkLx
y+FLspdELBH0qVtuEkl95mw=
=Cu99
-----END PGP SIGNATURE-----

--0lsrIB+s628ok5gC--
