From: Harald Welte <laforge@netfilter.org>
Subject: Re: Suggestion regarding masquerading / action when the link goes down
Date: Thu, 19 Jun 2003 14:11:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030619121154.GI20125@sunbeam.de.gnumonks.org>
References: <005001c32c4d$6e2c3240$7b00a8c0@chr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KJY2Ze80yH5MUxol"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Morgenstern <C.Morgenstern@gmx.de>
Content-Disposition: inline
In-Reply-To: <005001c32c4d$6e2c3240$7b00a8c0@chr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--KJY2Ze80yH5MUxol
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 06, 2003 at 07:02:35PM +0200, Christian Morgenstern wrote:
> From NAT-HOWTO:
> You don't need to put in the source address explicitly with masquerading:=
 it
> will use the source address of the interface the packet is going out from.
> But more importantly, if the link goes down, the connections (which are n=
ow
> lost anyway) are forgotten, meaning fewer glitches when connection comes
> back up with a new IP address.
>=20
>=20
> So if the link goes down for a few seconds, and then comes back up all ma=
sq
> connections are lost, even though the IP did not change.

yes.  But I have to admit that I haven't seen this happen, at least not
at any ISP I have seen so far.

> Would it be possible to have an additional option for the kernel config, =
so
> the connections aren't cleared if the connection goes down ?

Kernel config option seems to be a bit static, and too 'big'.  What
about a sysctl?  I'm happy to accept a patch that makes this behaviour
sysctl-controllable.

> Or even better, how about only clearing the connections if the link comes
> back up having a different IP ?

This would mean that we'd need to hook in to ip address change functions
of the core ipv4 stack. too ugly.

> Is the conntrack table also being cleared if the link goes down/comes back
> up ?

as the NAT mappings are stored in the conntrack table, yes - and no.  We
don't clear the whole table, just the ones MASQ'ed to the particular
interface (see ipt_MASQUERADE.c:masq_device_event() and device_cmp()).

> -- Christian

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KJY2Ze80yH5MUxol
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+8aiKXaXGVTD0i/8RAk/HAJ9pbqg7ACmVUVNTsjcXbexMc+E04QCggx4C
cEvMAL4qUYobvC9GzmCMqdE=
=kL2l
-----END PGP SIGNATURE-----

--KJY2Ze80yH5MUxol--
