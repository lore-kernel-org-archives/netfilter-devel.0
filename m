From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] buffer overflow potential in /proc handling of iptables
Date: Fri, 5 Sep 2003 15:40:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030905134003.GG1597@obroa-skai.de.gnumonks.org>
References: <200309022248.h82Mm5YD007988@caligula.anu.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KscVNZbUup0vZz0f"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Darren Reed <avalon@caligula.anu.edu.au>
Content-Disposition: inline
In-Reply-To: <200309022248.h82Mm5YD007988@caligula.anu.edu.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KscVNZbUup0vZz0f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2003 at 08:48:04AM +1000, Darren Reed wrote:

> Today I was looking at the /proc handler for iptables, as an example
> of a simple implementation and along the way noticed that print_name()
> does this:
>=20
>           namelen =3D sprintf(buffer + *pos, "%s\n", t->name);
>                 if (*pos + namelen > length) {
>                         /* Stop iterating */
>                         return 1;
>                 }
>=20
> This is kind of like putting the horse before the cart.
>=20
> i.e. what's the point of checking to see if you're going to
> write to memory after the end of the buffer if you've already
> done it ?

Well, this question is based on an assumption:  the assumption that
the parameter stored in 'length' passed by proc_file_read() is the size
of the buffer.  This is not true.  The 'count' (how it is called in
proc_file_read() itself) indicates how many bytes the user wans to read.

And to quote from fs/proc/generic.c :

/* buffer size is one page but our output routines use some slack for
 * overruns */
 #define PROC_BLOCK_SIZE (PAGE_SIZE - 1024)

Which means that every get_info() member function is allowed to overrun
'count' up to 1024 bytes.

> The same code as above is used in other locations as well. =20

Yes, because it is fair use of the existing API.

> Darren

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KscVNZbUup0vZz0f
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/WJIyXaXGVTD0i/8RAioPAJ9EIidK9IapVcmu91mQc3ZCXLiUlwCgrqZB
krTjWvSzgevygF6PbALSywI=
=ugUi
-----END PGP SIGNATURE-----

--KscVNZbUup0vZz0f--
