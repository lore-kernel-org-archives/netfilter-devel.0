From: gideon olam <gideon@gideonolam.com>
Subject: Re: RBAC Integration
Date: 27 Jun 2003 21:45:10 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056771910.7156.28.camel@skinny.gideonolam.com>
References: <1056734756.7156.2.camel@skinny.gideonolam.com>
	 <20030627174010.GB10045@oknodo.bof.de>
	 <1056741347.7156.10.camel@skinny.gideonolam.com>
	 <1056746685.19776.5.camel@porky>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m85Ojac2Wx1c84tyzVgW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eric Leblond <eric@regit.org>
In-Reply-To: <1056746685.19776.5.camel@porky>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-m85Ojac2Wx1c84tyzVgW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-06-27 at 14:44, Eric Leblond wrote:
> Le ven 27/06/2003 =C3=A0 21:15, gideon olam a =C3=A9crit :
> > On Fri, 2003-06-27 at 11:40, Patrick Schaaf wrote:
> >   Userspace could use roles to determine who has what access rights to =
a table.
> >    Matches like owner might be able to benefit.  I would think there=20
> > would be a large variety
> > of implications for integration.
>=20
> I think you don't go far enough. A framework doing external autorisation
> thanks to the QUEUE target could be very useful.
> In fact, I'm coding an auth request system (based on UDP) which permits
> to any protocol compliant auth server to take decision over packet.
>=20
> BR,

I agree,  I was just saying that I felt there were many benefits to
integrating netfilter with the various security models.  The QUEUE is
great for some apps,  but personally though I think a netfilter module
that provided additional matches would provide instant integration.  It
would become easy to tie specific filters down to authenticated Roles on
the system.   Some of this might even require patches for other
netfilter code to integrate role management.=20

Netfilter integrated into an RBAC would provide a truly least privilege
network layer for secure servers.  It would also move administration of
iptables out of root's domain in a secure manner and into secure roles
allowed to modify netfilter objects.


--=-m85Ojac2Wx1c84tyzVgW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+/Q9GnOx3U+/N6ccRAr5aAJ0b53LU4mjp+ZPVKMisai8VLZO6aACgopZN
+YwfV4/BYimge+6pkVErheg=
=ckx3
-----END PGP SIGNATURE-----

--=-m85Ojac2Wx1c84tyzVgW--
