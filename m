From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] PPTP conntrack bugfixes
Date: Mon, 10 Feb 2003 13:06:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210120612.GZ24861@sunbeam.de.gnumonks.org>
References: <3E40C93E.5080603@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MI2pJyvBeFc4alSb"
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


--MI2pJyvBeFc4alSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2003 at 06:20:14PM +1000, Philip Craig wrote:

> The first patch changes the way we mangle the call ids.
> Since the call id is in the data portion of the TCP packet,
> we must make a copy of the skb first,  otherwise bad things
> happen if TCP tries to retransmit this data.  I've used
> ip_nat_mangle_tcp_packet() for this purpose, although it is
> slightly less efficient than needed since it handles resizing
> as well.

great.  I have now decided to use ip_nat_mangle_tcp_packet, otherwise
the code really gets too ugly.  They only change I made is the
calculation of the 'offset' parameter needed for the mangle_tcp_packet()
function.

> The second patch unexpects the related connections when a
> CALL_DISCONNECT_NOTIFY is received.  I've had situations
> where leaving these expectations caused subsequent attempts
> to connect to fail.  I suspect this is partly due to a
> buggy PPTP server reusing call IDs, but there is no need to
> keep these expectations around any longer.

as stated before, this is correct.

I'll submit the updated patch to CVS soon.

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances
--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--MI2pJyvBeFc4alSb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+R5W0XaXGVTD0i/8RAp5NAJ9NzhavFjWrB25kItU65R5zFYgOUQCfd8De
zFsNZYZ7Go/lljvMqScDAdo=
=T+PM
-----END PGP SIGNATURE-----

--MI2pJyvBeFc4alSb--
