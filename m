From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter_queue to libipq comatiblity library
Date: Wed, 25 Oct 2006 12:19:35 +0200
Message-ID: <20061025101935.GE6045@sunbeam.de.gnumonks.org>
References: <453F22A0.4040506@ds.hj.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gSSGYPGSs0dvYOj7"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Gunnarsson <guda@ds.hj.se>
Content-Disposition: inline
In-Reply-To: <453F22A0.4040506@ds.hj.se>
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


--gSSGYPGSs0dvYOj7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2006 at 10:38:56AM +0200, David Gunnarsson wrote:
> Hi my name is David Gunnarsson and i am working on my masters thesis
> work where i am in a situation where it might come handy to port a
> libipq-program to netfilter_queue. Ofcourse a "real" porting of the
> legacy libipq-based software might be the best it is quite some work,
> i've read about a compatiblity "layer" to netfilter_queue and libipq
> which could make porting easier. On your online blog dated to august
> 2005 i read that work was going on with the API but i've read no
> further about any progress. Are there any?

no, it's working just fine, I know several programs using (the new api,
not the compatibility)

> If there are, where can i find information on how to use it? I see
> that in the source of libnetfilter_queue there is a libipq_compat.c
> source file containing womething that seems to be some kind of
> compatiblity layer. (im using version 0.0.12)

yes. that basically is all information there is (the header files and
the library source code).  You also might look at the port of inline
snort to the new api, and the nufw code  (http://www.nufw.org)  as an
example.

> b.t.w. i have seen the ipqueue multiplex daemon but it did not seem as
> as good solution as a compatiblity layer.

no, no way. that was sort-of a programming exercise and some kludge some
six years ago, and it doesn't perform well.

if you need support for multiple queue listeners, you cannot use the
libipq_compat layer, though.  The compatibility layer is 100%
compatible, e.g. doesn't give you any more features.  If you want more
features, you will have to use the native 'libnetfilter_queue' API.

> i dont know if this is the right email to reach you by but it was the one=
 i found.

I don't really have time for netfilter at this moment.  I suggest
posting to netfilter-devel@lists.netfilter.org and see what other
developers can assist you.

--=20
- Harald Welte <laforge@gnumonks.org>          	        http://gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
We all know Linux is great...it does infinite loops in 5 seconds. -- Linus

--gSSGYPGSs0dvYOj7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFPzo3XaXGVTD0i/8RAqpHAJ91+KlFSrjhcXa0jEpe9br7Vi4A1wCfUyq0
JM9FMetZj0tMVe1UJ9HvzWI=
=GXbB
-----END PGP SIGNATURE-----

--gSSGYPGSs0dvYOj7--
