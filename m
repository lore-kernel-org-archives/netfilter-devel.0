From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Bug with netfilter and NFS server on same machine (fwd)
Date: Thu, 5 Dec 2002 21:21:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021205202119.GH11068@naboo.club.berlin.ccc.de>
References: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Cc: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Lars Knudsen <gandalfit@virgilio.it>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211231342530.3237-100000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2002 at 01:44:45PM -0500, William Stearns wrote:
> Good day, Lars,
> 	Whether or not the netfilter list was able to find an answer, it=20
> might still make sense to CC that list.

yup, definitely.

> The problem is this: A machine running linux 2.4.18 or 2.4.19 works just=
=20
> fine when running just the kernel nfsd. A single client connected to the=
=20
> server with 100Mbit ethernet sees throughput of 5-10MByte/sec even after=
=20
> an hour or two of continous transfers. If the nfs server is also running=
=20
> iptables the throughput is initially the same (5-10MByte/sec) but after=
=20
> a while (200MByte-500MByte total transfer) the client starts reporting=20
> "nfs server not responding" followed after a while by "nfs server OK"=20
> and of course the transfer rate goes way down (< 1MByte/sec). Using=20
> tcpdump on the client seems to indicate that some packets have their=20
> headers garbled - wrong fragment ids being the typical error.

this sounds like a problem with nfs's exceptionally large packet size
(up to 8k) and the resulting udp fragments, which need to get
defragmented and refragmented while conntrack is done.

Apart from that I don't have any idea.  I run lots of linux nfs servers
on machines which have conntrack running, without ever encountering the
problem you are describing.  There has to be something special about
your setup(s) we are missing here.

Any idea?

Thanks.

> \Lars Knudsen

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE977U/XaXGVTD0i/8RArkSAJ9v4akb330zQSxvnPfkj0nZV3pX5wCgn2pf
qCA4BYmEL2jAA3wTnDVqf/w=
=jfSX
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
