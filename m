From: netfilter@interlinx.bc.ca
Subject: Weird results with tcp-window-tracking patch
Date: Wed, 6 Nov 2002 10:32:59 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021106153259.GC12743@pc.ilinx>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rQ2U398070+RC21q"
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


--rQ2U398070+RC21q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I have the tcp-window-tracking patch applied to my firewall's kernel.
For reference, the dates on the first hunk in the
=2E/extra/tcp-window-tracking.patch are as follows:

--- linux-2.4.19-base/include/linux/netfilter_ipv4/ip_conntrack_tcp.h Fri O=
ct 18 11:38:10 2002
+++ linux-2.4.19-tcp-window/include/linux/netfilter_ipv4/ip_conntrack_tcp.h=
 Fri Oct 18 11:56:35 2002

Anyway, I have been seeing some strange results from the patch.  I
have lots of these from the last 12 or so hours:

04:16:48 kernel SRC=3D195.33.98.115 DST=3D205.210.52.208 LEN=3D64 TOS=3D0x0=
0 PREC=3D0x00 TTL=3D37 ID=3D1 PROTO=3DTCP SPT=3D57376 DPT=3D53 SEQ=3D232119=
966 ACK=3D1365344649 WINDOW=3D2048 RES=3D0x00 SYN URGP=3D0 ip_conntrack_tcp=
: INVALID: Out of window data; SEQ is under the lower bound (retransmitted =
already ACKed data)=20
04:16:49 kernel SRC=3D195.33.98.115 DST=3D205.210.52.208 LEN=3D64 TOS=3D0x0=
0 PREC=3D0x00 TTL=3D37 ID=3D2 PROTO=3DTCP SPT=3D57380 DPT=3D53 SEQ=3D291116=
2149 ACK=3D4054392719 WINDOW=3D2048 RES=3D0x00 SYN URGP=3D0 ip_conntrack_tc=
p: INVALID: Out of window data; SEQ is under the lower bound (retransmitted=
 already ACKed data)=20
04:16:50 kernel SRC=3D195.33.98.115 DST=3D205.210.52.208 LEN=3D64 TOS=3D0x0=
0 PREC=3D0x00 TTL=3D37 ID=3D3 PROTO=3DTCP SPT=3D57382 DPT=3D53 SEQ=3D210422=
3658 ACK=3D1098213046 WINDOW=3D2048 RES=3D0x00 SYN URGP=3D0 ip_conntrack_tc=
p: INVALID: Out of window data; SEQ is under the lower bound (retransmitted=
 already ACKed data)=20

It seems to me that these are just regular run-of-the-mill initial SYN
packets (i.e. packet one of the TCP three-way handshake) for TCP DNS
queries of my name server (even though I don't have one -- from the
number of both UDP and TCP DNS queries I am getting, the previous
owner of my IP address must have a name server running).

Why would these be flagged as "Out of window data" packets when in
reality they are just a simple violation of the rules I have
installed?  Doesn't there have to be an established TCP session in
order to determine if there is any "Out of window data"?

b.

--=20
Brian J. Murrell

--rQ2U398070+RC21q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9yTYrl3EQlGLyuXARAvDXAKCmdqJOY9UeX2IUbPVo8ihM9sr7awCdHyxu
Ue71hUxIktWyXF85ztBjKyU=
=Oubi
-----END PGP SIGNATURE-----

--rQ2U398070+RC21q--
--rQ2U398070+RC21q--
