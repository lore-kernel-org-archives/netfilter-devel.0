From: Harald Welte <laforge@netfilter.org>
Subject: Re: Rusty Guide, "Receiving command from userspace" "Packet handling in Userspace"
Date: Fri, 23 May 2003 22:02:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030523200258.GS3077@sunbeam.de.gnumonks.org>
References: <003c01c31ba2$6b95fef0$d211fea9@toowoomba>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxQt9wRz9wbL5Edg"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Calvin <calvinproject@ihug.com.au>
Content-Disposition: inline
In-Reply-To: <003c01c31ba2$6b95fef0$d211fea9@toowoomba>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HxQt9wRz9wbL5Edg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 09:58:05PM +1000, Calvin wrote:
> Hi all,
>=20
> Sorry about my questions again, I am really new to netfilter programming =
and after reading materials of different palces, I got a fair bit ideas, I =
started my module complie and running and testing but still along way to go.
>=20
> I was reading the section "Receiving command from userspace" "Packet
> handling in Userspace", I am quite sure the meaning of these two. Does
> it means I can write a C program run in shell can communicate with
> netfilter which is running in kernel space?=20

yes. please read the libipq manpages=20

> I am particularly interested in Packet Handling in userspace. Is this
> funactionality useful? what is the purpose of doing this since we can
> write a module doing doign simliar things and load it into kernel.
=20
there are certain things you don't want (or cannot reasonably) do from
inside the kernel.   doing asynchronous dns lookups, for example.

Also, you don't want to have huge error-prone code in your kernel, if it
isn't really necessary.

> Thanks for everything
> Calvin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--HxQt9wRz9wbL5Edg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+zn5yXaXGVTD0i/8RAmN5AJ492hM9GvGdtxfQjT/KbKUSeYHVAQCfYlps
meS5dvvf5arzQlCJbRXkVBk=
=PNYZ
-----END PGP SIGNATURE-----

--HxQt9wRz9wbL5Edg--
