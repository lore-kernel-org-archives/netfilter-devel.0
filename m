From: Harald Welte <laforge@netfilter.org>
Subject: Re: real time stateful filtering question
Date: Wed, 17 Mar 2004 20:44:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040317194407.GK21899@sunbeam.de.gnumonks.org>
References: <20040317135825.GA21899@sunbeam.de.gnumonks.org> <NEBBJFIAIKIHKGJDONCDMENJCCAA.smith-peter@comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rwgQ89ZNnFUwFHTC"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: peter smith <smith-peter@comcast.net>
Content-Disposition: inline
In-Reply-To: <NEBBJFIAIKIHKGJDONCDMENJCCAA.smith-peter@comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rwgQ89ZNnFUwFHTC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 17, 2004 at 09:53:34AM -0500, peter smith wrote:
> I believe that while the backlog queue is processed in the kernel, in-ord=
er,
> the fact that the packet containing the FTP "PORT" command isn't processed
> by my userland application level decode until a context switch occurs mak=
es
> it impossible to guarantee that the userland application level decode will
> get to process the PORT command packet will be seen before data channel
> packets are discarded ... this seems to be common sense unless there is s=
ome
> workaround that I am missing (or fundamental tenet I am missing)...

I thought you were talking about a connection tracking helper module.
Those (like ip_conntrack_ftp) are execute inside the network RX softirq,
so there is no asynchronous behaviour.

If you have to pass the packet up to userspace, you are completely
right.  There would definitely be a race condition.

> Thanks!
> Peter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--rwgQ89ZNnFUwFHTC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAWKqHXaXGVTD0i/8RAh+qAJ9aqd0zxK+kuzAuNMaoavsvig8lbgCdH+OK
5k+9ZWmMB5q8/aPkBgE9KfI=
=cPVM
-----END PGP SIGNATURE-----

--rwgQ89ZNnFUwFHTC--
