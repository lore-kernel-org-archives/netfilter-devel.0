From: Harald Welte <laforge@netfilter.org>
Subject: Re: Question about a kernel module adding an iptables rule...
Date: Fri, 3 Oct 2003 12:48:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031003104824.GD5758@sunbeam.de.gnumonks.org>
References: <200309251952.h8PJq6f13018@kumo.us.cray.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+wihTgxq1uVd/aSE"
Cc: netfilter@lists.samba.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Duane Cloud <cloud@cray.com>
Content-Disposition: inline
In-Reply-To: <200309251952.h8PJq6f13018@kumo.us.cray.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+wihTgxq1uVd/aSE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2003 at 02:52:06PM -0500, Duane Cloud wrote:
> Hello,
>=20
> I was wondering if there was a simple way for a kernel module
> to create a NAT rule "on the fly". =20

first, this is a development question.  Why don't you ask it on the
development list?

no, this is absolutely impossible.

> Is there a simple way to accomplish this?  I was hoping there
> would be an insert_rule() function, but it looks like the tables
> are modified by a doing a get_table(), modify the local copy, then
> replace_table().

yes. the tables are atomically replaced, and there is no functionality
for parsing/modifying the table inside the kernel.  All the kernel can
do is iterating them.

the only chance you have is to set up the nat binding by using
ip_conntrack_expect_related() - but you need to do that _before_ you
have received the first SYN packet.
=20
> Thank you,
> Duane Cloud

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+wihTgxq1uVd/aSE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fVP4XaXGVTD0i/8RAlbgAJ9Cj5IwTO5JFJopobMPZ+/bGnZJJgCgsGge
3G5TCcFm17TqwdBNZfpMwMY=
=R8v9
-----END PGP SIGNATURE-----

--+wihTgxq1uVd/aSE--
