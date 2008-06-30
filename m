From: Patrick McHardy <kaber@trash.net>
Subject: netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid ACK
Date: Mon, 30 Jun 2008 17:56:10 +0200 (MEST)
Message-ID: <20080630155610.24326.75331.sendpatchset@localhost.localdomain>
References: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39796 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYF3P4M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:56:12 -0400
In-Reply-To: <20080630155609.24326.34250.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

netfilter: nf_conntrack_tcp: fixing to check the lower bound of valid A=
CK

Lost connections was reported by Thomas B=E4tzler (running 2.6.25 kerne=
l) on
the netfilter mailing list (see the thread "Weird nat/conntrack Problem
with PASV FTP upload"). He provided tcpdump recordings which helped to
find a long lingering bug in conntrack.

In TCP connection tracking, checking the lower bound of valid ACK could
lead to mark valid packets as INVALID because:

 - We have got a "higher or equal" inequality, but the test checked
   the "higher" condition only; fixed.
 - If the packet contains a SACK option, it could occur that the ACK
   value was before the left edge of our (S)ACK "window": if a previous
   packet from the other party intersected the right edge of the window
   of the receiver, we could move forward the window parameters beyond
   accepting a valid ack. Therefore in this patch we check the rightmos=
t
   SACK edge instead of the ACK value in the lower bound of valid (S)AC=
K
   test.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5c61a61f0df27eba716646da0b7371bf49f13d89
tree d325c80abe018baac9cd492a76d38b998ae87d4c
parent d420895efb259a78dda50f95289571faa6e10e41
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Mon, 30 Jun 2008 17:=
40:34 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 30 Jun 2008 17:40:34 +=
0200

 net/netfilter/nf_conntrack_proto_tcp.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_=
conntrack_proto_tcp.c
index ba94004..271cd01 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -331,12 +331,13 @@ static unsigned int get_conntrack_index(const str=
uct tcphdr *tcph)
=20
    I.   Upper bound for valid data:	seq <=3D sender.td_maxend
    II.  Lower bound for valid data:	seq + len >=3D sender.td_end - rec=
eiver.td_maxwin
-   III.	Upper bound for valid ack:      sack <=3D receiver.td_end
-   IV.	Lower bound for valid ack:	ack >=3D receiver.td_end - MAXACKWIN=
DOW
+   III.	Upper bound for valid (s)ack:   sack <=3D receiver.td_end
+   IV.	Lower bound for valid (s)ack:	sack >=3D receiver.td_end - MAXAC=
KWINDOW
=20
-   where sack is the highest right edge of sack block found in the pac=
ket.
+   where sack is the highest right edge of sack block found in the pac=
ket
+   or ack in the case of packet without SACK option.
=20
-   The upper bound limit for a valid ack is not ignored -
+   The upper bound limit for a valid (s)ack is not ignored -
    we doesn't have to deal with fragments.
 */
=20
@@ -606,12 +607,12 @@ static bool tcp_in_window(const struct nf_conn *c=
t,
 		 before(seq, sender->td_maxend + 1),
 		 after(end, sender->td_end - receiver->td_maxwin - 1),
 		 before(sack, receiver->td_end + 1),
-		 after(ack, receiver->td_end - MAXACKWINDOW(sender)));
+		 after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1));
=20
 	if (before(seq, sender->td_maxend + 1) &&
 	    after(end, sender->td_end - receiver->td_maxwin - 1) &&
 	    before(sack, receiver->td_end + 1) &&
-	    after(ack, receiver->td_end - MAXACKWINDOW(sender))) {
+	    after(sack, receiver->td_end - MAXACKWINDOW(sender) - 1)) {
 		/*
 		 * Take into account window scaling (RFC 1323).
 		 */
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
