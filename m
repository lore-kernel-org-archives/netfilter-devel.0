From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] PPTP conntrack bugfixes
Date: Sun, 9 Feb 2003 10:52:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209095200.GT13269@naboo.fugue.com>
References: <3E40C93E.5080603@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="25rOlkxR6a4U87uN"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3E40C93E.5080603@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--25rOlkxR6a4U87uN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2003 at 06:20:14PM +1000, Philip Craig wrote:
> I've attached 2 patches for the pptp connection tracking.

thanks, pptp conntrack/nat seems to be more popular than i thought ;)

> The first patch changes the way we mangle the call ids.
> Since the call id is in the data portion of the TCP packet,
> we must make a copy of the skb first,  otherwise bad things
> happen if TCP tries to retransmit this data.  I've used
> ip_nat_mangle_tcp_packet() for this purpose, although it is
> slightly less efficient than needed since it handles resizing
> as well.

mh. I've never thought of this stuff being used for a _local_ pptp
server - and this is the only case where tcp would retransmit something.

I think I'll change your patch to not make this additional call to
ip_nat_mangle_tcp_packet().

> The second patch unexpects the related connections when a
> CALL_DISCONNECT_NOTIFY is received.  I've had situations
> where leaving these expectations caused subsequent attempts
> to connect to fail.  I suspect this is partly due to a
> buggy PPTP server reusing call IDs, but there is no need to
> keep these expectations around any longer.

yes, this totally makes sense. thanks.

> While making the second patch, I noticed that
> pptp_timeout_related() has a comment asking if a lock is
> needed.  I suspect that we need to hold a write lock on
> ip_conntrack_lock here?

Yes, but it was a more complex issue than that.  I need to  think this
through thoroughly.

> Harald, is this format for patches okay?  I can diff them
> against the patch in patch-o-matic if needed.

it's perfectly fine.  Expect me to take some time for mergeing and testing.

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--25rOlkxR6a4U87uN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+RiTAXaXGVTD0i/8RAgpqAKCzNL5wNaMweQ0CgoZx9QYRkQqdcACgsMOw
PvP0GoUfwqpDubk7Jhswsxc=
=su0D
-----END PGP SIGNATURE-----

--25rOlkxR6a4U87uN--
