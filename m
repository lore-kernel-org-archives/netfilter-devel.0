From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 09:04:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020070433.GZ21521@sunbeam.de.gnumonks.org>
References: <3F931647.5060204@trash.net> <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6y2Evnd5/t1JTLIo"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6y2Evnd5/t1JTLIo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 03:05:41AM +0200, Henrik Nordstrom wrote:

> It is imporant that userspace does not miss entries which was in the=20
> kernel when duming started and still exists in the kernel when the dump=
=20
> finished.

finally agreed.

> It is also important userspace can have some kind of semi-static=20
> reference to a conntrack to be able to manipulate that conntrack without=
=20
> risking hitting another conntrack.

also agreed.

> It is OK for me if it is unspecified what happens with entries which=20
> either was created or destroyed while the dump was in progress.

ack.

> With these criterias in mind I propose a hybrid of your approaches
>=20
> a) Assign a globally unique ID to each conntrack, in such manner that IDs=
=20
> is not reused for a significant amount of time. This to provide a stable=
=20
> point of reference to a connection with low risk of false collisions if=
=20
> the original connection was destroyed while userspace still thought it wa=
s=20
> there.=20

In reality, we could use a pointer together with a generation-counter.
That generation counter could be incremented as soon as we return the
structure to the slab cache.  This way we could live with a 32bit
generation counter + pointer/address.=20

> b) When duming the conntrack entries, dump one bucket at a time.=20
> If the bucket is too large to fit in the current response packet=20
> then sort the bucket entries on ID and keep track of which bucket+ID=20
> was last dumped. On next netlink packet restart at the same bucket and=20
> skip the entries with a ID lower than those already dumped for that=20
> bucket.

I'm going to comment on this in the next mail.
> Regarding the conntrack ID. For me it is acceptable if as much as 64 bits
> is reserved for the conntrack ID. This gives sufficient namespace to

for me, not a single bit is acceptable.  the size of ip_conntrack is
already way too heavy.  the l3 generic conntrack should have support for
different-sized conntracks, e.g. saving the ct/nat helper part for all
conncetions but the ones that actually have a helper, etc.

> a) Provide truly unique IDs suitable for long-term reference without any=
=20
> risk of collisions.

a generation counter would make that guarantee.

> b) Allows for the namespace to be built in such manner that there never
> will be any risk for congestion in finding the next available ID. For=20
> example by using CPU#+counter.

generation counters also fulfill that requirement. However, they are not
ordered.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6y2Evnd5/t1JTLIo
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/k4kBXaXGVTD0i/8RAsYjAJ9dYaEGWDJgQZ8LXF0neh665y3XoQCcDCcT
YlSiGv0bR6qk9zI/mpMB+X8=
=zjbs
-----END PGP SIGNATURE-----

--6y2Evnd5/t1JTLIo--
