From: Harald Welte <laforge@netfilter.org>
Subject: Re: String match patch 2.6.10
Date: Fri, 5 Nov 2004 10:26:39 +0100
Message-ID: <20041105092639.GT5606@sunbeam.de.gnumonks.org>
References: <20041105085422.GA22273@physik.uni-hannover.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6tPipYVl+OcoAvSh"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jochen Paul <cpaul@physik.uni-hannover.de>
Content-Disposition: inline
In-Reply-To: <20041105085422.GA22273@physik.uni-hannover.de>
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


--6tPipYVl+OcoAvSh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 05, 2004 at 09:54:22AM +0100, Jochen Paul wrote:
> Dear Harald,
>=20
Hi Jochen!

Please send patches (in diff -u format rather than .tar.gz) to
netfilter-devel.

> According to the differences in ipoption between linux and linux-2.6 and
> the following references :
> http://lists.netfilter.org/pipermail/netfilter-devel/
> 2004-February/014116.html and
> http://lists.netfilter.org/pipermail/netfilter-devel/
> 2004-February/014066.html I have generated the string module for
> the 2.6.x Kernel. The Patch File patch-o-string.tgz for extracting in the
> patch-o-matic-ng-2004.... could be found here:
> http://www.physik.uni-hannover.de/string_2.6/patch-o-string.tgz .
> The code has been tested only on a single processor maschine and with
> strings less than 20 characters and seems to work. Please test it also on
> multiprozessor boards and with large strings.

The problem is that it is not as easy as this to read the packet
contents anymore in 2.6.x. There is no guarantee that the whole packet
is in one contiguous memory segment anymore.  Your match will terribly
crash as soon as the first nonlinear skb is found.

Please look for references of 'nonlinear skb' or skb_iter on the
netfilter lists and netdev.

Because this is not an easy issue, I'm working on a general pattern
matching API for nonlinar skb's -  but as usual I got distracted by
other stuff.  Give me some two more weeks.

> Please put it in the actual patch-o-matic tree.

Sorry, not in it's current form.  You're welcome to fix it wrt. linear
skb's (but don't just call skb_linearize, that is considered broken,
too), then I'm happy to apply it.

> Best regards
>                             Jochen Paul

Cheers,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6tPipYVl+OcoAvSh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBi0dPXaXGVTD0i/8RAneoAKCLLOMP0TG1DJpIQw54SOzaYqabWgCfTaF2
t/pKSbrb8FVyKsitaTi1/30=
=ry17
-----END PGP SIGNATURE-----

--6tPipYVl+OcoAvSh--
