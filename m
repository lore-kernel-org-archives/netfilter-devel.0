From: Polychronis Ypodimatopoulos <ypol@intracom.gr>
Subject: IPv6 module vs Netfilter static
Date: Thu, 9 Oct 2003 08:55:24 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310090855.24134.ypol@intracom.gr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Description: clearsigned data
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

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Dear all

There is a problem if you compile IPv6 as a module and the
IPv6 netfilter options statically into the kernel. AFAICS they should depen=
d=20
on the IPv6 option and not be allowed to compile statically if IPv6 is a=20
module. Otherwise, various depend errors occur.

Please cc me as I am no expert (or intermediate :) in netfilter development=
=20
and therefore not subscribed in this list.

=2D --=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
Polychronis Ypodimatopoulos MSc
Software Engineer
Defense Systems Development
INTRACOM S.A.
Markopoulo Ave, 190 02
Peania
Tel:   (+30)210-667 9067
=46ax:   (+30)210-667 4634
email: ypol at intracom dot gr
http://www.intracom.gr

=20
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/hPhMJ3lXivLkjBERAj2TAJ43rV1z+5Kwoy571b49flney436IQCffkj0
3SXZYtLW1IjqapCN6y+3Jcc=3D
=3DjnMq
=2D----END PGP SIGNATURE-----
