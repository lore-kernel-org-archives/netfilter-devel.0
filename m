From: Harald Welte <laforge@netfilter.org>
Subject: Re: [netfilter-core] How many packets can be held by queue target?
Date: Thu, 8 Dec 2005 16:16:41 +0530
Message-ID: <20051208104641.GC19616@rama.exocore.com>
References: <4397FB0B.4070608@measurelabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3siQDZowHQqNOShm"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Xiaohu Dong <dongxiaohu@measurelabs.com>
Content-Disposition: inline
In-Reply-To: <4397FB0B.4070608@measurelabs.com>
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


--3siQDZowHQqNOShm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 08, 2005 at 05:21:15PM +0800, Xiaohu Dong wrote:
> Hi,
>     I am using libipq to fetch pkt in my current project. I am curious
>  if I don't retrieve pkt from the queue in time, how many pkt can
>  the queue hold before dropping?

that depends on how much you have configured ;)  I think the limit would
be 2^32 packets if you have that amount of RAM.  default is 1024.

use the source, luke.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3siQDZowHQqNOShm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDmA8RXaXGVTD0i/8RApauAJ9hS64ky2St4P1UQRhHYDV0RC2uPQCgjH8Q
5G2ZxN0f9t48V5yafYCGWfE=
=HRgO
-----END PGP SIGNATURE-----

--3siQDZowHQqNOShm--
