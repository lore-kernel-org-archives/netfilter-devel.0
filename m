From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Sun, 31 Jul 2005 21:11:18 +0200
Message-ID: <20050731191118.GE22330@rama.de.gnumonks.org>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
	<1122802193.4159.12.camel@porky>
	<20050731103812.GF14874@rama.de.gnumonks.org>
	<1122833084.4159.24.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1QUDc0q7S3U7/Jg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1122833084.4159.24.camel@porky>
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


--a1QUDc0q7S3U7/Jg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 31, 2005 at 08:04:44PM +0200, Eric Leblond wrote:
> > The problem are the optional attributes.  A packet from the kernel could
> > optionally contain
> > 	PAYLOAD
> > 	MARK
> > 	TIMESTAMP
> > 	IFINDEX_IN
> > 	IFINDEX_OUT
> > 	...
> > and this may change from packet to packet.  so we cannot just pass a
> > fixed structure to the application program like libipq did.  OTOTH, I
> > don't want the applications have to do their own netlink message parsing
> > (with NFA_... macros), since that would violate the layering. Any ideas?
>=20
> It reminds me the problem we had when we had to define the NuFW
> protocols. We take the idea from radius protocol which can contains an
> arbitrary number of fields. This works as follow :=20
> start of the message contains the type of the message and its length
> (calculate from the content). Then we have fields all optional
> containing their type, option and length

The problem is not the protocol.  This is already implemented on the
kernel side, and there are accessor macros on the userspace side.  No
worries about that.

The problem is: How would your application like to interface with those
optional attributes.  The library should hide protocol details from
the application, but how would a sane API for that look like?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--a1QUDc0q7S3U7/Jg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC7SJWXaXGVTD0i/8RAkARAJ9ojXsL4YZGnCdW4L6C/EwsMFd7dgCeNxaQ
BnmKdJfKsjxo+XmN+DUBwLs=
=cuvX
-----END PGP SIGNATURE-----

--a1QUDc0q7S3U7/Jg--
