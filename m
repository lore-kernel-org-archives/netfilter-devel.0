From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP connection tracking and NAT patches
Date: Thu, 27 Mar 2003 10:22:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030327092243.GM21953@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com> <20030326152047.GY21953@sunbeam.de.gnumonks.org> <3E8242E8.3050609@snapgear.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gz4FNQG/2iJjJcgR"
Cc: Jeff Hall <hall@vdata.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Content-Disposition: inline
In-Reply-To: <3E8242E8.3050609@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gz4FNQG/2iJjJcgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2003 at 10:16:40AM +1000, Philip Craig wrote:
> >Mh.  If we don't have any nat mappings, we shouldn't call the helper.
>=20
> We use the TCP source port of the control channel for the call ID when
> NATting.  For this to work, we have to NAT both forwarded and local
> connections, otherwise there is a possibility of a call ID clash.

This is true.  But I don't think we should make this automatic.  The
only case where this clash actually could happen is when both NAT'ed and
local connections use the same source IP. =20

We already have other difficulties in this case, see the 'locally bound
UDP port can still be used for NAT mappings' discussion.

If somebody wants to NAT PPTP sessions (local and remote), he should
insert a SNAT rule in POSTROUTING which then matches local and remote
connections.

> Since the original call ID is usually different from the TCP source
> port, there will be a nat mapping for local connections, and the
> helper needs to be called.  If we get reservation of call IDs, then
> this behaviour can be changed.

yes, in the end we whould have some mechanism for callID reservation,
even if it is just a simple 16bit counter that is incremented every time
we need to use a CallID and wraps around after 16bit are expired.

I don't think it's worth the effort doing a 'real' allocation (including
a 'free') which would be per-IP.  Nobody will want to do 2^16 PPTP
sessions from a single IP... and even if he would, there are other
problems ;)

> Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
> SnapGear - Custom Embedded Solutions and Security Appliances

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gz4FNQG/2iJjJcgR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gsLjXaXGVTD0i/8RAhovAJsHnH5zR7Z6YW4CMq+MeTF1aEGTrQCeJNE8
ozC9FOk6qCPM46dMICgD1Cw=
=KfK/
-----END PGP SIGNATURE-----

--gz4FNQG/2iJjJcgR--
