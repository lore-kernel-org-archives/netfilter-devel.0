From: Harald Welte <laforge@netfilter.org>
Subject: Re: indev_name in bridge+iptables?
Date: Mon, 14 Jul 2003 09:41:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714074134.GA6538@naboo>
References: <004801c345d8$8f9d9eb0$8101a8c0@dev> <20030712152759.5547.qmail@web13905.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Cc: Yong <sdssly@sina.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
Content-Disposition: inline
In-Reply-To: <20030712152759.5547.qmail@web13905.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2003 at 08:27:59AM -0700, Scott MacKay wrote:
> Hi, I had the exact same thing.  The physical name is
> not passed up in the message, sucks huh?
>=20
> What I resorted to was to alter the kernel code for
> the QUEUE messages.  The low level structure has the
> physical device names in it, but are not passed up.  I
> altered it so if there was a physical device name for
> in & out, it copied those values over the existing
> indev and outdev names (since 'br0' is pretty
> useless).  There is only 1 file to change, but can't
> remember it off the top of my head.  The 'real' method
> would be to alter the _msg structure to include the
> physdev names in it, but I was lazy :P

The reason for this dilemma is historical:

- ip_queue was in the kernel first (since pre 2.4.0)
- support for bridging firewalls was added later
- real support for physdev matching in iptables is only available
  for kernel 2.5.x
- changing the ipq_msg structure would render all previous versions of
  libipq (and existing ip_queue using applications) incompatible with
  new kernels

Combined with the fact that bridging firewalls still seem very rare,
we'd rather stick with compatibility instead of adding that feature...

=2E.. however, a patch is always welcome and we'd put it into
patch-o-matic 'experimental' or something.

> -Scott

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/El6tXaXGVTD0i/8RAtA5AJ40qYWIyyVQSzoP/JC5FnSYoy8j8gCfcF2c
ON3JZU/DL0ahv2yLF3nzT5g=
=bIe/
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
