From: Lennart Poettering <mz6e657466696c746572@itaparica.org>
Subject: libipq + packet mangling + MTU
Date: Fri, 4 Oct 2002 17:34:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021004153401.GA23867@whiskey.dummy.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I am currently working on a new target for netfilter which modifies
packages and, as a side effect, may enlarge packets by some bytes. I
have currently a working prototype in userspace using libipq. It
already works quite fine, but suffers by one problem:

If the MTU of a device ist e.g. 1500 bytes, a packet may be enlarged
to 1520 bytes. (just an example) the kernel drops such large packages,
since they are larger than the MTU.

I read on some mails regarding a project calles SPS
(http://ds9a.nl/sps/) that the same thing would not occur in kernel
space (as a real netfilter module), since the kernel would
automatically fragment the packets correctly. Thus a packet of 1500
bytes would result in a packet of 1500 bytes and another of
20+ip-header-length. However, this will slow down the things
massively.

Is there any sane way to get this fixed correctly?=20

I would like to see a second MTU-value attached to each network device
which specifies a higher limit than the normal MTU. Packets which are
larger than this second MTU get dropped, packets which are larger than
the normal MTU but smaller than that special MTU are accepted. So that
I would be able to set the normal mtu to 1480 and the effective MTU to
1500 and be happy this way. Is there anything like this available in
the Linux kernel currently?

Can anyone suggest me a better fix for this problem?

Maybe there is a simple sysctl variable that may modify the packet
size the kernel splits its TCP stream with?

Any suggestions?

Thanks,
  Lennart

--=20
name { Lennart Poettering } mail { lennart@poettering.de }
icq { 11060553 } www { http://www.poettering.de/lennart/ }
loc { hamburg, germany } pgp { 0x1A015CC4 } hack { .phi. }

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.0 (GNU/Linux)

iD8DBQE9nbTpMn8mlRoBXMQRAigMAJ9k4HAiDCaFFidSvilFAYvDj4kx3QCePmdB
3JLwWt6tZJfxGcyuH0BgCqg=
=BPnI
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
