From: Harald Welte <laforge@netfilter.org>
Subject: Re: ALGs
Date: Wed, 4 Jun 2003 09:16:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030604071600.GA14268@sunbeam.de.gnumonks.org>
References: <Sea2-F11MieZutGvO8n00003af5@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F11MieZutGvO8n00003af5@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2003 at 07:06:30AM +0000, Ricky Foo wrote:
> Good day,
>=20
> Some doubts about the conntrack helper module.

There are quite a few examples, even for complex protocols like h323, so
please try to find your answers=20

> 1. For the "help" callback, what exactly am I suppose to do with the=20
> packets when this function is activated?

That totally depends on your protocol.  The most important thing is to
find out which other (slave/sibling) connections are going to be
established and call ip_conntrack_expect_related() accordingly.

> 2. For the netbios protocol, there are a couple of ports to monitor, such=
=20
> as 137 for name-service, 138 for datagram service, 139 for session servic=
e.=20
> Does that mean I have to write 3 different tracking modules or do I follo=
w=20
> what has been done in the ftp module...i.e register the 3 different ports=
=20
> to track.

That again depends on your protocol.  I think the packet formats on all
three ports are different, aren't they?  So you write one module that
registers three helpers (with different help() functions).

> 3. In the corresponding header files, what do we normally have to define=
=20
> for the various structure? I kinda got confused by what I have read from=
=20
> the source code!

Again, protocol dependant.

> 4. How do I get to the payload part where the netbios data-fields are?

just read the packet.  Again, there are quite a lot of examples.  Just
look at ip_conntrack_amanda.c:help()

       struct udphdr *udph =3D (void *)iph + iph->ihl * 4;
       u_int32_t udplen =3D len - iph->ihl * 4;
       u_int32_t datalen =3D udplen - sizeof(struct udphdr);
       char *data =3D (char *)udph + sizeof(struct udphdr);

> Please pardon me if my questions do seems silly to you guys.

No, they are not.  But please try to find out as much as possible by
reading the examples.=20

Good luck!

>    Ricky
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+3ZywXaXGVTD0i/8RAqGHAJ4xNmUFX7U/RcEMtGhAAfv0IanZswCgrmEv
Fd3DZ56u2UgurM2b3RKMkCc=
=TMMI
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
