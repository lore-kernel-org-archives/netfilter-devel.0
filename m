From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Fixing to check the lower bound of valid ACK
Date: Wed, 25 Jun 2008 12:13:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806251151400.21979@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="110391808-493834459-1214388208=:21979"
Cc: netfilter-devel@vger.kernel.org,
	=?ISO-8859-2?Q?Thomas_B=E4tzler?= <t.baetzler@bringe.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:42355 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755475AbYFYKNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:13:32 -0400
Content-ID: <Pine.LNX.4.64.0806251203360.21979@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--110391808-493834459-1214388208=:21979
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0806251203361.21979@blackhole.kfki.hu>

Hi Patrick,

Lost connections was reported by Thomas B=E4tzler (running 2.6.25 kernel) o=
n=20
the netfilter mailing list (see the thread "Weird nat/conntrack Problem=20
with PASV FTP upload"). He provided tcpdump recordings which helped to=20
find a long lingering bug in conntrack.

In TCP connection tracking, checking the lower bound of valid ACK could=20
lead to mark valid packets as INVALID because:

 - We have got a "higher or equal" inequality, but the test checked
   the "higher" condition only; fixed.
 - If the packet contains a SACK option, it could occur that the ACK
   value was before the left edge of our (S)ACK "window": if a previous
   packet from the other party intersected the right edge of the window
   of the receiver, we could move forward the window parameters beyond
   accepting a valid ack. Therefore in this patch we check the rightmost
   SACK edge instead of the ACK value in the lower bound of valid (S)ACK
   test.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

---
 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conn=
track_proto_tcp.c
index 6256795..fc43e22 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -332,12 +332,13 @@ static unsigned int get_conntrack_index(const struct =
tcphdr *tcph)
=20
    I.   Upper bound for valid data:=09seq <=3D sender.td_maxend
    II.  Lower bound for valid data:=09seq + len >=3D sender.td_end - recei=
ver.td_maxwin
-   III.=09Upper bound for valid ack:      sack <=3D receiver.td_end
-   IV.=09Lower bound for valid ack:=09ack >=3D receiver.td_end - MAXACKWIN=
DOW
+   III.=09Upper bound for valid (s)ack:   sack <=3D receiver.td_end
+   IV.=09Lower bound for valid (s)ack:=09sack >=3D receiver.td_end - MAXAC=
KWINDOW
=20
-   where sack is the highest right edge of sack block found in the packet.
+   where sack is the highest right edge of sack block found in the packet
+   or ack in the case of packet without SACK option.
=20
-   The upper bound limit for a valid ack is not ignored -
+   The upper bound limit for a valid (s)ack is not ignored -
    we doesn't have to deal with fragments.
 */
=20
@@ -607,12 +608,12 @@ static int tcp_in_window(const struct nf_conn *ct,
 =09=09 before(seq, sender->td_maxend + 1),
 =09=09 after(end, sender->td_end - receiver->td_maxwin - 1),
 =09=09 before(sack, receiver->td_end + 1),
-=09=09 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+=09=09 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
=20
 =09if (before(seq, sender->td_maxend + 1) &&
 =09    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 =09    before(sack, receiver->td_end + 1) &&
-=09    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
+=09    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 =09=09/*
 =09=09 * Take into account window scaling (RFC 1323).
 =09=09 */
--=20
1.5.3.4

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
--110391808-493834459-1214388208=:21979--
